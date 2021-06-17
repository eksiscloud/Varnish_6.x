sub wc_basics {
	# Common WooCommerce related stuff

	# Fixed non AJAX cart problem
	# Does this same thing than earlier?
	if (req.http.Cookie ~ "woocommerce_(cart|session)|wp_woocommerce_session") {
		return(pass);
	}
	
	# Pass the Woocommerce related
	# 'tuote¨is product on finnish
	# If I have 'logout' among others logging out doesn't work and gives error 500.
	# I'm using plugin Peter's Login Redirect - conflict? Have to check it.
	if (req.url ~ "(cart|my-account|checkout|tuote|wc-api|addons|lost-password)") {
		return(pass);
	}

	# But if I pipe logput, it works. Matter of nonce?
	if (req.url ~ "logout") {
		return (pipe);
	}

	# Pass through the WooCommerce's add to cart 
	if (req.url ~ "\?add-to-cart") {
		return(pass);
	}
	
	 #Pass the most biggest reason why the shop is so god damn slow
	if (req.url ~ "\?wc-ajax=get_refreshed_fragments") {
		return(pass);
	}
	
	# Rest of worth of passing is declared in wordpress_common.vcl
	
# Ends here
}