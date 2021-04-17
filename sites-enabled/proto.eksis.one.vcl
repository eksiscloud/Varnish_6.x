## Discourse ##
sub vcl_recv {
  if (req.http.host == "proto.eksis.one") {
		set req.backend_hint = proto;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	return(pipe);

	if (req.url ~ "admin") {
		return(pass);
	}
	
	if (req.url ~ "mini-profiler-resources") {
		return(pass);
	}

	if (req.url ~ "message-bus") {
		return(pass);
	}

	if (req.url ~ "review") {
		return(pass);
	}
	
	# Post requests will not be cached
	if (req.http.Authorization || req.method == "POST") {
		return(pass);
	}
	
	# Do not cache AJAX requests.
	if (req.http.X-Requested-With == "XMLHttpRequest") {
		return(pass);
	}
	
	
	# Cache all others requests if they reach this point
	return(hash);


  }
}