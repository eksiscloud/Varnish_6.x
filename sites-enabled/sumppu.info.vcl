## Plain domain, no content ##
sub vcl_recv {
  if (req.http.host == "sumppu.info" || req.http.host == "www.sumppu.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);


	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^sumppu\.info$", "www.sumppu.info");
	
	call common_rules;
	
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
	
	call wp_basics;
	
	return(synth(403, "Unauthorized request"));
	
	}
}