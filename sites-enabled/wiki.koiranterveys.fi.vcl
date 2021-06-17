### Old starting point, not in use

sub vcl_recv {
  if (req.http.host == "wiki.koiranterveys.fi") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
  }
}