sub cors {

	if (req.http.X-Saved-Origin == "") {
		set resp.http.Access-Control-Allow-Origin = "https://" + req.http.host;
	} else {
		set resp.http.Access-Control-Allow-Origin = req.http.X-Saved-Origin;
	}
	
	unset req.http.X-Saved-Origin;
	
	

	
	#if (req.http.host ~ "www.katiska.info") {
	#	set resp.http.Access-Control-Allow-Origin = "*";
	#}
	
	
	
	# Discourse. Nothing here works either.
#	if (req.http.host == "kaffein.jagster.fi") {
#		set resp.http.Access-Control-Allow-Origin = "*";
#		set resp.http.Access-Control-Allow-Credentials = "true";
#		set resp.http.Access-Control-Allow-Headers = "Content-Type, Cache-Control, X-Requested-With, X-CSRF-Token, Discourse-Present, User-Api-Key, User-Api-Client-Id, Authorization";
#		set resp.http.Access-Control-Allow-Methods = "POST, PUT, GET, OPTIONS, DELETE";
#		
#		set resp.http.content-security-policy = "base-uri 'none'; object-src 'none'; script-src https://kaffein.jagster.fi/logs/ https://kaffein.jagster.fi/sidekiq/ https://kaffein.jagster.fi/mini-profiler-resources/ https://kaffein.jagster.fi/assets/ https://kaffein.jagster.fi/brotli_asset/ https://kaffein.jagster.fi/extra-locales/ https://kaffein.jagster.fi/highlight-js/ https://kaffein.jagster.fi/javascripts/ https://kaffein.jagster.fi/plugins/ https://kaffein.jagster.fi/theme-javascripts/ https://kaffein.jagster.fi/svg-sprite/; worker-src 'self' https://kaffein.jagster.fi/assets/ https://kaffein.jagster.fi/brotli_asset/ https://kaffein.jagster.fi/javascripts/ https://kaffein.jagster.fi/plugins/";
#	}

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