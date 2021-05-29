
## Wordpress (Woocommerce) ##
sub vcl_recv {
  if (req.http.host == "eksis.one" || req.http.host == "www.eksis.one") {
		set req.backend_hint = default;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^eksis\.one$", "www.eksis.one");
	
	call common_rules;

	# Limit logins by acl whitelist
	if (req.url ~ "^/wp-login.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)) {
		if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
				return(synth(403, "Access Denied " + req.http.X-Real-IP));
		} else {
				return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
	}

	# drops stage site totally
	if (req.url ~ "/stage") {
		return (pipe);
	}

	# Discourse as commenting
	if (req.url ~ "/wp-json/wp-discourse/v1/discourse-comments") {
		return(pass);
	}

	# drops Mailster/contact form
	if (req.url ~ "/postilista/") {
		return (pass);
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}
	
	# Keep this last
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  }
}

