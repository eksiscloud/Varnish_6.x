sub wp_basics {
	# Only for Wordpresses
	
	## I have strange redirection issue with all WordPresses
	## Must be a problem with cookies/caching/nonce, but I don't understand how.
	## So, I'm taking a short road here
	if (
		   req.url ~ "&_wpnonce"
		|| req.url ~ "&reauth=1"
		) {
			return(pipe);
		}
	
	# admin-ajax can be a little bit faster
	# This must be before passing wp-admin
	if (req.url ~ "admin-ajax.php" && req.http.cookie !~ "wordpress_logged_in" ) {
		return (hash);
	}
	
	# Stop behaving bad
	if (
		   req.url ~ "/adminer/"
		|| req.url ~ "^/vendor/"
		|| req.http.User-Agent ~ "jetmon"
		|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		) {
		if (
			   req.http.X-County-Code ~ "fi"
			|| req.http.x-language ~ "fi" 
			|| req.http.x-agent == "nice"
			) {
				return(synth(403, "Forbidden: " + req.http.X-Real-IP));
		} else {
				return(synth(666, "Forbidden: " + req.http.X-Real-IP));
		}
	}
	
	## Fix Wordpress visual editor issues, must be the first one as url requests to work
	if (req.url ~ "/wp-((login|admin)|comments-post.php|cron|)" || req.url ~ "/login" || req.url ~ "preview=true") {
		return(pass);
	}
	
	## Normalize the query arguments.
	# 'If...' structure is for Wordpress, so change/add something else when needed
	# If std.querysort is any earlier it will break things, like giving error 500 when logging out.
	if (req.url !~ "wp-admin" || req.url !~ "wp-login") {
		set req.url = std.querysort(req.url);
	}
	
	# Wordpress REST API
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ whitelist) {
			return(pass);
		}
		# Must be logged in
		elseif (req.http.Cookie !~ "wordpress_logged_in") {
			return(synth(403, "Unauthorized request"));
		}
	}
	
	# Don't cache wordpress related
	if (req.url ~ "(signup|activate|mail|logout)") {
		return(pass);
	}

	# Don't cache logged-in user
	if (req.http.Cookie ~ "wordpress_logged_in|resetpass") {
		return(pass);
	}
	
	# If a post is behind password
	if (req.http.Cookie ~ "wp-postpass") {
		return(pass);
	}

	# Must Use plugins I reckon
	if (req.url ~ "/mu-.*") {
		return(pass);
	}

	# Caos, locally hosted GA
	if (req.url ~ "caos") {
		return(pass);
	}

	#Hit everything else.
	# I'm dealing with both, Wordpress and Woocommerce, here even I have Woocommerce spesific vcl too.
	# Again, 'tuote' is product in finnish
	if (req.url !~ "wp-(login.php|cron.php|admin)|login|cart|my-account|wc-api|checkout|addons|loggedout|lost-password|tuote") {
		unset req.http.Cookie;
	}

# Ends here
}