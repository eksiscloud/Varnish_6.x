## Discourse
sub vcl_recv {
  if (req.http.host == "kaffein.jagster.fi") {
	set req.backend_hint = kaffein;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	## Common to all hosts
	call common_rules;
	
	## These are quite static, except sitemap, but it is just matter of TTL
	if (req.url ~"/(robots.txt|humans.txt|sitemap)") {
		return(hash);
	}

	## The only things I can cache from Discourse.
	# Yes, I'm usin S3 as CDN, but loading from RAM is always faster than jumps to CDN edge.
	if (req.url ~ "(^/uploads/|^/assets/|^/user_avatar/)") {
      return (hash);
   }

	# And that's it. Nothing else. Must pipe or get error 500. And pipe means too that anything in vcl_backend_response amd vcl_delivet won't apply.
	return(pipe);
	
  # The of the host
  }
# The end of the sub
}