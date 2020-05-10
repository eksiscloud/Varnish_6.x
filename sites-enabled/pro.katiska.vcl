## Moodle
sub vcl_recv {
  if (req.http.host == "pro.katiska.info") {
		set req.backend_hint = default;
	
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	return(pipe);
	
	## Followind doesn't work, because of something @ default.vcl
	# That's why piping and no cache, no fixed headers, no nothing
	
	# Allow purging from ACL
	if (req.method == "PURGE") {
	if (!client.ip ~ purge) {
		 return(synth(405, "This IP is not allowed to send PURGE requests."));
	}
	# If allowed, do a cache_lookup -> vlc_hit() or vlc_miss()
	return (purge);
	}

	# Only deal with "normal" types
	if (req.method != "GET" &&
	req.method != "HEAD" &&
	req.method != "PUT" &&
	req.method != "POST" &&
	req.method != "TRACE" &&
	req.method != "OPTIONS" &&
	req.method != "PATCH" &&
	req.method != "DELETE") {
	# Non-RFC2616 or CONNECT which is weird. */
	# Why send the packet upstream, while the visitor is using a non-valid HTTP method? */
	return (synth(404, "Non-valid HTTP method!"));
	}
	
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