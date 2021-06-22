## Common for all subdomains
##
sub vcl_recv {

	### Cookies: Varnish >6.4 (same as earlier libvmod-cookie)
	
	## Keeping needed cookies and deleting rest.
	# You don't need to hash with every cookie. You can do something like this too:
	# sub vcl_hash {
	#	hash_data(cookie.get("language"));
	# }
	# Well, filtering per sitetype is quite meaningless, though. And adds more hassling.
	
	# Gitea (almost nothing can be cached)
	if (req.http.host ~ "git.eksis.one") {
		set req.http.x-host = "gitea";
		cookie.parse(req.http.cookie);
		# https://docs.gitea.io/en-us/config-cheat-sheet/
		cookie.keep("i_like_gitea,_csrf,redirect_to,lang,gitea_incredible,gitea_awesome");
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-git = req.http.cookie;
	}
	
	
	# Discourses (waste of time, must pipe)
	elseif (
		req.http.host ~ "kaffein.jagster.fi"
		|| req.http.host ~ "proto.eksis.one"
		|| req.http.host ~ "meta.katiska.info"
	) {
		set req.http.x-host = "discourse";
		cookie.parse(req.http.cookie);
		# https://meta.discourse.org/t/list-of-cookies-used-by-discourse/83690
		cookie.keep("email,destination_url,sso_destination_url,authentication_data,fsl,_t,_bypass_cache,_forum_session,dosp,");
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-dc = req.http.cookie;
	}
	
	# MediaWiki
	elseif (req.http.host ~ "www.koiranravitsemus.fi") {
		set req.http.x-host = "mediawiki";
		cookie.parse(req.http.cookie);
		cookie.keep("session,UserID,UserName,LoggedOut,Token");	# I've never seen LoggedOut or Token
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-wiki = req.http.cookie;
	}
	
	# Moodle (waste of time, must pass to work)
	elseif (req.http.host ~ "pro.") {
		set req.http.x-host = "moodle";
		cookie.parse(req.http.cookie);
		cookie.keep("MoodleSession,MoodleTest,MOODLEID");
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-moodle = req.http.cookie;
	}
	
	# Matomo (no point to cache what so ever)
	elseif (req.http.host ~ "stats.eksis.eu") {
		set req.http.x-host = "matomo";
		cookie.parse(req.http.cookie);
		cookie.keep("piwik_,MATOMO_");
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-moodle = req.http.cookie;
	}
	
	# Everything else must be pure WordPress/WooCommerce
	else {
		set req.http.x-host = "wordpress";
		cookie.parse(req.http.cookie);
		# I'm deleting test_cookie because 'wordpress_' acts like wildcard, I reckon
		# But why _pk_ cookies passes?
		cookie.delete("wordpress_test_Cookie,_pk_");
		cookie.keep("wordpress_,wp-settings,_wp-session,wordpress_logged_in_,resetpass,woocommerce_cart_hash,woocommerce_items_in_cart,wp_woocommerce_session_");
		set req.http.cookie = cookie.get_string();
		#set req.http.cookie-wp = req.http.cookie;
	}

	# Don' let empty cookies travel any further
	if (req.http.cookie == "") {
		unset req.http.cookie;
	}

	## Now we do everything per domains which are declared in all-vhost.vcl
}
