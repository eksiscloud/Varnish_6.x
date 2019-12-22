## Jakke Lehtonen
## by several sources
## Varnish default.vcl for multiple virtual hosts
## 
#
# Lets's start caching
 
#
 
# Marker to tell the VCL compiler that this VCL has been adapted to the 4.0 format.
vcl 4.1;

import directors;	# Load the vmod_directors
import std;		# Load the std, not STD for god sake
import vsthrottle;	# throttling by rate; you need varnish-modules so google or apt install varnish-modules
#import shield;		# resets the connection; didn't work for me

# Let's Encrypt
include "/etc/varnish/ext/letsencrypt.vcl";	# I really don't know if this id doing something, it was because Hitch

# Monit
include "/etc/varnish/ext/monit.vcl";

# Bad Bad Robots
include "/etc/varnish/ext/bad-bot.vcl";

# Stop knocking
include "/etc/varnish/ext/403.vcl";


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
	"127.0.0.1";
}

#acl whitelist {
#	"localhost";
#	"127.0.0.1";
#	"<your-home-ip>";
#}

acl forbidden {
# just as example, use fail2ban instead
	"144.76.151.45";
	"95.175.104.158";
	"95.175.104.125";
	"139.180.171.212";
	"128.199.110.156";
	"209.97.175.191";
	"123.31.21.25";
}

#################### vcl_init ##################
# Called when VCL is loaded, before any requests pass through it. Typically used to initialize VMODs.
# You have to define server at backend definition too.

sub vcl_init {

}


############### vcl_recv #################
## We should have here only statments without return(...)
## 
sub vcl_recv {

	if (client.ip ~ forbidden) {
		return(synth(403, "Forbidden IP"));
	}
	
	# Do not allow outside access to cron.php or install.php.
	## This gave some problems to me
	#if (req.url ~ "^/(cron|install)\.php$" && !client.ip ~ internal) {
    	# error 404 "Page not found.";
	
	## Your lifeline: Turn OFF cache
	## For caching keep this commented, but Varnish is still affecting headers, cookies etc.
	# return(pass);
	
	## Your last hope: a dumb TCP termination
	## It passes everything right thru Varnish
	# return(pipe);
	
	
## The real work starts here

	# Fix Wordpress visual editor issues, must be the first one to work
	if (req.url ~ "/wp-(login|admin|comments-post.php|cron)" || req.url ~ "preview=true") {
	return (pass);
	}
	
	call bad_bot_detection;
	call stop_pages;
	
	# Setting http headers for backend
#	set req.http.X-Forwarded-For = client.ip;
	if (req.restarts == 0) {
		if (req.http.X-Forwarded-for) {
		set req.http.X-Forwarded-For =
		req.http.X-Forwarded-For + ", " + client.ip;
    } else {
      set req.http.X-Forwarded-For = client.ip;
    }
  }
	
	# Save Origin in a custom header
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;

	# Normalize the header, remove the port (in case you're testing this on various TCP ports)
	set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");

	# Remove the proxy header
	unset req.http.Proxy;

	# Strip hash, server doesn't need it.
	if (req.url ~ "\#") {
	set req.url = regsub(req.url, "\#.*$", "");
	}

	# Strip a trailing ? if it exists / Can't figure out why we should do this 
	if (req.url ~ "\?$") {
	set req.url = regsub(req.url, "\?$", "");
	}

	# Unset headers that might cause us to cache duplicate infos
	unset req.http.Accept-Language;
	
	# Normalize the query arguments.
	# Note: Placing this above the "do not cache" section breaks some WP theme elements and admin functionality.
	set req.url = std.querysort(req.url);

	# Normalize Accept-Encoding header and compression
	if (req.http.Accept-Encoding) {
		# Do no compress compressed files...
		if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
		unset req.http.Accept-Encoding;
		} elsif (req.http.Accept-Encoding ~ "gzip") {
			set req.http.Accept-Encoding = "gzip";
			} elsif (req.http.Accept-Encoding ~ "deflate") {
				set req.http.Accept-Encoding = "deflate";
			} else {
				unset req.http.Accept-Encoding;
				}
			}

	# Send Surrogate-Capability headers to announce ESI support to backend
	set req.http.Surrogate-Capability = "key=ESI/1.0";

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


################vcl_hsh##################
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
	# normally you will kill all UA's but I'm using three of them
	if (req.http.User-Agent) {
	hash_data(req.http.User-Agent);
	}

	# If the client supports compression, keep that in a different cache
	if (req.http.Accept-Encoding) {
	hash_data(req.http.Accept-Encoding);
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
      #set req.http.grace = "normal(limited)";
      return (deliver);
    } else {
      # No candidate for grace. Fetch a fresh object.
      return(miss);
    }
  } else {
    # backend is sick - use full grace
      if (obj.ttl + obj.grace > 0s) {
      #set req.http.grace = "full";
      return (deliver);
    } else {
      # no graced object.
      return (miss);
    }
  }
  
  # fetch & deliver once we get the result
  return (miss); # Dead code, keep as a safeguard

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

	# Don't cache 404 responses
	if ( beresp.status == 404 ) {
		set beresp.ttl = 120s;
		set beresp.uncacheable = true;
		return (deliver);
	}
	
	# Sometimes, a 301 or 302 redirect formed via Apache's mod_rewrite can mess with the HTTP port that is being passed along.
	# This often happens with simple rewrite rules in a scenario where Varnish runs on :80 and Apache on :8080 on the same box.
	# A redirect can then often redirect the end-user to a URL on :8080, where it should be :80.
	# This may need fine tuning on your setup.
	# To prevent accidental replace, we only filter the 301/302 redirects for now.
	
	if (beresp.status == 301 || beresp.status == 302) {
	set beresp.http.Location = regsub(beresp.http.Location, ":[0-9]+", "");
	}

	# fix for empty cart issue
	if (!(bereq.url ~ "wp-(login|admin)|^cart|^my-account|^checkout|wc-api|resetpass") &&
		!bereq.http.Cookie ~ "wordpress_logged_in|woocommerce_cart_hash|woocommerce_items_in_cart|wp_woocommerce_session_|resetpass" &&
		!beresp.status == 302 ) {
			unset beresp.http.set-Cookie;
			set beresp.ttl = 604800s;
			set beresp.grace = 1h;
	}
 
	# retry a few times if backend is down
	if (beresp.status == 503 && bereq.retries < 3 ) {
	return(retry);
	}
	
	# Don't cache 50x responses
	if (beresp.status == 500 || beresp.status == 502 || beresp.status == 503 || beresp.status == 504) {
	return (abandon);
	}
	
	# Only cache status ok
	if ( beresp.status != 200 && beresp.status != 204) {
	set beresp.uncacheable = true;
	set beresp.ttl = 120s;
	return (deliver);
	}
	
	## Overall TTL
	## Note: The TTL is designed to be somewhat aggressive here, to keep things in cache.
	## We don't care what a webserver offers as TTL
	# Lets get doing some serious caching.
	
	if (beresp.ttl > 0s) {

		# Remove Expires from backend, it's not long enough
		unset beresp.http.expires;
		
		# Set the clients cache-control on this object
		set beresp.http.cache-control = "max-age=7776000";
		
		# Set how long Varnish will keep it
		set beresp.ttl = 31536000s;

		# marker for vcl_deliver to reset Age
		set beresp.http.magicmarker = "1";
		
		# This is useless because we have cache-control,
		# but let's keep Pingdom happy and we will set expires
		set beresp.http.x-obj-ttl = 180 + "d";
		
	}

	# Allow stale content, in case the backend goes down.
	# make Varnish keep all objects for x hours beyond their TTL
	set beresp.grace = 8h;

	# Enable cache for all static files
	# Monitor your cache size, if you get data nuked out of it, consider giving up the static file cache.
	# More reading here: https://ma.ttias.be/stop-caching-static-files/
	if (bereq.url ~ "^[^?]*\.(bmp|bz2|css|doc|eot|flv|gif|ico|jpeg|jpg|js|less|mp[34]|pdf|png|rar|rtf|swf|tar|tgz|txt|wav|woff|xml|zip)(\?.*)?$") {
		unset beresp.http.set-Cookie;
	}

	# Cache all static files by Removing all Cookies for static files - Note: These file extensions are generated by WordPress WP Super Cache.
	if (bereq.url ~ "^[^?]*\.(html|htm|gz)(\?.*)?$") {
		unset beresp.http.set-Cookie;
	}

	## Targeted TTL

	# Members section is very dynamic and uses Cookies (see Cookie settings in vcl_recv).
	if (bereq.url ~ "/members/") {
		set beresp.ttl = 86400s;
	}

	# My Shop section is fairly static when browsing the catalog, but woocommerce is passed in vcl_recv.
	if (bereq.url ~ "/koulutukset-2/") {
		set beresp.ttl = 604800s;
	}

	# phBB Forum
	# Note: Cookies are dropped for phpBB in vcl_recv which disables the forums Cookies, however, logged in users still get a hash.
	# I set the anonymous user as a bot in phpBB admin settings. As bots dont use Cookies, this gives 99% hit rate.
	#if (bereq.url ~ "/forumPM/") {
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
	# I do not stream large files from my server, I use a CDN, so I have not tested this.
	if (bereq.url ~ "^[^?]*\.(mp[34]|rar|tar|tgz|wav|zip|bz2|xz|7z|avi|mov|ogm|mpe?g|mk[av])(\?.*)?$") {
	unset beresp.http.set-Cookie;
	set beresp.do_stream = true;  # Check memory usage it'll grow in fetch_chunksize blocks (128k by default) if the backend doesn't send a Content-Length header, so only enable it for big objects
	set beresp.do_gzip = false;   # Don't try to compress it for storage
	}

	# don't cache response to posted requests or those with basic auth
	if ( bereq.method == "POST" || bereq.http.Authorization ) {
	set beresp.uncacheable = true;
	set beresp.ttl = 120s;
	return (deliver);
	}

	# Don't cache search results
	if ( bereq.url ~ "\?s=" ){
	set beresp.uncacheable = true;
	set beresp.ttl = 120s;
	return (deliver);
	}

	return (deliver);

}

#######################vcl_deliver#####################
#
sub vcl_deliver {

	# damn, backend is down
	if (resp.status == 503) {
	return(restart);
	}

	# Origin
	if (resp.http.Vary) {
		set resp.http.Vary = resp.http.Vary + ",Origin";
		} else {
		set resp.http.Vary = "Origin";
	}

	# HIT & MISS
	if (obj.hits > 0) { # Add debug header to see if it's a HIT/MISS and the number of hits, disable when not needed
		set resp.http.X-Cache = "Done";
	} else {
		set resp.http.X-Cache = "Phew";
	}

	# Show hit counts (per objecthead)
	set resp.http.X-Wham-Xmas = (obj.hits);

	# Earlier we set 1 year for Varnish and 3 months for client. Now it will finished
	if (resp.http.magicmarker) {
		# Remove the magic marker 
		unset resp.http.magicmarker;
		# By definition we have a fresh object
		set resp.http.age = "0";
		
		# and now Expires, just for Pingdom
		if (resp.http.x-obj-ttl) {
			set resp.http.Expires = "" + (now + std.duration(resp.http.x-obj-ttl, 180d));
			unset resp.http.x-obj-ttl;
		}
	}

	# Remove some headers:
	unset resp.http.Server;	
	unset resp.http.X-Powered-By;
	unset resp.http.X-Drupal-Cache;
	unset resp.http.X-Varnish;
	#unset resp.http.Age;  			# you need this for Pingdom
	unset resp.http.Via;
	unset resp.http.Link;
	unset resp.http.X-Generator;
	unset resp.http.X-Mod-Pagespeed;

		
	## let's set some extra just for fun
	## Please, don't use this
	set resp.http.Server = "Caffeine v64.19";
	set resp.http.X-Powered-By = "Talisker";
	set resp.http.X-callsign = "Basic stack";
	set resp.http.X-UXSpecialist = "Jakke Lehtonen";
	set resp.http.X-UXSite = "https://www.eksis.one";
	set resp.http.X-UXMeme = "Keep calm and smoke your coffee and drink your smokes - it's just a user";
	set resp.http.X-UX = "Good web-pages will die young";

	return (deliver);

}

############# vcl_purge ################
#
sub vcl_purge {

	# Only handle actual PURGE HTTP methods, everything else is discarded
	if (req.method == "PURGE") {
	# restart request
	set req.http.X-Purge = "Yes";
	return (restart);
  }
}


############# vcl_synth #################
sub vcl_synth {

	if (resp.status == 720) {
	# We use this special error status 720 to force redirects with 301 (permanent) redirects
	# To use this, call the following from anywhere in vcl_recv: return (synth(720, "http://host/new.html"));
	set resp.http.Location = resp.reason;
	set resp.status = 301;
	return (deliver);
	} elseif (resp.status == 721) {
	# And we use error status 721 to force redirects with a 302 (temporary) redirect
	# To use this, call the following from anywhere in vcl_recv: return (synth(720, "http://host/new.html"));
	set resp.http.Location = resp.reason;
	set resp.status = 302;
	return(deliver);
	}

	# because of force to https - or something 
	if (resp.status == 750) {
		set resp.status = 301;
		set resp.http.Location = req.http.X-Redir-Url;
	return(deliver);
	}
	
	# Custom errors
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

## This works just fibe but I'm not using them
#
		# forbidden
#		if (resp.status == 403) {
#			synthetic(std.fileread("/etc/varnish/error/403.html"));
#		}
		# throttled
#		if (resp.status == 429) {
#			synthetic(std.fileread("/etc/varnish/error/429.html"));
#		}
		# system is down
#		elseif (resp.status == 503) {
#			synthetic(std.fileread("/etc/varnish/error/503.html"));
#		}
#    return(deliver);
	

} 


####################### vcl_fini #######################
#

sub vcl_fini {

  # Called when VCL is discarded only after all requests have exited the VCL.
  # Typically used to clean up VMODs.

  return (ok);
}


# Vhosts
include "all-vhost.vcl";
include "all-common.vcl";


