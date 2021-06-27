## Cookie rules for Moodles

sub vcl_recv {

	### Cookies: Varnish >6.4 (same as earlier libvmod-cookie)
	
	## Keeping needed cookies and deleting rest.
	# You don't need to hash with every cookie. You can do something like this too:
	# sub vcl_hash {
	#	hash_data(cookie.get("language"));
	# }

	## Moodle (waste of time, must pass to work)
	cookie.parse(req.http.cookie);
	cookie.keep("MoodleSession,MoodleTest,MOODLEID");
	set req.http.cookie = cookie.get_string();

	## Don' let empty cookies travel any further
	if (req.http.cookie == "") {
		unset req.http.cookie;
	}

# The end of the recv and now we go further
}