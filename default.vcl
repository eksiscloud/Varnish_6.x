## Jakke Lehtonen
## https://git.eksis.one/jagster/varnish_6.x
## from several sources
## Heads up! There is errors for sure
## I'm just another copypaster
##
## Varnish 6.6.0 default.vcl for multiple virtual hosts
## 
## Known issues: 
##  - easy to get false bans (googlebot, Bing...) 
##  - geoip doesn't give a country everytime
#
# Lets's start caching
 
#
 
# Marker to tell the VCL compiler that this VCL has been adapted to the 4.1 format.
vcl 4.1;

import directors;	# Load the vmod_directors
import std;			# Load the std, not STD for god sake
import cookie;		# Load the cookie, former libvmod-cookie
import purge;		# Soft/hard purge by Varnish 6.x
import geoip2;		# Load the GeoIP2 by MaxMind

## I'm using sub-vcls only to keep default.vcl a little bit easier to read

# Let's Encrypt gets its own backend
include "/etc/varnish/letsencrypt.vcl";

# All common vcl_recv
include "/etc/varnish/ext/common.vcl";

# Wordpress stuff
include "/etc/varnish/ext/wordpress_common.vcl";

# WooCommerce related
include "/etc/varnish/ext/woocommerce_common.vcl";

# CORS
include "/etc/varnish/ext/addons/cors.vcl";

# Some URL manipulations
include "/etc/varnish/ext/redirect/manipulate.vcl";

# Soft/hard purge
include "/etc/varnish/ext/addons/lets_purge.vcl";

# 301 Redirect
include "/etc/varnish/ext/redirect/301sites.vcl";

# Global redirecting if any
include "/etc/varnish/ext/redirect/404.vcl";

# 410 Gone
include "/etc/varnish/ext/redirect/410sites.vcl";

# Banning by ASN
include "/etc/varnish/ext/filtering/asn.vcl";

# Probes and similar good stuff
include "/etc/varnish/ext/filtering/probes.vcl";

# Bad Bad Robots
include "/etc/varnish/ext/filtering/bad-bot.vcl";

# Cute and nice botties
include "/etc/varnish/ext/filtering/nice-bot.vcl";

# Stop knocking
include "/etc/varnish/ext/filtering/403.vcl";

# Just some debugging headers like HIT and MISS
include "/etc/varnish/ext/general/debugs.vcl";

# Cheshire cat at headers
include "/etc/varnish/ext/general/cheshire_cat.vcl";

# X-headers, just for fun
include "/etc/varnish/ext/general/x-heads.vcl";

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

probe sondi-git {
    .request =
      "HEAD / HTTP/1.1"
      "Host: git.eksis.one"
      "Connection: close"
      "User-Agent: Varnish Health Probe";
	.timeout = 3s;
	.interval = 4s;
	.window = 5;
	.threshold = 3;
}

#probe sondi-wiki {
#    .request =
#      "HEAD / HTTP/1.1"
#      "Host: www.koiranravitsemus.fi"
#      "Connection: close"
#      "User-Agent: Varnish Health Probe";
#	.timeout = 3s;
#	.interval = 4s;
#	.window = 5;
#	.threshold = 3;
#}

probe sondi-proto {
    .request =
      "HEAD / HTTP/1.1"
      "Host: proto.eksis.one"
      "Connection: close"
      "User-Agent: Varnish Health Probe";
	.timeout = 3s;
	.interval = 4s;
	.window = 5;
	.threshold = 3;
}

probe sondi-kaffein {
    .request =
      "HEAD / HTTP/1.1"
      "Host: kaffein.jagster.fi"
      "Connection: close"
      "User-Agent: Varnish Health Probe";
	.timeout = 3s;
	.interval = 4s;
	.window = 5;
	.threshold = 3;
}

probe sondi-meta {
    .request =
      "HEAD / HTTP/1.1"
      "Host: meta.katiska.info"
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

# git.eksis.one by Gitea
backend gitea {
	.path = "/run/gitea/gitea.sock";
	#.host = "localhost";
	#.port = "3000";				# Gitea
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi-git;				# We have chance to recycle the probe
}

# www.koiranravitsemus.fi by MediaWiki
backend wiki {
	.host = "127.0.0.1";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	#.probe = sondi-wiki;			# We have chance to recycle the probe
}

# stats.eksis.eu by Matomo
backend matomo {
	.host = "127.0.0.1";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

# proto.eksis.one by Discourse
backend proto {
	.path = "/var/discourse/shared/proto/nginx.http.sock";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi-proto;			# We have chance to recycle the probe
}

# kaffein.jagster.fi by Discourse
backend kaffein {
	.path = "/var/discourse/shared/jagster/nginx.http.sock";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi-kaffein;			# We have chance to recycle the probe
}

# meta.katiska.info by Discourse in other DO droplet
backend meta {
	.host = "138.68.111.130";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi-meta;			# We have chance to recycle the probe
}

## ACLs: I can't use client.ip because it is always 127.0.0.1 by Nginx (or any proxy like Apache2)
# Instead client.ip it has to be like std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist

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

# just an example, I use 403.vcl together fail2ban
#acl forbidden {
#	"134.209.232.158";
#	"5.117.231.54";
#}

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
## We should have here only statments without return(...)
## because such jumps to buildin.vcl passing everything in all.common.vcl and hosts' vcl
## The solution has explained here: https://www.getpagespeed.com/server-setup/varnish/varnish-virtual-hosts

sub vcl_recv {
	
	### pass/pipe here are varnish-wide
	
	## Your lifeline: Turn OFF cache (everything else happends, though)
	## For caching keep this commented
	# return(pass);
	
	
	## Your last hope: a dumb TCP termination
	## It passes everything right thru Varnish
	# return(pipe);

	# My personal safenet moneywise when (not if...) I'll make some funny to Varnish
	#if (req.http.host == "store.katiska.info") {
	#	return(pipe);
	#}

	### The work starts here
	###
	### At main vcl_recv will happend only normalizing etc, where is no return(...) statements because those bypasses other VCLs.
	### At all-common.vcl is for cookies and similar commmon things for hosts
	### All domain-VCLs do the rest where return(...) is needed and part of jobs are done using 'call common.vcl'
	### Exception to rule no-return-statements is everything where the connection will be terminated for good and anything else is not needed
	
	## Just an example how to do geo-blocking
	# 1st: GeoIP and normalizing country codes to lower case, because remembering to use capital letters is just too hard
	set req.http.X-Country-Code = country.lookup("country/iso_code", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.X-Country-Code = std.tolower(req.http.X-Country-Code);
	# I could do for example:
	#if (req.http.X-Country-Code ~ "(fi|se)") {
	#	set req.http.X-Country-Code = "fi";
	#} else {
	#	set req.http.X-Country-Code = "us";
	#}
	
	# 2nd: Actual blocking: (mostly I do geo-blocking in iptables, but this is much easier way)
	# I'll ban ir stop a country only after several tries, it is not a decision made easily (well... it is actually) 
	# Heads up: Cloudflare and other big CDNs can route traffic through really strange datacenters - like from Turkey to Finland via Senegal
	if (req.http.X-Country-Code ~ "(bd|bg|cn|cr|ru|hk|id|my|pl|tw|ua)") {
		std.log("banned country: " + req.http.X-Country-Code);
		return(synth(403, "Forbidden country: " + std.toupper(req.http.X-Country-Code)));
	}
	
	## I can block service provider too.
	# 1st: Finding out and normalizing ASN
	set req.http.x-asn = asn.lookup("autonomous_system_organization", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.x-asn = std.tolower(req.http.x-asn);
	
	# 2nd: Actual blocking: (customers from these are knocking security holes etc. way too often)
	# Finding out ASN from whois-data isn't so straight forwarded
	# It is quite often descr. (if told) or whole or partially same as NetName.
	# You can find it out using ASN lookup like https://hackertarget.com/as-ip-lookup/
	call asn_name;
	
	## Normalize the header, remove the port (in case you're testing this on various TCP ports)
	set req.http.host = std.tolower(req.http.host);
	set req.http.host = regsub(req.http.host, ":[0-9]+", "");
	
	## Let's tune up a bit behavior for healthy backends: Cap grace to 5 min
	if (std.healthy(req.backend_hint)) {
		set req.grace = 300s;
	}
	
	## Setting http headers for backend
	if (req.restarts == 0) {
		if (req.http.X-Forwarded-For) {
			set req.http.X-Forwarded-For =
			req.http.X-Forwarded-For + " " + req.http.X-Real-IP;
		} else {
			set req.http.X-Forwarded-For = req.http.X-Real-IP;
		}
	}
	
	## Remove the proxy header
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
	
	## URL changes by manipulate.vcl, mostly fixed search strings
	call new_direction;
	
	## Awstats needs the host 
	# You must add something like this in systemctl edit --full varnishncsa at line StartExec:
	# -F '%%{X-Forwarded-For}i %%{VCL_Log:X-Req-Host}x %%l %%u %%t "%%r" %%s %%b "%%{Referer}i" "%%{User-agent}i"'
	set req.http.X-Req-Host = req.http.host;
	std.log("X-Req-Host:" + req.http.X-Req-Host);

	## Save Origin (for CORS) in a custom header and 
	## remove Origin from the request so that backend doesn’t add CORS headers.
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;

	## I'm normalizing language
	# For REAL normalizing you should work with Accept-Language only
	set req.http.x-language = std.tolower(req.http.Accept-Language);
	unset req.http.Accept-Language;
	if (req.http.x-language ~ "fi") {
		set req.http.x-language = "fi";
	#} elseif (req.http.x-language ~ "se") {
	#	set req.http.x-language = "se"
	#} elseif (req.http.x-language ~ "en") {
	#	set req.http.x-language = "en"
	} else {
		unset req.http.x-language;
	}

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

	## Cookie monster
	
	# Gitea 
	if (req.http.x-host == "gitea") {
		hash_data(req.http.cookie);
	}
	
	# Discourse 
	if (req.http.x-host == "discourse") {
		hash_data(req.http.cookie);
	}
	
	# MediaWiki 
	if (req.http.x-host == "mediawiki") {
		hash_data(req.http.cookie);
	}
	
	# Moodle 
	if (req.http.x-host == "moodle") {
		hash_data(req.http.cookie);
	}
	
	# Matomo 
	if (req.http.x-host == "matomo") {
		hash_data(req.http.cookie);
	}
	
	# WordPress/WooCommerce 
	if (req.http.x-host == "wordpress") {
		hash_data(req.http.cookie);
	}
	
	# There shouldn't be any meaningful cookies left, but if there is...
	#if (req.http.cookie) {
	#	hash_data(req.http.cookie);
	#}
	
	## Return of User-Agent, but without caching
	# Now I can send User-Agent to backend for 404 logging etc.
	# Vary must be cleaned of course
	if (req.http.x-agent) {
		set req.http.User-Agent = req.http.x-agent;
		unset req.http.x-agent;
	}
	
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
	
	## Backend is down, stop caching
	if (beresp.status >= 500 && bereq.is_bgfetch) {
		return(abandon);
	}
	
	## Send User-Agent to backend, but removing it from Vary prevents Varnish to use it caching
	if (beresp.http.Vary ~ "User-Agent") {
		set beresp.http.Vary = regsuball(beresp.http.Vary, ",? *User-Agent *", "");
		set beresp.http.Vary = regsub(beresp.http.Vary, "^, *", "");
		if (beresp.http.Vary == "") {
			unset beresp.http.Vary;
		}
	}
	
	## Ordinary default; how long Varnish will keep objects
	# Varnish is using s-maxage as beresp.ttl (max-age is for browser),
	# Server must reboot about once in month so 1y is ridiculous long
	# If backend sets s-maxage Varnish will use it, otherwise it will be 1y
	# Heads up! What should I do with nonce by Wordpress? That can't be cached over 12 hours.
	if (beresp.http.cache-control !~ "s-maxage") {
		set beresp.ttl = 31536000s;
		# or if you will pass TTL to other intermediate caches as CDN, otherwise they will use maxage
		#set beresp.http.cache-control = "s-maxage=31536000, " + beresp.http.cache-control;
	}

	## Will kick in if backend is sick
	# Why using grace instead keep? IDK.
	set beresp.grace = 24h;
	
	## Cache some responses only short period
	# Can I do beresp.status == 302 || beresp.status == 307 ?
	if (beresp.status == 404) {
		set beresp.http.cache-control = "max-age=300";
		set beresp.ttl = 3600s; # 1h
	}
	
	## 301/410 are quite static
	if (beresp.status == 301 || beresp.status == 410) {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=2592000"; # 30d
		set beresp.ttl = 31536000s;
	}
	
	## 301 and 410 are quite steady, again, so let Varnish cache resuls from backend
	# I don't understand meaning of this and what is this doing differently than earlier statements?
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
	
	## Moodle and static objects
	if (beresp.http.Cache-Control && bereq.http.x-moodle-ttl && beresp.ttl < std.duration(bereq.http.x-moodle-ttl + "s", 1s) && !beresp.http.WWW-Authenticate ) { 
		# If max-age < defined in x-moodle-ttl header
		set beresp.http.X-Orig-Cache-Control = beresp.http.Cache-Control;
		set beresp.http.Cache-Control = "public, max-age="+bereq.http.X-Long-TTL + ", no-transform";
		set beresp.ttl = std.duration(bereq.http.x-moodle-cache + "s", 1s);
        unset bereq.http.x-moodle-cache;
	}
    elseif(!beresp.http.Cache-Control && bereq.http.x-moodle-ttl && !beresp.http.WWW-Authenticate ) {
		set beresp.http.Cache-Control = "public, max-age="+bereq.http.x-moodle-ttl + ", no-transform";
		set beresp.ttl = std.duration(bereq.http.x-moodle-ttl + "s", 1s);
		unset bereq.http.x-moodle-ttl;
	}
	else { 
		# Don't touch headers if max-age > defined in x-moodle-ttl header
		unset bereq.http.x-moodle-ttl;
	}
	
	## RSS and other feeds like podcast can be cached
	# Podcast services are checking feed way too often, and I'm quite lazy to publish, so 24h delay is acceptable
	if (beresp.http.Content-Type ~ "text/xml") {
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; 
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

	## Tags
	if (bereq.url ~ "(avainsana|tag)") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; # 24h
	}

	## Search results, mostly Wordpress if I'm guessing right
	# Normally those querys should pass but I want to cache answers
	# Caching or not doesn't matter because users don't search too often anyway
	if (bereq.url ~ "/\?s=") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=120";
		set beresp.ttl = 43200s; # 12h
	}
	
	## I have an issue with one cache-control value from WordPress
	if (bereq.url ~ "/icons.ttf\?pozjks") {
		unset beresp.http.set-cookie;
		set beresp.http.cache-control = "max-age=31536000"; 
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
	
	## Some admin-ajax.php calls can be cached by Varnish
	# Except... it is almost always POST and that is uncacheable
	if (bereq.url ~ "admin-ajax.php" && bereq.http.cookie !~ "wordpress_logged_in" ) {
		unset beresp.http.set-cookie;
		set beresp.ttl = 1d;
		set beresp.grace = 1d;
	}
	
	## My repo/Gitea
	if (bereq.url ~ "/src/" || bereq.url ~ "/explore/" ) {
		#unset beresp.http.set-cookie;
		set beresp.ttl = 1d;
		set beresp.grace = 1d;
		set beresp.http.cache-control = "max-age=86400"; # 24h
	}
	
	## Not found images from different caches after I started CDN; yes, these should redirect on server but I don't know how
	# shows as ordinary 404 at logs of Wordpress of course
	if (beresp.status == 404 && bereq.url ~ ".jpg") {
		set beresp.status = 410;
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
	
	## Just an example how to vary by country from GeoIP VMOD
	#if (bereq.http.X-Country-Code) {
	#	if (!beresp.http.Vary) {
	#		set beresp.http.Vary = "X-Country-Code";
	#	} elsif (beresp.http.Vary !~ "X-Country-Code") {
	#		set beresp.http.Vary = beresp.http.Vary + ", X-Country-Code";
	#	}
	#}
	
	## Stupid knockers trying different kind of executables or archives
	# 404 notices at backend, like Wordpress, doesn't disappear because this happends after backend, of course
	if (bereq.url !~ "(wp-json|caos|sitemap|lib/ajax)") {  # all of those give 404 sometimes, so this is just failsafe
		if (beresp.status == 404 && bereq.url ~ "/([a-z0-9_\.-]+).(asp|aspx|php|js|jsp|rar|zip|tar|gz)") {
			if (bereq.http.X-Country-Code !~ "fi" && bereq.http.x-bot != "nice") {
				set beresp.status = 666;
				set beresp.ttl = 24h; # longer TTL for foreigners
			} else {
				set beresp.status = 403;
				set beresp.ttl = 1h; # shorter TTL for more trustful ones
			}
		}
	}
	
	## Caching static files improves cache ratio, but eats RAM and doesn't make your site faster. 
	# Most of media files are served from CDN anyway and I have some RAM left so let's go hey-ho.
	# But... I'm almost sure this snippet had some meaning back Varnish 4.0, perhaps, but I'm using 6.6 and AFAIK these are just another objects
	if (bereq.url ~ "^[^?]*\.(7z|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gif|gz|ico|jpeg|jpg|js|otf|pdf|png|ppt|pptx|rtf|svg|svgz|swf|tar|tbz|tgz|ttf|txt|txz|webm|webp|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$") {
		unset beresp.http.set-cookie;
	}
	
	## Large static files are delivered directly to the end-user without waiting for Varnish to fully read the file first.
	# Most of these are in CDN, but I have some MP3s behind backend
	# Is this really needed anymore? AFAIK Varnish should do this anyway.
	if (bereq.url ~ "^[^?]*\.(avi|mkv|mov|mp3|mp4|mpeg|mpg|ogg|ogm|wav)(\?.*)?$") {
		unset beresp.http.set-cookie;
		set beresp.do_stream = true;  # This should be ignored because I have do_esi = true
	}
	
	## Unset cookies except for Wordpress admin and WooCommerce pages 
	# Heads up: product is 'tuote' in finnish, change it!
	# Heads up: some sites may need to set cookie!
	if (
		bereq.url !~ "(wp-(login|admin)|login|admin-ajax|cart|my-account|wc-api|checkout|addons|logout|resetpass|lost-password|tuote|\?wc-ajax=get_refreshed_fragments)" &&
		bereq.http.cookie !~ "(wordpress_|resetpass|wp-postpass)" &&
		bereq.http.cookie !~ "(woocommerce_|wp_woocommerce)" &&
		beresp.status != 302 &&
		bereq.method == "GET"
		) { 
		unset beresp.http.set-cookie; 
	}
	
	## Do I really have to tell this again?
	if (bereq.method == "POST") {
		set beresp.uncacheable = true;
		return (deliver);
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
	
	## Moodle: Revert back to original Cache-Control header before delivery to client
	if (resp.http.X-Orig-Cache-Control) {
		set resp.http.Cache-Control = resp.http.X-Orig-Cache-Control;
		unset resp.http.X-Orig-Cache-Control;
	}
	
	## MediaWiki doesn't set vary as I want it; this has no point anyway
	if (req.http.host ~ "koiranravitsemus.fi") {
		unset resp.http.vary;
		set resp.http.vary = "X-Forwarded-Proto, Accept-Encoding";
	}

	## Let's add the origin by cors.vcl
	call cors;
	
	# Origin should be in vary too
	if (resp.http.Vary) {
		set resp.http.Vary = resp.http.Vary + ",Origin";
	} else {
		set resp.http.Vary = "Origin";
	}
	
	## Just some unneeded headers from debugs.vcl
	call diagnose;
	
	## Moodle: Set X-AuthOK header when authentication succeeded
	# Not in use here, but some day... so, it will be ready
	if (req.http.X-AuthOK) {
		set resp.http.X-AuthOK = req.http.X-AuthOK;
	}
	
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

	call cors;
	
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
include "all-vhost.vcl";
include "all-cookies.vcl";