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
	
	## All I can do... I'm using if-elseif-else just more realiable way to reach return(pass)
	# Still too curious?
	if (req.url ~ "^/(ads.txt|sellers.json)") {
		return(synth(403, "Forbidden request from: " + req.http.X-Real-IP));
	}
	# Needed for uptime
	elseif (req.url == "^/pong") {
		return(pipe);
	}
	# humans.txt never change
	elseif (req.url ~ "^/(robots|humans).txt") { 
		return(hash);
	}
	else {
		return(pass);
	}

	
  # the host ends here
  }
# the end of sub
}