## Jekyll (commenting by Disqus) ##
sub vcl_recv {
	if (req.http.host == "proto.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	call common_rules;

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
