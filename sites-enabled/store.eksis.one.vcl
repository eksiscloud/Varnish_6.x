## Wordpress (Woocommerce) ##
sub vcl_recv {
  if (req.http.host == "store.eksis.one") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	return(pipe);

	## This caches almost nothing

	call common_rules;

	# drops stage site
	if (req.url ~ "/stage") {
		return (pass);
	}

	# drops amp; IDK if really needed, but there is no point even try because Google is caching AMP-pages
	if (req.url ~ "/amp/") {
		return (pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
	return (pipe);
	}

	# Pass the Store related
	if (req.url ~ "/(koulutukset-2|tuote)") {
	return (pass);
	}
	
	# Page of contact form
	if (req.url ~ "/(tiedustelut)") {
	return (pass);
	}

	# WooCommerce common
	call wc_basics;
	
	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  }
}

