sub vcl_recv {
  if (req.http.host == "koiranravitsemus.fi" || req.http.host == "www.koiranravitsemus.fi") {
		set req.backend_hint = default;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^koiranravitsemus\.fi$", "www.koiranravitsemus.fi");
	
	if (req.http.Authorization || req.http.Cookie ~ "session" || req.http.Cookie ~ "Token") {
		return (pass);
	}
	
  }
}