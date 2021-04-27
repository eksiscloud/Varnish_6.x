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

# User agent is allowed only from whitelisted IP
include "/etc/varnish/ext/420.vcl";

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
#backend kaffein {
#	.path = "/var/discourse/shared/jagster/nginx.http.sock";
#}

# Only allow purging from specific IPs
acl purge {
	"localhost";
	"127.0.0.1";
}

# This can do almost everything
acl whitelist {
	"localhost";
	"netti.link";
	"127.0.0.1";
	"84.231.164.255";
	"104.248.141.204";
	"64.225.73.149";
	"138.68.111.130";
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
	
	
	## I have strange redirection issue with all wordpresses
	## Must be a problem with cookies but can't solve it out
	## So, I'm taking a short road here
	if (
		   req.url ~ "&_wpnonce"
		|| req.url ~ "&reauth=1"
		) {
			return(pipe);
		}
		
	## Before anything else we clean up some trashes
	
		# Technical probes, so let them at large
		# These are useful and we want to know if backend is working etc.
		if (
			   req.http.User-Agent == "KatiskaWarmer"
			|| req.http.User-Agent == "Varnish Health Probe"
			|| req.http.User-Agent ~ "Monit"
			|| req.http.User-Agent ~ "WP Rocket/"
			|| req.http.User-Agent ~ "UptimeRobot"
			|| req.http.User-Agent ~ "Matomo"
			|| req.http.User-Agent ~ "Let's Encrypt validation server"
			) {
				return(pipe);
			}
		
		# These are nice bots, so let them through using nice-bot.vcl
		call cute_bot_allowance;
		
		# If you follow robots.txt you aren't a rotten one and Fail2ban doesn't ban you
		# This bypasses bad bot detection and lets every bots read robots.txt
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
		#if (req.url ~ "^/xmlrpc.php" && !client.ip ~ whitelist) {
		#	return(synth(423, "Post not allowed for " + client.ip));
		#}

		# I need curl every now and then, others not
		# Commented, because 420.vcl is doing the job
		#if (req.http.User-Agent ~ "curl/" && !client.ip ~ whitelist) {
		#	return(synth(420, "Forbidden Method"));
		#}
		
		# I need libwww-perl too
		# Commented, because 420.vcl is doing the job
		#if (req.http.User-Agent ~ "libwww-perl" && !client.ip ~ whitelist) {
		#	return(synth(420, "Forbidden Method"));
		#}
		
		# Trying figure out some strange traffic
		# Basicly, I'll try to find out which service will break down now
		# case 1
		if (client.ip ~ target && req.http.User-Agent == "Go-http-client/1.1") {
			return(synth(402, "Denied Access"));
		}
		# case 2
		if (client.ip ~ target && req.http.User-Agent == "^$") {
			return(synth(402, "Denied Access"));
		}
		
		## Special cases

		# Bots in 420.vcl are using same IP-space every now and then than real users, so I can't ban the IP.
		# Error 402 doesn't trigger Fail2ban here
		if (!client.ip ~ whitelist) {
			call foreign_agents;
		}
		
		# Now we stop known useless ones who's not from whitelisted IPs using bad-bot.vcl
		# This should not be active if Nginx do what it should do because I have bot filtering there
		if (!client.ip ~ whitelist) {
			call bad_bot_detection;
		}
		
		# Stop bots and knockers seeking holes using 403.vcl
		call stop_pages;
	
		# More or less just an example here. 
		# I'm cleaning bots and knockers using bad bot and 403 VCLs plus Fail2ban
		#if (client.ip ~ forbidden) {
		#	return(synth(403, "Forbidden IP"));
		#}
	
	# Who can do BAN, PURGE and REFRESH
	# Remember to use capitals when doing, size matters...
	
	if (req.method == "BAN") {
		if (!client.ip ~ purge) {
			return (synth(405, "Banning not allowed for " + client.ip));
		}
		ban("obj.http.x-url ~ " + req.http.x-ban-url +
			" && obj.http.x-host ~ " + req.http.x-ban-host);
		# Throw a synthetic page so the request won't go to the backend.
		return(synth(200, "Ban added"));
	}
	
	if (req.method == "PURGE") {
		if (!client.ip ~ purge) {
			return (synth(405, "Purging not allowed for " + client.ip));
		}
		return (purge);
	}
	
	if (req.method == "REFRESH") {
		if (!client.ip ~ purge) {
			return(synth(405, "Refreshing not allowed for " + client.ip));
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
			req.http.X-Forwarded-For + " " + client.ip;
		} else {
			set req.http.X-Forwarded-For = client.ip;
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
	
	## Needed for Monit
	if (req.url ~ "/pong") {
		return(pipe);
	}
	
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
	
	if (resp.status == 999) {
	# I use special error status 999 to force 301 redirects
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	}
	
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
	
	# all other errors if any
	set resp.http.Content-Type = "text/html; charset=utf-8";
	set resp.http.Retry-After = "5";
	synthetic( {"<!DOCTYPE html>
<html>
  <head>
    <title>"} + resp.status + " " + resp.reason + {"</title>
  </head>
  <body>
    <h1>Error "} + resp.status + " " + resp.reason + {"</h1>
    <p>"} + resp.reason + {"</p>
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


