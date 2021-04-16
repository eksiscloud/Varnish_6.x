sub foreign_agents {

# No bans by Fail2ban
	if (req.http.User-Agent ~ "BingPreview") {
		return (synth(402, "Access Denied" + client.ip));
	}

	if (req.http.User-Agent ~ "Facebot Twitterbot") {
		return (synth(402, "Access Denied" + client.ip));
	}
	
	if (req.http.User-Agent ~ "MSOffice 16") {
		return (synth(402, "Access Denied" + client.ip));
	}
	
	if (req.http.User-Agent ~ "Mozilla \/4\.0") {
		return (synth(402, "Access Denied" + client.ip));
	}
	
	if (req.http.User-Agent ~ "okhttp") {
		return (synth(402, "Access Denied" + client.ip));
	}
	
# Allowed only from whitelisted IP, but no bans by Fail2ban either
# Works only when user agent has not been changed

		if (req.http.User-Agent ~ "curl") {
			if (!client.ip ~ whitelist) {
				return (synth(402, "Access Denied" + client.ip));
			}
		}

		if (req.http.User-Agent ~ "wget") {
			if (!client.ip ~ whitelist) {
				return (synth(402, "Access Denied" + client.ip));
			}
		}

		if (req.http.User-Agent ~ "libwww-perl") {
			if (!client.ip ~ whitelist) {
				return (synth(402, "Access Denied" + client.ip));
			}
		}
		
		if (req.http.User-Agent ~ "Ruby") {
			if (!client.ip ~ whitelist) {
				return (synth(402, "Access Denied" + client.ip));
			}
		}
	# And here is the end
}