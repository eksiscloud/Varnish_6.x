
## Wordpress (podcasting, photos, instagram, twitter) ##
sub vcl_recv {
  if (req.http.host == "jagster.fi" || req.http.host == "www.jagster.fi") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	# Normalize hostname as www. to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^jagster\.fi$", "www.jagster.fi");

	call common_rules;

	# Limit logins by acl whitelist
	if ( req.url ~ "^/wp-login.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) ) {
		return(synth(403, "Forbidden."));
	}

	# Discourse as commenting
	if (req.url ~ "/wp-json/wp-discourse/v1/discourse-comments") {
		return(pass);
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