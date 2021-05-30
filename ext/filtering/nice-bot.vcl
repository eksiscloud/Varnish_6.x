sub cute_bot_allowance {

	## Useful bots, spiders etc.
	# I'm using x-bot somekind of ACL
	
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
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "Google"; 
		}
		
	elseif (
		# Microsoft
		req.http.User-Agent ~ "Bingbot"
		|| req.http.User-Agent ~ "bingbot"
		|| req.http.User-Agent ~ "msnbot"
		#|| req.http.User-Agent ~ "BingPreview"	# done elsewhere
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "Bing"; }
		
	elseif (
		# DuckDuckGo
		req.http.User-Agent ~ "DuckDuckBot"
		|| req.http.User-Agent ~ "DuckDuckGo-Favicons-Bot"
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "DuckDuckGo"; 
		}
		
	elseif (
		# Apple
		req.http.User-Agent ~ "Applebot"
		|| req.http.User-Agent ~ "AppleCoreMedia"
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "Apple"; 
		}
		
	elseif (
		req.http.User-Agent == "iTMS" # iTunes
		|| req.http.User-Agent ~ "Jakarta Commons-HttpClient" # always together with iTMS
		|| req.http.User-Agent ~ "Podcastit" # Apple Podcast-app
		|| req.http.User-Agent ~ "iTunes"	 # Older way to get podcasts, will disappers I reckon
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "iTunes"; 
		}
		
	elseif (
		# Facebook
		req.http.User-Agent ~ "externalhit_uatext"
		|| req.http.User-Agent ~ "facebookexternalhit"
		|| req.http.User-Agent ~ "cortex"
		|| req.http.User-Agent ~ "adreview"
		) { 
			set req.http.x-bot = "nice"; 
			set req.http.User-Agent = "Facebook"; 
		}
		
	# podcasts
	elseif (req.http.User-Agent ~ "Spotify") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Spotify"; }
	elseif (req.http.User-Agent ~ "StitcherBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Stitcher"; }
	elseif (req.http.User-Agent ~ "Podcaster") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Podcaster"; }
	elseif (req.http.User-Agent ~ "Overcast") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Overcast"; }
	elseif (req.http.User-Agent ~ "Breaker") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Breaker"; }
	elseif (req.http.User-Agent ~ "CastBox") { set req.http.x-bot = "nice"; set req.http.User-Agent = "CastBox"; }
	elseif (req.http.User-Agent == "Amazon Music Podcast") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Amazon Podcast"; }
		
	# Others
	elseif (req.http.User-Agent ~ "ia_archiver") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Alexa"; }
	elseif (req.http.User-Agent ~ "Blekkobot") {set req.http.x-bot = "nice"; set req.http.User-Agent = "Blekko"; }
	elseif (req.http.User-Agent == "Amazon Simple Notification Service Agent") { set req.http.x-bot = "nice"; set req.http.User-Agent = "AWS"; }
	elseif (req.http.User-Agent ~ "^MeWeBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "MeWe"; }
	elseif (req.http.User-Agent ~ "TurnitinBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "TurnitinBot"; }
	elseif (req.http.User-Agent ~ "archive.org") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Internet Archiver"; }
	elseif (req.http.User-Agent ~ "Feedly") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Feedly"; }
	elseif (req.http.User-Agent ~ "MetaFeedly") { set req.http.x-bot = "nice"; set req.http.User-Agent = "MetaFeedly"; }
	elseif (req.http.User-Agent ~ "Bloglovin") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Bloglovin"; }
	elseif (req.http.User-Agent ~ "Moodlebot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Moodle"; }
	elseif (req.http.User-Agent ~ "TelegramBot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Telegram"; }
	elseif (req.http.User-Agent ~ "^Twitterbot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Twitter"; }
	elseif (req.http.User-Agent ~ "Pinterestbot") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Pinterest"; }
	elseif (req.http.User-Agent ~ "WhatsApp") { set req.http.x-bot = "nice"; set req.http.User-Agent = "WhatsApp"; }
	elseif (req.http.User-Agent ~ "Snapchat") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Snapchat"; }
	elseif (req.http.User-Agent ~ "Newsify") { set req.http.x-bot = "nice"; set req.http.User-Agent = "Newsify"; }
	
	# That's it, folk
}