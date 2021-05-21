## Wordpress ##
sub vcl_recv {
  if (req.http.host == "ymparistosuunnittelija.com" || req.http.host == "www.ymparistosuunnittelija.com") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);


	# Normalize hostname as www. to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^ymparistosuunnittelija\.com$", "www.ymparistosuunnittelija.com");
	
	call common_rules;


	# Needed for Monit
	if (req.url ~ "/pong") {
	return (pipe);
	}

	# Check the Cookies for wordpress-comment items I reckon
	if (req.http.Cookie ~ "comment_") {
	return (pass);
	}
	
	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  }
}
