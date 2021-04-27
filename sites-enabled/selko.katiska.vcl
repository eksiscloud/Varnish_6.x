## Wordpress ##
sub vcl_recv {
  if (req.http.host == "selko.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like a dumb proxy
	#return(pass);
	#return(pipe);

	# Googlebot-Image doesn't follow limits of robots.txt		
	if (req.http.User-Agent ~ "Googlebot-Image") {
		if (!req.url ~ "/uploads/|/images/") {
			return(synth(403, "Forbidden"));
		} 
	}
	
	# Limit logins by acl whitelist
	if ( req.url ~ "^/wp-login.php" && !client.ip ~ whitelist ) {
		return(synth(403, "Forbidden."));
	}

	# drops stage site
	if (req.url ~ "/stage") {
		return(pass);
	}

	# drops amp; IDK if really needed, but there is no point even try because Google is caching AMP-pages
	if (req.url ~ "/amp/") {
		return(pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
	return(pipe);
	}

	### Do not Cache: special cases ###


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

	## Wordpress etc ##

	# Don't cache post and edit pages
	if (req.url ~ "/wp-(post.php|edit.php)") {
		return(pass);
	}

	# Don't cache logged-in user and cart
	if ( req.http.Cookie ~ "wordpress_logged_in|resetpass" ) {
		return(pass);
	}

	# REST API
	if ( !req.http.Cookie ~ "wordpress_logged_in" && req.url ~ "/wp-json/wp/v2/users" ) {
		return(synth(403, "Unauthorized request"));
	}

	# Page of contact form
	if (req.url ~ "/(tiedustelut)") {
		return(pass);
	}

	# Did not cache the RSS feed
	if (req.url ~ "/feed") {
		return(pass);
	}

	# Must Use plugins I reckon
	if (req.url ~ "/mu-") {
		return (pass);
	}
	
	#Hit everything else
	if (!req.url ~ "/wp-(login|admin|cron)|logout|administrator|resetpass") {
		unset req.http.Cookie;
	}
	
	## Everything else
	
	# Cache all others requests if they reach this point
	return(hash);

  }
}