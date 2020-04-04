## Wordpress ##
sub vcl_recv {
  if (req.http.host == "selko.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like a dumb proxy
	#return(pass);
	#return(pipe);


	# I don't need this two because I'm using Fail2ban, but this is more like a safetynet
#	if(vsthrottle.is_denied(req.http.X-Forwarded-For, 2, 1s) && (req.url ~ "xmlrpc|wp-login.php|\?s\=")) {
#		return(synth(413, "Too Damn Much"));
#	}

	#Prevent users from making excessive POST requests that aren't for admin-ajax
	if(vsthrottle.is_denied(req.http.X-Forwarded-For, 15, 10s) && ((!req.url ~ "\/wp-admin\/|(xmlrpc|admin-ajax)\.php") && (req.method == "POST"))){
		return(synth(413, "Too Damn Much"));
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

	# Allow purging from ACL
	if (req.method == "PURGE") {
		if (!client.ip ~ purge) {
			return(synth(405, "This IP is not allowed to send PURGE requests."));
		}
		return(purge);
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
	return(synth(405, "Non-valid HTTP method!"));
	}

	# Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
	if (req.http.Upgrade ~ "(?i)websocket") {
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
