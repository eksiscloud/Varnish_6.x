## Discourse ##
## this isn't served through Varnish because I just can't get it work
sub vcl_recv {
  if (req.http.host == "kaffein.jagster.fi") {
		set req.backend_hint = kaffein;
  
	# Your lifelines: 
	# Turn off cache
	#return(pass);
	# or make Varnish act like dumb proxy
	#return(pipe);

	#call common_rules;

	# Stop knocking
	if (
		   req.url ~ "wp-login.php"
		|| req.url ~ "xmlrpc.php"
		) {
		if (
		   req.http.X-County-Code ~ "fi"
		|| req.http.x-language ~ "fi" 
		|| req.http.x-agent == "nice"
		) {
			return(synth(403, "Forbidden request: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden request: " + req.http.X-Real-IP));
		}
	}

	## Who can do BAN, PURGE and REFRESH
	# Remember to use capitals when doing, size matters...
	if (req.method == "BAN") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purge) {
			return (synth(405, "Banning not allowed for " + req.http.X-Real-IP));
		}
		ban("obj.http.x-url ~ " + req.http.x-ban-url +
			" && obj.http.x-host ~ " + req.http.x-ban-host);
		# Throw a synthetic page so the request won't go to the backend.
		return(synth(200, "Ban added"));
	}
	
	if (req.method == "PURGE") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purge) {
			return (synth(405, "Purging not allowed for " + req.http.X-Real-IP));
		} 
		# WP Rocket
		if (req.http.X-Purge-Method == "regex") {
			ban("req.url ~ " + req.url + " && req.http.host ~ " + req.http.host);
			return (synth(200, "Banned."));
		} else {
			return (purge);
		}
	}
	
	if (req.method == "REFRESH") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purge) {
			return(synth(405, "Refreshing not allowed for " + req.http.X-Real-IP));
		}
		set req.method = "GET";
		set req.hash_always_miss = true;
	}

	## Only deal with "normal" types
	# This should do at Nginx?
	if (req.method != "GET" &&
	req.method != "HEAD" &&
	req.method != "PUT" &&
	req.method != "POST" &&
	req.method != "TRACE" &&
	req.method != "OPTIONS" &&
	req.method != "PATCH" &&
	req.method != "DELETE"
	) {
	# Non-RFC2616 or CONNECT which is weird.
	# Why send the packet upstream, while the visitor is using a non-valid HTTP method?
		return(synth(405, "Non-valid HTTP method!"));
	}

	## I must clean up some trashes
	
		# Technical probes, so let them at large using probes.vcl
		# These are useful and I want to know if backend is working etc.
		call tech_things;
		
		# These are nice bots, so let them through using nice-bot.vcl and using just one UA
		call cute_bot_allowance;
		
		## Special cases
		
		# Now we stop known useless ones who's not from whitelisted IPs using bad-bot.vcl
		# This should not be active if Nginx do what it should do because I have bot filtering there
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
			call bad_bot_detection;
		}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.User-Agent != "nice") {
			call stop_pages;
		}

	# Must pipe, otherwise I just get error 500
	return(pipe);

	
	# Cache all others requests if they reach this point
	return(hash);
  }
}