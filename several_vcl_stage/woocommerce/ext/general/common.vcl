sub common_rules {
	### These are common to every woocommerce based virtual hosts
	
	## Who can do BAN, PURGE and REFRESH
	# Remember to use capitals when doing, size matters...
	
	# WP Rocket; I'm not sure how is WP Rocket actually doing ban/purge
	if (req.http.X-Purge-Method == "regex") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purger) {
			ban("req.url ~ " + req.url + " && req.http.host ~ " + req.http.host);
			return (synth(200, "Banned."));
		}
	}
	
	if (req.method == "BAN" && req.http.X-Purge-Method != "regex") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purger) {
			return (synth(405, "Banning not allowed for " + req.http.X-Real-IP));
		}
		ban("obj.http.x-url ~ " + req.http.x-ban-url +
			" && obj.http.x-host ~ " + req.http.x-ban-host);
		# Throw a synthetic page so the request won't go to the backend.
		return(synth(200, "Ban added"));
	}
	
	# soft/hard purge
	if (req.method == "PURGE" && req.http.X-Purge-Method != "regex") {
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
	
	## Enable smart refreshing, aka. ctrl+F5 will flush that page
	# Remember your header Cache-Control must be set something else than no-cache
	# Otherwise everything will miss
	if (req.http.Cache-Control ~ "no-cache" && (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ purger)) {
		set req.hash_always_miss = true;
	}
	
	## Page that Monit will ping
	# Change this URL to something that will NEVER be a real URL for the hosted site, it will be effectively inaccessible.
	if (req.url == "^/monit-zxcvb") {
		return(synth(200, "OK"));
	}
	
	## 410 Gone redirects by 410sites.vcl
	call all_gone;
	
	## Steady and easy 301 redirections by 301sites.vcl
	call this_way;

	## I don't show ads
	if (req.url ~ "^/(ads.txt|sellers.json)") {
		return(synth(403, "Unauthorized request"));
	}

	## Implementing websocket support
	if (req.http.Upgrade ~ "(?i)websocket") {
		return(pipe);
	}

	## Cache warmup
	# wget --spider -o wget.log -e robots=off -r -l 5 -p -S -T3 --header="X-Bypass-Cache: 1" --header="User-Agent:CacheWarmer" -H --domains=example.com --show-progress www.example.com
	# It saves a lot of directories, so think where you are before launching it... A protip: /tmp
	if (req.http.X-Bypass-Cache == "1" && req.http.User-Agent == "CacheWarmer") {
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
		# Why I did this?
		#else {
		#	set req.http.x-bot = "tech";
		#}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.x-bots != "nice") {
			call stop_pages;
		}

	## AWStats
	if (req.url ~ "cgi-bin/awsstats.pl") {
		return(pass);
	}
	
	## Large static files are delivered directly to the end-user without waiting for Varnish to fully read the file first.
	# The job will be done at vcl_backend_response
	# But is this really needed nowadays?
	if (req.url ~ "^[^?]*\.(avi|mkv|mov|mp3|mp4|mpeg|mpg|ogg|ogm|wav)(\?.*)?$") {
		unset req.http.cookie;
		return(hash);
	}

	## Cache all static files by Removing all Cookies for static files
	# Remember, do you really need to cache static files that don't cause load? Only if you have memory left.
	# Here I decide to cache these static files. I exclude images because they are handled by the CDN.
	if (req.http.host !~ "cdn." && req.url ~ "^[^?]*\.(7z|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gz|ico|js|otf|pdf|png|ppt|pptx|rtf|svg|swf|tar|tbz|tgz|ttf|txt|txz|webm|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$") {
		unset req.http.cookie;
		return(hash);
	}
	
	## Let's clean User-Agent, just to be on safe side
	# It will come back at vcl_hash, but without separate cache
	# I want send User-Agent to backend because that is te only way to show who is actually getting error 404; I don't serve bots other nice ones 
	# and 404 from real users must fix right away
	set req.http.x-agent = req.http.User-Agent;
	unset req.http.User-Agent;
	
# The end
}