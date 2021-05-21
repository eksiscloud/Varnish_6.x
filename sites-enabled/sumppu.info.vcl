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
	call wp_basics;
	
	return(synth(403, "Unauthorized request"));
	
	}
}