## Moodle
sub vcl_recv {
  if (req.http.host == "pro.katiska.info") {
		set req.backend_hint = default;
	
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
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
	
	return(pass);
	
	### just testing
	
	if (req.url ~ "^/(theme|pix)/") { 
		unset req.http.cookie-moodle; 
	}
	
	if (req.url ~ "/(login|my|user|courses|admin|tool|h5p|cohort|backup|grade|mod|cache|filter)") {
		return (pass);
	}


  # The host ends here
  }
# The end of the sub
}