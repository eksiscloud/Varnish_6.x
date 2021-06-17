## Wordpress ##
sub vcl_recv {
  if (req.http.host == "katti.katiska.info") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## General rules common to every backend by common.vcl
	call common_rules;
	
	## Limit logins by acl whitelist
	if (req.url ~ "^/wp-login.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)) {
		# I can't ban finnish IPs
		if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
			return(synth(403, "Access Denied " + req.http.X-Real-IP));
		} else {
		# other knockers I can ban
			return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
	}

	## Wordpress REST API
	# For some reason this isn't working if in wordpress_common.vcl
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass, but only when logged in
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ whitelist) {
			return(pass);
		} else {
		# Must be logged in
			if (req.http.cookie !~ "wordpress_logged_in") {
				return(synth(403, "Unauthorized request"));
			}
		}
	}

	## serving general robots.txt that disallow all
	# doesn't work...
	if (req.url ~ "^/robots.txt") {
		return(synth(601));
	}
	
	## drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	## drops Mailster
	if (req.url ~ "/postilista/") {
		return(pass);
	}

	## Keep this last because wordpress_common.vcl limits more and tells cache all others etc.
	call wp_basics;
	
	## Cache all others requests if they reach this point. None should come to here, ever, because of wp_basics.
	return(hash);
	
  # The end of host
  }
# The end of sub-vcl
}