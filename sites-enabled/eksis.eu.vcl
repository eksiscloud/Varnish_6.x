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

  }
}

