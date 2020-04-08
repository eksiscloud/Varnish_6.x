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
	|| req.url ~ "/?author=([1-9]|[1-9][1-9])"
	|| req.url ~ "^/.well-known/assetlinks.json"
	) {
		return(synth(410, "Error 410 Gone"));
	}

}
