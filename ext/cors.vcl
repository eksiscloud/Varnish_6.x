sub cors {

	if (req.http.X-Saved-Origin == "") {
		set resp.http.Access-Control-Allow-Origin = "https://" + req.http.host;
	} else {
		set resp.http.Access-Control-Allow-Origin = req.http.X-Saved-Origin;
	}
	
	if (req.http.host ~ "www.katiska.info") {
		set resp.http.Access-Control-Allow-Origin = "*";
	}
	
	unset req.http.X-Saved-Origin;
	
	# Discourse. Not behind Varnish.
	#if (req.http.host == "kaffein.jagster.fi") {
	#	set resp.http.Access-Control-Allow-Credentials = "true";
	#	set resp.http.Access-Control-Allow-Headers = "Content-Type, Cache-Control, X-Requested-With, X-CSRF-Token, Discourse-Present, User-Api-Key, User-Api-Client-Id, Authorization";
	#	set resp.http.Access-Control-Allow-Methods = "POST, PUT, GET, OPTIONS, DELETE";
	#}

		# just examples...

		#set resp.http.Access-Control-Allow-Origin = "*"
		#set resp.http.Access-Control-Allow-Methods = "OPTIONS, GET";
		#set resp.http.Access-Control-Allow-Headers = "Authorization";

		#if (req.http.X-Saved-Origin == "https://www.example.com"
		#   || req.http.X-Saved-Origin == "http://www.example.com"
		#   || req.http.X-Saved-Origin == "http://www.friends.example") {
		#		set resp.http.Access-Control-Allow-Origin = req.http.X-Saved-Origin;
		#}


# The end
}