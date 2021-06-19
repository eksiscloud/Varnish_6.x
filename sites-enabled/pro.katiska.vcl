## Moodle
sub vcl_recv {
  if (req.http.host == "pro.katiska.info") {
		set req.backend_hint = default;
	
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	### No real caching, Moodle has its own caching system
	
	## Common rules to every sites by common.vcl
	call common_rules;
	
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
	
	## Still too curious?
	if (req.url ~ "^/(ads.txt|sellers.json)") {
		return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
	}
	
	## Needed for uptime
	if (req.url == "^/pong") {
		return(pipe);
	}
	
	## Pipe requests to backup.php straight to backend - prevents problem with progress bar long polling 503 problem
	# backup.php is POSTing to itself - Perhaps should filter before !GET&&!HEAD
	if (req.url ~ "^/backup/backup.php") {
		return (pipe);
	}
	
	## humans.txt never change
	if (req.url ~ "^/(robots|humans).txt") { 
		return(hash);
	}
	
	## Moodle doesn't require cookie to serve following assets. Remove Cookie header from request, so it will be looked up.
	if (
		req.url ~ "^/altlogin/.+/.+\.(png|jpg|jpeg|gif|css|js|webp)$" ||
		req.url ~ "^/pix/.+\.(png|jpg|jpeg|gif)$" ||
		req.url ~ "^/theme/font.php" ||
		req.url ~ "^/theme/image.php" ||
		req.url ~ "^/theme/javascript.php" ||
		req.url ~ "^/theme/jquery.php" ||
		req.url ~ "^/theme/styles.php" ||
		req.url ~ "^/theme/yui" ||
		req.url ~ "^/lib/javascript.php/-1/" ||
		req.url ~ "^/lib/requirejs.php/-1/"
		) {
		# Set internal temporary header, based on which we will do things in vcl_backend_response
		set req.http.x-moodle-ttl = "86400";
		unset req.http.Cookie;
		return(hash);
	}
	
	## Perform lookup for selected assets that we know are static but Moodle still needs a Cookie
	if(
		req.url ~ "^/theme/.+\.(png|jpg|jpeg|gif|css|js|webp)" ||
		req.url ~ "^/lib/.+\.(png|jpg|jpeg|gif|css|js|webp)" ||
		req.url ~ "^/pluginfile.php/[0-9]+/course/overviewfiles/.+\.(?i)(png|jpg)$"
		) {
		# Set internal temporary header, based on which we will do things in vcl_backend_response
		set req.http.x-moodle-ttl = "86400";
		return(hash);
	}
	
	## Serve requests to SCORM checknet.txt from varnish. Have to remove get parameters. Response body always contains "1"
	if ( req.url ~ "^/lib/yui/build/moodle-core-checknet/assets/checknet.txt" ) {
		set req.url = regsub(req.url, "(.*)\?.*", "\1");
		unset req.http.cookie;
		set req.http.x-moodle-ttl = "86400";
		return(hash);
		}
	
	## Cookies needed, so no caching
	if (req.http.cookie ~ "Moodle|MOODLEID") {
		return(pass);
	}
	
    # Almost everything in Moodle correctly serves Cache-Control headers, if
    # needed, which varnish will honor, but there are some which don't. Rather
    # than explicitly finding them all and listing them here we just fail safe
    # and don't cache unknown urls that get this far.
	return(pass);
	
  # the host ends here
  }
# the end of sub
}