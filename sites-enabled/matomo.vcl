## Matomo analytics
sub vcl_recv {
  if (req.http.host == "stats.eksis.eu") {
		set req.backend_hint = default;

	### Here is nothing to cache, I'm only user and statistics are really dynamic
	
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
	
	## Technical probes, so let them at large using probes.vcl
	# These are useful and I want to know if backend is working etc.
	call tech_things;
		
	## These are nice bots, so let them through using nice-bot.vcl and using just one UA
	call cute_bot_allowance;
	
	# and now we stop those nice ones, they have abolut nothing to do here
	if (req.http.x-bot == "nice") {
		return(synth(403, "Forbidden to: " + req.http.user-agent));
	}
	
	## Now we stop known useless ones who's not from whitelisted IPs using bad-bot.vcl
	# This should not be active if Nginx do what it should do because I have bot filtering there
	if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
		call bad_bot_detection;
	}
	
	## Stop bots and knockers seeking holes using 403.vcl
	# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
	# Good bots shouldn't come here but but better to be safe than sorry.
	if (req.http.x-bots != "nice") {
		call stop_pages;
	}
	
	## And last but not least: pass everything
	return (pass);

  # The end of the host
  }
# The end of the sub
}