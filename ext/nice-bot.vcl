sub cute_bot_allowance {

# Useful bots, spiders etc.
	if (
		# Google
		   req.http.User-Agent ~ "APIs-Google"
		|| req.http.User-Agent ~ "Mediapartners-Google"
		|| req.http.User-Agent ~ "AdsBot-Google"
		|| req.http.User-Agent ~ "Googlebot"
		|| req.http.User-Agent ~ "FeedFetcher-Google"
		|| req.http.User-Agent ~ "Google-Read-Aloud"
		|| req.http.User-Agent ~ "DuplexWeb-Google"
		|| req.http.User-Agent ~ "Google Favicon"
		|| req.http.User-Agent ~ "GoogleImageProxy" #anonymizes Gmail openings and is a human
		|| req.http.User-Agent ~ "Googlebot-Video"
		|| req.http.User-Agent ~ "AppEngine-Google" #snapchat
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246 Mozilla/5.0" # the actual gmail bot
		# Microsoft
		|| req.http.User-Agent ~ "Bingbot"
		|| req.http.User-Agent ~ "bingbot"
		|| req.http.User-Agent ~ "msnbot"
#		|| req.http.User-Agent ~ "BingPreview"
		# DuckDuckGo
		|| req.http.User-Agent ~ "DuckDuckBot"
		|| req.http.User-Agent ~ "DuckDuckGo-Favicons-Bot"
		# Alexa
		|| req.http.User-Agent ~ "ia_archiver"
		# Apple
		|| req.http.User-Agent ~ "Applebot"
		|| req.http.User-Agent ~ "AppleCoreMedia"
		|| req.http.User-Agent == "iTMS" # iTunes
		|| req.http.User-Agent ~ "Jakarta Commons-HttpClient" #always together with iTMS
		|| req.http.User-Agent ~ "Podcastit" #Apple Podcast-app
		|| req.http.User-Agent ~ "iTunes"
		# Blekko
		|| req.http.User-Agent ~ "Blekkobot"
		# Facebook
		|| req.http.User-Agent ~ "externalhit_uatext"
		|| req.http.User-Agent ~ "cortex"
		|| req.http.User-Agent ~ "adreview"
		# AWS
		|| req.http.User-Agent == "Amazon Simple Notification Service Agent"
		|| req.http.User-Agent == "Amazon Music Podcast"
		# podcasts
		|| req.http.User-Agent ~ "Spotify"
		|| req.http.User-Agent ~ "Luminary"
		|| req.http.User-Agent ~ "StitcherBot"
		|| req.http.User-Agent ~ "Podcaster"
		|| req.http.User-Agent ~ "Overcast"
		|| req.http.User-Agent ~ "Breaker"
		|| req.http.User-Agent ~ "CastBox"
		# MeWe
		|| req.http.User-Agent ~ "^MeWeBot"
		# Others
		|| req.http.User-Agent ~ "TurnitinBot"
		|| req.http.User-Agent ~ "special_archiver"
		|| req.http.User-Agent ~ "archive.org_bot"
		|| req.http.User-Agent ~ "Feedly"
		|| req.http.User-Agent ~ "MetaFeedly"
		|| req.http.User-Agent ~ "Bloglovin"
		|| req.http.User-Agent ~ "Moodlebot"
		|| req.http.User-Agent ~ "TelegramBot"
		|| req.http.User-Agent ~ "^Twitterbot"
		|| req.http.User-Agent ~ "Pinterestbot"
		|| req.http.User-Agent ~ "Disqus"
		|| req.http.User-Agent ~ "WhatsApp"
		|| req.http.User-Agent ~ "Snapchat"
		|| req.http.User-Agent ~ "Newsify"
		) {
			# For testing purposes I need to identify bots on backend every now and then
			set req.http.User-Agent = "Nice bot";
			#unset req.http.User-Agent;
		}

	# That's it, folk
}