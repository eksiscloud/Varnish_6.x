## Moodle
sub vcl_recv {
  if (req.http.host == "pro.eksis.one") {
  		set req.backend_hint = default;
	
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	return(pipe);
	
	# No cache, no fixed headers, no nothing
	
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
	
  }


}