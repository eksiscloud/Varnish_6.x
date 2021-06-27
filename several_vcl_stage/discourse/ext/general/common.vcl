# Common for all Discourses

sub common_rules {

	## Remove the proxy header
	# Well... Nginx doesn't use it, and I don't use Hitch; unnecessary
	unset req.http.Proxy;
	
	## Remove the Google Analytics added parameters, useless for backend
	if (req.url ~ "(\?|&)(utm_source|utm_medium|utm_campaign|utm_content|gclid|fbclid|cx|ie|cof|siteurl)=") {
		set req.url = regsuball(req.url, "&(utm_source|utm_medium|utm_campaign|utm_content|gclid|fbclid|cx|ie|cof|siteurl)=([A-z0-9_\-\.%25]+)", "");
		set req.url = regsuball(req.url, "\?(utm_source|utm_medium|utm_campaign|utm_content|gclid|fbclid|cx|ie|cof|siteurl)=([A-z0-9_\-\.%25]+)", "?");
		set req.url = regsub(req.url, "\?&", "?");
		set req.url = regsub(req.url, "\?$", "");
	}
	
	## Strip querystring ?nocache, 3rd party doesn't tell when caching or not
	set req.url = regsuball(req.url, "\?nocache", "");
	
	## Strip a plain HTML anchor #, server doesn't need it.
	if (req.url ~ "\#") {
		set req.url = regsub(req.url, "\#.*$", "");
	}

	## Strip a trailing ? if it exists 
	if (req.url ~ "\?$") {
		set req.url = regsub(req.url, "\?$", "");
	}
	
	## Send Surrogate-Capability headers to announce ESI support to backend
	set req.http.Surrogate-Capability = "key=ESI/1.0";
	
	## Who can do BAN, PURGE and REFRESH
	# Remember to use capitals when doing, size matters...
	
	if (req.method == "BAN") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purger) {
			return (synth(405, "Banning not allowed for " + req.http.X-Real-IP));
		}
		ban("obj.http.x-url ~ " + req.http.x-ban-url +
			" && obj.http.x-host ~ " + req.http.x-ban-host);
		# Throw a synthetic page so the request won't go to the backend.
		return(synth(200, "Ban added"));
	}
	
	# soft/hard purge
	if (req.method == "PURGE") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purger) {
			return (synth(405, "Purging not allowed for " + req.http.X-Real-IP));
		} else {
		return(hash);
		 }
	}
	
	if (req.method == "REFRESH") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purger) {
			return(synth(405, "Refreshing not allowed for " + req.http.X-Real-IP));
		}
		set req.method = "GET";
		set req.hash_always_miss = true;
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
		# Why I had this?
		#else {
		#	set req.http.x-bot = "tech";
		#}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.x-bots != "nice") {
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
	
	## These are quite static
	if (req.url ~"/(robots.txt|humans.txt)") {
		return(hash);
	}

	## Awstats needs the host 
	# You must add something like this in systemctl edit --full varnishncsa at line StartExec:
	# -F '%%{X-Forwarded-For}i %%{VCL_Log:X-Req-Host}x %%l %%u %%t "%%r" %%s %%b "%%{Referer}i" "%%{User-agent}i"'
	set req.http.X-Req-Host = req.http.host;
	std.log("X-Req-Host:" + req.http.X-Req-Host);

	## AWStats
	if (req.url ~ "cgi-bin/awsstats.pl") {
		return(pipe);
	}
	
	## Implementing websocket support
	if (req.http.Upgrade ~ "(?i)websocket") {
		return(pipe);
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
	
# The end the sub
}
