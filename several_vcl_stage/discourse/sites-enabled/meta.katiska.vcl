## Discourse
sub vcl_recv {
  if (req.http.host == "meta.katiska.info") {
	set req.backend_hint = meta;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);
	
	## Common rules
	call common_rules;

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