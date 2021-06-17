## Jekyll (commenting by Disqus) Not active now ##
sub vcl_recv {
	if (req.http.host == "proto.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	call common_rules;

	# Cache all others requests if they reach this point
	return (hash);
	}
}
