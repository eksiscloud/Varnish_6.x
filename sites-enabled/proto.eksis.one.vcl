## Discourse ##
sub vcl_recv {
  if (req.http.host == "proto.eksis.one") {
		set req.backend_hint = proto;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);


	## Only deal with "normal" types
	# This should do at Nginx?
	if (req.method != "GET" &&
	req.method != "HEAD" &&
	req.method != "PUT" &&
	req.method != "POST" &&
	req.method != "TRACE" &&
	req.method != "OPTIONS" &&
	req.method != "PATCH" &&
	req.method != "DELETE"
	) {
	# Non-RFC2616 or CONNECT which is weird.
	# Why send the packet upstream, while the visitor is using a non-valid HTTP method?
		return(synth(405, "Non-valid HTTP method!"));
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
		
		# Stop bots and knockers seeking holes using 403.vcl
		# I don't let search agents and similar to forbidden urls. Otherwise Fail2ban would ban theirs IPs too.
		# I get error for testing purposes, but Fail2ban has whitelisted my IP.
		if (req.http.User-Agent != "nice") {
			call stop_pages;
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
	elseif (req.url ~"/(robots.txt|humans.txt|sitemap)") {
		return(hash);
	}
#	elseif (req.url ~ "^[^?]*\.(7z|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gz|ico|js|otf|pdf|png|ppt|pptx|rtf|svg|swf|tar|tbz|tgz|ttf|txt|txz|webm|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$") {
#		unset req.http.cookie;
#		return(hash);
#	}
	else {
		# Must pipe, otherwise I just get error 500
		return(pipe);
	}
	
	# Cache all others requests if they reach this point
	return(hash);
  }
}
