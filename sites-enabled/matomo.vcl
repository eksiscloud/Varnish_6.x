## Matomo analytichs
sub vcl_recv {
  if (req.http.host == "stats.eksis.eu") {
		set req.backend_hint = default;

	# No cache, no fixed headers, no nothing
	# Here is nothing to cache
	
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
	
	return (pass);

  }


}