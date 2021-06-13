## Discourse ##
sub vcl_recv {
	if (req.http.host == "meta.katiska.info") {
		set req.backend_hint = meta;

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
			return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden request from: " + req.http.X-Real-IP));
		}
	}

	# Must pipe, otherwise I just get error 500
	return(pipe);
	
	}

# The of the sub
}