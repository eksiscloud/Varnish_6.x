## Discourse ##
## this isn't served through Varnish because I just can't get it work
sub vcl_recv {
  if (req.http.host == "kaffein.jagster.fi") {
		set req.backend_hint = kaffein;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);

	# Stop knocking
	if (
		   req.url ~ "wp-login.php"
		|| req.url ~ "xmlrpc.php"
		) {
		if (
		   req.http.X-County-Code ~ "fi"
		|| req.http.x-language ~ "fi" 
		|| req.http.x-agent == "nice"
		) {
			return(synth(403, "Forbidden referer: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden referer: " + req.http.X-Real-IP));
		}
	}

	# Must pipe, otherwise I just get error 500
	return(pipe);

	
	# Cache all others requests if they reach this point
	return(hash);
  }
}