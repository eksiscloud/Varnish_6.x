## Discourse ##
sub vcl_recv {
  if (req.http.host == "meta.katiska.info") {
	set req.backend_hint = meta;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	## I must clean up some trashes
	
		# Technical probes, so let them at large using probes.vcl
		# These are useful and I want to know if backend is working etc.
		call tech_things;
		
		# These are nice bots, so let them through using nice-bot.vcl and using just one UA
		call cute_bot_allowance;
		
		# Now we stop known useless ones who's not from whitelisted IPs using bad-bot.vcl
		# This should not be active if Nginx do what it should do because I have bot filtering there
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
			call bad_bot_detection;
		}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.x-bots != "(nice|tech)") {
			call stop_pages;
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

	## These are quite static, except sitemap, but it is just matter of TTL
	if (req.url ~"/(robots.txt|humans.txt|sitemap)") {
		return(hash);
	}

	## The only things I can cache from Discourse.
	# Yes, I'm usin S3 as CDN, but loading from RAM is always faster than jumps to CDN edge.
	if (req.url ~ "(^/uploads/|^/assets/|^/user_avatar/)") {
      return (hash);
   }

	# And that's it. Nothing else. Must pipe or get error 500. And pipe means too that anything in vcl_backend_response amd vcl_delivet won't apply.
	return(pipe);
	
  #The end of the host
  }
# The end of the sub
}