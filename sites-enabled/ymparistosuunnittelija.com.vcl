

## Wordpress (no commenting) ##
sub vcl_recv {
  if (req.http.host == "ymparistosuunnittelija.com" || req.http.host == "www.ymparistosuunnittelija.com") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);


	# I don't need this because I'm using Fail2ban, but this is more like a safetynet
	if(vsthrottle.is_denied(req.http.X-Forwarded-For, 2, 1s) && (req.url ~ "xmlrpc|wp-login.php|\?s\=")) {
		return (synth(413, "Too Damn Much"));
		# Use shield vmod to reset connection
		#shield.conn_reset();
	}

	#Prevent users from making excessive POST requests that aren't for admin-ajax
	if(vsthrottle.is_denied(req.http.X-Forwarded-For, 15, 10s) && ((!req.url ~ "\/wp-admin\/|(xmlrpc|admin-ajax)\.php") && (req.method == "POST"))){
		return (synth(413, "Too Damn Much"));
		# Use shield vmod to reset connection
		#shield.conn_reset(); #this isn't working anymore
	}

	# Normalize hostname as www. to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^ymparistosuunnittelija\.com$", "www.ymparistosuunnittelija.com");

	# drops amp; IDK if really needed, but there is no point even try because Google is caching AMP-pages
	if (req.url ~ "/amp/") {
		return (pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
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
	
	# REST API
	if ( !req.http.Cookie ~ "wordpress_logged_in" && req.url ~ "/wp-json/wp/v2/users" ) {
		return(synth(403, "Unauthorized request"));
	}

	# Did not cache the RSS feed
	if (req.url ~ "/feed") {
	return (pass);
	}

	# Must Use plugins I reckon
	if (req.url ~ "/mu-.*") {
	return (pass);
	}
	
	# Check the Cookies for wordpress-comment items I reckon
	if (req.http.Cookie ~ "comment_") {
	return (pass);
	}
	
	#Hit everything else
	if (!req.url ~ "/wp-(login|admin|cron)|logout|administrator|resetpass") {
	unset req.http.Cookie;
	}
	
	## General filtering
	
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
	
	# Do not cache HTTP authentication and HTTP Cookie
	if (req.http.Authorization || req.http.Cookie) {
	return (pass);
	}
	
	# Cache all others requests if they reach this point
	return (hash);

	
}
  
}
