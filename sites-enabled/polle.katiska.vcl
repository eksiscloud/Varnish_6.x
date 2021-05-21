## Wordpress ##
sub vcl_recv {
  if (req.http.host == "polle.katiska.info") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	call common_rules;
	
	# serving general robots.txt that disallow all
	# doesn't work...
	if (req.url ~ "/robots.txt") {
		return(synth(601));
	}
	
	# drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	# drops Mailster
	if (req.url ~ "/postilista/") {
		return(pass);
	}

	# Keep this last
	call wp_basics;

	# Cache all others requests if they reach this point
	return(hash);
  }
}

