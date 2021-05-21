sub tech_things {

	# Local ones
	if (
		   req.http.User-Agent == "KatiskaWarmer"
		|| req.http.User-Agent == "Varnish Health Probe"
		|| req.http.User-Agent ~ "Matomo"
		|| req.http.User-Agent ~ "Monit"
		|| req.http.User-Agent ~ "WP Rocket/"
		) {
			if (std.ip(req.http.X-Real-IP, "0.0.0.0") ~ whitelist) {
				return(pass);
			} else {
				return(synth(403, "False Bot"));
			}
		}
	
	# UptimeRobot
	if (req.http.User-Agent ~ "UptimeRobot") {
		if (req.url ~ "^/(pong|tietosuojaseloste|latest|login|user)") {
			return(pass);
		} else {
			return(synth(403, "False Bot"));
		}
	}
	
	# Let's Encrypt
	if (req.http.User-Agent ~ "Let's Encrypt validation server") {
		if (req.url ~ "^/.well-known/acme-challenge/") {
			return(pipe);
		} else {
			return(synth(404, "Not found"));
		}
	}
		


# And here's the end
}