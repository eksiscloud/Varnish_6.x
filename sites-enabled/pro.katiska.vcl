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