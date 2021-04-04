## Just for redirect
sub vcl_recv {
  if (req.http.host == "eksis.cloud" || req.http.host == "www.eksis.cloud") {

	# Your lifeline: Turn OFF cache
	# For caching keep this commented
	#return(pass);
	#return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^eksis\.cloud$", "www.eksis.cloud");

	return (synth(720, "https://www.eksis.one" + req.url));

	# Cache all others requests if they reach this point
	return (hash);


  }



}
