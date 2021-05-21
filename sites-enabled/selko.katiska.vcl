## Wordpress ##
sub vcl_recv {
  if (req.http.host == "selko.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like a dumb proxy
	#return(pass);
	#return(pipe);

	call common_rules;
	
	# Limit logins by acl whitelist
	if ( req.url ~ "^/wp-login.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) ) {
		return(synth(403, "Forbidden."));
	}

	# drops stage site
	if (req.url ~ "/stage") {
		return(pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
	return(pipe);
	}

	call common_rules;
	
	## Everything else
	
	# Cache all others requests if they reach this point
	return(hash);
  }
}