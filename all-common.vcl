## Common for all subdomains
##
sub vcl_recv {

	### Cookies: Varnish >6.4 (same as earlier libvmod-cookie)
	
	## Keepning needed cookies and deleting rest. Setting up flag, because I don't want to send every cookie to every hosts.
	# Well, filtering per site type is quite meaningless, though. And adds more hassling.
	
	# Gitea (almost nothing can be cached)
	if (req.http.host ~ "git.eksis.one") {
		cookie.parse(req.http.cookie);
		# https://docs.gitea.io/en-us/config-cheat-sheet/
		cookie.keep("i_like_gitea,_csrf,redirect_to,lang,gitea_incredible,gitea_awesome");
		set req.http.cookie = cookie.get_string();
		set req.http.cookie-git = req.http.cookie;
	}
	
	# Discourses (waste of time, must pipe to work)
	elseif (
		req.http.host ~ "kaffein.jagster.fi"
		|| req.http.host ~ "proto.eksis.one"
		|| req.http.host ~ "meta.katiska.info"
	) {
		cookie.parse(req.http.cookie);
		# https://meta.discourse.org/t/list-of-cookies-used-by-discourse/83690
		cookie.keep("email,destination_url,sso_destination_url,authentication_data,fsl,_t,_bypass_cache,_forum_session,dosp,");
		set req.http.cookie = cookie.get_string();
		set req.http.cookie-dc = req.http.cookie;
	}
	
	# MediaWiki
	elseif (req.http.host ~ "www.koiranravitsemus.fi") {
		cookie.parse(req.http.cookie);
		# MediaWiki sets prefix from conf
		cookie.keep("mikromakro_");
		set req.http.cookie = cookie.get_string();
		set req.http.cookie-wiki = req.http.cookie;
		
	# Everything else must be pure Wordpress and/or Woocommerce
	} else {
		cookie.parse(req.http.cookie);
		# I'm deleting test_cookie because 'wordpress_' acts like wildcard, I reckon
		cookie.delete("wordpress_test_Cookie");
		cookie.keep("wordpress_,wp-settings,_wp-session,wordpress_logged_in_,resetpass,woocommerce_cart_hash,woocommerce_items_in_cart,wp_woocommerce_session_");
		set req.http.cookie = cookie.get_string();
		set req.http.cookie-wp = req.http.cookie;
	}

	# Cleaning everything
	unset req.http.cookie;

	## Now we do everything per domains which are declared in all-vhost.vcl
}
