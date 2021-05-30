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

	## Limit logins by acl whitelist
	if (req.url ~ "^/wp-login.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)) {
		# I can't ban finnish IPs
		if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
			return(synth(403, "Access Denied " + req.http.X-Real-IP));
		} else {
		# other knockers I can ban
			return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
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

	# drops stage site
	if (req.url ~ "/stage") {
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

