## Discourse ##
## this isn't served through Varnish because I just can't get it work
sub vcl_recv {
  if (req.http.host == "kaffein.jagster.fi") {
		set req.backend_hint = kaffein;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	
	# Must pipe, otherwise I just can't get Discourse work
	return(pipe);
	
	########### Not working #########

	# Gives error 500 if pass
	
		if (req.url ~ "message-bus") {
		return(pipe);
	}
	
		# Post requests will not be cached
	if (req.http.Authorization || req.method == "POST") {
		return(pipe);
	}
	
	if (req.url ~ "login") {
		return(pipe);
	}
	
	if (!(req.url ~ "(^/uploads/|^/assets/|^/user_avatar/)" )) {
		return(pipe);
	}
	
	# Something like this gives error 500 too
	
	if (req.url ~ "admin") {
		return(pass);
	}
	
	if (req.url ~ "mini-profiler-resources") {
		return(pass);
	}



	if (req.url ~ "review") {
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