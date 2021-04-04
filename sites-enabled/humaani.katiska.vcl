## Wordpress ##
sub vcl_recv {
  if (req.http.host == "humaani.katiska.info") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## just an example. For me Nginx is doing this.
	## If you are using SSL and it doesn't forward http to https when URL is given without protocol
	#if ( req.http.X-Forwarded-Proto !~ "(?i)https" ) {
	#	set req.http.X-Redir-Url = "https://" + req.http.host + req.url;
	#	return ( synth( 750 ));
	#}
	#set req.http.X-Forwarded-Proto = "https";
	
	# drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	# drops Mailster
	if (req.url ~ "/postilista/") {
		return(pass);
	}

	## Do not Cache: special cases ##

	# Do not cache AJAX requests.
	if (req.http.X-Requested-With == "XMLHttpRequest") {
		return(pass);
	}

	# Post requests will not be cached
	if (req.http.Authorization || req.method == "POST") {
		return(pass);
	}
	
	# Pass Let's Encrypt
	if (req.url ~ "^/\.well-known/acme-challenge/") {
		return(pass);
	}
	
	## Wordpress ##

	# Don't cache post and edit pages
	if (req.url ~ "/wp-(post.php|edit.php)") {
		return(pass);
	}

	# Don't cache logged-in user
	if ( req.http.Cookie ~ "wordpress_logged_in|resetpass" ) {
		return(pass);
	}

	# Pass contact form, RSS feed and must use plugins of Wordpress
	if (req.url ~ "/(tiedustelut|feed|mu-)") {
		return(pass);
	}

	#Hit everything else
	if (!req.url ~ "/wp-(login|admin|cron)|logout|administrator|resetpass") {
		unset req.http.Cookie;
		return(hash);
	}
	
	## Everything else ##
	
	# Cache all others requests if they reach this point
	return(hash);

  }
}

