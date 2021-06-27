#### Jakke Lehtonen
## https://git.eksis.one/jagster/varnish_6.x
## from several sources
## Heads up! There is errors for sure
## I'm just another copypaster
##
## Varnish 6.6.0 default.vcl for multiple vcl and virtual hosts
## 
## Known issues: 
##  - easy to get false bans (googlebot, Bing...) 
##  - ASN is unreliable
##
## This setup uses different vcl with different type of apps, not per host
## The first one is like a crossroad or catalog to tell what vcl should used
##

## Lets's start caching
 
#################### start ##################
# some really important basics must tell to Varnish
 
## Marker to tell the VCL compiler that this VCL has been adapted to the 4.1 format.
vcl 4.1;

import std;			# Load the std, not STD for god sake

## fake, never-used backend to silence the compiler
backend fake {
	.host = "0:0";
}

############### vcl_recv #################
## The first to take care of requests
## Now I'm doing only some door slamming and
## and telling direction to proper vcl.

sub vcl_recv {
	
	## Normalize the host and remove the port (in case you're testing this on various TCP ports)
	
	set req.http.host = std.tolower(req.http.host);
	set req.http.host = regsub(req.http.host, ":[0-9]+", "");
	
	## Lets tell which VCL must use
	# if a proxy front of Varnish will pass like www and non-www you have to normalize it here or allow both
	# For me Nginx is sending only www.
	# Heads up: vcl label is not same as file name. It is symbolic name and you will set it up in CLI.
	
	if (
	# Pure WordPress
	req.http.host == "www.katiska.info" ||
	req.http.host == "www.eksis.one" ||
	req.http.host == "www.eksis.dev" ||
	req.http.host == "www.jagster.fi" ||
	req.http.host == "www.ymparistosuunnittelija.com" ||
	req.http.host == "humaani.katiska.info" ||
	req.http.host == "katti.katiska.info" ||
	req.http.host == "polle.katiska.info" ||
	req.http.host == "selko.katiska.info" ||
	req.http.host == "www.eksis.eu"
	) {
		return(vcl(wordpress));
	} 
	elseif (
	# WooCommerce
	req.http.host == "store.katiska.info" ||
	req.http.host == "store.eksis.one"
	) {
		return(vcl(woocommerce));
	}
	# Discourse
	elseif (req.http.host == "meta.katiska.info") { return(vcl(meta_katiska_info)); }
	elseif (req.http.host == "proto.eksis.one") { return(vcl(proto_eksis_one)); }
	elseif (req.http.host == "kaffein.jagster.fi") { return(vcl(kaffein_jagster_fi)); }
	elseif (
	# For some reason Discourse and MediaWiki must be in the same vcl. Otherwise only the first loaded one will work.
	req.http.host == "www.koiranravitsemus.fi" ||
	req.http.host == "git.eksis.one"
	) {
		return(vcl(discowikigit));
	}
	elseif (
	# Moodle
	req.http.host == "pro.katiska.info" ||
	req.http.host == "pro.eksis.one"
	) {
		return(vcl(moodle));
	}
	elseif (
	# Matomo
	req.http.host == "stats.eksis.eu"
	) {
		return(vcl(matomo));
	}
	elseif (
	# One dead domain
	req.http.host == "www.sumppu.info"
	) {
		return(vcl(zombie));
	}
	elseif (
	# IP of the server, doesn't work as I want; will disappear
	req.http.host == "104.248.141.204" ||
	req.http.host == "_" ||
	req.http.host == ""
	) {
		return (vcl(server));
	}
	else {
		return(synth(404));
	}
# That's it. We are ready here.
}