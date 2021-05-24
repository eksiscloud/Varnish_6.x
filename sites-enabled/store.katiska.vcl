## Wordpress (Woocommerce) ##
sub vcl_recv {
  if (req.http.host == "store.katiska.info") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	## This caches almost nothing

	call common_rules;

	# drops stage site
	if (req.url ~ "/stage") {
		return (pipe);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	# Email-link to Gravity form by WP Offload
	if (req.url ~ "^/wp-json/wp-offload-ses/v1/") {
		return(pass);
	}

	# Pass the Store related
	if (req.url ~ "/(koulutukset-2|tuote)") {
		return (pass);
	}
	
	# Page of contact form
	if (req.url ~ "/(tiedustelut)") {
		return (pass);
	}
	
	# Gravity form 
	if (req.url ~ "/puhelinajan-lisatiedot") {
		return(pass);
	}

	# WooCommerce common
	call wc_basics;
	
	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);

  }
}

