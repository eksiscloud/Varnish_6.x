sub cors {

	if (req.http.X-Saved-Origin == "") {
		set resp.http.Access-Control-Allow-Origin = "https://" + req.http.host;
	} else {
		set resp.http.Access-Control-Allow-Origin = req.http.X-Saved-Origin;
	}
	
	unset req.http.X-Saved-Origin;
	
	
	
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