
## Wordpress ##
sub vcl_recv {
  if (req.http.host == "eksis.dev" || req.http.host == "www.eksis.dev") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	# Normalize hostname as www. to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^eksis\.dev$", "www.eksis.dev");

	call common_rules;
	
	# Limit logins by acl whitelist
	if ( req.url ~ "^/wp-login.php" && !client.ip ~ whitelist ) {
		return(synth(403, "Forbidden."));
	}
	
	# drops stage site
	if (req.url ~ "/stage") {
		return (pass);
	}
	
	# Needed for Monit
	if (req.url ~ "/pong") {
	return (pipe);
	}

	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  }

}