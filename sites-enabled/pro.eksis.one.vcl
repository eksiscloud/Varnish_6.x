## Moodle
sub vcl_recv {
  if (req.http.host == "pro.eksis.one") {
  		set req.backend_hint = default;
	
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	
	#return(pipe);
	
	# No cache, no fixed headers, no nothing
	
	call common_rules;
	
	#return(pass);
	
	### just testing
	
	if (req.url ~ "^/(theme|pix)/") { 
		unset req.http.cookie-moodle; 
	} else {
		return(pass);
	}

	## or...
	
    #if (req.url ~ "/(login|my|user|courses|admin|tool|h5p|cohort|backup|grade|mod|cache|filter|") {
		#return (pass);
	 #}
	
  # host ends here
  }
# the end of sub
}