sub foreign_agents {

# Allowed only from whitelisted IP, but no bans by Fail2ban
	if (req.http.User-Agent ~ "BingPreview") {
		return (synth(402, "Access Denied" + client.ip));
		set req.http.User-Agent = "Nozy one";
	}

	if (req.http.User-Agent ~ "curl") {
		return (synth(402, "Access Denied" + client.ip));
		set req.http.User-Agent = "Nozy one";
	}

	if (req.http.User-Agent ~ "Facebot Twitterbot") {
		return (synth(402, "Access Denied" + client.ip));
		set req.http.User-Agent = "Nozy one";
	}

	if (req.http.User-Agent ~ "libwww-perl") {
		return (synth(402, "Access Denied" + client.ip));
		set req.http.User-Agent = "Nozy one";
	}

	if (req.http.User-Agent ~ "Ruby") {
		return (synth(402, "Access Denied" + client.ip));
		set req.http.User-Agent = "Nozy one";
	}
		
	# And here is the end
}