sub vcl_recv {
  if (req.http.host == "stats.eksis.eu") {
		set req.backend_hint = matomo;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## General rules common to every backend by common.vcl
	call common_rules;
	
	## Limit logins by acl whitelist
	if (req.url == "^/" && req.url ~ "^/index.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)) {
		# I can't ban finnish IPs
		if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
			return(synth(403, "Access Denied " + req.http.X-Real-IP));
		} else {
		# other knockers I can ban
			return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
	}
	
	## Stop knocking
	if (req.url ~ "(wp-login|xmlrpc).php") {
		if (
		   req.http.X-County-Code ~ "fi"
		|| req.http.x-language ~ "fi" 
		|| req.http.x-agent == "nice"
		) {
			return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden request from: " + req.http.X-Real-IP));
		}
	}

	## No robots.txt, ads.txt, site.webmanifest or sellers.json.
	if (req.url ~ "^/(robots.txt|ads.txt|site.webmanifest|sellers.json)") {
		return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
	}
	
	## Normally I would hash at this point, but I don't want to cache anyhing.
	return(pass);
	
  # The end of host
  }
# The end of sub-vcl
}