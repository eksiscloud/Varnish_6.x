## Plain domain, no content. Only for redirection purposes, was a site once ##

vcl 4.1;

import std;			# Load the std, not STD for god sake
import geoip2;		# Load the GeoIP2 by MaxMind

## I'm using sub-vcls only to keep default.vcl a little bit easier to read

# Useful bots
include "/etc/varnish/common/filtering/nice-bots.vcl";

## Backend tells where a site can be found
backend zombie {					# use your servers instead default if you have more than just one
	.host = "127.0.0.1";			# IP or Hostname of backend
	.port = "81";					# Apache, Nginx or whatever is listening
#	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
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

	if (req.http.host == "sumppu.info" || req.http.host == "www.sumppu.info") {
		set req.backend_hint = zombie;
	}

	## Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	## Normalize hostname to www. to avoid double caching
	# I like to keep triple-w
	set req.http.host = regsub(req.http.host,
	"^sumppu\.info$", "www.sumppu.info");
	
	## GeoIP and ASN
	# I don't need actual geo-blocking anymore. It has been done at default.vcl
	# All I need is country condes, ASN and language to not ban finnish IPs and/or users

	# GeoIP and normalizing country codes to lower case, because remembering to use capital letters is just too hard
	set req.http.X-Country-Code = country.lookup("country/iso_code", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.X-Country-Code = std.tolower(req.http.X-Country-Code);
	
	# Finding out and normalizing ASN. I don't need this but is used in funny headers
	set req.http.x-asn = asn.lookup("autonomous_system_organization", std.ip(req.http.X-Real-IP, "0.0.0.0"));
	set req.http.x-asn = std.tolower(req.http.x-asn);
	
	## I'm normalizing language
	# For REAL normalizing you should work with Accept-Language only
	set req.http.x-language = std.tolower(req.http.Accept-Language);
	unset req.http.Accept-Language;
	if (req.http.x-language ~ "fi") {
		set req.http.x-language = "fi";
	} else {
		unset req.http.x-language;
	}
	
	## Normalize aka. good bots
	call cute_bot_allowance;
	
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
	
	## And the last stop if something gets here
	return(synth(403, "Unauthorized request"));

# The end of sub
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