## Discourse ##
sub vcl_recv {
  if (req.http.host == "proto.eksis.one") {
		set req.backend_hint = proto;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	#### # Must pipe, otherwise I just get error 500
	
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
	
	return(pipe);
	
	# Cache all others requests if they reach this point
	return(hash);
  }
}