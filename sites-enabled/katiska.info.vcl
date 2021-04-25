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

	# Wordpress REST API
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass
		if (client.ip ~ whitelist) {
			return(pass);
		}
		# Must be logged in
		elseif (!req.http.Cookie ~ "wordpress_logged_in") {
			return(synth(403, "Unauthorized request"));
		}
	}
	
	# drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	# drops Mailster
	if (req.url ~ "/postilista/") {
		return(pass);
	}
	
	# AWStats
	if (req.url ~ "cgi-bin/awsstats.pl") {
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
	# This should not happend because I give a pipeline to UA Let's Encrypt
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

