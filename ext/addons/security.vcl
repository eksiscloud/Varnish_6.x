sub sec_headers {

	### These should come from apps and/or server, but like WordPress doesn't set anything
	### For me this is easier solution because now I can handle everything in one place
	### Everything here works only if not piped. So, Discourse can't be secured here - there is no need, becauce Discourse sets these up by itself

	## Cross Site Scripting, aka. XSS
	if (resp.http.X-XSS-Protection =="") {
		set resp.http.X-XSS-Protection = "1; mode=block";
	}
	
	## Content Security Policy, aka. CSP
	# Use your browser to find out if (or when...) there is some CSP violations by the rules
	# or set up reporting endpoint
	# Yes, I know all rules should be per site, but there is too musch work. Maybe some day.
	
	# For some reason = "" doesn't work here, and same time ! doesn't work wth every other rules
	if (!resp.http.Content-Security-Policy) {
	
		# I'm using temporary rules to help reading/tuning/fixing
		set resp.http.x-www-google = "www.google.nl www.google.com.au www.google.es www.google.no www.google.se www.google.de www.google.fi www.google.com";
		set resp.http.x-adservice = "adservice.google.com adservice.google.pt adservice.google.com.au adservice.google.nl adservice.google.fi adservice.google.se adservice.google.no adservice.google.it adservice.google.es adservice.google.de";
		# -->
		set resp.http.x-default-src = "default-src stats.eksis.eu *.googlesyndication.com www.google-analytics.com data: 'unsafe-inline' 'unsafe-eval' 'self';";
		set resp.http.x-child-src = "child-src *.youtube.com *.doubleclick.net *.googlesyndication.com apis.google.com *.google.com store.katiska.info 'self'";
		set resp.http.x-script-src = "script-src 'unsafe-inline' 'unsafe-eval' 'self' data: stats.eksis.eu seuranta.eksis.pro platform.twitter.com bam.nr-data.net js-agent.newrelic.com js.klarna.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net *.github.com *.fontawesome.com *.facebook.net *.ampproject.org *.googletagmanager.com partner.googleadservices.com *.googlesyndication.com www.google-analytics.com ajax.googleapis.com www.googletagservices.com *.doubleclick.net" + " " + resp.http.x-adservice + " " + resp.http.x-www-google;
		set resp.http.x-connect-src = "connect-src endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com eu.klarnaevt.com attestation.android.com *.doubleclick.net *.google-analytics.com *.gstatic.com *.googlesyndication.com stats.eksis.eu seuranta.eksis.pro 'self'";
		set resp.http.x-frame-src = "frame-src wp.freemius.com wp-rocket.me js.klarna.com www.facebook.com *.twitter.com *.google.com *.googlesyndication.com *.doubleclick.net *.soundcloud.com *.youtube.com *.vimeo.com 'self'";
		set resp.http.x-img-src = "img-src pbs.twimg.com ps.w.org www.kennelrehu.fi/media/favicon/default/favicon.ico sporttimekka.fi/sm_favicon.ico www.yliopistonapteekki.fi s.w.org upload.wikimedia.org farm5.static.flickr.com farm3.static.flickr.com *.static.flickr.com dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com woopos.com.au cdn.klarna.com eu.klarnaevt.com s3-eu-west-1.amazonaws.com/krokedil-checkout-addons/images/kco/klarna-icon-thumbnail.jpg woocommerce.com woothemess3.s3.amazonaws.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com www.googletagmanager.com play-lh.googleusercontent.com pagead2.googlesyndication.com www.google-analytics.com meta-katiska.s3.dualstack.eu-north-1.amazonaws.com stats.eksis.eu data: 'unsafe-inline' 'self'" + " " + resp.http.x-www-google;
		set resp.http.x-media-src = "media-src fast.wistia.net s3-eu-west-1.amazonaws.com/e-matsku/ blob: data: 'self'";
		set resp.http.x-font-src = "font-src maxcdn.bootstrapcdn.com use.fontawesome.com fonts.gstatic.com data: 'self'";
		set resp.http.x-style-src = "style-src maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com *.googleapis.com *.fontawesome.com github.githubassets.com 'unsafe-inline' 'self'";
		set resp.http.x-form-action = "form-action 'self'";
		set resp.http.x-prefetch-src = "prefetch-src 'self'";
		set resp.http.x-manifest-src = "manifest-src 'self'";
		set resp.http.x-frame-ancestors = "frame-ancestors 'self'";  
		set resp.http.x-upgrade-mixed = "upgrade-insecure-requests; block-all-mixed-content"; 
		set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
	
		# I need hosts too - this would be easier if I wouldn't use FQDN in hosts... I will fix this, some day
		if (req.http.host == "(www|store|pro|selko).katiska.info") { set resp.http.x-csp-host = "*.katiska.info"; }
		if (req.http.host == "(www|store|pro).eksis.one") { set resp.http.x-csp-host = "store.eksis.one www.eksis.one cdn.eksis.one proto.eksis.one"; }
		if (req.http.host == "www.jagster.fi") { set resp.http.x-csp-host = "*.jagster.fi *.katiska.info"; }
		if (req.http.host == "www.ymparistosuunnittelija.com") { set resp.http.x-csp-host = "www.ymparistosuunnittelija.com"; }
		if (req.http.host == "www.koiranravitsemus.fi") { set resp.http.x-csp-host = "www.koiranravitsemus.fi"; }
	
		# Actual CSP
		# if you want no action, intel only: resp.http.Content-Security-Policy-Report-Only
		set resp.http.Content-Security-Policy = resp.http.x-default-src + " " + resp.http.x-child-src + " " + resp.http.x-csp-host + "; " + resp.http.x-script-src + " " + resp.http.x-csp-host + "; " + resp.http.x-connect-src + " " + resp.http.x-csp-host + "; " + resp.http.x-frame-src + " " + resp.http.x-csp-host + "; " + resp.http.x-img-src + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; " + resp.http.x-media-src + " " + resp.http.x-csp-host + "; " + resp.http.x-font-src + " " + resp.http.x-csp-host + "; " + resp.http.x-style-src + " " + resp.http.x-csp-host + "; " + resp.http.x-form-action + "; " + resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; " + resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; " + resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; " + resp.http.x-upgrade-mixed + "; " + resp.http.x-report;
	
		# Some hosts may not be here, even should
		if (!resp.http.x-csp-host) {
			unset resp.http.Content-Security-Policy;
		}
	
		# Remove temps
		unset resp.http.x-www-google;
		unset resp.http.x-default-src;
		unset resp.http.x-child-src;
		unset resp.http.x-adservice;
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
	# Cookies can be done, manipulated and changed using Varnish. But I can't.
	# Instead manipulation here these should be in wp-config.php of WordPress:
	# @ini_set('session.cookie_httponly', true); 
	# @ini_set('session.cookie_secure', true); 
	# @ini_set('session.use_only_cookies', true);
	
# the end of the sub
}