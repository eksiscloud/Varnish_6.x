## Jakke Lehtonen
## from several sources
## Heads up! There is errors for sure
## I'm just another copypaster
##
## Varnish 6.2.1 default.vcl for multiple virtual hosts
## 
#
# Lets's start caching
 
#
 
# Marker to tell the VCL compiler that this VCL has been adapted to the 4.0 format.
vcl 4.1;

import directors;	# Load the vmod_directors
import std;			# Load the std, not STD for god sake

# Let's Encrypt; this was just for Hitch and has nothing to do right now
#include "/etc/varnish/ext/letsencrypt.vcl";

# Probes and similar good stuff
include "/etc/varnish/ext/probes.vcl";

# CORS
include "/etc/varnish/ext/cors.vcl";

# Monit
include "/etc/varnish/ext/monit.vcl";

# Bad Bad Robots
include "/etc/varnish/ext/bad-bot.vcl";

# Cute and nice botties
include "/etc/varnish/ext/nice-bot.vcl";

# Stop knocking
include "/etc/varnish/ext/403.vcl";

# Some will get error 444
include "/etc/varnish/ext/404-444.vcl";

# Global redirecting if any
include "/etc/varnish/ext/404.vcl";

# Cheshire cat at headers
include "/etc/varnish/ext/cheshire_cat.vcl";

# X-headers, just for fun
include "/etc/varnish/ext/x-heads.vcl";


probe sondi {
    #.url = "/index.html";  # or you can use just an url
	# you must have installed libwww-perl:
    .request =
      "HEAD / HTTP/1.1"
      "Host: www.katiska.info"
      "Connection: close"
      "User-Agent: Varnish Health Probe";
	.timeout = 3s;
	.interval = 4s;
	.window = 5;
	.threshold = 3;
}

backend default {					# use your servers instead default if you have more than just one
	.host = "127.0.0.1";			# IP or Hostname of backend
	.port = "81";					# Apache or whatever is listening
#	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi;					# We have chance to recycle the probe 
}

## REMEMBER: You can not do pipe or pass before domain.vcl 
## If you do so, the backend can't be founded and all you get is your very first domain in alphabetically

# git.eksis.one by Gitea
backend gitea {
	.path = "/run/gitea/gitea.sock";
	#.host = "localhost";
	#.port = "3000";					# Gitea
}

#backend wiki {
#	.host = "127.0.0.1";
#	.port = "82";
#}

# proto.eksis.one by Discourse
# Served by Nginx because my VCLs have something wrong
#backend proto {
#	.path = "/var/discourse/shared/proto/nginx.http.sock";
#}

# kaffein.jagster.fi by Discourse
# Served by Nginx because my VCLs have something wrong
backend kaffein {
	.path = "/var/discourse/shared/jagster/nginx.http.sock";
}

## ACLs: I can't use client.ip because it is alwaus 127.0.0.1 because of Nginx (or any proxy like Apache2)
## It have to be like (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)

# Only allow purging from specific IPs
acl purge {
	"localhost";
	"127.0.0.1";
	"84.231.164.255";
	"104.248.141.204";
	"64.225.73.149";
	"138.68.111.130";
}

# This can do almost everything
acl whitelist {
	"localhost";
	"netti.link";
	"127.0.0.1";
	"84.231.164.255";
	"104.248.141.204";
	#"64.225.73.149";
	"138.68.111.130";
}

# Mostly finnish ISPs that can't be banned by Fail2ban
acl isplist {
	#"84.231.164.255";
	"37.33.128.0"/17;
	"37.219.0.0"/17;
	"37.219.128.0"/17;
	"46.132.0.0"/17;
	"66.220.144.0"/20;
	"78.27.64.0"/19;
	"80.220.0.0"/16;
	"80.222.0.0"/15;
	"83.245.224.0"/21;
	"84.248.0.0"/15; 
	"84.250.0.0"/15;
	"84.253.192.0"/19;
	"85.76.16.0"/21;
	"85.76.40.0"/21;
	"85.76.48.0"/21;
	"85.76.72.0"/21;
	"85.76.8.0"/21;
	"85.76.32.0"/21;
	"85.76.64.0"/21;
	"85.76.104.0"/21;
	"85.76.112.0"/21;
	"85.76.128.0"/21;
	"85.76.136.0"/21;
	"85.76.144.0"/21;
	"86.114.192.0"/18;
	"87.95.0.0"/17;
	"88.193.0.0"/16;
	"89.27.96.0"/21;
	"91.152.0.0"/16;
	"91.155.0.0"/16;
	"91.159.0.0"/16;
	"93.106.0.0"/17;
	"93.106.128.0"/18;
	"95.214.64.0"/24;
	"109.240.128.0"/17;
	"176.93.128.0"/17;
	"188.238.128.0"/17;
	"194.111.82.0"/23;
	"207.241.224.0"/20;
}

# UptimeRobot should be whitelisted
acl uptime {
	"69.162.124.224"/28;
	"63.143.42.240"/28;
	"216.245.221.80"/28;
	"208.115.199.16"/28;
	"104.131.107.63";
	"122.248.234.23";
	"128.199.195.156";
	"138.197.150.151";
	"139.59.173.249";
	"146.185.143.14";
	"159.203.30.41";
	"159.89.8.111";
	"165.227.83.148";
	"178.62.52.237";
	"18.221.56.27";
	"167.99.209.234";
	"216.144.250.150";
	"34.233.66.117";
	"46.101.250.135";
	"46.137.190.132";
	"52.60.129.180";
	"54.64.67.106";
	"54.67.10.127";
	"54.79.28.129";
	"54.94.142.218";
}

# I'm using this sometimes for testing purposes
acl target {
	"127.0.0.1";
}

# just an example, I use 403.vcl together fail2ban
#acl forbidden {
#	"134.209.232.158";
#	"5.117.231.54";
#}

#################### vcl_init ##################
# Called when VCL is loaded, before any requests pass through it. Typically used to initialize VMODs.
# You have to define server at backend definition too.

sub vcl_init {

}


############### vcl_recv #################
## We should have here only statments without return(...)
## because such goes over virtual hosts

sub vcl_recv {
	
	### pass/pipe here are varnish-wide
	
	## Your lifeline: Turn OFF cache (everything else happends, though)
	## For caching keep this commented
	# return(pass);
	
	
	## Your last hope: a dumb TCP termination
	## It passes everything right thru Varnish
	# return(pipe);
	
	
	### The work starts here
	
	## You never know if this is needed
	set req.http.X-Agent = req.http.User-Agent;
	
	## I have strange redirection issue with all WordPresses
	## Must be a problem with cookies but I can't solve it out
	## So, I'm taking a short road here
	if (
		   req.url ~ "&_wpnonce"
		|| req.url ~ "&reauth=1"
		) {
			return(pipe);
		}
		
	## Before anything I must clean up some trashes
	
		# Technical probes, so let them at large using probes.vcl
		# These are useful and I want to know if backend is working etc.
		call tech_things;
		
		# These are nice bots, so let them through using nice-bot.vcl and using just one UA
		call cute_bot_allowance;
		
		# If you follow robots.txt you aren't a rotten one and Fail2ban doesn't ban you
		# This bypasses bad bot detection and lets every bots read robots.txt (if I wouldn't use Nginx...)
		if (req.url ~ "^/robots.txt") {
			return(pass);
		}
		
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
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ target && req.http.User-Agent == "Go-http-client/1.1") {
			return(synth(402, "Denied Access"));
		}
		# case 2
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ target && req.http.User-Agent == "^$") {
			return(synth(402, "Denied Access"));
		}
		
		## Special cases
		
		# Now we stop known useless ones who's not from whitelisted IPs using bad-bot.vcl
		# This should not be active if Nginx do what it should do because I have bot filtering there
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
			call bad_bot_detection;
		}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (!req.http.User-Agent == "Nice bot") {
			call stop_pages;
		}
	
		# More or less just an example here. 
		# I'm cleaning bots and knockers using bad bot and 403 VCLs plus Fail2ban
		#if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ forbidden) {
		#	return(synth(403, "Forbidden IP"));
		#}
	
	# Who can do BAN, PURGE and REFRESH
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
		return (purge);
	}
	
	if (req.method == "REFRESH") {
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ purge) {
			return(synth(405, "Refreshing not allowed for " + req.http.X-Real-IP));
		}
		set req.method = "GET";
		set req.hash_always_miss = true;
	}

	# Only deal with "normal" types
	if (req.method != "GET" &&
	req.method != "HEAD" &&
	req.method != "PUT" &&
	req.method != "POST" &&
	req.method != "TRACE" &&
	req.method != "OPTIONS" &&
	req.method != "PATCH" &&
	req.method != "DELETE") {
	# Non-RFC2616 or CONNECT which is weird. */
	# Why send the packet upstream, while the visitor is using a non-valid HTTP method? */
		return(synth(405, "Non-valid HTTP method!"));
	}

	# Implementing websocket support
	if (req.http.Upgrade ~ "(?i)websocket") {
		return(pipe);
	}
	
	## Giving a pipeline to sites that I doesn't want to be under influence of Varnish (except killing the bots)
	# - Moodle dislike Varnish (I have some cookie issues) and Moodle has its own system to cache things
	# - When a Woocommerce is small and there isn't any real content, Varnish will give only headache
	# - Matomo is quite dynamic and because there is no other users, Varnish doesn't help a bit
	if (
		   req.http.host == "pro.eksis.one" 			# Moodle
		|| req.http.host == "pro.katiska.info" 			# Moodle
		|| req.http.host == "store.katiska.info"		# Woocommerce
		|| req.http.host == "stats.eksis.eu"			# Matomo
		|| req.http.host == "graph.eksis.eu"			# Munit
		) {
			return(pipe);
		}
	
	# Let's tune up a bit behavior for healthy backends: Cap grace to 5 min
	if (std.healthy(req.backend_hint)) {
		set req.grace = 300s;
	}

	# Fix Wordpress visual editor issues, must be the first one as url requests to work
	if (req.url ~ "/wp-(login|admin|comments-post.php|cron)" || req.url ~ "preview=true") {
		return (pass);
	}

	# That's it, no more filtering by user-agent
	unset req.http.User-Agent;

	## Normalize the header, remove the port (in case you're testing this on various TCP ports)
	set req.http.host = regsub(req.http.host, ":[0-9]+", "");
	
	## Setting http headers for backend
	if (req.restarts == 0) {
		if (req.http.X-Forwarded-For) {
			set req.http.X-Forwarded-For =
			req.http.X-Forwarded-For + " " + req.http.X-Real-IP;
		} else {
			set req.http.X-Forwarded-For = req.http.X-Real-IP;
		}
	}
	
	## Awstats needs the host 
	# You must add something like this in systemctl edit --full varnishncsa at line StartExec:
	# -F '%%{X-Forwarded-For}i %%{VCL_Log:X-Req-Host}x %%l %%u %%t "%%r" %%s %%b "%%{Referer}i" "%%{User-agent}i"'
	set req.http.X-Req-Host = req.http.host;
	std.log("X-Req-Host:" + req.http.X-Req-Host);
	
	## Strip a trailing #, server doesn't need it.
	if (req.url ~ "\#") {
		set req.url = regsub(req.url, "\#.*$", "");
	}

	## Strip a trailing ? if it exists 
	if (req.url ~ "\?$") {
		set req.url = regsub(req.url, "\?$", "");
	}

	## Save Origin (for CORS) in a custom header and 
	## remove Origin from the request so that backend doesn’t add CORS headers.
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;

	## Remove the proxy header
	unset req.http.Proxy;
	
	## Unset language, because I don't have any multilingual site
	unset req.http.Accept-Language;
	
	## Normalize Accept-Encoding header and compression
	# We don't need compress/uncompress, Varnish will do it automatically if backend tells so
	#if (req.http.Accept-Encoding) {
		# Do no compress compressed files...
	#	if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|mp4|ogg|jpeg|rar|zip|exe|flv|mov|wma|avi|swf|mpg|mpeg|mp4|webm|webp|pdf)$") {
	#	unset req.http.Accept-Encoding;
	#	}
	#}
	
	## Normalize the query arguments.
	# Note: Placing this above the "do not cache" section breaks some WP theme elements and admin functionality.
	# Well, this is above most of those... I don't even know what this should do
	set req.url = std.querysort(req.url);
	
	## Global handling of 404 and 410
	call global-redirect;

	## Send Surrogate-Capability headers to announce ESI support to backend
	set req.http.Surrogate-Capability = "key=ESI/1.0";
	
	## At this point we jump to all-common.vcl

} 


##############vcl_pipe################
#
sub vcl_pipe {

	## Implementing websocket support
	if (req.http.upgrade) {
		set bereq.http.upgrade = req.http.upgrade;
		set bereq.http.connection = req.http.connection;
	}

	## The end of the road
	return (pipe);
}


################vcl_pass################
#
sub vcl_pass {


}


################vcl_hash##################
#
sub vcl_hash {

	hash_data(req.url);

	if (req.http.host) {
		hash_data(req.http.host);
	} else {
		hash_data(server.ip);
	}

	## hash Cookies for requests that have them 
	
	# like store cache based on PHPSESSID or woocommerce Cookie so cart doesn't show 0
	# I can't understand meaning of this. Does it work if I first fix all other cookies at vcl_recv?
	# Well, I don't have any Woocommerces behind Varnish nowadays so it is commented
	#if (req.http.Cookie) {
	#	hash_data(req.http.Cookie);
	#}
	
	if (req.http.cookie ~ "lang=") {
		set req.http.X-COOKIE = regsub(req.http.cookie, "lang=([^;]+);.*", "\1");
		hash_data(req.http.X-COOKIE);
		unset req.http.X-COOKIE;
	}
	
	if (req.http.cookie ~ "Cookie_notice_accepted=") {
		set req.http.X-COOKIE = regsub(req.http.cookie, "Cookie_notice_accepted=([^;]+);.*", "\1");
		hash_data(req.http.X-COOKIE);
		unset req.http.X-COOKIE;
	}
	
	if (req.http.Cookie-Backup) {
		# restore the cookies before the lookup if any
		set req.http.Cookie = req.http.Cookie-Backup;
		unset req.http.Cookie-Backup;
	}


	## The end
	return (lookup);

}


###################vcl_hit#########################
#
sub vcl_hit {

	## Varnish has now built-in grace, so there is no need to adjust grace times by yourself
	## Still... I do it on vcl_backend_response
	return(deliver);

}


###################vcl_miss#########################
#
sub vcl_miss {

	## ESI
	# I don't know how to handle ESI or do I need it at all
	# ESI is enabled in backend and I don't know what I should put in
	# (object needs ESI processing)
	#if (object needs ESI processing) {
	#	unset req.http.accept-encoding;
	#}


	## Last call
	return (fetch);
}


###################vcl_backend_response#############
# This will alter everything that backend responses back to Varnish
#
sub vcl_backend_response {

	# Will kick in if backend is sick
	set beresp.grace = 24h;

	# Backend is down, stop caching
	if (beresp.status >= 500 && bereq.is_bgfetch) {
		return (abandon);
	}
	
	# ESI is enabled. IDK if this is enough
	set beresp.do_esi = true;
	
	# Same thing here as in vcl_miss 
	# No clue what to put as object 
	#if (object needs ESI processing) {
	#	set beresp.do_esi = true;
	#	set beresp.do_gzip = true;
	#}
	
	# Keep the response in cache for 6 hours if the response has validating headers.
	if (beresp.http.ETag || beresp.http.Last-Modified) {
		set beresp.keep = 6h;
	}
		
	# I have an issue with one cache-control value from WordPress
	if (bereq.url ~ "/icons\.ttf\?pozjks") {
		unset beresp.http.set-cookie;
		set beresp.http.cache-control = "max-age=31536000s";
		set beresp.ttl = 1y; 
	}
	
	# I tried this with MediaWiki; it did something, but i couldn't put MediaWiki behind Varnish.
	#if (bereq.http.host ~ "koiranravitsemus.fi") {
	#	unset beresp.http.cache-control;
	#	# max-age doesn't go through and I don't know why.
	#	#set beresp.http.cache-control = "max-age=300s";
	#	set beresp.ttl = 300s;
	#}
	
	# Old wp-json leak'ish of users/authors. I'm using this only to stop nagging from Bing.
	if (beresp.status == 404 && bereq.url ~ "/kirjoittaja/") {
		set beresp.status = 410;
	}
	
	# Stupid knockers and 404-444.vcl
	call endless_void;
		
	# 301 and 410 are quite steady, so let Varnish cache resuls from backend
	if (beresp.status == 301 && beresp.http.location ~ "^https?://[^/]+/") {
		set bereq.http.host = regsuball(beresp.http.location, "^https?://([^/]+)/.*", "\1");
		set bereq.url = regsuball(beresp.http.location, "^https?://([^/]+)", "");
		return(retry);
	}
	
	if (beresp.status == 410 && beresp.http.location ~ "^https?://[^/]+/") {
		set bereq.http.host = regsuball(beresp.http.location, "^https?://([^/]+)/.*", "\1");
		set bereq.url = regsuball(beresp.http.location, "^https?://([^/]+)", "");
		return(retry);
	}

	## We are at the end
	return(deliver);

}


#######################vcl_deliver#####################
#
sub vcl_deliver {

	## Damn, backend is down (or the request is not allowed; almost same thing)
	if (resp.status == 503) {
		return(restart);
	}
	
	## Knockers with 404 will get synthetic error 999
	## They will be redirected to server IP and getting 444 from there
	if (resp.status == 999) {
		return(synth(999, "http://104.248.141.204" + req.url));
	}

	## MediaWiki doesn't set vary as I want it; this has no point anyway
	#if (req.http.host ~ "koiranravitsemus.fi") {
	#	unset resp.http.vary;
	#	set resp.http.vary = "X-Forwarded-Proto, Accept-Encoding";
	#}

	## Let's add the origin
	call cors;
	
	# Origin should be in vary too
	if (resp.http.Vary) {
		set resp.http.Vary = resp.http.Vary + ",Origin";
	} else {
		set resp.http.Vary = "Origin";
	}

	## HIT & MISS
	if (obj.hits > 0) {
		# I don't fancy boring hit/miss announcements
		set resp.http.You-had-only-one-job = "Success";
	} else {
		set resp.http.You-had-only-one-job = "Phew";
	}

	## Show hit counts (per objecthead)
	# Same here, something like X-total-hits is just boring
	set resp.http.Footprint-of-CO2-metric-tons = (obj.hits);
	
	## Not too important one, but I use these sometimes for debugging
	set resp.http.Your-Agent = req.http.X-Agent;
	set resp.http.Your-IP = req.http.X-Real-IP;

	## Remove some headers, because the client doesn't need them
	unset resp.http.Server;	
	unset resp.http.X-Powered-By;
	unset resp.http.X-Varnish;
	#unset resp.http.Age;
	unset resp.http.Via;
	unset resp.http.Link;
	unset resp.http.X-Generator;
	unset resp.http.x-url;
	unset resp.http.x-host;
	# these were by MediaWiki
	#unset resp.http.x-request-id;
	#unset resp.http.x-frame-options;
	#unset resp.http.x-content-type-options;

	## Custom headers, not so serious thing 
	call headers_x;
	call header_smiley;



	return (deliver);

}


#################vcl_purge######################
#
sub vcl_purge {

#	return (synth(200, "Purged"));

	## Only handle actual PURGE HTTP methods, everything else is discarded
	if (req.method == "PURGE") {
	# restart request
		set req.http.X-Purge = "Yes";
		# let's get right away fresh stuff
		set req.method = "GET";
		return (restart);
	}
}


##################vcl_synth######################
#
sub vcl_synth {

	## 301/302 redirects using custom status
	#if (resp.status == 720) {
	# We use this special error status 720 to force redirects with 301 (permanent) redirects
	# To use this, call the following from anywhere in vcl_recv: return(synth(720, "http://host/new.html"));
	#	set resp.http.Location = resp.reason;
	#	set resp.status = 301;
	#	return(deliver);
	#} elseif (resp.status == 721) {
	# And we use error status 721 to force redirects with a 302 (temporary) redirect
	# To use this, call the following from anywhere in vcl_recv: return(synth(721, "http://host/new.html"));
	#	set resp.http.Location = resp.reason;
	#	set resp.status = 302;
	#	return(deliver);
	#}
	
	call cors;
	
	## Custom errors
		
	# forbidden login
	if (resp.status == 403) {
		synthetic(std.fileread("/etc/varnish/error/403.html"));
		return (deliver);
	}
		
	# forbidden url
	if (resp.status == 429) {
		synthetic(std.fileread("/etc/varnish/error/429.html"));
		return (deliver);
	}
		
	# system is down
	if (resp.status == 503) {
		synthetic(std.fileread("/etc/varnish/error/503.html"));
		return (deliver);
	} 

	if (resp.status == 999) {
	# I use special error status 999 to force 301 redirects
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	}

	# all other errors if any
	set resp.http.Content-Type = "text/html; charset=utf-8";
	set resp.http.Retry-After = "5";
	synthetic( {"<!DOCTYPE html>
<html>
  <head>
    <title>Error "} + resp.status + " " + resp.reason + {"</title>
  </head>
  <body>
    <h1>Error "} + resp.status + " " + resp.reason + {"</h1>
    <p>"} + resp.reason + " for IP " + req.http.X-Real-IP + {"</p>
    <h3>Guru Meditation:</h3>
    <p>XID: "} + req.xid + {"</p>
    <hr>
    <p>Varnish cache server</p>
  </body>
</html>
"} );
    return (deliver);


} 


####################### vcl_fini #######################
#

sub vcl_fini {

  ## Called when VCL is discarded only after all requests have exited the VCL.
  # Typically used to clean up VMODs.

  return (ok);
}


# Vhosts, needed when multiple virtual hosts is in use
include "all-vhost.vcl";
include "all-common.vcl";


