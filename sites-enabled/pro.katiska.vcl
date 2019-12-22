## Moodle
sub vcl_recv {
  if (req.http.host == "pro.katiska.info") {
	
	# Your lifeline: Turn OFF cache
	# For caching keep this commented
	#return(pass);
	
	# No cache, no fixed headers, no nothing
	return (pipe);
	
	# If you are using SSL and it doesn't forward http to https when URL is given without protocol
	#if ( req.http.X-Forwarded-Proto !~ "(?i)https" ) {
	#	set req.http.X-Redir-Url = "https://" + req.http.host + req.url;
	#return ( synth( 750 ));
	#}
	
	#set req.http.X-Forwarded-Proto = "https";
	
	## Followind doesn't work
	
	if (req.url ~ "^/(theme|pix)/") { 
		unset req.http.Cookie; 
	}

	#Moodle doesn't like to be cached, passing
    if (req.http.Cookie ~ "(MoodleSession|MoodleTest|MOODLEID)") {
      return (pass);
    }
    if (req.url ~ "^/courses") {
      return (pass);
	  
    }
    if (req.url ~ "file.php") {
      return (pass);
    }

  }


}