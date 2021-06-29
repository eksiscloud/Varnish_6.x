sub diagnose {
	## HIT & MISS
	if (obj.hits > 0) {
		# I don't fancy boring hit/miss announcements
		set resp.http.You-had-only-one-job = "Success";
	} else {
		set resp.http.You-had-only-one-job = "Phew";
	}

	## Show hit counts (per objecthead)
	# Same here, something like X-total-hits is just boring
	if (obj.hits > 0) {
		set resp.http.Footprint-of-CO2 = (obj.hits) + " metric-tons";
	} else {
		set resp.http.Footprint-of-CO2 = "Greenwash in progress";
	}
	
	## Using ETAG (content based) by backend is more accurate than Last-Modified (time based), 
	# but I want to get last-modified because I'm curious, even curiosity kills the cat
	set resp.http.Modified = resp.http.Last-Modified;
	unset resp.http.Last-Modified;
	
	## Just to be sure who is seeing what
	if (req.http.x-bot) {
		set resp.http.debug = req.http.x-bot;
	}
# Ends here
}