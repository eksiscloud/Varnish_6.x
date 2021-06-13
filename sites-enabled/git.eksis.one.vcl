## Gitea ##
sub vcl_recv {
  if (req.http.host == "git.eksis.one") {
		set req.backend_hint = gitea;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	### Gitea is quite impossible to cache with Varnish. To keep return(pass) is the best option.

	call common_rules;
	
	# Stop knocking
	if (
		   req.url ~ "wp-login.php"
		|| req.url ~ "xmlrpc.php"
		) {
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

	# Only directory-likes and standard pages can be cached
	if (
	req.url !~ "/explore/"
	&& req.url !~ "/licenses.txt"
	&& req.url !~ "/tietosuojaseloste"
	&& req.url !~ "/humans.txt"
	&& req.url !~ "/avatar"
	# this is bad idea, but my repos are quite static...
	&& req.url !~ "/src/"
	) {
		return(pass);
	} elseif (req.url == "/explore/repos") {
		return(pass);
	}
	
	# Cache all others requests if they reach this point
	return (hash);


  }
}