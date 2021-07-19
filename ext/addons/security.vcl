sub sec_headers {

	### These should come from apps and/or server, but like WordPress doesn't set anything
	### Everything here works only if not piped. So, Discourse can't be secured here

	## Cross Site Scripting, aka. XSS
	if (resp.http.X-XSS-Protection =="") {
		set resp.http.X-XSS-Protection = "1; mode=block";
	}
	
	## Content Security Policy, aka. CSP
	# Use your browser to find out if (or when...) there is some CSP violations by the rules
	# or set up reporting endpoint
	
	if (!resp.http.Content-Security-Policy) {
	
		# I'm using temporary rules to help reading/tuning/fixing
		set resp.http.x-default-src = "default-src stats.eksis.eu *.googlesyndication.com www.google-analytics.com data: 'unsafe-inline' 'unsafe-eval' 'self';";
		set resp.http.x-child-src = "child-src *.youtube.com *.doubleclick.net *.googlesyndication.com *.google.com 'self'";
		set resp.http.x-script-src = "script-src 'unsafe-inline' 'unsafe-eval' 'self' data: stats.eksis.eu *.github.com *.fontawesome.com *.facebook.net *.ampproject.org *.googletagmanager.com partner.googleadservices.com *.googlesyndication.com adservice.google.fi adservice.google.se adservice.google.no adservice.google.it adservice.google.es adservice.google.com www.google-analytics.com ajax.googleapis.com www.googletagservices.com *.google.fi *.google.com *.doubleclick.net";
		set resp.http.x-connect-src = "connect-src attestation.android.com *.doubleclick.net *.google-analytics.com *.gstatic.com *.googlesyndication.com stats.eksis.eu 'self'";
		set resp.http.x-frame-src = "frame-src *.google.com *.googlesyndication.com *.doubleclick.net *.soundcloud.com *.youtube.com *.vimeo.com 'self'";
		set resp.http.x-img-src = "img-src * data: 'self'";
		set resp.http.x-media-src = "media-src * data: 'self'";
		set resp.http.x-font-src = "font-src * data: 'self'";
		set resp.http.x-style-src = "style-src *.googleapis.com *.fontawesome.com github.githubassets.com 'unsafe-inline' 'self'";
		set resp.http.x-form-action = "form-action 'self'";
		set resp.http.x-prefetch-src = "prefetch-src 'self'";
		set resp.http.x-manifest-src = "manifest-src 'self'";
		set resp.http.x-frame-ancestors = "frame-ancestors 'self'";  
		set resp.http.x-upgrade-mixed = "upgrade-insecure-requests; block-all-mixed-content"; 
		set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
	
		# I need hosts too - this would be easier if I wouldn't use FQDN in hosts... I will fix this, some day
		if (req.http.host == "www.katiska.info") { set resp.http.x-csp-host = "*.katiska.info"; }
		if (req.http.host == "store.katiska.info") { set resp.http.x-csp-host = "*.katiska.info"; }
		if (req.http.host == "pro.katiska.info") { set resp.http.x-csp-host = "*.katiska.info"; }
		if (req.http.host == "www.eksis.one") { set resp.http.x-csp-host = "*.eksis.one"; }
		if (req.http.host == "store.eksis.one") { set resp.http.x-csp-host = "*.eksis.one"; }
		if (req.http.host == "pro.eksis.one") { set resp.http.x-csp-host = "*.eksis.one"; }
		if (req.http.host == "www.jagster.fi") { set resp.http.x-csp-host = "*.jagster.fi"; }
		if (req.http.host == "www.ymparistosuunnittelija.com") { set resp.http.x-csp-host = "*.ymparistosuunnittelija.com"; }
		if (req.http.host == "www.koiranravitsemus.fi") { set resp.http.x-csp-host = "*.koiranravitsemus.fi"; }
	
		# Actual CSP
		if (req.url !~ "wp-admin") {
			set resp.http.Content-Security-Policy-Report-Only = resp.http.x-default-src + " " + resp.http.x-child-src + " " + resp.http.x-csp-host + "; " + resp.http.x-script-src + " " + resp.http.x-csp-host + "; " + resp.http.x-connect-src + " " + resp.http.x-csp-host + "; " + resp.http.x-frame-src + " " + resp.http.x-csp-host + "; " + resp.http.x-img-src  + "; " + resp.http.x-media-src + "; " + resp.http.x-font-src + "; " + resp.http.x-style-src + "; " + resp.http.x-form-action + resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; " + resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; " + resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; " + resp.http.x-upgrade-mixed + "; " + resp.http.x-report;
		} else {
			unset resp.http.Content-Security-Policy;
		}
	
		# Remove temps
		unset resp.http.x-default-src;
		unset resp.http.x-child-src;
		unset resp.http.x-script-src;
		unset resp.http.x-connect-src;
		unset resp.http.x-frame-src;
		unset resp.http.x-img-src;
		unset resp.http.x-media-src;
		unset resp.http.x-font-src;
		unset resp.http.x-style-src;
		unset resp.http.x-form-action;
		unset resp.http.x-prefetch-src;
		unset resp.http.x-manifest-src;
		unset resp.http.x-frame-ancestors;
		unset resp.http.x-upgrade-mixed;
		unset resp.http.x-report;
		unset resp.http.x-csp-host;
	
	}

#	if (req.http.host !~ "www.(katiska\.info|eksis\.one)" || req.url ~ "wp-admin") {
#		unset resp.http.Content-Security-Policy;
#	} else {
#		set resp.http.Content-Security-Policy-Report-Only = "default-src 'unsafe-inline' 'unsafe-eval' data: stats.eksis.eu *.googlesyndication.com www.google-analytics.com *.doubleclick.net 'self'; child-src *.youtube.com *.doubleclick.net *.googlesyndication.com *.google.com *.katiska.info 'self'; form-action 'self'; img-src * data:; media-src *; font-src * data:; script-src 'unsafe-inline' 'unsafe-eval' 'self' data: stats.eksis.eu *.facebook.net *.ampproject.org partner.googleadservices.com *.googlesyndication.com www.google-analytics.com ajax.googleapis.com www.googletagservices.com *.google.fi *.google.com *.doubleclick.net; frame-ancestors *.katiska.info 'unsafe-inline' 'self'; connect-src attestation.android.com *.doubleclick.net *.google-analytics.com *.gstatic.com *.googlesyndication.com stats.eksis.eu *.katiska.info 'self'; upgrade-insecure-requests; block-all-mixed-content; report-uri https://www.katiska.info/_csp;";
#	}
	
	
	## HTTP Strict Transport Security, aka. HSTS
	if (resp.http.Strict-Transport-Security == "") {
		set resp.http.Strict-Transport-Security = "max-age=31536000; includeSubdomains; ";
	}

	## MIME sniffing
	if (resp.http.X-Content-Type-Options == "") {
		set resp.http.X-Content-Type-Options = "nosniff";
	}
	
	## Referrer-Policy
	#if (resp.http.Referrer-Policy == "") {
		set resp.http.Referrer-Policy = "same-origin";
	#}
	
	## Cookies
	# Cookies can be done and changed using Varnish. But I can't.
	# Instead manipulation here these should be in wp-config.php of WordPress:
	# @ini_set('session.cookie_httponly', true); 
	# @ini_set('session.cookie_secure', true); 
	# @ini_set('session.use_only_cookies', true);
	
# the end of the sub
}