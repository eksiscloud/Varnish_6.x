## Wordpress (no commenting) ##
sub vcl_recv {
  if (req.http.host == "eksis.eu" || req.http.host == "www.eksis.eu") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);


	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^eksis\.eu$", "www.eksis.eu");
	
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

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	# Page of contact form
	if (req.url ~ "/(tiedustelut)") {
	return (pass);
	}

	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  # The end of host
  }
 # The end of sub
}