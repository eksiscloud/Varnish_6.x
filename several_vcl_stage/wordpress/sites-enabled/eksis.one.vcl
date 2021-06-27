## Wordpress

sub vcl_recv {
  if (req.http.host == "eksis.one" || req.http.host == "www.eksis.one") {
		set req.backend_hint = wordpress;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	## Normalize hostname to avoid double caching
	# I like to keep triple-w
	set req.http.host = regsub(req.http.host,
	"^eksis\.one$", "www.eksis.one");
	
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

	# drops stage site totally
	if (req.url ~ "/stage") {
		return (pipe);
	}

	# Discourse as commenting system
	if (req.url ~ "/wp-json/wp-discourse/v1/discourse-comments") {
		return(pass);
	}

	# drops Mailster/contact form
	if (req.url ~ "/postilista/") {
		return (pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}
	
	## Keep this last because wordpress_common.vcl limits more and tells cache all others etc.
	call wp_basics;
	
	## Cache all others requests if they reach this point.
	return(hash);
	
  # The end of host
  }
# The end of sub-vcl
}