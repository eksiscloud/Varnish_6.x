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
import std;		# Load the std, not STD for god sake

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

# Cheshire cat at headers
include "/etc/varnish/ext/cheshire_cat.vcl";

# X-headers, just for fun
include "/etc/varnish/ext/x-heads.vcl";


probe sondi {
    #.url = "/index.html";  # or you can use just an url
    # or
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

backend default {				# use your servers instead default if you have more than just one
	.host = "127.0.0.1";			# IP or Hostname of backend
	.port = "81";				# Apache or whatever is listening
	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;		# How long to wait between bytes received from our backend?
	.probe = sondi;				# We have chance to recycle the probe 
}

# Only allow purging from specific IPs
acl purge {
	"localhost";
	"netti.link";		# VPN, doesn't work too well with Varnish
	"127.0.0.1";
	"my.home.ip.address";
	"104.248.141.204";
	"64.225.73.149";
}

acl whitelist {
	"localhost";
	"netti.link";
	"127.0.0.1";
	"my.home.ip.address";
	"104.248.141.204";
	"64.225.73.149";
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
	
	
	# Pass CDN - IDK if this is really needed
	if (req.http.host ~ "cdn.") {
		return(pass);
	}
	
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
	
	# Let's tune up a bit behavior for healthy backends: Cap grace to 10s
	if (std.healthy(req.backend_hint)) {
		set req.grace = 10s;
	}
	
	# Fix Wordpress visual editor issues, must be the first one as url requests to work
	if (req.url ~ "/wp-(login|admin|comments-post.php|cron)" || req.url ~ "preview=true") {
		return (pass);
	}

	## Let's clean up some trashes
		
		# If you follow robots.txt you aren't a rotten one and Fail2ban doesn't ban you
		# This bypasses bad bot detection and lets every bots read robots.txt
		# Commented because Nginx cleans up bots for me and only few useful gets through
		#if (req.url ~ "^/robots.txt") {
		#	return(pass);
		#}
		
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
		if (req.http.User-Agent ~ "curl/" && !client.ip ~ whitelist) {
			return(synth(420, "Forbidden Method"));
		}
		
		# I need libwww-perl too
		if (req.http.User-Agent ~ "libwww-perl" && !client.ip ~ whitelist) {
			return(synth(420, "Forbidden Method"));
		}

		# now we stop known useless ones
		call bad_bot_detection;
		call stop_pages;

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
	
	## Wordpress REST API
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass
		if (client.ip ~ whitelist) {
			return(pass);
		}
		# Must be logged in
		elseif (!req.http.Cookie ~ "wordpress_logged_in") {
			return(synth(403, "Unauthorized request"));
		}
	}

	## Giving a pipeline to sites that I doesn't want to be under influence of Varnish (except killing the bots)
	# - Moodle dislike Varnish (I have some cookie issues) and Moodle has its own system to cache things
	# - When a Woocommerce is small and there isn't any real content, Varnish will give only headache
	# - Matomo is quite dynamic and because there is no other users, Varnish doesn't help a bit
	if (
		   req.http.host == "pro.eksis.one"		# Moodle
		|| req.http.host == "pro.katiska.info"		# Moodle
		|| req.http.host == "store.katiska.info"	# Woocommerce
		|| req.http.host == "stats.eksis.eu"		# Matomo
		|| req.http.host == "graph.eksis.eu"		# Munit
		) {
			return(pipe);
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

	## Save Origin in a custom header
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;

	## Remove the proxy header
	unset req.http.Proxy;
	
	## Unset language, because we don't have a multilangual site
	unset req.http.Accept-Language;
	
	## Normalize Accept-Encoding header and compression
	# We don't need compress/uncompress even in vhosts, Varnish will do it automatically
	# Actually general unset req.http.Accept-Encoding; should be enough?
	if (req.http.Accept-Encoding) {
		# Do no compress compressed files...
		if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|mp4|ogg|jpeg|rar|zip|exe|flv|mov|wma|avi|swf|mpg|mpeg|mp4|webm|webp|pdf)$") {
			unset req.http.Accept-Encoding;
		}
	}
	
	## Normalize the query arguments.
	# Note: Placing this above the "do not cache" section breaks some WP theme elements and admin functionality.
	# Well, this is above most of those... and nothing broke
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
	if (req.http.Cookie) {
		hash_data(req.http.Cookie);
	}
	
	## hash User-Agent for requests that have them
	if (req.http.User-Agent) {
		hash_data(req.http.User-Agent);
	}
	
	## fix flexible ssl css
	if (req.http.X-Forwarded-Proto) {
		hash_data(req.http.X-Forwarded-Proto);
	}

	## The end
	return (lookup);


}


###################vcl_hit#########################
#

sub vcl_hit {

	## This do now even built-in grace, so there is no need to adjust grace times by yourself
	return(deliver);

}


###################vcl_miss#########################
#

sub vcl_miss {

#	if (object needs ESI processing) {
#		unset req.http.accept-encoding;
#	}

	## Last call
	return (fetch);
}


###################vcl_backend_response#############
#

sub vcl_backend_response {



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

	## Origin
	if (resp.http.Vary) {
		set resp.http.Vary = resp.http.Vary + ",Origin";
	} else {
		set resp.http.Vary = "Origin";
	}
	
	## We remove resp.http.x-* HTTP header fields,
	# because the client does not neeed them
	unset resp.http.x-url;
	unset resp.http.x-host;
	
	## Grace...
	# This isn't in use anymore I reckon
	# Let's show if we have grace period in use
	#	set resp.http.grace = req.http.grace;

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

	## Earlier we set something like 1 year for Varnish and 3 months for client. Now it will finished
	if (resp.http.magicmarker) {
		# Remove the magic marker 
		unset resp.http.magicmarker;
		# By definition we have a fresh object
		set resp.http.age = "0";
		
		## and now Expires if you earlier allowed it, 
		# and it is just for Pingdom 'cos they are old fashioned
#		if (resp.http.x-obj-ttl) {
#			set resp.http.Expires = "" + (now + std.duration(resp.http.x-obj-ttl, 180d));
#			unset resp.http.x-obj-ttl;
#		}
	}


	## Remove some headers:
	unset resp.http.Server;	
	unset resp.http.X-Powered-By;
	unset resp.http.X-Varnish;
	unset resp.http.Age;		# comment for Pingdom
	unset resp.http.Via;
	unset resp.http.Link;
	unset resp.http.X-Generator;

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
sub vcl_synth {

	## 301/302 redirects using custom status
	if (resp.status == 720) {
	# We use this special error status 720 to force redirects with 301 (permanent) redirects
	# To use this, call the following from anywhere in vcl_recv: return(synth(720, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	} elseif (resp.status == 721) {
	# And we use error status 721 to force redirects with a 302 (temporary) redirect
	# To use this, call the following from anywhere in vcl_recv: return(synth(721, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 302;
		return(deliver);
	}

	## Let's force http to https 
	# I don't need this because Nginx at front of Varnish is redirecting 80 > 443
#	if (resp.status == 750) {
#		set resp.status = 301;
#		set resp.http.Location = req.http.X-Redir-Url;
#		return(deliver);
#	}
	
	## Custom errors
		
	# forbidden login
	if (resp.status == 403) {
		synthetic(std.fileread("/etc/varnish/error/403.html"));
		return (deliver);
	}
	
	# throttled
	# not in use anymore nowadays
#	if (resp.status == 413) {
#		synthetic(std.fileread("/etc/varnish/error/413.html"));
#		return (deliver);
#	}
		
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


# Vhosts, needed when multiple virtual hosts in use
include "all-vhost.vcl";
include "all-common.vcl";
