## Plain domain, no content. Only for redirection purposes, was a site once ##
sub vcl_recv {
  if (req.http.host == "sumppu.info" || req.http.host == "www.sumppu.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	## Normalize hostname to www. to avoid double caching
	# I like to keep triple-w
	set req.http.host = regsub(req.http.host,
	"^sumppu\.info$", "www.sumppu.info");
	
	## General rules common to every backend by common.vcl
	call common_rules;
	
	## Stop knocking
	if (req.url ~ "(wp-login|xmlrpc).php") {
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
	
	## And the last stop of one get here
	return(synth(403, "Unauthorized request"));
	
  # The end of host
  }
# The end of sub
}