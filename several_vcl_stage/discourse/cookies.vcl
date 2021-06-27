# Cookie rules for Discourses.

sub vcl_recv {

	# MediaWiki
	if (req.http.host == "www.koiranravitsemus.fi") {
		cookie.parse(req.http.cookie);
		cookie.keep("session,UserID,UserName,LoggedOut,Token");	# I've never seen LoggedOut or Token
		set req.http.cookie = cookie.get_string();
	}
	
	## Gitea
	elseif (req.http.host == "git.eksis.one") {
		cookie.parse(req.http.cookie);
		# https://docs.gitea.io/en-us/config-cheat-sheet/
		cookie.keep("i_like_gitea,_csrf,redirect_to,lang,gitea_incredible,gitea_awesome");
		set req.http.cookie = cookie.get_string();
	}
	
	# Don' let empty cookies travel any further
	if (req.http.cookie == "") {
		unset req.http.cookie;
	}

# The end of the recv and now we go further
}