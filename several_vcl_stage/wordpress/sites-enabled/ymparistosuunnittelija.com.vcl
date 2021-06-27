## Wordpress

sub vcl_recv {

  if (req.http.host == "ymparistosuunnittelija.com" || req.http.host == "www.ymparistosuunnittelija.com") {
		set req.backend_hint = wordpress;

	# Your lifelines: 
	# Turn off cache
	# or make Varnish act like dumb proxy
	#return(pass);
	#return(pipe);


	## Normalize hostname to www. to avoid double caching
	# I like to keep triple-w
	set req.http.host = regsub(req.http.host,
	"^ymparistosuunnittelija\.com$", "www.ymparistosuunnittelija.com");
	
	## General rules common to every backend by common.vcl
	call common_rules;

	## Limit logins to finnish only
	if (req.url ~ "^/wp-login.php") {
		if (req.http.X-Country-Code !~ "fi" && req.http.x-language !~ "fi") {
			return(synth(666, "Forbidden action from " + req.http.X-Real-IP));
		}
	}

	## Wordpress REST API
	# For some reason this isn't working if in wordpress_common.vcl
	if (req.url ~ "/wp-json/wp/v2/") {
		# Whitelisted IP will pass, but only when logged in
		if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ whitelist) {
			return(pass);
		} else {
		# Must be logged in
			if (req.http.cookie !~ "wordpress_logged_in") {
				return(synth(403, "Unauthorized request"));
			}
		}
	}

	# Needed for Monit
	if (req.url ~ "/pong") {
		return (pipe);
	}

	# Check the Cookies for wordpress-comment items I reckon
	if (req.http.Cookie ~ "comment_") {
		return (pass);
	}
	
	# Keep this last. Rules from wordpress_common.vcl
	call wp_basics;
	
	# Cache all others requests if they reach this point
	return (hash);
  
  # The end of host
  }
# The end of sub-vcl
}