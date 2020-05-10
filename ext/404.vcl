sub global-redirect {
#
## Normally we do 404/410 redirects per every vhost.conf, but sometimes it is easier to tune up globally for all vhosts
## 

	# redirect 301
	
	if (req.url ~ "^/sitemap.xml") {
		return(synth(720, "https://" + req.http.host + "/sitemap_index.xml"));
	}
	
	# error 410
	if (
	   req.url ~ "^/app-ads.txt"
	|| req.url ~ "\?author=[1-9]"
	|| req.url ~ "^/.well-known/assetlinks.json"
	) {
		return(synth(410, "Error 410 Gone"));
	}

	# more or less just an example; if not depending of UA this should do at vhost, but it is easier this way. Maybe.
	If (req.http.User-Agent ~ "Googlebot" && req.http.url ~ "^/mailster/form?id=3") {
		if (req.http.url ~ "cdn.katiska.info" || req.http.url ~ "%3Famp" || req.http.Referer ~ "katiska.info") {
			return(synth(410, "Gone"));
		}
	}

}