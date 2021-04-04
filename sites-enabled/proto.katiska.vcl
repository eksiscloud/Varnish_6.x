## Jekyll (commenting by Disqus) ##
sub vcl_recv {
  if (req.http.host == "proto.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	# drops amp; IDK if really needed, but there is no point even try because Google is caching AMP-pages
	if (req.url ~ "/amp/") {
		return (pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
	return (pipe);
	}

	### Do not Cache: special cases ###

	# Pass Let's Encrypt
	if (req.url ~ "^/\.well-known/acme-challenge/") {
	return (pass);
	}

	# Did not cache the RSS feed
	if (req.url ~ "/feed") {
	return (pass);
	}

	## General filtering
	## With Jekyll these are useless, because there is no cookies
	
	# Large static files are delivered directly to the end-user without
	# waiting for Varnish to fully read the file first.
	# Varnish 4 fully supports Streaming, so see do_stream in vcl_backend_response() to witness the glory.
	if (req.url ~ "^[^?]*\.(mp[34]|wav)(\?.*)?$") {
		unset req.http.Cookie;
		return (hash);
	}

	# Cache all static files by Removing all Cookies for static files
	# Remember, do you really need to cache static files that don't cause load? Only if you have memory left.
	# Here I decide to cache these static files. For me, most of them are handled by the CDN anyway.
	if (req.url ~ "^[^?]*\.(ico|txt|xml|mp3|html|htm)(\?.*)?$") {
		unset req.http.Cookie;
		return (hash);
	}

	# Cache all others requests if they reach this point
	return (hash);

}
  
}
