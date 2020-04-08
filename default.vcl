## Jakke Lehtonen
## from several sources
## Heads up! There is errors for sure
## I'm just another copypaster
##
## Varnish 6.1.1 default.vcl for multiple virtual hosts
## 
#
# Lets's start caching
 
#
 
# Marker to tell the VCL compiler that this VCL has been adapted to the 4.0 format.
vcl 4.1;

import directors;	# Load the vmod_directors
import std;			# Load the std, not STD for god sake
import vsthrottle;	# throttling by rate

# Let's Encrypt
include "/etc/varnish/ext/letsencrypt.vcl";

# Monit
include "/etc/varnish/ext/monit.vcl";

# Bad Bad Robots
include "/etc/varnish/ext/bad-bot.vcl";

# Stop knocking
include "/etc/varnish/ext/403.vcl";

# Global redirecting
include "/etc/varnish/ext/404.vcl";

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
	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi;					# We have chance to recycle the probe 
}

# Only allow purging from specific IPs
acl purge {
	"localhost";
	"127.0.0.1";
}

acl whitelist {
	"localhost";
	"127.0.0.1";
	"your.personal.ip";
}

# just an example, I use 403.vcl together fail2ban
acl forbidden {
	"134.209.232.158";
	"5.117.231.54";
}

#################### vcl_init ##################
# Called when VCL is loaded, before any requests pass through it. Typically used to initialize VMODs.
# You have to define server at backend definition too.

sub vcl_init {

}


############### vcl_recv #################
## We should have here only statments without return(...)
## unless such goes over virtual hosts

sub vcl_recv {
	
	### pass/pipe here are varnish-wide
	
	## Your lifeline: Turn OFF cache
	## For caching keep this commented
	# return(pass);
	
	
	## Your last hope: a dumb TCP termination
	## It passes everything right thru Varnish
	# return(pipe);
	
	# More or less just an example here. 
	# I'm cleaning bots and knockers using bad bot and 403 VCLs
	if (client.ip ~ forbidden) {
		return(synth(403, "Forbidden IP"));
	}
	
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

	# Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
	if (req.http.Upgrade ~ "(?i)websocket") {
		return(pipe);
	}

	# Fix Wordpress visual editor issues, must be the first one as url requests to work
	if (req.url ~ "/wp-(login|admin|comments-post.php|cron)" || req.url ~ "preview=true") {
	return (pass);
	}
	
	# Let's clean up some trashes
		# If you follow robots.txt you aren't a rotten one and Fail2ban doesn't ban you
		# This bypasses bad bot detection and lets every bots read robots.txt
		# Commented because Nginx cleans up bots for me and only few useful gets through
#		if (req.url ~ "^/robots.txt") {
#			return(pass);
#		}
		# robots.txt offers a honey pot to fail2ban, let's serve it
		if (req.url ~ "^/private-wallet/") {
			return(pipe);
		}
		# Extra layer of security to xmlrpc.php 
		# Now I can use xmlrpc.php
		# Commented because Nginx do this for me
#		if (req.url ~ "^/xmlrpc.php" && !client.ip ~ whitelist) {
#			return(synth(666, "Post not allowed for " + client.ip));
#		}
		# I need curl every now and then, others not
		if (req.http.User-Agent ~ "curl/" && !client.ip ~ whitelist) {
			return(synth(666, "Forbidden Method"));
		}
		# now we stop known useless ones
		call bad_bot_detection;
		call stop_pages;
		
	# Starting state for grace perios
	set req.http.grace = "For you? No!";
	
	if (std.healthy(req.backend_hint)) {
		# change the behavior for healthy backends: Cap grace to 10s
		set req.grace = 10s;
	}
	
	# Normalize the header, remove the port (in case you're testing this on various TCP ports)
	set req.http.host = regsub(req.http.host, ":[0-9]+", "");
	
	# Setting http headers for backend
	if (req.restarts == 0) {
		if (req.http.X-Forwarded-For) {
			set req.http.X-Forwarded-For =
			req.http.X-Forwarded-For + " " + client.ip;
		} else {
			set req.http.X-Forwarded-For = client.ip;
		}
	}
	
	# Giving a pipeline to sites that I doesn't want to be under influence of Varnish (except killing the bots)
	# - Moodle dislike Varnish (I have some cookie issues) and Moodle has its own system to cache things
	# - When a Woocommerce is small and there isn't any real content, Varnish will give only headache
	# - Matomo is quite dynamic and because there is no other users, Varnish doesn't help a bit
	if (
		   req.http.host == "pro.eksis.one" 		# Moodle
		|| req.http.host == "pro.katiska.info" 		# Moodle
		|| req.http.host == "store.katiska.info"	# Woocommerce
		|| req.http.host == "stats.eksis.eu"		# Matomo
		) {
			return(pipe);
	}
	
	# Awstats needs the host 
	# You must add something like this in systemctl edit --full varnishncsa at line StartExec:
	# -F '%%{X-Forwarded-For}i %%{VCL_Log:X-Req-Host}x %%l %%u %%t "%%r" %%s %%b "%%{Referer}i" "%%{User-agent}i"'
	set req.http.X-Req-Host = req.http.host;
	std.log("X-Req-Host:" + req.http.X-Req-Host);
	
	# Strip a trailing #, server doesn't need it.
	if (req.url ~ "\#") {
		set req.url = regsub(req.url, "\#.*$", "");
	}

	# Strip a trailing ? if it exists 
	if (req.url ~ "\?$") {
		set req.url = regsub(req.url, "\?$", "");
	}

	# Save Origin in a custom header
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;

	# Remove the proxy header
	unset req.http.Proxy;
	
	# Unset language, because we don't have a multilangual site
	unset req.http.Accept-Language;
	
	# Normalize Accept-Encoding header and compression
	# We don't need compress/uncompress even in vhosts, Varnish will do it automatic
	# Actually general unset req.http.Accept-Encoding; should be enough?
	if (req.http.Accept-Encoding) {
		# Do no compress compressed files...
		if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|mp4|ogg|jpeg|rar|zip|exe|flv|mov|wma|avi|swf|mpg|mpeg|mp4|webm|webp|pdf)$") {
			unset req.http.Accept-Encoding;
		}
	}
	
	# Normalize the query arguments.
	# Note: Placing this above the "do not cache" section breaks some WP theme elements and admin functionality.
	# Well, this is above most of those...
	set req.url = std.querysort(req.url);
	
	# Global handling of 404 and 410
	call global-redirect;

	# Send Surrogate-Capability headers to announce ESI support to backend
	set req.http.Surrogate-Capability = "key=ESI/1.0";
	
	## At this point we jump to all-common.vcl

} 


##############vcl_pipe################
#
sub vcl_pipe {
  
	# set bereq.http.Connection = "Close";
  
	# Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
	if (req.http.upgrade) {
		set bereq.http.upgrade = req.http.upgrade;
	}

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

	# hash Cookies for requests that have them 
	# like store cache based on PHPSESSID or woocommerce Cookie so cart doesn't show 0
	if (req.http.Cookie) {
		hash_data(req.http.Cookie);
	}
	
	# hash User-Agent for requests that have them
	if (req.http.User-Agent) {
		hash_data(req.http.User-Agent);
	}
	
	#fix flexible ssl css
	if (req.http.X-Forwarded-Proto) {
		hash_data(req.http.X-Forwarded-Proto);
	}

	return (lookup);


}


###################vcl_hit#########################
#

sub vcl_hit {

	# a pure unadultered hit, deliver it
	if (obj.ttl >= 0s) {
		return (deliver);
	}

# We have no fresh fish. Lets look at the stale ones.
	if (std.healthy(req.backend_hint)) {
		# Backend is healthy. Limit age to 10s.
		if (obj.ttl + 10s > 0s) {
			set req.http.grace = "Is limited edition enough?";
			return (deliver);
		} else {
			# No candidate for grace. Fetch a fresh object.
			return(miss);
		}
		} else {
			# backend is sick - use full grace
			if (obj.ttl + obj.grace > 0s) {
				set req.http.grace = "Sure! Do you see the light?";
				return (deliver);
		} else {
			# no graced object.
			return (miss);
		}
	}

	# fetch & deliver once we get the result
	return (miss);

}


###################vcl_miss#########################
#

sub vcl_miss {

	return (fetch);
}


###################vcl_backend_response#############
#

sub vcl_backend_response {


	## http errors 
	
	## Only cache status ok
	## Uncomment this if you don't want to adjust by error basis
	#if ( beresp.status != 200 && beresp.status != 204) {
	#	set beresp.uncacheable = true;
	#	set beresp.ttl = 120s;
	#	return(deliver);
	#}
	
	# Sometimes, a 301 or 302 redirect formed via Apache's mod_rewrite can mess with the HTTP port that is being passed along.
	# This often happens with simple rewrite rules in a scenario where Varnish runs on :80 and Apache on :8080 on the same box.
	# A redirect can then often redirect the end-user to a URL on :8080, where it should be :80.
	# This may need fine tuning on your setup.
	# To prevent accidental replace, we only filter the 301/302 redirects for now.
	if (beresp.status == 301 || beresp.status == 302) {
		set beresp.http.Location = regsub(beresp.http.Location, ":[0-9]+", "");
	}
	
	# Follow redirects to backend and put them in the cache when there is one
	# I don't know how to be sure this is working
	# max retrys is 4 by Varnish. You may have to increase it.
	if (beresp.status == 301 && beresp.http.Location ~ "^https?://[^/]+/") {
		set bereq.http.host = regsuball(beresp.http.Location, "^https?://([^/]+)/.*", "\1");
		set bereq.url = regsuball(beresp.http.Location, "^https?://([^/]+)", "");
		return(retry);
	}
	
	# Conditionally 404 redirect: empty archive pages 
	# 404 monitor still gets error but is is covered now
	# When ^/page/ canonical redirection of WP + SEO-plugins will override this and does 301 to frontpage
	# It shows as 200 OK with Varnish. If you do pipe you'll get original 301 and header x-redirect-by: WordPress
#	if (beresp.status == 404 && bereq.url ~ "/page/") {
#		set beresp.ttl = 86400s;
#		set beresp.status = 301;
#		set bereq.url = "/archive/";
#		return(deliver);
#	}

	# Conditionally 404 redirect
	if (beresp.status == 404 && (
			   bereq.url ~ "/wp-content/cache/"		# old WP Rocket cache files that Bing can't handle
			|| bereq.url ~ "\?cat\="				# null category
			|| bereq.url ~ "/page/"					# empty archive pages of WP; canonical 301 of WP + SEO plugins may override this
			|| bereq.url ~ "/feed/"					# old RSS-feed
			)) {
		set beresp.ttl = 86400s;
		set beresp.status = 410;
		return(deliver);
	}

	# Conditionally 404 redirect: malicious wordpress-knockers
	# wp-include etc has protected by Nginx
	# 404 monitor still gets error but is covered now
	if (beresp.status == 404 && (bereq.url ~ "^/wp-admin/" || bereq.url ~ "^/wp-content/themes" || bereq.url ~ "^/wp-content/plugins" || bereq.url ~ ".js")) {
		set beresp.status = 666;
		set beresp.ttl = 86400s;
		return(deliver);
	}

	# Don't cache 404 respons
	if (beresp.status == 404) {
		set beresp.ttl = 120s;
		set beresp.uncacheable = true;
		return(deliver);
	}
	
	## Don't cache 410 responses
	## I keep this commented because 410s are static and solid
	#if (beresp.status == 410) {
	#	set beresp.ttl = 120s;
	#	set beresp.uncacheable = true;
	#	return(deliver);
	#}
	
	# Stop cache insertion when backend is down
	if (beresp.status >= 500 && bereq.is_bgfetch) {
		return(abandon);
	}
	
	# Don't cache 50x responses
	# Is this same as earlier beresp.status >= 500 && bereq.is_bgfetch? IDK.
	if (beresp.status == 500 || beresp.status == 502 || beresp.status == 503 || beresp.status == 504) {
		return(abandon);
	}
	
	# ban & purge
	set beresp.http.x-url = bereq.url;
	set beresp.http.x-host = bereq.http.host;

	# fix for empty cart issue
	if (!(bereq.url ~ "wp-(login|admin)|^cart|^my-account|^checkout|wc-api|resetpass") &&
		!bereq.http.Cookie ~ "wordpress_logged_in|woocommerce_cart_hash|woocommerce_items_in_cart|wp_woocommerce_session_|resetpass" &&
		!beresp.status == 302 ) {
			unset beresp.http.set-Cookie;
			set beresp.ttl = 604800s;
			set beresp.grace = 1h;
	}
	
	## Overall TTL
	## Note: The TTL is designed to be somewhat aggressive here, to keep things in cache.
	## We don't care what a webserver offers as TTL
	## If you want to follow TTL by Apache/Nginx/whatever, fix this
	#
	# Lets get doing some serious caching.
	
	# Is this overdriving everything we did earlier? I reckon so.
	if (beresp.ttl > 0s) {

		# Remove Expires from backend, it's not long enough
		unset beresp.http.expires;
		
		# Set the clients cache-control on this object
		set beresp.http.cache-control = "max-age=7776000";
		
		# Set how long Varnish will keep it
		set beresp.ttl = 31536000s;
		
		# Allow stale content, in case the backend goes down.
		# make Varnish keep all objects for x hours beyond their TTL
		set beresp.grace = 24h;

		# marker for vcl_deliver to reset Age
		set beresp.http.magicmarker = "1";
		
		# This is useless because we have cache-control,
		# but if you want to keep Pingdom happy, you have to set expires
		#set beresp.http.x-obj-ttl = 180 + "d";
		
	}

	# Enable cache for some static files
	# More reading here: https://ma.ttias.be/stop-caching-static-files/
	if (bereq.url ~ "^[^?]*\.(ico|txt|xml|mp3|html|htm)(\?.*)?$") {
		unset beresp.http.set-Cookie;
	}

	## Targeted TTL

	# PMPro section @ Worpdress is very dynamic and uses Cookies (see Cookie settings in vcl_recv).
#	if (bereq.url ~ "/members/") {
#		set beresp.ttl = 86400s;
#	}

	# Shop section of Woocommerce is fairly static when browsing the catalog, but woocommerce is passed in vcl_recv.
	if (bereq.url ~ "/koulutukset-2/") {
		set beresp.ttl = 604800s;
	}

	# phBB Forum
	# Note: Cookies are dropped for phpBB in vcl_recv which disables the forums Cookies, however, logged in users still get a hash.
	# I set the anonymous user as a bot in phpBB admin settings. As bots dont use Cookies, this gives 99% hit rate.
	#if (bereq.url ~ "/forum/") {
	#set beresp.ttl = 3600s;
	#}

	# Long ttl sites
	#if (bereq.url ~ "(example.com|example2.com)") {
	#  set beresp.ttl = 604800s;
	#}
	
	## This aren't normal cases
	
	# Pause ESI request and remove Surrogate-Control header
	if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
		unset beresp.http.Surrogate-Control;
		set beresp.do_esi = true;
	}

	# Large static files are delivered directly to the end-user without
	# waiting for Varnish to fully read the file first.
	# Varnish 4 fully supports Streaming, so use streaming here to avoid locking.
	# I stream only podcast-MP3s from my server.
	if (bereq.url ~ "^[^?]*\.(mp[34]|wav)(\?.*)?$") {
		unset beresp.http.set-Cookie;
		set beresp.do_stream = true;  # Check memory usage it'll grow in fetch_chunksize blocks (128k by default) if the backend doesn't send a Content-Length header, so only enable it for big objects
		#set beresp.do_gzip = false;   # Don't try to compress it for storage; commented because of Varnish should know this anyway
	}

	# don't cache response to posted requests or those with basic auth
	if ( bereq.method == "POST" || bereq.http.Authorization ) {
		set beresp.uncacheable = true;
		set beresp.ttl = 120s;
		return(deliver);
	}

	# Don't cache search results
	if ( bereq.url ~ "\?s=" ){
		set beresp.uncacheable = true;
		set beresp.ttl = 120s;
		return(deliver);
	}

	return(deliver);

}


#######################vcl_deliver#####################
#
sub vcl_deliver {

	# damn, backend is down
	if (resp.status == 503) {
		return(restart);
	}

	# We put wordpress-knockers in the black hole
	if (resp.status == 666) {
		return(synth(666, "Bot access denied"));
	}

	# Origin
	if (resp.http.Vary) {
		set resp.http.Vary = resp.http.Vary + ",Origin";
	} else {
		set resp.http.Vary = "Origin";
	}
	
	# We remove resp.http.x-* HTTP header fields,
	# because the client does not neeed them
	unset resp.http.x-url;
	unset resp.http.x-host;
	
	# Let's show if we have grace period in use
	set resp.http.grace = req.http.grace;

	# HIT & MISS
	if (obj.hits > 0) {
		# I don't fancy boring hit/miss announcements
		set resp.http.X-You-had-only-one-job = "Success";
	} else {
		set resp.http.X-You-had-only-one-job = "Phew";
	}

	# Show hit counts (per objecthead)
	# Same here, something like X-total-hits is just boring
	set resp.http.X-CO2-metric-tons = (obj.hits);

	# Earlier we set something like 1 year for Varnish and 3 months for client. Now it will finished
	if (resp.http.magicmarker) {
		# Remove the magic marker 
		unset resp.http.magicmarker;
		# By definition we have a fresh object
		set resp.http.age = "0";
		
		# and now Expires if you earlier allowed it, and just for Pingdom
#		if (resp.http.x-obj-ttl) {
#			set resp.http.Expires = "" + (now + std.duration(resp.http.x-obj-ttl, 180d));
#			unset resp.http.x-obj-ttl;
#		}
	}


	# Remove some headers:
	unset resp.http.Server;	
	unset resp.http.X-Powered-By;
	unset resp.http.X-Varnish;
	unset resp.http.Age;  # comment for Pingdom
	unset resp.http.Via;
	unset resp.http.Link;
	unset resp.http.X-Generator;

		
	## let's set some extra just for fun
	set resp.http.Server = "Caffeine v64.19.56";
	set resp.http.X-Powered-By = "Talisker";
	set resp.http.X-callsign = "Basic stack";
	set resp.http.X-callsign-W3 = "Laura";
	set resp.http.X-callsign-Cache = "Emppa";
	set resp.http.X-callsign-CacheD = "Rasmus";
	set resp.http.X-callsign-Termination = "Aapo";
	set resp.http.X-callsign-DB = "Tiitu";
	set resp.http.X-UXSpecialist = "Jakke Lehtonen";
	set resp.http.X-UXSite = "https://www.eksis.one";
	set resp.http.X-UXMeme = "Keep calm and smoke your coffee and drink your smokes - it's just a user";
	set resp.http.X-UX = "Good web-pages will die young";

	return (deliver);

}


#################vcl_purge######################
#
sub vcl_purge {

#	return (synth(200, "Purged"));

	# Only handle actual PURGE HTTP methods, everything else is discarded
	if (req.method == "PURGE") {
	# restart request
		set req.http.X-Purge = "Yes";
		# let's get right away fresh stuff
		set req.method = "GET";
		return (restart);
	}
}


##################vcl_synth######################
sub vcl_synth {

	if (resp.status == 720) {
	# We use this special error status 720 to force redirects with 301 (permanent) redirects
	# To use this, call the following from anywhere in vcl_recv: return (synth(720, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	} elseif (resp.status == 721) {
	# And we use error status 721 to force redirects with a 302 (temporary) redirect
	# To use this, call the following from anywhere in vcl_recv: return (synth(721, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 302;
		return(deliver);
	}

	# because of force http to https 
	# I don't need this because Nginx at front of Varnish is redirecting 80 > 443
#	if (resp.status == 750) {
#		set resp.status = 301;
#		set resp.http.Location = req.http.X-Redir-Url;
#		return(deliver);
#	}
	
	# Custom errors
		
	# forbidden login
	if (resp.status == 403) {
		synthetic(std.fileread("/etc/varnish/error/403.html"));
		return (deliver);
	}
	
	# throttled
	if (resp.status == 413) {
		synthetic(std.fileread("/etc/varnish/error/413.html"));
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

  # Called when VCL is discarded only after all requests have exited the VCL.
  # Typically used to clean up VMODs.

  return (ok);
}


# Vhosts, needed when multiple virtual hosts in use
include "all-vhost.vcl";
include "all-common.vcl";


