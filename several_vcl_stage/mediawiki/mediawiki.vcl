## MediaWiki

############### vcl_recv #################
#
sub vcl_recv {

  if (req.http.host == "koiranravitsemus.fi" || req.http.host == "www.koiranravitsemus.fi") {
		set req.backend_hint = wiki;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^koiranravitsemus\.fi$", "www.koiranravitsemus.fi");
	
	### MediaWiki is cacheable only for visitors who hasn't log in.
	
	## Cache only if random visitor without 30 d UserName cookie
	if (req.http.cookie ~ "(session|UserID|UserName|LoggedOut|Token)") {
		return (pass);
	} else {
		unset req.http.cookie;
	}
	
	## Cache all others requests if they reach this point.
	return(hash);
	
  }
# The end of the sub
}