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
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "Google"; }
		
		if (
		# Microsoft
		req.http.User-Agent ~ "Bingbot"
		|| req.http.User-Agent ~ "bingbot"
		|| req.http.User-Agent ~ "msnbot"
#		|| req.http.User-Agent ~ "BingPreview"	# done elsewhere
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "Bing"; }
		
		if (
		# DuckDuckGo
		req.http.User-Agent ~ "DuckDuckBot"
		|| req.http.User-Agent ~ "DuckDuckGo-Favicons-Bot"
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "DuckDuckGo"; }
		
		if (
		# Apple
		req.http.User-Agent ~ "Applebot"
		|| req.http.User-Agent ~ "AppleCoreMedia"
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "Apple"; }
		
		if (
		req.http.User-Agent == "iTMS" # iTunes
		|| req.http.User-Agent ~ "Jakarta Commons-HttpClient" #always together with iTMS
		|| req.http.User-Agent ~ "Podcastit" #Apple Podcast-app
		|| req.http.User-Agent ~ "iTunes"
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "iTunes"; }
		
		if (
		# Facebook
		req.http.User-Agent ~ "externalhit_uatext"
		|| req.http.User-Agent ~ "cortex"
		|| req.http.User-Agent ~ "adreview"
		) { set req.http.x-bot = "nice"; set req.http.User-Agent = "Facebook"; }
		
		# podcasts
		if (req.http.User-Agent ~ "Spotify") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Spotify"; }
		if (req.http.User-Agent ~ "StitcherBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Stitcher"; }
		if (req.http.User-Agent ~ "Podcaster") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Podcaster"; }
		if (req.http.User-Agent ~ "Overcast") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Overcast"; }
		if (req.http.User-Agent ~ "Breaker") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Breaker"; }
		if (req.http.User-Agent ~ "CastBox") { set req.http.x-bot = "nice"; set req.http.User-Agent = "CastBox"; }
		if (req.http.User-Agent == "Amazon Music Podcast") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Amazon Podcast"; }
		
		# Others
		if (req.http.User-Agent ~ "ia_archiver") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Alexa"; }
		if (req.http.User-Agent ~ "Blekkobot") {set req.http.x-bot = "nice"; set req.http.User-Agent = "Blekko"; }
		if (req.http.User-Agent == "Amazon Simple Notification Service Agent") { set req.http.x-bot = "nice"; set req.http.User-Agent = "AWS"; }
		if (req.http.User-Agent ~ "^MeWeBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "MeWe"; }
		if (req.http.User-Agent ~ "TurnitinBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "TurnitinBot"; }
		if (req.http.User-Agent ~ "archive.org") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Internet Archiver"; }
		if (req.http.User-Agent ~ "Feedly") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Feedly"; }
		if (req.http.User-Agent ~ "MetaFeedly") { set req.http.x-bot = "nice"; set req.http.User-Agent = "MetaFeedly"; }
		if (req.http.User-Agent ~ "Bloglovin") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Bloglovin"; }
		if (req.http.User-Agent ~ "Moodlebot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Moodle"; }
		if (req.http.User-Agent ~ "TelegramBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Telegram"; }
		if (req.http.User-Agent ~ "^Twitterbot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Twitter"; }
		if (req.http.User-Agent ~ "Pinterestbot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Pinterest"; }
		if (req.http.User-Agent ~ "WhatsApp") { set req.http.x-bot = "nice"; set req.http.User-Agent = "WhatsApp"; }
		if (req.http.User-Agent ~ "Snapchat") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Snapchat"; }
		if (req.http.User-Agent ~ "Newsify") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Newsify"; }
	
	# That's it, folk
}