

## Wordpress (Woocommerce) ##
sub vcl_recv {
  if (req.http.host == "store.katiska.info") {
	#set req.backend_hint = katiska;

	# Your lifeline: Turn OFF cache
	# For caching keep this commented
	#return(pass);
	
	# If you are using SSL and it doesn't forward http to https when URL is given without protocol
#	if ( req.http.X-Forwarded-Proto !~ "(?i)https" ) {
#		set req.http.X-Redir-Url = "https://" + req.http.host + req.url;
#	return ( synth( 750 ));
#	}
	
#	set req.http.X-Forwarded-Proto = "https";
	
	if(vsthrottle.is_denied(req.http.X-Forwarded-For, 2, 1s) && (req.url ~ "xmlrpc|wp-login.php|\?s\=")) {
	return (synth(429, "Too Many Requests"));
	# Use shield vmod to reset connection
#	shield.conn_reset();
	}

#Prevent users from making excessive POST requests that aren't for admin-ajax
if(vsthrottle.is_denied(req.http.X-Forwarded-For, 15, 10s) && ((!req.url ~ "\/wp-admin\/|(xmlrpc|admin-ajax)\.php") && (req.method == "POST"))){
	return (synth(429, "Too Many Requests"));
	# Use shield vmod to reset connection
#	shield.conn_reset();
	}

	# drops stage site
	if (req.url ~ "/stage") {
		return (pass);
	}

	# drops amp
	if (req.url ~ "/amp/") {
		return (pass);
	}

	# Allow purging from ACL
	if (req.method == "PURGE") {
	# If not allowed then a error 405 is returned
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

	# Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
	if (req.http.Upgrade ~ "(?i)websocket") {
	return (pipe);
	}

	### Do not Cache: special cases ###


	# Do not cache AJAX requests.
	if (req.http.X-Requested-With == "XMLHttpRequest") {
	return(pass);
	}

	# Post requests will not be cached
	if (req.http.Authorization || req.method == "POST") {
	return (pass);
	}
	
	# Pass Let's Encrypt
	if (req.url ~ "^/\.well-known/acme-challenge/") {
	return (pass);
	}

	## Wordpress, Woocommerce, etc ##

	# Don't cache post and edit pages
	if (req.url ~ "/wp-(post.php|edit.php)") {
	return(pass);
	}

	# Don't cache logged-in user and cart
	if ( req.http.Cookie ~ "wordpress_logged_in|resetpass" ) {
	return( pass );
	}

	#fixed non AJAX cart problem
	if (req.http.Cookie ~ "woocommerce_(cart|session)|wp_woocommerce_session") {
	return(pass);
	}
	
	# Pass the Woocommerce related
	if (req.url ~ "/(cart|my-account|checkout|wc-api|addons|logout|lost-password|administrator)") {
	return (pass);
	}

	# Pass the Store related
	if (req.url ~ "/(koulutukset-2|tuote)") {
	return (pass);
	}
	
	# Page of contact form
	if (req.url ~ "/(tiedustelut)") {
	return (pass);
	}

	# Did not cache the RSS feed
	if (req.url ~ "/feed") {
	return (pass);
	}

	# Must Use plugins I reckon
	if (req.url ~ "/mu-.*") {
	return (pass);
	}

	# Pass through the WooCommerce API
	if (req.url ~ "\?wc-api=" ) {
	return (pass);
	}

	# Pass through the WooCommerce add to cart 
	if (req.url ~ "\?add-to-cart=" ) {
	return (pass);
	}
	
	# Check the Cookies for wordpress-comment items I reckon
	if (req.http.Cookie ~ "comment_") {
	unset req.http.Cookie;
	}
	
	#Hit everything else
	if (!req.url ~ "/wp-(login|admin|cron)|logout|lost-password|wc-api|cart|my-account|checkout|addons|administrator|resetpass") {
	unset req.http.Cookie;
	}
	
	## General filtering
	
	# Large static files are delivered directly to the end-user without
	# waiting for Varnish to fully read the file first.
	# Varnish 4 fully supports Streaming, so see do_stream in vcl_backend_response() to witness the glory.
	if (req.url ~ "^[^?]*\.(mp[34]|rar|tar|tgz|wav|zip|bz2|xz|7z|avi|mov|ogm|mpe?g|mk[av])(\?.*)?$") {
	unset req.http.Cookie;
	return (hash);
	}

	# Cache all static files by Removing all Cookies for static files
	# Remember, do you really need to cache static files that don't cause load? Only if you have memory left.
	# Here I decide to cache these static files. For me, most of them are handled by the CDN anyway.
	if (req.url ~ "^[^?]*\.(bmp|bz2|css|doc|eot|flv|gif|ico|jpeg|jpg|js|less|pdf|png|rtf|swf|txt|woff|xml)(\?.*)?$") {
	unset req.http.Cookie;
	return (hash);
	}
	
	# Cache all static files by Removing all Cookies for static files.
	if (req.url ~ "^[^?]*\.(html|htm|gz)(\?.*)?$") {
	unset req.http.Cookie;
	return (hash);
	}
	
	# Do not cache HTTP authentication and HTTP Cookie
	if (req.http.Authorization || req.http.Cookie) {
	return (pass);
	}
	
	# Cache all others requests if they reach this point
	return (hash);

  }
}

