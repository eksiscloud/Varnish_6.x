sub sec_headers {

	### These should come from apps and/or server, but like WordPress doesn't set anything
	### For me this is easier solution because now I can handle everything in one place
	### Everything here works only if not piped. So, Discourse can't be secured here - there is no need, becauce Discourse sets these up by itself

	## Cross Site Scripting, aka. XSS
	if (!resp.http.X-XSS-Protection) {
		set resp.http.X-XSS-Protection = "1; mode=block";
	}
	
	## Content Security Policy, aka. CSP
	# Use your browser to find out if (or when...) there is some CSP violations by the rules
	# or set up reporting endpoint
	# Yes, I know all rules should be per site, but there is too musch work. Maybe some day.
	
	# Applies only if a backend doesn't set CSP; if CSP or another headers come from frontend, like proxy as Nginx, Varnish doesn't see it
	if (!resp.http.Content-Security-Policy) {
		
		
/* -- First version: same rules to every hosts --
		
		
		## I'm using temporary rules to help reading/tuning/fixing
		
		# I need hosts too - this would be easier if I wouldn't use FQDN earlier in hosts... I will fix this, some day
		# Wildcards don't work everytime, for example Avast browser doesn't accept *.domain.tld or 'self' as should.
		# I don't have any WooCommerce here because all /embed/ urls will be blocked for some reason. Quite often such error comes from mobile-Safari.
		if (req.http.host ~ "(www|pro|selko).katiska.info") { set resp.http.x-csp-host = "www.katiska.info cdn.katiska.info pro.katiska.info selko.katiska.info meta.katiska.info cdnmeta.katiska.info store.katiska.info cdnstore.katiska.info"; }
		if (req.http.host ~ "(www|pro).eksis.one") { set resp.http.x-csp-host = "www.eksis.one cdn.eksis.one pro.eksis.one proto.eksis.one"; }
		if (req.http.host ~ "www.jagster.fi") { set resp.http.x-csp-host = "www.jagster.fi kaffein.jagster.fi *.katiska.info"; }
		if (req.http.host ~ "www.ymparistosuunnittelija.com") { set resp.http.x-csp-host = "www.ymparistosuunnittelija.com"; }
		if (req.http.host ~ "www.koiranravitsemus.fi") { set resp.http.x-csp-host = "www.koiranravitsemus.fi"; }
		
		# Google is using solution that rapes CSP big time. I could ban almost everything from www.google.* and adservice.google.* because my sites are pure finnish
		set resp.http.x-www-google = "www.google.ch www.google.ee www.google.at www.google.gr www.google.com.cy www.google.ee www.google.ca www.google.it www.google.hr www.google.lv www.google.co.uk www.google.nl www.google.com.au www.google.es www.google.no www.google.se www.google.de www.google.fi www.google.com";
		set resp.http.x-adservice = "adservice.google.ch adservice.google.ee adservice.google.at adservice.google.gr adservice.google.com.cy adservice.google.ee adservice.google.ca adservice.google.it adservice.google.hr adservice.google.lv adservice.google.co.uk adservice.google.com adservice.google.pt adservice.google.com.au adservice.google.nl adservice.google.fi adservice.google.se adservice.google.no adservice.google.it adservice.google.es adservice.google.de";
		
		# and now the actual rules -->
		set resp.http.x-default-src = "default-src stats.eksis.eu *.googlesyndication.com www.google-analytics.com data: 'unsafe-inline' 'unsafe-eval' 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-child-src = "child-src *.youtube.com *.doubleclick.net *.googlesyndication.com apis.google.com *.google.com 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-script-src = "script-src 'unsafe-inline' 'unsafe-eval' 'self' data: stats.eksis.eu seuranta.eksis.pro cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com js.klarna.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net *.github.com *.fontawesome.com *.facebook.net *.ampproject.org www.gstatic.com *.googletagmanager.com partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com www.google-analytics.com apis.google.com ajax.googleapis.com www.googletagservices.com *.doubleclick.net" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-connect-src = "connect-src endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com eu.klarnaevt.com attestation.android.com stats.g.doubleclick.net *.google-analytics.com *.gstatic.com pagead2.googlesyndication.com stats.eksis.eu seuranta.eksis.pro 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-frame-src = "frame-src wp.freemius.com wp-rocket.me js.klarna.com web.facebook.com www.facebook.com *.twitter.com *.google.com *.googlesyndication.com *.doubleclick.net *.soundcloud.com *.youtube.com *.vimeo.com data: 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-img-src = "img-src www.hs.fi pbs.twimg.com ps.w.org www.kennelrehu.fi/media/favicon/default/favicon.ico sporttimekka.fi/sm_favicon.ico www.yliopistonapteekki.fi s.w.org upload.wikimedia.org *.static.flickr.com dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com woopos.com.au cdn.klarna.com eu.klarnaevt.com s3-eu-west-1.amazonaws.com/krokedil-checkout-addons/images/kco/klarna-icon-thumbnail.jpg woocommerce.com woothemess3.s3.amazonaws.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com translate.google.com www.gstatic.com www.googletagmanager.com play-lh.googleusercontent.com pagead2.googlesyndication.com www.google-analytics.com meta-katiska.s3.dualstack.eu-north-1.amazonaws.com stats.eksis.eu data: 'self'" + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-media-src = "media-src fast.wistia.net e-matsku.s3-eu-west-1.amazonaws.com s3-eu-west-1.amazonaws.com/e-matsku/ blob: data: 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-font-src = "font-src static3.avast.com/1000947/web/o/f/ maxcdn.bootstrapcdn.com l.facebook.com use.fontawesome.com fonts.gstatic.com data: 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-style-src = "style-src maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com *.googleapis.com *.fontawesome.com github.githubassets.com 'unsafe-inline' 'self'" + " " + resp.http.x-csp-host + "; ";
		set resp.http.x-form-action = "form-action 'self'" + "; ";
		set resp.http.x-prefetch-src = "prefetch-src palvelut2.evira.fi www.koiranravitsemus.fi 'self' " + resp.http.x-csp-host + "; ";
		set resp.http.x-manifest-src = "manifest-src 'self' " + resp.http.x-csp-host + "; ";
		set resp.http.x-frame-ancestors = "frame-ancestors 'self' " + resp.http.x-csp-host + "; ";  
		set resp.http.x-upgrade-mixed = "upgrade-insecure-requests; block-all-mixed-content; "; 
		set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		
		# CSP parsing
		# if you want no action, intel only: resp.http.Content-Security-Policy-Report-Only
		set resp.http.Content-Security-Policy = resp.http.x-default-src + " " + resp.http.x-child-src + " " + resp.http.x-script-src + " " + resp.http.x-connect-src + " " + resp.http.x-frame-src + " " + resp.http.x-img-src + " " + resp.http.x-media-src + " " + resp.http.x-font-src + " " + resp.http.x-style-src + " " + resp.http.x-form-action + " " + resp.http.x-prefetch-src + " " + resp.http.x-manifest-src + " " + resp.http.x-frame-ancestors + " " + resp.http.x-upgrade-mixed + " " + resp.http.x-report;
	
		
-- the end of first version -- */
		
		
		## I'm using temporary rules to help reading/tuning/fixing
		
		# Google is using solution that rapes CSP big time. I could ban almost everything from www.google.* and adservice.google.* because my sites are pure finnish
		set resp.http.x-www-google = "www.google.hu www.google.fr www.google.at www.google.gr www.google.com.cy www.google.ee www.google.ca www.google.it www.google.hr www.google.lv www.google.co.uk www.google.nl www.google.com.au www.google.es www.google.no www.google.se www.google.de www.google.fi www.google.com";
		set resp.http.x-adservice = "adservice.google.hu adservice.google.fr adservice.google.at adservice.google.gr adservice.google.com.cy adservice.google.ee adservice.google.ca adservice.google.it adservice.google.hr adservice.google.lv adservice.google.co.uk adservice.google.com adservice.google.pt adservice.google.com.au adservice.google.nl adservice.google.fi adservice.google.se adservice.google.no adservice.google.it adservice.google.es adservice.google.de";
		
		# Common parts
		set resp.http.x-child-src = "child-src apis.google.com 'self'";
		set resp.http.x-script-src = "script-src 'unsafe-eval' 'unsafe-inline' 'self' data: connect.facebook.net use.fontawesome.com stats.eksis.eu seuranta.eksis.pro www.googletagservices.com www.googletagmanager.com www.gstatic.com www.google-analytics.com";		# If you are using WordPress and/or any services from Google avoiding 'unsafe-inline' is nearly impossible
		set resp.http.x-connect-src = "connect-src attestation.android.com csi.gstatic.com www.gstatic.com www.google-analytics.com stats.eksis.eu seuranta.eksis.pro 'self'";
		set resp.http.x-frame-src = "frame-src web.facebook.com www.facebook.com www.youtube.com www.google.com 'self'";
		set resp.http.x-img-src = "img-src secure.gravatar.com www.gstatic.com www.googletagmanager.com www.google-analytics.com stats.eksis.eu data: 'self'";
		set resp.http.x-media-src = "media-src 'self'";
		set resp.http.x-font-src = "font-src static3.avast.com/1000947/web/o/f/ use.fontawesome.com fonts.gstatic.com data: 'self'";
		set resp.http.x-style-src = "style-src use.fontawesome.com cdnjs.cloudflare.com connect.facebook.net 'unsafe-inline' 'self'";
		set resp.http.x-form-action = "form-action 'self'";
		set resp.http.x-prefetch-src = "prefetch-src 'self'";
		set resp.http.x-manifest-src = "manifest-src 'self'";
		set resp.http.x-frame-ancestors = "frame-ancestors 'self'";
		set resp.http.x-sandbox = "allow-same-origin allow-scripts" + "; ";
		set resp.http.x-upgrade-mixed = "upgrade-insecure-requests; block-all-mixed-content;";
		set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		
		
		# Host based parts
		
		# WordPress
		if (req.http.host ~ "www.katiska.info") {
			set resp.http.x-csp-host = "www.katiska.info cdn.katiska.info meta.katiska.info cdnmeta.katiska.info store.katiska.info cdnstore.katiska.info selko.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + "*.youtube.com stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net cdn.ampproject.org stats.g.doubleclick.net partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com apis.google.com ajax.googleapis.com" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com attestation.android.com stats.g.doubleclick.net pagead2.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org wp.freemius.com wp-rocket.me pagead2.googlesyndication.com googleads.g.doubleclick.net stats.g.doubleclick.net tpc.googlesyndication.com data:" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "www.hs.fi pbs.twimg.com ps.w.org www.kennelrehu.fi/media/favicon/default/favicon.ico sporttimekka.fi/sm_favicon.ico www.yliopistonapteekki.fi s.w.org upload.wikimedia.org *.static.flickr.com dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com translate.google.com play-lh.googleusercontent.com pagead2.googlesyndication.com meta-katiska.s3.dualstack.eu-north-1.amazonaws.com data: " + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + "fast.wistia.net e-matsku.s3-eu-west-1.amazonaws.com s3-eu-west-1.amazonaws.com/e-matsku/ blob: data:" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + "maxcdn.bootstrapcdn.com l.facebook.com " + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com fonts.googleapis.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + "palvelut2.evira.fi www.koiranravitsemus.fi" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WooCommerce
		elseif (req.http.host ~ "store.katiska.info") {
			set resp.http.x-csp-host = "store.katiska.info cdnstore.katiska.info www.katiska.info cdn.katiska.info meta.katiska.info cdnmeta.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "js.klarna.com cdn.mxpnl.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "api-js.mixpanel.com eu.klarnaevt.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org js.klarna.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "'unsafe-inline' i.ytimg.com ps.w.org woopos.com.au cdn.klarna.com eu.klarnaevt.com s3-eu-west-1.amazonaws.com/krokedil-checkout-addons/images/kco/klarna-icon-thumbnail.jpg woocommerce.com woothemess3.s3.amazonaws.com deliciousbrains.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# Moodle
		elseif (req.http.host ~ "pro.katiska.info") {
			set resp.http.x-csp-host = "pro.katiska.info store.katiska.info cdnstore.katiska.info www.katiska.info cdn.katiska.info meta.katiska.info cdnmeta.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WordPress
		if (req.http.host ~ "selko.katiska.info") {
			set resp.http.x-csp-host = "selko.katiska.info www.katiska.info cdn.katiska.info meta.katiska.info cdnmeta.katiska.info store.katiska.info cdnstore.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + "*.youtube.com stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net cdn.ampproject.org stats.g.doubleclick.net partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com apis.google.com ajax.googleapis.com" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com attestation.android.com stats.g.doubleclick.net pagead2.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org wp.freemius.com wp-rocket.me pagead2.googlesyndication.com googleads.g.doubleclick.net stats.g.doubleclick.net tpc.googlesyndication.com data:" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "www.hs.fi pbs.twimg.com ps.w.org www.kennelrehu.fi/media/favicon/default/favicon.ico sporttimekka.fi/sm_favicon.ico www.yliopistonapteekki.fi s.w.org upload.wikimedia.org *.static.flickr.com dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com translate.google.com play-lh.googleusercontent.com pagead2.googlesyndication.com meta-katiska.s3.dualstack.eu-north-1.amazonaws.com data:" + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + "fast.wistia.net e-matsku.s3-eu-west-1.amazonaws.com s3-eu-west-1.amazonaws.com/e-matsku/ blob: data:" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + "maxcdn.bootstrapcdn.com l.facebook.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + "palvelut2.evira.fi www.koiranravitsemus.fi" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WordPress
		elseif (req.http.host ~ "www.eksis.one") {
			set resp.http.x-csp-host = "www.eksis.one cdn.eksis.one pro.eksis.one proto.eksis.one";
			set resp.http.x-child-src = resp.http.x-child-src + " " + "*.youtube.com stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "gist.github.com cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net cdn.ampproject.org stats.g.doubleclick.net partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com apis.google.com ajax.googleapis.com" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com attestation.android.com stats.g.doubleclick.net pagead2.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org wp.freemius.com wp-rocket.me pagead2.googlesyndication.com googleads.g.doubleclick.net stats.g.doubleclick.net tpc.googlesyndication.com data:" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "pbs.twimg.com ps.w.org dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com translate.google.com play-lh.googleusercontent.com pagead2.googlesyndication.com" + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + "fast.wistia.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + "maxcdn.bootstrapcdn.com l.facebook.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "github.githubassets.com maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WooCommerce
		elseif (req.http.host ~ "store.eksis.one") {
			set resp.http.x-csp-host = "store.eksis.one cdnstore.eksis.one www.eksis.one cdn.eksis.one pro.eksis.one proto.eksis.one";
			set resp.http.x-child-src = resp.http.x-child-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "js.klarna.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "eu.klarnaevt.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org js.klarna.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "woopos.com.au cdn.klarna.com eu.klarnaevt.com s3-eu-west-1.amazonaws.com/krokedil-checkout-addons/images/kco/klarna-icon-thumbnail.jpg woocommerce.com woothemess3.s3.amazonaws.com deliciousbrains.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# Moodle
		elseif (req.http.host ~ "pro.eksis.one") {
			set resp.http.x-csp-host = "store.eksis.one cdnstore.eksis.one www.eksis.one cdn.eksis.one pro.eksis.one proto.eksis.one";
			set resp.http.x-child-src = resp.http.x-child-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WordPress
		if (req.http.host ~ "www.jagster.fi") {
			set resp.http.x-csp-host = "www.jagster.fi kaffein.jagster.fi www.katiska.info cdn.katiska.info meta.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + "stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net stats.g.doubleclick.net cdn.ampproject.org partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com apis.google.com ajax.googleapis.com 'unsafe-eval'" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com attestation.android.com stats.g.doubleclick.net pagead2.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org wp.freemius.com wp-rocket.me pagead2.googlesyndication.com googleads.g.doubleclick.net stats.g.doubleclick.net tpc.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "f001.backblazeb2.com/file/ f001.backblaze.com/file/nextgen-gallery/ pbs.twimg.com ps.w.org s.w.org dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com play-lh.googleusercontent.com pagead2.googlesyndication.com blob:" + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + "fast.wistia.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + "maxcdn.bootstrapcdn.com l.facebook.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# MediaWiki
		if (req.http.host ~ "www.koiranravitsemus.fi") {
			set resp.http.x-csp-host = "www.koiranravitsemus.fi www.katiska.info cdn.katiska.info";
			set resp.http.x-child-src = resp.http.x-child-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "upload.wikimedia.org" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# WordPress
		if (req.http.host ~ "www.ymparistosuunnittelija.com") {
			set resp.http.x-csp-host = "www.ymparistosuunnittelija.com";
			set resp.http.x-child-src = resp.http.x-child-src + " " + "stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-script-src = resp.http.x-script-src + " " + "cdn.jsdelivr.net platform.twitter.com bam.nr-data.net js-agent.newrelic.com cdnjs.cloudflare.com cdn.mxpnl.com fast.wistia.com beacon-v2.helpscout.net stats.g.doubleclick.net partner.googleadservices.com tpc.googlesyndication.com pagead2.googlesyndication.com apis.google.com ajax.googleapis.com" + " " + resp.http.x-adservice + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-connect-src = resp.http.x-connect-src + " " + "endpoint1.collection.us2.sumologic.com bam.nr-data.net fg8vvsvnieiv3ej16jby.litix.io api-js.mixpanel.com d3hb14vkzrxvla.cloudfront.net distillery.wistia.com pipedream.wistia.com beaconapi.helpscout.net beacon-v2.helpscout.net fast.wistia.com attestation.android.com stats.g.doubleclick.net pagead2.googlesyndication.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-src = resp.http.x-frame-src + " " + "fi.wordpress.org wp.freemius.com wp-rocket.me pagead2.googlesyndication.com stats.g.doubleclick.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-img-src = resp.http.x-img-src + " " + "pbs.twimg.com ps.w.org s.w.org dashboard.freemius.com img.freemius.com s0.wp.com www.facebook.com secure.gravatar.com deliciousbrains.com fast.wistia.com embed-fastly.wistia.com wp-rocket.me embedwistia-a.akamaihd.net i.ytimg.com syndication.twitter.com platform.twitter.com play-lh.googleusercontent.com pagead2.googlesyndication.com" + " " + resp.http.x-www-google + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-media-src = resp.http.x-media-src + " " + "fast.wistia.net" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-font-src = resp.http.x-font-src + " " + "maxcdn.bootstrapcdn.com l.facebook.com" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-style-src = resp.http.x-style-src + " " + "maxcdn.bootstrapcdn.com code.jquery.com deliciousbrains.com fonts.googleapis.com 'unsafe-inline'" + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-form-action = resp.http.x-form-action + "; ";
			set resp.http.x-prefetch-src = resp.http.x-prefetch-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-manifest-src = resp.http.x-manifest-src + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-frame-ancestors = resp.http.x-frame-ancestors + " " + resp.http.x-csp-host + "; ";
			set resp.http.x-upgrade-mixed = resp.http.x-upgrade-mixed + " ";
			set resp.http.x-report = "report-uri https://" + req.http.host + "/_csp;";
		}
		
		# Common fallback to everything
		set resp.http.x-default-src = "default-src stats.eksis.eu 'self'" + " " + resp.http.x-csp-host + "; ";
		
		# CSP parsing
		# if you want no action, intel only: resp.http.Content-Security-Policy-Report-Only
		set resp.http.Content-Security-Policy = resp.http.x-default-src + resp.http.x-child-src + resp.http.x-script-src + resp.http.x-connect-src + resp.http.x-frame-src + resp.http.x-img-src + resp.http.x-media-src + resp.http.x-font-src + resp.http.x-style-src + resp.http.x-form-action + resp.http.x-prefetch-src + resp.http.x-manifest-src + resp.http.x-frame-ancestors + resp.http.x-sandbox + resp.http.x-upgrade-mixed + resp.http.x-report;
		
		# Some hosts may not be here, even should
		if (resp.http.x-csp-host == "") {
			unset resp.http.Content-Security-Policy;
		}
		
		# I have too many issues with Safari so I don't use acting CSP with WooCommerce - The issues are mostly with embeds
		# Heads up: Safari caches even CSP.
		if (req.http.User-Agent ~ "Safari" && req.http.host ~ "store.") {
			set resp.http.Content-Security-Policy-Report-Only = resp.http.Content-Security-Policy;
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
	
	# The of CSP
	}
	
	## HTTP Strict Transport Security, aka. HSTS
	# Applies only if a backend doesn't set HSTS as it normally doesn't; if it comes from frontend, like proxy as Nginx, Varnish doesn't see it
	if (!resp.http.Strict-Transport-Security) {
		set resp.http.Strict-Transport-Security = "max-age=31536000; includeSubdomains; ";
	}

	## MIME sniffing
	# Applies only if a backend doesn't set sniffing as it normally doesn't; if it comes from frontend, like proxy as Nginx, Varnish doesn't see it
	if (!resp.http.X-Content-Type-Options) {
		set resp.http.X-Content-Type-Options = "nosniff";
	}
	
	## Referrer-Policy
	if (!resp.http.Referrer-Policy) {
		set resp.http.Referrer-Policy = "strict-origin-when-cross-origin";
		#set resp.http.Referrer-Policy = "unsafe-url";
	}
	
	## Cleaning unnecessary headers
	if (resp.http.obj ~ "\.(appcache|atom|bbaw|bmp|crx|css|cur|eot|f4[abpv]|flv|geojson|gif|htc|ic[os]|jpe?g|m?js|json(ld)?|m4[av]|manifest|map|markdown|md|mp4|oex|og[agv]|opus|otf|pdf|png|rdf|rss|safariextz|svgz?|swf|topojson|tt[cf]|txt|vcard|vcf|vtt|webapp|web[mp]|webmanifest|woff2?|xloc|xpi)$") {
		unset resp.http.X-UA-Compatible;
		unset resp.http.X-XSS-Protection;
	}
	
	if (resp.http.obj ~ "\.(appcache|atom|bbaw|bmp|crx|css|cur|eot|f4[abpv]|flv|geojson|gif|htc|ic[os]|jpe?g|json(ld)?|m4[av]|manifest|map|markdown|md|mp4|oex|og[agv]|opus|otf|png|rdf|rss|safariextz|swf|topojson|tt[cf]|txt|vcard|vcf|vtt|webapp|web[mp]|webmanifest|woff2?|xloc|xpi)$") {
		unset resp.http.Content-Security-Policy;
	}
	
	## Cookies
	# Cookies can be done, manipulated and changed using Varnish. But I can't.
	# Instead manipulation here these should be in wp-config.php of WordPress:
	# @ini_set('session.cookie_httponly', true); 
	# @ini_set('session.cookie_secure', true); 
	# @ini_set('session.use_only_cookies', true);
	
# the end of the sub
}