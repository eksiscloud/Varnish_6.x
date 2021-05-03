sub foreign_agents {

# No bans by Fail2ban
	if (req.http.User-Agent ~ "BingPreview") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}

	if (req.http.User-Agent ~ "Facebot Twitterbot") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
	
	if (req.http.User-Agent ~ "MSOffice 16") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
	
	if (req.http.User-Agent ~ "Mozilla \/4\.0") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
	
	if (req.http.User-Agent ~ "okhttp") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
	
# Script kiddies are knocking
# should be commented if in use
	
	if (req.http.url ~ "/themes/twenty(ten|eleven|thirteen|fourteen|fifteen|sixteen|seventeen|nineteen|twenty)") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
	
# Allowed only from whitelisted IP, but no bans by Fail2ban either
# Works only when user agent has not been changed, so this will stop only easy ones
if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ whitelist) {
	if (req.http.User-Agent ~ "curl") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}

	elseif (req.http.User-Agent ~ "wget") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}

	elseif (req.http.User-Agent ~ "libwww-perl") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
		
	elseif (req.http.User-Agent ~ "Ruby") {
		return (synth(402, "Access Denied" + req.http.X-Real-IP));
	}
}
	
	# And here is the end
}