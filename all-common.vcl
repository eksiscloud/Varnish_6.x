## Common for all subdomains
##
sub vcl_recv {

#return(pipe);
	
	## Enable smart refreshing
	# Remember your header Cache-Control must be set something else than no-cache
	# Otherwise everything will miss
	if (req.http.Cache-Control ~ "no-cache" && (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ purge)) {
		set req.hash_always_miss = true;
	}
	
	### Cookies: Varnish >6.4 (same as earlier libvmod-cookie)
	# This setup isn't totally right. When giving host.com/wp-admin/ it doesn't redirect to admin, but to login.
	# So, there is issues with 'wordpress_' cookies. Or something else, IDK
	
	## First remove the Google Analytics added parameters, useless for backend
	if (req.url ~ "(\?|&)(utm_source|utm_medium|utm_campaign|utm_content|gclid|cx|ie|cof|siteurl)=") {
		set req.url = regsuball(req.url, "&(utm_source|utm_medium|utm_campaign|utm_content|gclid|cx|ie|cof|siteurl)=([A-z0-9_\-\.%25]+)", "");
		set req.url = regsuball(req.url, "\?(utm_source|utm_medium|utm_campaign|utm_content|gclid|cx|ie|cof|siteurl)=([A-z0-9_\-\.%25]+)", "?");
		set req.url = regsub(req.url, "\?&", "?");
		set req.url = regsub(req.url, "\?$", "");
	}
	
	## Setting up flag, because I don't want to send every cookie to every hosts.
	# Well, this in quite meaningless, though. And adds more hassling.
	
	# Woocommerce
	if (
	   req.http.host ~ "store.eksis.one"
	|| req.http.host ~ "store.katiska.info"
	) { set req.http.x-cookiebase = "wc"; }
	
	# Gitea
	if (req.http.host ~ "git.eksis.one") {
		set req.http.x-cookiebase = "git";
	}
	
	# Everything else must be pure Wordpress
	if (req.http.x-cookiebase == "") {
		set req.http.x-cookiebase = "wp";
	}
	
	## Let the vmod parse the "Cookie:" header from the client
	cookie.parse(req.http.cookie);

	## These I keep for caching
	# Heads Up! This can not be right. Or... can it?
	
	# Wordpress
	if (req.http.x-cookiebase == "wp" || req.http.x-cookiebase == "wc") {
		cookie.keep("wordpress_,wp-settings,wp-saving-post,_wp-session,wordpress_logged_in,resetpass");
	}
	
	# Woocommerce
	if (req.http.x-cookiebase == "wc") {
		cookie.keep("woocommerce_cart_hash,woocommerce_items_in_cart,wp_woocommerce_session_");
	}
	
	# Gitea
	if (req.http.x-cookiebase == "git" || req.http.x-cookiebase == "git") {
		cookie.keep("i_like_gitea");
	}
	
	# Others for every sites
	cookie.keep("PHPSESSID,_csrf");
	
	## Set the "Cookie:" header to the parsed/filtered value, removing all unnecessary cookies
	set req.http.cookie = cookie.get_string();
	
	## If empty, unset so the builtin VCL can consider it for caching.
	if (req.http.cookie == "") {
		unset req.http.cookie;
	}
	
	## Save the cookies if any left before the built-in vcl_recv
	# Those can be restored without cacheing at vcl_hash
	# This worked with original cookie madness, but not when cookie vmod is in use
	#set req.http.Cookie-Backup = req.http.Cookie;
	#unset req.http.Cookie;

	## Now we do everything per domains which are declared in all-vhost.vcl
}
