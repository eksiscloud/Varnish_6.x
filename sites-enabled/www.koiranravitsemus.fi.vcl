sub vcl_recv {
  if (req.http.host == "koiranravitsemus.fi" || req.http.host == "www.koiranravitsemus.fi") {
		set req.backend_hint = wiki;

	## just for this virtual host
	# for stop caching uncomment
	#return(pass);
	# for dumb TCL-proxy uncomment
	#return(pipe);
	
	# Normalize hostname to avoid double caching
	set req.http.host = regsub(req.http.host,
	"^koiranravitsemus\.fi$", "www.koiranravitsemus.fi");
	
	## General rules common to every backend by common.vcl
	call common_rules;
	
	## Stop knocking
	if (
		   req.url ~ "wp-login.php"
		|| req.url ~ "xmlrpc.php"
		) {
		if (
		   req.http.X-County-Code ~ "fi"
		|| req.http.x-language ~ "fi" 
		|| req.http.x-agent == "nice"
		) {
			return(synth(403, "Forbidden referer: " + req.http.X-Real-IP));
		} else {
			return(synth(666, "Forbidden referer: " + req.http.X-Real-IP));
		}
	}
	
	return(pass);
	
	##### Doesn't work, that's why pipe
	
	## MediaWiki doesn't let cache anything, because it loves to be dynamic for everybody. So, MediaWiki is setting vary:cookie and prgma: no-cache.
	## My wiki aren't that dynamic so I'll adjust those two later at backend_response.

	
	# Let's help MediaWiki cache by responsive skins
	unset req.http.x-wap; # Requester shouldn't be allowed to supply arbitrary X-WAP header
	if(req.http.User-Agent ~ "(?i)^(lg-|sie-|nec-|lge-|sgh-|pg-)|(mobi|240x240|240x320|320x320|alcatel|android|audiovox|bada|benq|blackberry|cdm-|compal-|docomo|ericsson|hiptop|htc[-_]|huawei|ipod|kddi-|kindle|meego|midp|mitsu|mmp\/|mot-|motor|ngm_|nintendo|opera.m|palm|panasonic|philips|phone|playstation|portalmmm|sagem-|samsung|sanyo|sec-|sendo|sharp|softbank|symbian|teleca|up.browser|webos)") {
		set req.http.x-wap = "no";
	}

	if (req.http.Authorization || req.http.Cookie ~ "mikromakro_" || req.http.Cookie ~ "Token") {
		return (pass);
	}
	
	if (req.url ~ "/index.php") {
		return(pass);
	}

	
  # The end of the host
  }
# And the real end - back to default.vcl
}