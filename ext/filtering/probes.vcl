sub tech_things {

	## Local ones
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
	
	## UptimeRobot
	if (req.http.User-Agent ~ "UptimeRobot") {
		if (req.url ~ "^/(pong|tietosuojaseloste|latest|login|user)") {
			return(pass);
		} else {
			return(synth(403, "False Bot"));
		}
	}


# And here's the end
}