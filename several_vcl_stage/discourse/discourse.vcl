## Discourse

vcl 4.1;

import std;			# Load the std, not STD for god sake
import cookie;		# Load the cookie, former libvmod-cookie
import purge;		# Soft/hard purge by Varnish 6.x
import vsthrottle;	# from Varnish-modules https://github.com/varnish/varnish-modules
import geoip2;		# Load the GeoIP2 by MaxMind

### I'm using sub-vcls only to keep default.vcl a little bit easier to read

# Let's Encrypt gets own backend
include "/etc/varnish/common/general/letsencrypt.vcl";

# Useful bots
include "/etc/varnish/common/filtering/nice-bots.vcl";

# Tech bots
include "/etc/varnish/common/filtering/probes.vcl";

# Bad bad bots
include "/etc/varnish/common/filtering/bad-bot.vcl";

# Geo-blocking/language
include "/etc/varnish/common/filtering/geo.vcl";

# ASN
include "/etc/varnish/common/filtering/asn.vcl";

# Stop knocking
include "/etc/varnish/common/filtering/403.vcl";

# Soft/hard purge
include "/etc/varnish/common/general/lets_purge.vcl";

# Just some debugging headers like HIT and MISS
include "/etc/varnish/common/general/debugs.vcl";

# Cheshire cat at headers
include "/etc/varnish/common/additional/cheshire_cat.vcl";

# X-headers, just for fun
include "/etc/varnish/common/additional/x-heads.vcl";

# Common rules
include "/etc/varnish/discourse/ext/general/common.vcl";


## Backend tells where a site can be found


backend wiki {
	.host = "127.0.0.1";
	.port = "82";
	.first_byte_timeout = 600s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 600s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 600s;	# How long to wait between bytes received from our backend?
}

backend gitea {
	.path = "/run/gitea/gitea.sock";
	#.host = "127.0.0.1";
	#.port = "3000";					# Gitea
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

## ACLs: I can't use client.ip because it is always 127.0.0.1 by Nginx (or any proxy like Apache2)
# Instead client.ip it has to be something like std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist

# Only allow purging from specific IPs
acl purger {
	"localhost";
	"127.0.0.1";
	"84.231.4.60";
	"104.248.141.204";
	"64.225.73.149";
	"138.68.111.130";
}

# This can do almost everything
acl whitelist {
	"localhost";
	"netti.link";		# reverse dns is done only when systemctl restart
	"127.0.0.1";
	"84.231.4.60";
	"104.248.141.204";
	#"64.225.73.149";
	"138.68.111.130";
}

#################### vcl_init ##################
# Called when VCL is loaded, before any requests pass through it. Typically used to initialize VMODs.
# You have to define server at backend definition too.
sub vcl_init {
	
	# GeiOP
	new country = geoip2.geoip2("/usr/share/GeoIP/GeoLite2-Country.mmdb");
	new city = geoip2.geoip2("/usr/share/GeoIP/GeoLite2-City.mmdb");
	new asn = geoip2.geoip2("/usr/share/GeoIP/GeoLite2-ASN.mmdb");
	
# The end of init
}

############### vcl_recv #################
#
sub vcl_recv {

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## Setting http headers for backend
	if (req.restarts == 0) {
		if (req.http.X-Forwarded-For) {
			set req.http.X-Forwarded-For =
			req.http.X-Forwarded-For + " " + req.http.X-Real-IP;
		} else {
			set req.http.X-Forwarded-For = req.http.X-Real-IP;
		}
	}
	
	## GeoIP/language and ASN
	# lookup doesn't work in sub-vcls

	# GeoIP and normalizing country codes to lower case, because remembering to use capital letters is just too hard
	set req.http.X-Country-Code = country.lookup("country/iso_code", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.X-Country-Code = std.tolower(req.http.X-Country-Code);
	call geo-lang;
	
	# Finding out and normalizing ASN. This isn't an effective way to block, but I'm using ASN-data in funny headers too.
	set req.http.x-asn = asn.lookup("autonomous_system_organization", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.x-asn = std.tolower(req.http.x-asn);
	call asn_name;
	
	## Normalize aka. good bots
	call cute_bot_allowance;
	
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
	
	## At this point we jump to sites.vcl

# The of the sub
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

	## Must hashes
	
	hash_data(req.url);

	if (req.http.host) {
		hash_data(req.http.host);
	} else {
		hash_data(server.ip);
	}
	
	if (req.http.cookie) {
		hash_data(req.http.cookie);
	}
	
	# I'm passing cookies to backend without hashing. Quite useless trick with Discourse.
	#if (req.http.x-cookie) {
	#	set req.http.cookie = req.http.x-cookie;
	#	unset req.http.x-cookie;
	#}
	
	## The end
	return (lookup);
}


###################vcl_hit#########################
#
sub vcl_hit {

	if (req.method == "PURGE") {
		call my_purge;
	}
	
	## End of the road, Jack
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

	if (req.method == "PURGE") {
		call my_purge;
	}

	## Last call
	return (fetch);
}


###################vcl_backend_response#############
# This will alter everything that backend responses back to Varnish
#
sub vcl_backend_response {

	## Add name of backend in varnishncsa log (I don't do with that much, because I have only a couple active backends)
	# You can find slow replying backends (over 3 sec) with that:
	# varnishncsa -b -F '%t "%r" %s %{Varnish:time_firstbyte}x %{VCL_Log:backend}x' | awk '$7 > 3 {print}'
	# or
	# varnishncsa -b -F '%t "%r" %s %{Varnish:time_firstbyte}x %{VCL_Log:backend}x' -q "Timestamp:Beresp[3] > 3 or Timestamp:Error[3] > 3"
	std.log("backend: " + beresp.backend.name);
	
	## Add name of backend in varnishncsa log (I don't do with that much, because I have only a couple active backends)
	# You can find slow replying backends (over 3 sec) with that:
	# varnishncsa -b -F '%t "%r" %s %{Varnish:time_firstbyte}x %{VCL_Log:backend}x' | awk '$7 > 3 {print}'
	# or
	# varnishncsa -b -F '%t "%r" %s %{Varnish:time_firstbyte}x %{VCL_Log:backend}x' -q "Timestamp:Beresp[3] > 3 or Timestamp:Error[3] > 3"
	std.log("backend: " + beresp.backend.name);
	
	## Backend is down, stop caching
	if (beresp.status >= 500 && bereq.is_bgfetch) {
		return(abandon);
	}
	
	## Slowing down amount of backend requests to way too anxious ones
	# If the client IP makes more than 100 requests per second that result in a cache miss, access is prohibited for one minute
	if (vsthrottle.is_denied(std.ip(bereq.http.X-Real-IP, "0.0.0.0"), 100, 1s, 1m)) {
		return(error(429, "Too Many Requests"));
	}
	
	## Ordinary default; how long Varnish will keep objects
	# Varnish is using s-maxage as beresp.ttl (max-age is for browser),
	# Server must reboot about once in month so 1y is ridiculous long
	# If backend sets s-maxage Varnish will use it, otherwise it will be 1y
	if (beresp.http.cache-control !~ "s-maxage") {
		set beresp.ttl = 31536000s;
		# or if you will pass TTL to other intermediate caches as CDN, otherwise they will use maxage
		#set beresp.http.cache-control = "s-maxage=31536000, " + beresp.http.cache-control;
	}
	
	## 301/410 are quite static
	if (beresp.status == 301 || beresp.status == 410) {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=2592000"; # 30d
		set beresp.ttl = 31536000s;
	}
	
	## MediaWiki: TTL when not logged in and there isn't 30d UserName cookie
	if (bereq.http.host ~ "koiranravitsemus.fi") {
		if (bereq.http.cookie !~ "session|UserID|UserName|LoggedOut|Token" 
			) {		
				unset beresp.http.set-cookie; 
				unset beresp.http.cache-control;
				set beresp.http.cache-control = "max-age=86400s";
				set beresp.ttl = 1d;
		}
	}
	
	## My repo/Gitea
	if (bereq.url ~ "/src/" || bereq.url ~ "/explore/" ) {
		#unset beresp.http.set-cookie;
		set beresp.ttl = 1d;
		set beresp.grace = 1d;
		set beresp.http.cache-control = "max-age=86400"; # 24h
	}
	
	## Robots.txt is really static, but let's be on safe side
	# Against all claims bots check robots.txt almost never, so caching doesn't help much
	if (bereq.url ~ "/robots.txt") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=604800";
		set beresp.ttl = 604800s; # 1wk
	}
	
	## ads.txt and sellers.json is really static to me, but let's be on safe side
	if (bereq.url ~ "^/(ads.txt|sellers.json)") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=604800";
		set beresp.ttl = 604800s; # 1wk
	}
	
	## Sitemaps
	if (bereq.url ~ "sitemap") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; # 24h
	}
	
	## ESI is enabled. IDK if this is enough
	set beresp.do_esi = true;
	
	# Same thing here as in vcl_miss 
	# No clue what to put as object 
	#if (object needs ESI processing) {
	#	set beresp.do_esi = true;
	#	set beresp.do_gzip = true;
	#}
	
	## Keep the response in cache for 24 hours if the response has validating headers.
	# 6 hours isn't nearly same as other TTLs. Should I use this at all?
	if (beresp.http.ETag || beresp.http.Last-Modified) {
		set beresp.keep = 24h;
	}

	## I set X-Trace header, prepending it to X-Trace header received from backend. Useful for troubleshooting
	if(beresp.http.x-trace && !beresp.was_304) {
		set beresp.http.X-Trace = regsub(server.identity, "^([^.]+),?.*$", "\1")+"->"+regsub(beresp.backend.name, "^(.+)\((?:[0-9]{1,3}\.){3}([0-9]{1,3})\)","\1(\2)")+"->"+beresp.http.X-Trace;
	}
	else {
		set beresp.http.X-Trace = regsub(server.identity, "^([^.]+),?.*$", "\1")+"->"+regsub(beresp.backend.name, "^(.+)\((?:[0-9]{1,3}\.){3}([0-9]{1,3})\)","\1(\2)");
	}

	## Unset the old pragma header
	# Unnecessary filtering 'cos Varnish doesn't care of pragma, but it is ugly in headers
	unset beresp.http.Pragma;

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
	
	## Knockers with 404 will get synthetic error 666 that leads to real error 666
	if (resp.status == 666) {
		return(synth(666, "Requests not allowed for " + req.url));
	}
	
	## MediaWiki doesn't set vary as I want it; this has no point anyway
	if (req.http.host ~ "koiranravitsemus.fi") {
		unset resp.http.vary;
		set resp.http.vary = "X-Forwarded-Proto, Accept-Encoding";
	}
	
	## Just some unneeded headers from debugs.vcl
	call diagnose;
	
	## Expires is unneeded because cache-control overrides it
	unset resp.http.Expires;
	
	## Remove some headers, because the client doesn't need them
	unset resp.http.Server;
	unset resp.http.X-Powered-By;
	unset resp.http.X-Varnish;
	unset resp.http.Via;
	unset resp.http.Link;
	unset resp.http.X-Generator;
	unset resp.http.x-url;
	unset resp.http.x-host;
	unset resp.http.Pragma;

	## Custom headers, not so serious thing 
	set resp.http.Your-Agent = req.http.User-Agent;
	set resp.http.Your-IP = req.http.X-Real-IP;
	
	## Don't show funny stuff to bots
	if (req.http.x-bot !~ "(nice|bad|libs|tech)") {
		# lookup can't be in sub vcl
		set resp.http.Your-IP-Country = country.lookup("country/names/en", std.ip(req.http.X-Real-IP, "0.0.0.0")) + "/" + std.toupper(req.http.X-Country-Code);
		set resp.http.Your-IP-City = city.lookup("city/names/en", std.ip(req.http.X-Real-IP, "0.0.0.0"));
		set resp.http.Your-IP-GPS = city.lookup("location/latitude", std.ip(req.http.X-Real-IP, "0.0.0.0")) + " " + city.lookup("location/longitude", std.ip(req.http.X-Real-IP, "0.0.0.0"));
		set resp.http.Your-IP-ASN = asn.lookup("autonomous_system_organization", std.ip(req.http.X-Real-IP, "0.0.0.0"));
		call headers_x;		# x-heads.vcl
		call header_smiley;	# cheshire_cat.vcl
	}

	# That's it
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

# End of vcl_purge
}


##################vcl_synth######################
#
sub vcl_synth {
	
	### Custom errors
		
	## forbidden error 403
	if (resp.status == 403) {
		set resp.status = 403;
		#synthetic(std.fileread("/etc/varnish/error/403.html"));
		set resp.http.Content-Type = "text/html; charset=utf-8";
		set resp.http.Retry-After = "5";
		synthetic( {"<!DOCTYPE html>
		<html>
			<head>
				<title>Error "} + resp.status + " " + resp.reason + {"</title>
			</head>
			<body>
				<h1>Error "} + resp.status + " " + resp.reason + {"</h1>
				<p>"} + resp.reason + " from IP " + std.ip(req.http.X-Real-IP, "0.0.0.0") + {"</p>
				<h3>Guru Meditation:</h3>
				<p>XID: "} + req.xid + {"</p>
				<hr>
				<p>Varnish cache server</p>
			</body>
		</html>
		"} );
		return (deliver);
	}
		
	## Forbidden url
	if (resp.status == 429) {
		set resp.status = 429;
		#synthetic(std.fileread("/etc/varnish/error/429.html"));
		set resp.http.Content-Type = "text/html; charset=utf-8";
		set resp.http.Retry-After = "5";
		synthetic( {"<!DOCTYPE html>
		<html>
			<head>
				<title>Error "} + resp.status + " " + resp.reason + {"</title>
			</head>
			<body>
				<h1>Error "} + resp.status + " " + resp.reason + {"</h1>
				<p>"} + resp.reason + " from IP " + std.ip(req.http.X-Real-IP, "0.0.0.0") + {"</p>
				<h3>Guru Meditation:</h3>
				<p>XID: "} + req.xid + {"</p>
				<hr>
				<p>Varnish cache server</p>
			</body>
		</html>
		"} );
		return (deliver);
	}
		
	## System is down
	if (resp.status == 503) {
		set resp.status = 503;
		#synthetic(std.fileread("/etc/varnish/error/503.html"));
		set resp.http.Content-Type = "text/html; charset=utf-8";
		set resp.http.Retry-After = "5";
		synthetic( {"<!DOCTYPE html>
		<html>
			<head>
				<title>Error "} + resp.status + " " + resp.reason + {"</title>
			</head>
			<body>
				<h1>Error "} + resp.status + " " + resp.reason + {"</h1>
				<p>"} + resp.reason + " from IP " + std.ip(req.http.X-Real-IP, "0.0.0.0") + {"</p>
				<h3>Guru Meditation:</h3>
				<p>XID: "} + req.xid + {"</p>
				<hr>
				<p>Varnish cache server</p>
			</body>
		</html>
		"} );
		return (deliver);
	} 
	
	## robots.txt for those sites that not generate theirs own
	# doesn't work with Wordpress where if under construction plugin is on
	if (resp.status == 601) {
		set resp.status = 200;
		set resp.reason = "OK";
		set resp.http.Content-Type = "text/plain; charset=utf8";
		synthetic( {"
		User-agent: *
		Disallow: /
		"} );
		return(deliver);
	}

	## 301/302 redirects using custom status
	if (resp.status == 701) {
	# We use this special error status 720 to force redirects with 301 (permanent) redirects
	# To use this, call the following from anywhere in vcl_recv: return(synth(701, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	} elseif (resp.status == 702) {
	# And we use error status 721 to force redirects with a 302 (temporary) redirect
	# To use this, call the following from anywhere in vcl_recv: return(synth(702, "http://host/new.html"));
		set resp.http.Location = resp.reason;
		set resp.status = 302;
		return(deliver);
	}

	## 410 Gone
	if (resp.status == 810) {
		set resp.status = 410;
		set resp.reason = "Gone";
		# If there is custom 410-page
		# but... redirecting doesn't work
		if (req.http.host ~ "www.katiska.info") {
			set resp.http.Location = "https://www.katiska.info/error-410-sisalto-on-poistettu/";
			return(deliver);
		} else {
			set resp.http.Content-Type = "text/html; charset=utf-8";
			set resp.http.Retry-After = "5";
			synthetic( {"<!DOCTYPE html>
			<html>
				<head>
					<title>Error "} + resp.status + " " + resp.reason + {"</title>
				</head>
					<body>
						<h1>Error "} + resp.status + " " + resp.reason + {"</h1>
						<p>Sorry, the content you were looking for has deleted. </p>
						<h3>Guru Meditation:</h3>
						<p>XID: "} + req.xid + {"</p>
						<hr>
						<p>Varnish cache server</p>
					</body>
				</html>
			"} );
			return(deliver);
		}
	}

	## all other errors if any
	set resp.http.Content-Type = "text/html; charset=utf-8";
	set resp.http.Retry-After = "5";
	synthetic( {"<!DOCTYPE html>
		<html>
			<head>
				<title>Error "} + resp.status + " " + resp.reason + {"</title>
			</head>
			<body>
				<h1>Error "} + resp.status + " " + resp.reason + {"</h1>
				<p>"} + resp.reason + " from IP " + std.ip(req.http.X-Real-IP, "0.0.0.0") + {"</p>
				<h3>Guru Meditation:</h3>
				<p>XID: "} + req.xid + {"</p>
				<hr>
				<p>Varnish cache server</p>
			</body>
		</html>
	"} );
	return (deliver);

# End of sub
} 


####################### vcl_fini #######################
#

sub vcl_fini {

  ## Called when VCL is discarded only after all requests have exited the VCL.
  # Typically used to clean up VMODs.

  return (ok);
}

# Vhosts, needed when multiple virtual hosts is in use
# must be in this order
include "/etc/varnish/discourse/sites.vcl";
include "/etc/varnish/discourse/cookies.vcl";