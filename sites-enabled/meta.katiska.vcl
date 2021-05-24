## Discourse ##
sub vcl_recv {
	if (req.http.host == "meta.katiska.info") {
		set req.backend_hint = meta;

	# Must pipe, otherwise I just get error 500
	return(pipe);
	
	}

# The of the sub
}