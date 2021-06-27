## Gitea


############### vcl_recv #################
#
sub vcl_recv {

  if (req.http.host == "git.eksis.one") {
		set req.backend_hint = gitea;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	### Gitea is quite impossible to cache with Varnish. To keep return(pass) is the best option.
	
	## Common rules
	call common_rules;
	
	## Auth requests shall be passed
	if (req.http.Authorization || req.method == "POST") {
		return (pass);
	}
	
	## Do not cache AJAX requests.
	if (req.http.X-Requested-With == "XMLHttpRequest") {
		return(pass);
	}
	
	## Only GET and HEAD are cacheable methods AFAIK
	# Well, Varnish doesn't cache POST and others anyway and I don't like unneeded pass-jumps
	if (req.method != "GET" && req.method != "HEAD") {
		return(pass);
	}
	
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
		# Why did I something like that?
		#else {
		#	set req.http.x-bot = "tech";
		#}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.x-bots != "nice") {
			call stop_pages;
		}
	
	## Still too curious?
	if (req.url ~ "^/(ads.txt|sellers.json)") {
		return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
	}
	
	## Only directory-likes and standard pages can be cached if you are brave enough
	if (req.url == "/explore/repos") {
		return(pass);
	}
	
	if (
	req.url !~ "/explore/"
	&& req.url !~ "/licenses.txt"
	&& req.url !~ "/tietosuojaseloste"
	&& req.url !~ "/humans.txt"
	&& req.url !~ "/avatar"
	# this is bad idea, but my repos are quite static...
	&& req.url !~ "/src/"
	) {
		return(pass);
	}
	
	# Cache all others requests when they reach this point
	return (hash);

  # The end of the host
  }
# The end of the sub
}