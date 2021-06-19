#### Not in use nowadays. Putting MediaWiki behind Varnish is just over my limited skills ####

sub vcl_recv {
  if (req.http.host == "koiranravitsemus.fi" || req.http.host == "www.koiranravitsemus.fi") {
		set req.backend_hint = wiki;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^koiranravitsemus\.fi$", "www.koiranravitsemus.fi");
	
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
	
	if (req.http.cookie ~ "(session|UserID|UserName|Token|LoggedOut)") {
		return (pass);
	} 
	else {
		unset req.http.cookie;
	}

	## Cache all others requests if they reach this point.
	return(hash);
	
  # The end of the host
  }
# And the real end - back to default.vcl
}