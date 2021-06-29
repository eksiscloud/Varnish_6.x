sub global-redirect {
#
## Normally we do 404/410 redirects per every vhost.conf, but sometimes it is easier to tune up globally for all vhosts
## 
## This sub may vanish someday; it is too much overlapping with others


	## redirect 301
	
	# Old sitemap
	#if (req.url ~ "^/sitemap.(xml|xml.gz)") {
	#	return(synth(720, "https://" + req.http.host + "/sitemap_index.xml"));
	#}
	
	# I have some strange problems with Google and old Mailster links
	if (req.url ~ "^/mailster/form") {
		return(synth(720, "https://" + req.http.host + "/postilista/"));
	}
	
	# Old url of privacy statement
	if (req.url ~ "/privacy") {
		if (req.http.host ~ "www.katiska.info") {
			return(synth(720, "https://" + req.http.host + "/blogi/rekisteriseloste/"));
		} else {
			return(synth(720, "https://" + req.http.host + "/rekisteriseloste/"));
		}
	}
	
	
	## error 410
	
	if (
	   req.url ~ "^/app-ads.txt"
	|| req.url ~ "/architecture/"
	|| req.url ~ "/art/"
	|| req.url ~ "\?author=[1-9]"
	|| req.url ~ "/bitnami/"
	|| req.url ~ "^/pwa-amp-sw.js"
	|| req.url ~ "^/.well-known/assetlinks.json"
	) {
		return(synth(810, "Gone"));
	}


	## Useless image search; no threat at all but 404 errors are annoying
	if (req.url ~ "Mira-Bird") { return(synth(413, "Unauthorized use of resources")); }
	
	
	## A project by Google, mostly AMP based thing. I just don't want to see this in 404-list
	# 403.vcl would be more logic place but nice bots never visit there. And I might start using this, some day.
	if (req.url ~ "^/.well-known/traffic-advice") {
		return(synth(403, "Not in use"));
	}
# end of sub
}