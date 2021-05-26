## Wordpress ##
sub vcl_recv {
  if (req.http.host == "katiska.info" || req.http.host == "www.katiska.info") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^katiska\.info$", "www.katiska.info");
	
	call common_rules;
	
	# Discourse as commenting
	if (req.url ~ "/wp-json/wp-discourse/v1/discourse-comments") {
		return(pass);
	}
	
	# Tag list 
	if (req.url ~ "^/blogi/avainsana/") {
		return(pass);
	}

	# drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	# Landing pages with form/mailing list (needs nonce)
	if (req.url ~ "/laskeutumissivut") {
		return(pass);
	}

	# drops Mailster/contact form
	if (req.url ~ "/postilista") {
		return(pass);
	}

	# Pass contact form
	if (req.url ~ "/tiedustelut") {
		return(pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return(hash);
	
	#the of host
  }
  # The end of sub-vcl
}

