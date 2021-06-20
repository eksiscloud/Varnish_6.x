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
				set req.http.x-bot = "tech";
				return(pass);
			} else {
				return(synth(403, "False Bot"));
			}
		}
	
	## UptimeRobot
	if (req.http.User-Agent ~ "UptimeRobot") {
		if (req.url ~ "^/(pong|tietosuojaseloste|latest|login|user)") {
			set req.http.x-bot = "tech";
			return(pass);
		} else {
			return(synth(403, "False Bot"));
		}
	}

	## I just can't shutdown Munin...
	if (req.http.User-Agent ~ "Munin") {
		return(synth(403, "Munin"));
	}

# And here's the end
}