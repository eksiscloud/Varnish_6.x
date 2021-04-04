## Gitea ##
sub vcl_recv {
  if (req.http.host == "git.eksis.one") {
		set req.backend_hint = gitea;
  
	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	# Pass Let's Encrypt
	if (req.url ~ "^/\.well-known/acme-challenge/") {
		return (pass);
	}
	
	# user, admin and login pages
	if (req.url ~ "/(user|admin|login)") {
		return(pass);
	}
	
	# Don't cache logged-in user
	if (req.http.Cookie ~ "gitea_(awesome|incredible)") {
		return(pass);
	}

	# Post requests will not be cached; does Gitea need this?
	if (req.http.Authorization || req.method == "POST") {
		return(pass);
	}
	
	# Cache all others requests if they reach this point
	return (hash);


  }
}