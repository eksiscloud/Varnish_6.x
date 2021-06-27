## Matomo analytics

vcl 4.1;

import std;			# Load the std, not STD for god sake
import vsthrottle;	# from Varnish-modules https://github.com/varnish/varnish-modules
import geoip2;		# Load the GeoIP2 by MaxMind

## I'm using sub-vcls only to keep default.vcl a little bit easier to read

# Let's Encrypt gets own backend
include "/etc/varnish/common/general/letsencrypt.vcl";

# Geo-blocking/language
include "/etc/varnish/common/filtering/geo.vcl";

# ASN
include "/etc/varnish/common/filtering/asn.vcl";

# Bad bad bots
include "/etc/varnish/common/filtering/bad-bot.vcl";

# Stop knocking
include "/etc/varnish/common/filtering/403.vcl";

# Useful bots
include "/etc/varnish/common/filtering/nice-bots.vcl";

# Tech bots
include "/etc/varnish/common/filtering/probes.vcl";

## Backend tells where a site can be found
backend matomo {
	.host = "127.0.0.1";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

## Access control lists

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
	if (req.http.host == "stats.eksis.eu") {
		set req.backend_hint = matomo;
	}

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	## GeoIP/language and ASN
	# lookup doesn't work in sub-vcls

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
	
	## Limit logins by acl whitelist
	if (req.url == "^/" && req.url ~ "^/index.php" && (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist)) {
		# I can't ban finnish IPs
		if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
			return(synth(403, "Access Denied " + req.http.X-Real-IP));
		} else {
		# other knockers I can ban
			return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
	}
	
	## Stop knocking
	if (req.url ~ "(wp-login|xmlrpc).php") {
		if (
		   req.http.X-County-Code ~ "fi"
		|| req.http.x-language ~ "fi" 
		|| req.http.x-agent == "nice"
		) {
			return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden request from: " + req.http.X-Real-IP));
		}
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
		# Why did I this?
		#else {
		#	set req.http.x-bot = "tech";
		#}
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.x-bots != "nice") {
			call stop_pages;
		}

	## No robots.txt, ads.txt, site.webmanifest or sellers.json.
	if (req.url ~ "^/(robots.txt|ads.txt|site.webmanifest|sellers.json)") {
		return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
	}
	
	## Normally I would hash at this point, but I don't want to cache anyhing.
	return(pipe);
	
# The end of sub-vcl
}

############### vcl_synth #################
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