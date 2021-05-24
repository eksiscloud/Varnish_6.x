## Discourse ##
sub vcl_recv {
  if (req.http.host == "proto.eksis.one") {
		set req.backend_hint = proto;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	return(pipe);
	
	#### # Must pipe, otherwise I just get error 500
	
	
	# Cache all others requests if they reach this point
	return(hash);
  }
}