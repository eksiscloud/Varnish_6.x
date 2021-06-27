sub geo-lang {
	### These are common to every virtual hosts
	
	## GeoIP-blocking and language normalizing

	# Geo-blocking
	if (req.http.X-Country-Code ~ "(bd|bg|cn|cr|ru|hk|id|my|pl|tw|ua)") {
		std.log("banned country: " + req.http.X-Country-Code);
		return(synth(403, "Forbidden country: " + std.toupper(req.http.X-Country-Code)));
	}
	
	## I'm normalizing language
	# For REAL normalizing you should work with Accept-Language only
	set req.http.x-language = std.tolower(req.http.Accept-Language);
	unset req.http.Accept-Language;
	if (req.http.x-language ~ "fi") {
		set req.http.x-language = "fi";
	} else {
		unset req.http.x-language;
	}

# The end of the sub
}