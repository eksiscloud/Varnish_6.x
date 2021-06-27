## WordPress

vcl 4.1;

import std;			# Load the std, not STD for god sake
import cookie;		# Load the cookie, former libvmod-cookie
import purge;		# Soft/hard purge by Varnish 6.x
import vsthrottle;	# from Varnish-modules https://github.com/varnish/varnish-modules
import geoip2;		# Load the GeoIP2 by MaxMind

## I'm using sub-vcls only to keep default.vcl a little bit easier to read

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

# CORS
include "/etc/varnish/common/general/cors.vcl";

# Just some debugging headers like HIT and MISS
include "/etc/varnish/common/general/debugs.vcl";

# Cheshire cat at headers
include "/etc/varnish/common/additional/cheshire_cat.vcl";

# X-headers, just for fun
include "/etc/varnish/common/additional/x-heads.vcl";

# WordPress stuff
include "/etc/varnish/common/general/wordpress_common.vcl";

# Common things
include "/etc/varnish/wordpress/ext/general/common.vcl";

# 410 Gone
include "/etc/varnish/wordpress/ext/redirect/410sites.vcl";

# 301 Redirect
include "/etc/varnish/wordpress/ext/redirect/301sites.vcl";

## Probes are watching if backends are healthy
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

## Backend tells where a site can be found
backend wordpress {					# use your servers instead default if you have more than just one
	.host = "127.0.0.1";			# IP or Hostname of backend
	.port = "81";					# Apache or whatever is listening
#	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
	.probe = sondi;					# We have chance to recycle the probe 
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

	## just for these virtual hosts
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## GeoIP and ASN
	# I don't need actual geo-blocking anymore. It has been done at default.vcl
	# All I need is country condes, ASN and language to not ban finnish IPs and/or users

	# GeoIP and normalizing country codes to lower case, because remembering to use capital letters is just too hard
	set req.http.X-Country-Code = country.lookup("country/iso_code", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.X-Country-Code = std.tolower(req.http.X-Country-Code);
	call geo-lang;
	
	# Finding out and normalizing ASN. I don't need this but is used in funny headers
	set req.http.x-asn = asn.lookup("autonomous_system_organization", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.x-asn = std.tolower(req.http.x-asn);
	call asn_name;
	
	## Normalize aka. good bots
	call cute_bot_allowance;
	
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
	
	## Awstats needs the host 
	# You must add something like this in systemctl edit --full varnishncsa at line StartExec:
	# -F '%%{X-Forwarded-For}i %%{VCL_Log:X-Req-Host}x %%l %%u %%t "%%r" %%s %%b "%%{Referer}i" "%%{User-agent}i"'
	set req.http.X-Req-Host = req.http.host;
	std.log("X-Req-Host:" + req.http.X-Req-Host);

	## Save Origin (for CORS) in a custom header and 
	## remove Origin from the request so that backend doesn’t add CORS headers.
	set req.http.X-Saved-Origin = req.http.Origin;
	unset req.http.Origin;
	
	# Send Surrogate-Capability headers to announce ESI support to backend
	set req.http.Surrogate-Capability = "key=ESI/1.0";

	## At this point we jump to sites.vcl and further to hosts

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
	
	## There shouldn't be any meaningful cookies left, but if there is...
	if (req.http.cookie) {
		hash_data(req.http.cookie);
	}
	
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
	
	## Slowing down amount of backend requests to way too anxious ones
	# If the client IP makes more than 100 requests per second that result in a cache miss, access is prohibited for one minute
	if (vsthrottle.is_denied(std.ip(bereq.http.X-Real-IP, "0.0.0.0"), 100, 1s, 1m)) {
		return(error(429, "Too Many Requests"));
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
	# Heads up! What should I do with nonce by Wordpress? That can't be cached over 12 hours, claims all docs.
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
	
	## RSS and other feeds like podcast can be cached
	# Podcast services are checking feed way too often, and I'm quite lazy to publish, so 24h delay is acceptable
	if (beresp.http.Content-Type ~ "text/xml") {
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; 
	}
	
	## Robots.txt is really static, but let's be on safe side using one month
	# Against all claims bots check robots.txt almost never, so caching doesn't help much
	if (bereq.url ~ "/robots.txt") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=2592000";
		set beresp.ttl = 2592000s; # 1 month
	}
	
	## ads.txt and sellers.json is really static to me, but let's be on safe side
	if (bereq.url ~ "^/(ads.txt|sellers.json)") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=2592000";
		set beresp.ttl = 2592000s; # 1 month
	}
	
	## Sitemaps
	# Caching of sitemaps is borderline case. It depends, but I'm not publishing even every week
	if (bereq.url ~ "sitemap") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; # 24h
	}

	## Tags
	# Just another archive and normally these should not cache for longer time 
	if (bereq.url ~ "(avainsana|tag)") {
		unset beresp.http.cache-control;
		set beresp.http.cache-control = "max-age=86400"; # 24h
		set beresp.ttl = 86400s; # 24h
	}

	## Search results
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
	
	## Some admin-ajax.php calls can be cached by Varnish
	# Except... it is almost always POST and that is uncacheable
	if (bereq.url ~ "admin-ajax.php" && bereq.http.cookie !~ "wordpress_logged_in" ) {
		unset beresp.http.set-cookie;
		set beresp.ttl = 1d;
		set beresp.grace = 1d;
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



############### vcl_synth #################
#
sub vcl_synth {

	call cors;
	
	### Custom errors
		
	## forbidden error 403
	if (resp.status == 403) {
		set resp.status = 403;
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
include "/etc/varnish/wordpress/sites.vcl";
include "/etc/varnish/wordpress/cookies.vcl";