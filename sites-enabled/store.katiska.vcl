## WooCommerce (WordPress) ##
sub vcl_recv {
  if (req.http.host == "store.katiska.info") {
		set req.backend_hint = default;

	## Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	## General rules common to every backend by common.vcl
	call common_rules;
	
	## I have strange logout redirection issue with all WordPresses because without this logging out gives error 500
	# Must be a problem with cookies/caching/nonce or some plugin affects to endpoint redirections, but I don't understand how.
	# So, I'm taking a short road here
	# This must be here in this very one site, not in wordpress_common.vcl
	if (
		   req.url ~ "&_wpnonce"
		|| req.url ~ "&reauth=1"
		|| req.url ~ "&redirect_to"
		) {
			return(pipe);
		}

	## Individual things
	
	# drops stage site
	if (req.url ~ "/stage") {
		return (pipe);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	# Email-link to Gravity form by WP Offload
	if (req.url ~ "/wp-json/wp-offload-ses/v1/") {
		return(pass);
	}

	# Pass the Store related
	if (req.url ~ "/(koulutukset-2|tuote)") {
		return (pass);
	}
	
	# Page of contact form (Gravity)
	if (req.url ~ "/(tiedustelut)") {
		return (pass);
	}
	
	# Gravity form of one product
	if (req.url ~ "/(puhelinajan-lisatiedot|\?gf_token)") {
		return(pass);
	}

	## Wordpress REST API
	# For some reason this isn't working if in wordpress_common.vcl
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass, but only when logged in
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ whitelist) {
			return(pass);
		} else {
		# Must be logged in
			if (req.http.cookie !~ "wordpress_logged_in") {
				return(synth(403, "Unauthorized request"));
			}
		}
	}

	## Common WooCommerce related stuff
	call wc_basics;

	## Common rules to every WordPress. Keep this last.
	call wp_basics;
	
	## Cache all others requests if they reach this point
	return (hash);

  # The end of host
  }
# The end of sub-vcl
}

