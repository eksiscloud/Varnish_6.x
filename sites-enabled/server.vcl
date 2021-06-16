## Same as _default in Nginx; handling IP of the server ##
sub vcl_recv {
  if (req.http.host == "104.248.141.204" || req.http.host == "_") {
		set req.backend_hint = default;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);

	if (req.http.host == "_") {
		return(synth(666, "Access Denied from " + req.http.X-Real-IP));
	}

	if (req.url ~ "^/.well-known/acme-challenge/") {
		return(synth(403, "Access Denied from " + req.http.X-Real-IP));
	}

	# I can't ban finnish IPs
	if (req.http.X-Country-Code ~ "fi" || req.http.x-language ~ "fi") {
		return(synth(403, "Access Denied from " + req.http.X-Real-IP));
	} else {
	# other knockers I can ban
		return(synth(666, "Access Denied from " + req.http.X-Real-IP));
	}

  # end of the host
  }
# end of the sub
}