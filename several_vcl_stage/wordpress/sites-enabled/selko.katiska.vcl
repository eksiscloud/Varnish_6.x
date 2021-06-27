## Wordpress

sub vcl_recv {
  if (req.http.host == "selko.katiska.info") {
		set req.backend_hint = wordpress;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like a dumb proxy
	#return(pass);
	#return(pipe);

	## General rules common to every backend by common.vcl
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

	## Discourse as commenting system
	if (req.url ~ "/wp-json/wp-discourse/v1/discourse-comments") {
		return(pass);
	}
	
	## Tag list 
	# Actually, tags are quite static so commented. But I'll give a bit shorter TTL later
	if (req.url ~ "^/tieto/avainsana/") {
		return(pass);
	}

	## Drops stage site totally
	if (req.url ~ "/stage") {
		return(pipe);
	}

	## Landing pages with form/mailing list (needs nonce)
	# I'm not sure if pass helps with nonce
	if (req.url ~ "/laskeutumissivut") {
		return(pass);
	}

	## Drops Mailster/contact form
	if (req.url ~ "/postilista") {
		return(pass);
	}

	## Pass contact form
	if (req.url ~ "/tiedustelut") {
		return(pass);
	}

	## Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	## Keep this last because wordpress_common.vcl limits more and tells cache all others etc.
	call wp_basics;
	
	## Cache all others requests if they reach this point. None should come to here, ever, because of wp_basics.
	return(hash);
	
  # The end of host
  }
# The end of sub-vcl
}