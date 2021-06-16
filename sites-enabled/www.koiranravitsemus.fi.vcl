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
	#call common_rules;
	
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
	elseif (req.url ~"/(robots.txt|sitemap)") {
		return(hash);
	}
	#elseif (req.url ~ "^[^?]*\.(7z|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gz|ico|js|otf|pdf|png|ppt|pptx|rtf|svg|swf|tar|tbz|tgz|ttf|txt|txz|webm|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$") {
	#	unset req.http.cookie;
	#	return(hash);
	#}
	else {
		# Must pass, otherwise the site doesn't work
		return(pipe);
	}


	
  # The end of the host
  }
# And the real end - back to default.vcl
}