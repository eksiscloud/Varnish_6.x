sub common_rules {
	### These are common to every virtual hosts
	
	## Let's clean path to sitemaps
	if (req.url ~ "sitemap") { return(pipe); }
	
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
	
	# This just an example how to ban objects or purge all when country codes come from backend
	#if (req.method == "PURGE") {
	#	if (!std.ip(req.http.X-Real-IP, "0.0.0.0") ~ purge) {
	#		return (synth(405, "Purging not allowed for " + req.http.X-Real-IP));
	#	}
		# Backend gave X-Country-Code to indicate clearing of specific geo-variation
	#	if (req.http.X-Country-Code) {
	#		set req.method = "GET";
	#		set req.hash_always_miss = true;
	#	} else {
			# clear all geo-variants of this page
	#		return (purge);
	#		}
	#	} else {
	#		set req.http.X-Country-Code = country.lookup("country/iso_code", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	#		set req.http.X-Country-Code = std.tolower(req.http.X-Country-Code);    
	#		if (req.http.X-Country-Code !~ "(fi|se)") {
	#			set req.http.X-Country-Code = "us";
	#	}
	#}
	
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
	if (req.http.Cache-Control ~ "no-cache" && (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ purge)) {
		set req.hash_always_miss = true;
	}
	
	## Page that Monit will ping
	# Change this URL to something that will NEVER be a real URL for the hosted site, it will be effectively inaccessible.
	if (req.url == "^/monit-zxcvb") {
		return(synth(200, "OK"));
	}
	
	## 410 Gone redirects
	call all_gone;
	
	## Steady and easy 301 redirections
	call this_way;
	
	## Global handling of 404 and 410
	call global-redirect;

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
		
		# robots.txt offers a honey pot to fail2ban, let's serve it
		# BTW, it has catched never ever anything
		if (req.url ~ "^/private-wallet/") {
			return(pipe);
		}

		# Extra layer of security to xmlrpc.php 
		# Now I'm onlyone who can use xmlrpc.php
		# Commented because Nginx does this for me
		#if (req.url ~ "^/xmlrpc.php" && std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
		#	return(synth(423, "Post not allowed for " + req.http.X-Real-IP));
		#}

		# I need curl every now and then, others not
		# Commented, because 420.vcl is doing the job
		#if (req.http.User-Agent ~ "curl/" && std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
		#	return(synth(420, "Forbidden Method"));
		#}
		
		# I need libwww-perl too
		# Commented, because 420.vcl is doing the job
		#if (req.http.User-Agent ~ "libwww-perl" && (req.http.x-ip !~ whitelist)) {
		#	return(synth(420, "Forbidden Method"));
		#}
		
		# Trying figure out some strange traffic
		# Basicly, I'll try to find out which service will break down now
		# case 1
		#if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ target && req.http.User-Agent == "Go-http-client/1.1") {
		#	return(synth(402, "Denied Access"));
		#}
		# case 2
		#if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ target && req.http.User-Agent == "^$") {
		#	return(synth(402, "Denied Access"));
		#}
		
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
	
		# More or less just an example here. 
		# I'm cleaning bots and knockers using bad bot and 403 VCLs plus Fail2ban
		#if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ forbidden) {
		#	return(synth(403, "Forbidden IP"));
		#}

	## AWStats
	if (req.url ~ "cgi-bin/awsstats.pl") {
		return(pass);
	}

	## Pass Let's Encrypt
	# I'm using separate backend, so commented
	#if (req.url ~ "^/\.well-known/acme-challenge/") {
	#	return(pass);
	#}
	
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
	
# The end
}