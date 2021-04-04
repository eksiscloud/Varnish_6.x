## Common for all subdomains
##
sub vcl_recv {

	#return(pipe);
	
	# Enable smart refreshing
	# Remember your header Cache-Control must be set something else than no-cache
	# Otherwise everything will miss
	if (req.http.Cache-Control ~ "no-cache" && client.ip ~ purge) {
		set req.hash_always_miss = true;
	}
	
	#### All of this cookie things should be unnecessary because of the last statement ####
	
	## Cookies

	# Remove the "has_js" Cookie
	set req.http.Cookie = regsuball(req.http.Cookie, "has_js=[^;]+(; )?", "");

	# Remove any Google Analytics based Cookies
	set req.http.Cookie = regsuball(req.http.Cookie, "__utm.=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "_ga=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "_ga_XVK2PFXMLP=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "_gali=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "_gid=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "utmctr=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "utmcmd.=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "utmccn.=[^;]+(; )?", "");

	# Remove Caos, locally stored GA
	set req.http.Cookie = regsuball(req.http.Cookie, "caosLocalGA=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "caosLocalGA_gid=[^;]+(; )?", "");

	# Remove the Quant Capital Cookies (added by some plugin, all __qca)
	set req.http.Cookie = regsuball(req.http.Cookie, "__qc.=[^;]+(; )?", "");

	# Remove the wp-settings-1 Cookie
	set req.http.Cookie = regsuball(req.http.Cookie, "wp-settings-1=[^;]+(; )?", "");

	# Remove the wp-settings-time-1 Cookie
	set req.http.Cookie = regsuball(req.http.Cookie, "wp-settings-time-1=[^;]+(; )?", "");

	# Remove the wp test Cookie
	set req.http.Cookie = regsuball(req.http.Cookie, "wordpress_test_Cookie=[^;]+(; )?", "");

	# Remove the phpBB Cookie. This will help us cache bots and anonymous users.
	#set req.http.Cookie = regsuball(req.http.Cookie, "style_Cookie=[^;]+(; )?", "");
	#set req.http.Cookie = regsuball(req.http.Cookie, "phpbb3_psyfx_track=[^;]+(; )?", "");

	# Remove the PHPSESSID in members area Cookie
	set req.http.Cookie = regsuball(req.http.Cookie, "PHPSESSID=[^;]+(; )?", "");

	# Remove DoubleClick offensive Cookies
	set req.http.Cookie = regsuball(req.http.Cookie, "__gads=[^;]+(; )?", "");

	# Remove the AddThis Cookies
	set req.http.Cookie = regsuball(req.http.Cookie, "__atuv.=[^;]+(; )?", "");

	# Remove Woocommerce Cookies, all three
	set req.http.Cookie = regsuball(req.http.Cookie, "woocommerce_cart_hash=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "woocommerce_items_in_cart=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "wp_woocommerce_session_=[^;]+(; )?", "");

	# Remove PMPro
	#set req.http.Cookie = regsuball(req.http.Cookie, "pmpro_visit=[^;]+(; )?", "");

	# _wp_session
	set req.http.Cookie = regsuball(req.http.Cookie, "_wp_session=[^;]+(; )?", "");
	
	# Moodle, this doesn't work
	#set req.http.Cookie = regsuball(req.http.Cookie, "MoodleSession=[^;]+(; )?", "");
	#set req.http.Cookie = regsuball(req.http.Cookie, "MoodleTest=[^;]+(; )?", "");
	#set req.http.Cookie = regsuball(req.http.Cookie, "MOODLEID=[^;]+(; )?", "");
	
	# Gitea
	set req.http.Cookie = regsuball(req.http.Cookie, "i_like_gitea=[^;]+(; )?", "");
	set req.http.Cookie = regsuball(req.http.Cookie, "_csrf=[^;]+(; )?", "");
	
	# Let's kill some cookies 

	if (req.http.Cookie ~ "__distillery") {
		unset req.http.Cookie; 
	}
	if (req.http.Cookie ~ "mp_") {
		unset req.http.Cookie;
	}
	if (req.http.Cookie ~ "basepress") {
		unset req.http.Cookie;
	}
	if (req.http.Cookie ~ "_pk_") {
		unset req.http.Cookie;
	}

	# Are there Cookies left with only spaces or that are empty?
	if (req.http.Cookie ~ "^ *$") {
		unset req.http.Cookie;
	}
	
	## This actually do the magic? With statemant at vcl_hash it should let backend decide if a cookie means caching or not.
	## But will backends really do that? That's the question.
	
	# save the cookies before the built-in vcl_recv
	set req.http.Cookie-Backup = req.http.Cookie;
	unset req.http.Cookie;
	
	#### We are ready wuth cookies now ####


	## Now we do everything per domains which are declared in all-vhost.vcl

}
