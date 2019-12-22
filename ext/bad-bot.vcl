sub bad_bot_detection {

## I have to set user agent to find out in 404 monitoring of Wordpress who is getting 404.
## There is no point what so ever to start fixing 404s by bots and harvesters
## Fix only real users and Google etc.

    if (
		# Keyword harvesting and useless SEO
		   req.http.User-Agent ~ "libwww-perl"
		|| req.http.User-Agent ~ "Wget"
				# #
		|| req.http.User-Agent ~ "360Spider"
		|| req.http.User-Agent ~ "2345Explorer"
		# A 
		|| req.http.User-Agent ~ "AdAuth"
		|| req.http.User-Agent ~ "AdsTxtCrawler"
		|| req.http.User-Agent ~ "AhrefsBot"
		|| req.http.User-Agent ~ "America Online Browser"
		|| req.http.User-Agent ~ "Apache-HttpClient"
		|| req.http.User-Agent ~ "ApiTool"
		# B
		|| req.http.User-Agent ~ "Baidu"
		|| req.http.User-Agent ~ "Baiduspider"
		|| req.http.User-Agent ~ "bidswitchbot"
		|| req.http.User-Agent ~ "Blackboard Safeassign"
		|| req.http.User-Agent ~ "botify"
		|| req.http.User-Agent ~ "Buck"
		# C
		|| req.http.User-Agent ~ "CCBot"
		|| req.http.User-Agent ~ "Cliqzbot"
		|| req.http.User-Agent ~ "Cloud mapping experiment"
		|| req.http.User-Agent ~ "coccocbot"
		|| req.http.User-Agent ~ "cortex"
		# D
		|| req.http.User-Agent ~ "Dalvik"
		|| req.http.User-Agent ~ "Daum"
		|| req.http.User-Agent ~ "DotBot"
		# E
		|| req.http.User-Agent ~ "Exabot"
		# G
		|| req.http.User-Agent ~ "Go-http-client"
		|| req.http.User-Agent ~ "GotSiteMonitor"
		|| req.http.User-Agent ~ "GrapeshotCrawler"
		# H
		|| req.http.User-Agent ~ "Hello"
		# I
		|| req.http.User-Agent ~ "istellabot"
		# J
#		|| req.http.User-Agent ~ "Jakarta Commons-HttpClient"  # iTunes?
		|| req.http.User-Agent ~ "Java/"
		|| req.http.User-Agent ~ "Jersey"
		|| req.http.User-Agent ~ "jetmon"
		|| req.http.User-Agent ~ "Jetty"
		# K
		|| req.http.User-Agent ~ "Kinza"
		# L
		|| req.http.User-Agent ~ "LieBaoFast"
		# M
		|| req.http.User-Agent ~ "masscan"
		|| req.http.User-Agent ~ "MegaIndex.ru"
		|| req.http.User-Agent ~ "Mb2345Browser"
		|| req.http.User-Agent ~ "MJ12bot"
		# N
		|| req.http.User-Agent ~ "NetcraftSurveyAgent"
		|| req.http.User-Agent ~ "newspaper"
		|| req.http.User-Agent ~ "Nutch"
		# P
		|| req.http.User-Agent ~ "PaperLiBot"
		|| req.http.User-Agent ~ "Photon"
		|| req.http.User-Agent ~ "proximic"
		|| req.http.User-Agent ~ "python"
		|| req.http.User-Agent ~ "Python"
		# Q
		|| req.http.User-Agent ~ "Qwantify"
		# R
		|| req.http.User-Agent ~ "R6_"
		|| req.http.User-Agent ~ "RawVoice Generator"
#		|| req.http.User-Agent ~ "RED"
		|| req.http.User-Agent ~ "Rome Client"
		|| req.http.User-Agent ~ "Ruby"
		# S
		|| req.http.User-Agent ~ "Scrapy"
		|| req.http.User-Agent ~ "Screaming Frog SEO Spider"
		|| req.http.User-Agent ~ "SE 2.X MetaSr 1.0"
		|| req.http.User-Agent ~ "seewithkids.com"
		|| req.http.User-Agent ~ "SemrushBot"
		|| req.http.User-Agent ~ "serpstatbot"
		|| req.http.User-Agent ~ "SeznamBot"
		|| req.http.User-Agent ~ "SimplePie"
		|| req.http.User-Agent ~ "Slurp"
		|| req.http.User-Agent ~ "Sogou"
		|| req.http.User-Agent ~ "SurdotlyBot"
		# T
		|| req.http.User-Agent ~ "tapai"
		|| req.http.User-Agent ~ "TelegramBot"
		|| req.http.User-Agent ~ "temnos.com"
		|| req.http.User-Agent ~ "Test Certificate Info"
		|| req.http.User-Agent ~ "Thumbor"
		|| req.http.User-Agent ~ "TPA/1.0.0"
		|| req.http.User-Agent ~ "trendictionbot"
		|| req.http.User-Agent ~ "Typhoeus"
		|| req.http.User-Agent ~ "TweetmemeBot"
		# U
		|| req.http.User-Agent ~ "UCBrowser"
		|| req.http.User-Agent ~ "um-LN"
		|| req.http.User-Agent ~ "UniversalFeedParser"
		# V
		|| req.http.User-Agent ~ "VelenPublicWebCrawler"
		# W
		|| req.http.User-Agent ~ "WebZIP"
		# Y
		|| req.http.User-Agent ~ "YaBrowser"
		|| req.http.User-Agent ~ "YaK"
		|| req.http.User-Agent ~ "Yandex"
		|| req.http.User-Agent ~ "YisouSpider"
		# Z
		|| req.http.User-Agent ~ "zh_CN"
		|| req.http.User-Agent ~ "zh-cn"
		|| req.http.User-Agent ~ "ZmEu"
		##
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.90 Safari/537.36 2345Explorer/9.3.2.17331"
		|| req.http.User-Agent == "MobileSafari/604.1 CFNetwork/897.15 Darwin/17.5.0"
		) {
			set req.http.User-Agent = "Bad Bad Bot";
			return(synth(403, "Forbidden Bot"));
			} 

	elseif ( req.http.User-Agent == "^$" || req.http.User-Agent == "-") {
			set req.http.User-Agent = "Potatoehead"; # you actually don't need this UA
			return (synth(403, "Empty User Agent"));
			}
		
	elseif (
		  req.http.User-Agent == "KatiskaWarmer" # this is wget
		# Google
		||req.http.User-Agent ~ "APIs-Google"
		|| req.http.User-Agent ~ "Mediapartners-Google"
		|| req.http.User-Agent ~ "AdsBot-Google"
		|| req.http.User-Agent ~ "Googlebot"
		|| req.http.User-Agent ~ "FeedFetcher-Google"
		|| req.http.User-Agent ~ "Google-Read-Aloud"
		|| req.http.User-Agent ~ "DuplexWeb-Google"
		|| req.http.User-Agent ~ "Google Favicon"
		# Microsoft
		|| req.http.User-Agent ~ "Bingbot"
		|| req.http.User-Agent ~ "bingbot"
		|| req.http.User-Agent ~ "msnbot"
		|| req.http.User-Agent ~ "BingPreview"
		# DuckDuckGo
		|| req.http.User-Agent ~ "DuckDuckBot"
		# Alexa
		|| req.http.User-Agent ~ "ia_archiver"
		# Apple
		|| req.http.User-Agent ~ "Applebot"
		# Blekko
		|| req.http.User-Agent ~ "Blekkobot"
		# Others
		|| req.http.User-Agent ~ "TurnitinBot"
		|| req.http.User-Agent ~ "special_archiver"
		|| req.http.User-Agent ~ "archive.org_bot"
		|| req.http.User-Agent ~ "Feedly"
		# Facebook
		|| req.http.User-Agent ~ "facebot"
		|| req.http.User-Agent ~ "facebookexternalhit"
		# AWS
		|| req.http.User-Agent == "Amazon CloudFront"
		# podcasts
		|| req.http.User-Agent ~ "Spotify"
		|| req.http.User-Agent ~ "Luminary"
		|| req.http.User-Agent ~ "StitcherBot"
		|| req.http.User-Agent ~ "iTMS" #iTunes
		|| req.http.User-Agent ~ "Podcastit" # ?
		|| req.http.User-Agent ~ "Podcaster"
		|| req.http.User-Agent ~ "Overcast"
		|| req.http.User-Agent ~ "Breaker"
		|| req.http.User-Agent ~ "CastBox"
		# Others
		|| req.http.User-Agent ~ "Moodlebot"
		|| req.http.User-Agent ~ "Twitterbot"
		|| req.http.User-Agent ~ "Pinterestbot"
		|| req.http.User-Agent ~ "GoogleImageProxy" #anonymizes Gmail openings and is a human
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246 Mozilla/5.0" # the actual gmail bot
		|| req.http.User-Agent ~ "Disqus"
		|| req.http.User-Agent ~ "WhatsApp"
		) {
			set req.http.User-Agent = "Good guy";
			}
	
	elseif (
		# These are useful
		   req.http.User-Agent == "Varnish Health Probe"
		|| req.http.User-Agent ~ "Monit"
		|| req.http.User-Agent ~ "WP Rocket/"
		|| req.http.User-Agent ~ "UptimeRobot"
		) {
			set req.http.User-Agent = "Probes";
			return(pipe);
			}
			
	else {
		set req.http.User-Agent = "Others";
		}
	
		# That's all folk.
				
}    
