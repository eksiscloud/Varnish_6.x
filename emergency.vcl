#### Jakke Lehtonen
## https://git.eksis.one/jagster/varnish_6.x
## from several sources
## Heads up! There is errors for sure
## I'm just another copypaster
##
## Varnish 6.6.0 emergency.vcl when everything goes to south big time
## but it works only if Varnish is up
##

## Lets's start
 
#################### start ##################
# some really important basics must tell to Varnish
 
## Marker to tell the VCL compiler that this VCL has been adapted to the 4.1 format.
vcl 4.1;

import std;

# Let's Encrypt gets its own backend
include "/etc/varnish/letsencrypt.vcl";

## Backend tells where a site can be found
backend default {					# use your servers instead default if you have more than just one
	.host = "127.0.0.1";			# IP or Hostname of backend
	.port = "81";					# Apache or whatever is listening
#	.max_connections = 800;			# That's it enough 
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

# git.eksis.one by Gitea
backend gitea {
	.path = "/run/gitea/gitea.sock";
	#.host = "localhost";
	#.port = "3000";				# Gitea
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

# www.koiranravitsemus.fi by MediaWiki
backend wiki {
	.host = "127.0.0.1";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
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
}

# kaffein.jagster.fi by Discourse
backend kaffein {
	.path = "/var/discourse/shared/jagster/nginx.http.sock";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

# meta.katiska.info by Discourse in other DO droplet
backend meta {
	.host = "138.68.111.130";
	.port = "82";
	.first_byte_timeout = 300s;		# How long to wait before we receive a first byte from our backend?
	.connect_timeout = 300s;		# How long to wait for a backend connection?
	.between_bytes_timeout = 300s;	# How long to wait between bytes received from our backend?
}

#################### vcl_init ##################
# Called when VCL is loaded, before any requests pass through it. Typically used to initialize VMODs.
# You have to define server at backend definition too.
# I need this here only for GeoIP.

sub vcl_init {
	
# The end of init
}

############### vcl_recv #################
## The first to take care of requests
## Now I'm doing only some door slamming and
## and telling direction to proper vcl.

sub vcl_recv {
	
	## Normalize the host and remove the port (in case you're testing this on various TCP ports)
	
	set req.http.host = std.tolower(req.http.host);
	set req.http.host = regsub(req.http.host, ":[0-9]+", "");
	
	## Lets tell backends
	
	if (
	req.http.host == "www.katiska.info" ||
	req.http.host == "www.eksis.one" ||
	req.http.host == "www.eksis.dev" ||
	req.http.host == "www.jagster.fi" ||
	req.http.host == "www.ymparistosuunnittelija.com" ||
	req.http.host == "humaani.katiska.info" ||
	req.http.host == "katti.katiska.info" ||
	req.http.host == "polle.katiska.info" ||
	req.http.host == "selko.katiska.info" ||
	req.http.host == "www.eksis.eu" ||
	req.http.host == "store.katiska.info" ||
	req.http.host == "store.eksis.one" ||
	req.http.host == "pro.katiska.info" ||
	req.http.host == "pro.eksis.one" ||
	req.http.host == "www.sumppu.info"
	) {
		set req.backend_hint = default;
	} 
	
	elseif (req.http.host == "meta.katiska.info") { set req.backend_hint = meta; }
	elseif (req.http.host == "proto.eksis.one") { set req.backend_hint = proto; }
	elseif (req.http.host == "kaffein.jagster.fi") { set req.backend_hint = kaffein; }

	elseif (req.http.host == "www.koiranravitsemus.fi") { set req.backend_hint = wiki; }
	
	elseif (req.http.host == "git.eksis.one") { set req.backend_hint = gitea; }

	elseif (req.http.host == "stats.eksis.eu") { set req.backend_hint = matomo; }

	elseif (
	req.http.host == "104.248.141.204" ||
	req.http.host == "_" ||
	req.http.host == ""
	) {
		set req.backend_hint = default;
	}

	# Because I'm in deep shit, but Varnish is still alive...
	return(pipe);
	
# That's it. We are ready here.
}