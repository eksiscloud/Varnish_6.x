## Cookie rules for WooCommerces

sub vcl_recv {

	### Cookies: Varnish >6.4 (same as earlier libvmod-cookie)
	
	## Keeping needed cookies and deleting rest.
	# You don't need to hash with every cookie. You can do something like this too:
	# sub vcl_hash {
	#	hash_data(cookie.get("language"));
	# }

	cookie.parse(req.http.cookie);
	# I'm deleting test_cookie because 'wordpress_' acts like wildcard, I reckon
	# But why _pk_ cookies passes?
	cookie.delete("wordpress_test_Cookie,_pk_");
	cookie.keep("wordpress_,wp-settings,_wp-session,wordpress_logged_in_,resetpass,woocommerce_cart_hash,woocommerce_items_in_cart,wp_woocommerce_session_");
	set req.http.cookie = cookie.get_string();
	
	# Don' let empty cookies travel any further
	if (req.http.cookie == "") {
		unset req.http.cookie;
	}
	
# The end of the sub
}