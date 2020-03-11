sub bad_bot_detection {

## I have to set user agent to find out in 404 monitoring of Wordpress who is getting 404.
## There is no point what so ever to start fixing 404s getting by bots and harvesters
## Fix only real things that are issues for users and Google etc.
## All this have been visiting or still trying at my sites.

	if (
		# Rogues, keyword harvesting and useless SEO
		   req.http.User-Agent ~ "libwww-perl" 		#you might want to comment this, but this not stops from localhost
		|| req.http.User-Agent ~ "Wget" 		#same here
				# #
		|| req.http.User-Agent ~ "360Spider"
		|| req.http.User-Agent ~ "2345Explorer"
		|| req.http.User-Agent == "facebookexternalhit/1.1 Facebot Twitterbot/1.0"
		# A 
		|| req.http.User-Agent ~ "Acast "
		|| req.http.User-Agent ~ "AdAuth"
		|| req.http.User-Agent ~ "admantx-adform"
		|| req.http.User-Agent ~ "AdsTxtCrawler"
		|| req.http.User-Agent ~ "AffiliateLabz"
		|| req.http.User-Agent ~ "AHC"
		|| req.http.User-Agent ~ "AhrefsBot"
		|| req.http.User-Agent ~ "akka-http/"
		|| req.http.User-Agent ~ "AltaVista"
		|| req.http.User-Agent ~ "Amazon CloudFront"
		|| req.http.User-Agent ~ "America Online Browser"
		|| req.http.User-Agent ~ "Anchorage DMP"
		|| req.http.User-Agent ~ "Apache-HttpClient"
		|| req.http.User-Agent ~ "ApiTool"
		|| req.http.User-Agent ~ "AspiegelBot"
		|| req.http.User-Agent ~ "AVSearch"
		# B
		|| req.http.User-Agent ~ "Baidu"
		|| req.http.User-Agent ~ "Barkrowler"
		|| req.http.User-Agent ~ "BDCbot"
		|| req.http.User-Agent ~ "bidswitchbot"
		|| req.http.User-Agent ~ "Blackboard Safeassign"
		|| req.http.User-Agent ~ "BLEXBot"
		|| req.http.User-Agent ~ "Bloglines"
		|| req.http.User-Agent ~ "botify"
		|| req.http.User-Agent ~ "Buck"
		|| req.http.User-Agent ~ "BuiltWith"
		# C
		|| req.http.User-Agent ~ "CarrierWave"
		|| req.http.User-Agent ~ "CatchBot"
		|| req.http.User-Agent ~ "CCBot"
		|| req.http.User-Agent ~ "Centro"
		|| req.http.User-Agent ~ "check_http/"
		|| req.http.User-Agent ~ "checkout-"
		|| req.http.User-Agent ~ "Clarabot"
		|| req.http.User-Agent ~ "Cliqzbot"
		|| req.http.User-Agent ~ "Cloud mapping experiment"
		|| req.http.User-Agent ~ "CMS Crawler"
		|| req.http.User-Agent ~ "coccocbot"
		|| req.http.User-Agnet ~ "crawler4j"
#		|| req.http.User-Agent ~ "curl/"
		# D
		|| req.http.User-Agent ~ "Dalvik"
		|| req.http.User-Agent ~ "datagnionbot"
		|| req.http.User-Agent ~ "Datanyze"
		|| req.http.User-Agent ~ "Daum"
		|| req.http.User-Agent ~ "deepcrawl.com"
		|| req.http.User-Agent ~ "digincore"
		|| req.http.User-Agent ~ "Domnutch"
		|| req.http.User-Agent ~ "DotBot"
		# E
		|| req.http.User-Agent ~ "eContext"
		|| req.http.User-Agent ~ "EnigmaBot"
		|| req.http.User-Agent ~ "Entale bot"
		|| req.http.User-Agent ~ "Exabot"
		|| req.http.User-Agent ~ "Ezooms"
		# F
		|| req.http.User-Agent ~ "fr-crawler"
		|| req.http.User-Agent ~ "fyeo-crawler"
		# G
		|| req.http.User-Agent ~ "Go-http-client"
		|| req.http.User-Agent ~ "^got "
		|| req.http.User-Agent ~ "GotSiteMonitor"
		|| req.http.User-Agent ~ "GrapeshotCrawler"
		# H
		|| req.http.User-Agent ~ "Hello"
		|| req.http.User-Agent ~ "HTTP Banner Detection"
		# I
		|| req.http.User-Agent ~ "IAB ATQ"
		|| req.http.User-Agent ~ "IAS crawler"
		|| req.http.User-Agent ~ "import.io"
		|| req.http.User-Agent ~ "InfoSeek"
		|| req.http.User-Agent ~ "INGRID/0.1"
		|| req.http.User-Agent ~ "Internet-structure-research-project-bot"
		|| req.http.User-Agent ~ "istellabot"
		# J
		|| req.http.User-Agent ~ "Java/"
		|| req.http.User-Agent ~ "Jersey"
		|| req.http.User-Agent ~ "jetmon"
		|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		|| req.http.User-Agent ~ "Jetty"
		|| req.http.User-Agent ~ "JobboerseBot"
		# K
		|| req.http.User-Agent ~ "Kinza"
		|| req.http.User-Agent ~ "Kraphio"
		# L
		|| req.http.User-Agent ~ "libwww-perl"
		|| req.http.User-Agent ~ "LieBaoFast"
		|| req.http.User-Agent ~ "LightspeedSystemsCrawler"
		|| req.http.User-Agent ~ "linkdexbot"
		|| req.http.User-Agent ~ "linklooker"
		|| req.http.User-Agent ~ "Lycos"
		# M
		|| req.http.User-Agent ~ "magpie-crawler"
		|| req.http.User-Agent ~ "Mail.RU_Bot"
		|| req.http.User-Agent ~ "masscan"
		|| req.http.User-Agent ~ "Mb2345Browser"
		|| req.http.User-Agent ~ "MegaIndex.ru"
		|| req.http.User-Agent ~ "Mercator"
		|| req.http.User-Agent ~ "MixnodeCache"
		|| req.http.User-Agent ~ "MJ12bot"
		|| req.http.User-Agent ~ "ms-office"
		|| req.http.User-Agent ~ "MyTuner-ExoPlayerAdapter"
		# N
		|| req.http.User-Agent ~ "NetcraftSurveyAgent"
		|| req.http.User-Agent ~ "NetSeer"
		|| req.http.User-Agent ~ "newspaper"
		|| req.http.User-Agent ~ "Nimbostratus-Bot"
		|| req.http.User-Agent ~ "node-fetch"
		|| req.http.User-Agent ~ "Nutch"
		# O
		|| req.http.User-Agent ~ "oBot"
		|| req.http.User-Agent ~ "okhttp"
		|| req.http.User-Agent ~ "oncrawl.com"
		|| req.http.User-Agent ~ "OwlTail"
		# P
		|| req.http.User-Agent ~ "PaperLiBot"
		|| req.http.User-Agent ~ "PhantomJS"
		|| req.http.User-Agent ~ "Photon/"  # Automattic
		|| req.http.User-Agent ~ "PHP/"
		|| req.http.User-Agent ~ "Podalong"
		|| req.http.User-Agent ~ "Podchaser-Parser"
		|| req.http.User-Agent ~ "Podimo"
		|| req.http.User-Agent ~ "proximic"
		|| req.http.User-Agent ~ "python"
		|| req.http.User-Agent ~ "Python"
		# Q
		|| req.http.User-Agent ~ "Qwantify"
		# R
		|| req.http.User-Agent ~ "R6_"
		|| req.http.User-Agent ~ "radio.at"
		|| req.http.User-Agent ~ "radio.de"
		|| req.http.User-Agent ~ "radio.es"
		|| req.http.User-Agent ~ "radio.fr"
		|| req.http.User-Agent ~ "radio.it"
		|| req.http.User-Agent ~ "radio.net"
		|| req.http.User-Agent ~ "RawVoice Generator"
		|| req.http.User-Agent ~ "RogerBot"
		|| req.http.User-Agent ~ "Rome Client"
		|| req.http.User-Agent ~ "Ruby"
		# S
		|| req.http.User-Agent ~ "SafetyNet"
		|| req.http.User-Agent ~ "Scooter"
		|| req.http.User-Agent ~ "Scrapy"
		|| req.http.User-Agent ~ "Screaming Frog SEO Spider"
		|| req.http.User-Agent ~ "SE 2.X MetaSr 1.0"
		|| req.http.User-Agent ~ "seewithkids.com"
		|| req.http.User-Agent ~ "SemanticScholarBot"
		|| req.http.User-Agent ~ "SemrushBot"
		|| req.http.User-Agent ~ "SEMrushBot"
		|| req.http.User-Agent ~ "serpstatbot"
		|| req.http.User-Agent ~ "SeznamBot"
		|| req.http.User-Agent ~ "SimplePie"
		|| req.http.User-Agent ~ "SiteBot"
		|| req.http.User-Agent ~ "Slurp"
		|| req.http.User-Agent ~ "Sogou"
		|| req.http.User-Agent ~ "socialmediascanner"
		|| req.http.User-Agent ~ "ssearch_bot"
		|| req.http.User-Agent ~ "SurdotlyBot"
		# T
		|| req.http.User-Agent ~ "Talous"
		|| req.http.User-Agent ~ "tapai"
		|| req.http.User-Agent ~ "TelegramBot"
		|| req.http.User-Agent ~ "temnos.com"
		|| req.http.User-Agent ~ "Tentacles"
		|| req.http.User-Agent ~ "Test Certificate Info"
		|| req.http.User-Agent ~ "Thumbor"
		|| req.http.User-Agent ~ "TPA/1.0.0"
		|| req.http.User-Agent ~ "Trade Desk"
		|| req.http.User-Agent ~ "trendictionbot"
		|| req.http.User-Agent ~ "TrendsmapResolver"
		|| req.http.User-Agent ~ "TTD-content"
		|| req.http.User-Agent ~ "TTD-Content"
		|| req.http.User-Agent ~ "Typhoeus"
		|| req.http.User-Agent ~ "TweetmemeBot"
		# U
		|| req.http.User-Agent ~ "UCBrowser"
		|| req.http.User-Agent ~ "UltraSeek"
		|| req.http.User-Agent ~ "um-IC"
		|| req.http.User-Agent ~ "um-LN"
		|| req.http.User-Agent ~ "UniversalFeedParser"
		# V
		|| req.http.User-Agent ~ "VelenPublicWebCrawler"
		# W
		|| req.http.User-Agent ~ "^w3m"
		|| req.http.User-Agent ~ "WebZIP"
		|| req.http.User-Agent ~ "Windows Live Writter"
		|| req.http.User-Agent ~ "Wordpress.com"
		|| req.http.User-Agent ~ "wp.com"
		# X
		|| req.http.User-Agent ~ "XoviBot"
		# Y
		|| req.http.User-Agent ~ "YaBrowser"
		|| req.http.User-Agent ~ "YahooSeeker"
		|| req.http.User-Agent ~ "YaK"
		|| req.http.User-Agent ~ "Yandex"
		|| req.http.User-Agent ~ "YisouSpider"
		# Z
		|| req.http.User-Agent ~ "zgrab/"
		|| req.http.User-Agent ~ "zh_CN"
		|| req.http.User-Agent ~ "zh-CN"
		|| req.http.User-Agent ~ "zh-cn"
		|| req.http.User-Agent ~ "ZmEu"
		## Others
		## CFNetwork, Darwin are always bots, but some are useful. 2345Explorer same thing, but practically always harmful
		|| req.http.User-Agent ~ "Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.18"
		|| req.http.Ucer-Agent ~ "Opera/9.80 (Windows NT 5.1; U; en) Presto/2.10.289 Version/12.01"
		|| req.http.User-Agent ~ "Safari/14608.5.12 CFNetwork/978.2 Darwin/18.7.0 (x86_64)" #Maybe Apple, it is checking out mostly only touch-icon.png
		|| req.http.User-Agent ~ "Windows; U; MSIE 9.0; WIndows NT 9.0; de-DE"
		|| req.http.User-Agent == "Mozilla/5.0(compatible;MSIE9.0;WindowsNT6.1;Trident/5.0)"
		|| req.http.User-Agent ~ "(X11; Ubuntu; Linux x86_64; rv:21.0)"
		|| req.http.User-Agent ~ "(Windows NT 6.1; WOW64)"
		|| req.http.User-Agent == "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1)"
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.1; rv:3.4) Goanna/20180327 PaleMoon/27.8.3"
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"
		|| req.http.User-Agent == "Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; de-DE)"
		|| req.http.User-Agent ~ "Mozilla/4.0"
		|| req.http.User-Agent ~ "Windows NT 5.2"
		|| req.http.User-Agent ~ "(Windows NT 6.0)"
#		|| req.http.User-Agent ~ "Windows NT 6.1" 	# uncommenting will stop BingPreview
		|| req.http.Uset-Agent == "Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko"
		|| req.http.User-Agent ~ "Mozilla/5.1 (Windows NT 6.0; WOW64)"
		) {
			#set req.http.User-Agent = "Bad Bad Bot";
			return(synth(666, "Forbidden Bot"));
			} 

	#  Empty usear-agent
	elseif ( req.http.User-Agent == "^$" || req.http.User-Agent == "-") {
			set req.http.User-Agent = "Potatoehead";
			return (synth(666, "Empty User Agent"));
			}

	# Good ones
	elseif (
		  req.http.User-Agent == "KatiskaWarmer"	# my wget; warming up cache
		# Google
		|| req.http.User-Agent ~ "APIs-Google"
		|| req.http.User-Agent ~ "Mediapartners-Google"
		|| req.http.User-Agent ~ "AdsBot-Google"
		|| req.http.User-Agent ~ "Googlebot"
		|| req.http.User-Agent ~ "FeedFetcher-Google"
		|| req.http.User-Agent ~ "Google-Read-Aloud"
		|| req.http.User-Agent ~ "DuplexWeb-Google"
		|| req.http.User-Agent ~ "Google Favicon"
		|| req.http.User-Agent ~ "GoogleImageProxy" 	#anonymizes Gmail openings and is a human
		|| req.http.User-Agent ~ "Googlebot-Video"
		|| req.http.User-Agent ~ "AppEngine-Google" 	#snapchat
		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246 Mozilla/5.0" # the actual gmail bot
		# Microsoft
		|| req.http.User-Agent ~ "Bingbot"
		|| req.http.User-Agent ~ "bingbot"
		|| req.http.User-Agent ~ "msnbot"
		|| req.http.User-Agent ~ "BingPreview"
		# DuckDuckGo
		|| req.http.User-Agent ~ "DuckDuckBot"
		|| req.http.User-Agent ~ "DuckDuckGo-Favicons-Bot"
		# Alexa
		|| req.http.User-Agent ~ "ia_archiver"
		# Apple
		|| req.http.User-Agent ~ "Applebot"
		|| req.http.User-Agent ~ "AppleCoreMedia"
		|| req.http.User-Agent ~ "iTMS" 			# iTunes
		|| req.http.User-Agent ~ "Jakarta Commons-HttpClient" 	# always together with iTMS
		|| req.http.User-Agent ~ "Podcastit" 			#Apple Podcast-app
		|| req.http.User-Agent ~ "iTunes"
		# Blekko
		|| req.http.User-Agent ~ "Blekkobot"
		# Facebook
		#|| req.http.User-Agent ~ "facebot"
		|| req.http.User-Agent ~ "externalhit_uatext"
		|| req.http.User-Agent ~ "cortex"
		|| req.http.User-Agent ~ "adreview"
		# AWS
		|| req.http.User-Agent == "Amazon Simple Notification Service Agent"
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
		|| req.http.User-Agent ~ "^Twitterbot"
		|| req.http.User-Agent ~ "Pinterestbot"
		|| req.http.User-Agent ~ "Disqus"
		|| req.http.User-Agent ~ "WhatsApp"
		|| req.http.User-Agent ~ "Snapchat"
		|| req.http.User-Agent ~ "Newsify"
		) {
			#set req.http.User-Agent = "Good guy";
			#return(pipe);
			unset req.http.User-Agent;
			}
	
	elseif (
		# These are useful and we want to know if backend is working
		   req.http.User-Agent == "Varnish Health Probe"
		|| req.http.User-Agent ~ "Monit"
		|| req.http.User-Agent ~ "WP Rocket/"
		|| req.http.User-Agent ~ "UptimeRobot"
		|| req.http.User-Agent ~ "Matomo"
		) {
			set req.http.User-Agent = "Probes";
			return(pipe);
			}

	# others, like real visitors
	else {
		unset req.http.User-Agent;
		}
	
# That's all folk.
		
}    
