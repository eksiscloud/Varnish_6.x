sub global-redirect {
#
## Normally we do 404/410 redirects per every vhost.conf, but sometimes it is easier to tune up globally for all vhosts
## 

	# redirect 301
	
	if (req.url ~ "^/sitemap.xml") {
		return(synth(720, "https://" + req.http.host + "/sitemap_index.xml"));
	}
	
	# I have some strange problems with Google and old Mailster links
	if (req.url ~ "^/mailster/form") {
		return(synth(720, "https://" + req.http.host + "/postilista/"));
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
		return(synth(810, "Error 410 Gone"));
	}

	# Katiska.info
	# Old wp-json leak'ish of users/authors. I'm using this only to stop nagging from Bing.
	if (req.http.host ~ "www.katiska.info" && req.url ~ "^/(kirjoittaja|author)") {
		if (req.url !~ "(adurodiel|atmini|Jagster|Katiska|MKarulinna|osmaja|sinituulia|Sivusto|Sumppu|tehtailija|tiia)") {
			return(synth(810, "Error 410 Gone"));
		}
	}

	
# end of sub
}