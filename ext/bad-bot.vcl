sub bad_bot_detection {

## I have to set user agent to find out in 404 monitoring of Wordpress who is getting 404.
## There is no point what so ever to start fixing 404s by bots and harvesters
## Fix only real things that are issues for users and Google etc.
## All this have been visited or are still trying to my sites.
## Shows 404s: awk '($9 ~ /404/)' /var/log/nginx/access.log | awk '{print $7}' | sort | uniq -c | sort -rn
## Shows user agents: awk -F'"' '/GET/ {print $6}' /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -rn

# Special cases
	if (
		# These are using same IP-space every now and then than real users, so I can't ban the IP.
		   req.http.User-Agent ~ "BingPreview"					# bad, and too nosy and busy
#		|| req.http.User-Agent ~ "curl"							# vcl is taking care this allowing access only to whitelisted ones
		|| req.http.User-Agent ~ "Facebot Twitterbot"
#		|| req.http.User-Agent ~ "libwww-perl"					# vcl is taking care this allowing access only to whitelisted ones
		) {
			return(synth(402, "Denied Access"));
		}

# True bots, spiders and harvesters; Rogues, keyword harvesting and useless SEO
# These are now handled by Nginx giving error 499
	if (
		# #
		   req.http.User-Agent ~ "360Spider"					# bad 		- done
		|| req.http.User-Agent ~ "2345Explorer"					# malicious - done
		# A 
		|| req.http.User-Agent ~ "Acast "						# bad 		- done
		|| req.http.User-Agent ~ "Accept-Encoding"
		|| req.http.User-Agent ~ "AdAuth"						# bad 		- done
		|| req.http.User-Agent ~ "adidxbot"						# good
		|| req.http.User-Agent ~ "admantx"						# bad 		- done
		|| req.http.User-Agent ~ "AdsTxtCrawler"				# bad 		- done
		|| req.http.User-Agent ~ "AffiliateLabz"				# good 		- done
		|| req.http.User-Agent ~ "AHC"							# malicious
		|| req.http.User-Agent ~ "AhrefsBot"					# good		- done
		|| req.http.User-Agent ~ "aiohttp"
		|| req.http.User-Agent ~ "akka-http/"					# malicious - done
		|| req.http.User-Agent ~ "Amazon CloudFront"			# malicious - done
		|| req.http.User-Agent ~ "amp-wp"
		|| req.http.User-Agent ~ "Anchorage DMP"				# bad		- done
		|| req.http.User-Agent ~ "Apache-HttpClient"			# malicious - done
		|| req.http.User-Agent ~ "ApiTool"
		|| req.http.User-Agent ~ "aria2"
		|| req.http.User-Agent ~ "AspiegelBot"					# good
		|| req.http.User-Agent ~ "atc/"
		|| req.http.User-Agent ~ "AVSearch"
		|| req.http.User-Agent ~ "AwarioRssBot"					# brand/marketing - done
		|| req.http.User-Agent ~ "AwarioSmartBot"				# brand/marketing - done
		|| req.http.User-Agent ~ "axios"						# bad
		# B
		|| req.http.User-Agent ~ "Baidu"
		|| req.http.User-Agent ~ "Barkrowler"
		|| req.http.User-Agent ~ "BDCbot"
		|| req.http.User-Agent ~ "bidswitchbot"					# bad
		|| req.http.User-Agent ~ "Bidtellect"
		|| req.http.User-Agent ~ "Blackboard Safeassign"
		|| req.http.User-Agent ~ "BLEXBot"
		|| req.http.User-Agent ~ "Bloglines"
		|| req.http.User-Agent ~ "BorneoBot"
		|| req.http.User-Agent ~ "botify"
		|| req.http.User-Agent ~ "Buck"							# bad
		|| req.http.User-Agent ~ "BuiltWith"
		# C
		|| req.http.User-Agent ~ "CarrierWave"
		|| req.http.User-Agent ~ "CatchBot"
		|| req.http.User-Agent ~ "CATExplorador"				# bad
		|| req.http.User-Agent ~ "CCBot"						# bad
		|| req.http.User-Agent ~ "Centro"
		|| req.http.User-Agent ~ "check_http/"
		|| req.http.User-Agent ~ "CheckMarkNetwork"
		|| req.http.User-Agent ~ "checkout-"
		|| req.http.User-Agent ~ "CISPA"
		|| req.http.User-Agent ~ "Clarabot"
		|| req.http.User-Agent ~ "Cliqzbot"						# bad
		|| req.http.User-Agent ~ "Cloud mapping experiment"
		|| req.http.User-Agent ~ "CMS Crawler"
		|| req.http.User-Agent ~ "coccocbot"					# bad, uses "normal" UA at same time
		|| req.http.User-Agent ~ "COMODO"
		|| req.http.User-Agent ~ "crawler4j"
		# D
		|| req.http.User-Agent ~ "datagnionbot"
		|| req.http.User-Agent ~ "Datanyze"
		|| req.http.User-Agent ~ "Dataprovider"
		|| req.http.User-Agent ~ "Daum"							# bad
		|| req.http.User-Agent ~ "deepcrawl.com"
		|| req.http.User-Agent ~ "digincore"
		|| req.http.User-Agent ~ "Directo-Indexer"
		|| req.http.User-Agent ~ "Discordbot"
		|| req.http.User-Agent ~ "DisqusAdstxtCrawler"
		|| req.http.User-Agent ~ "Dispatch"
		|| req.http.User-Agent ~ "DomainStatsBot"
		|| req.http.User-Agent ~ "Domnutch"
		|| req.http.User-Agent ~ "DotBot"
		|| req.http.User-Agent ~ "downcast"
		|| req.http.User-Agent ~ "dproxy"
		# E
		|| req.http.User-Agent ~ "eContext"
		|| req.http.User-Agent ~ "EnigmaBot"
		|| req.http.User-Agent ~ "Entale bot"					# bad
		|| req.http.User-Agent ~ "en-US\)"
		|| req.http.User-Agent ~ "Exabot"
		|| req.http.User-Agent ~ "Ezooms"
		# F
		|| req.http.User-Agent ~ "Faraday"
		|| req.http.User-Agent ~ "Foregenix"
		|| req.http.User-Agent ~ "fr-crawler"
		|| req.http.User-Agent ~ "FYEO"
		|| req.http.User-Agent ~ "fyeo-crawler"
		# G
		|| req.http.User-Agent ~ "GetIntent"
		|| req.http.User-Agent ~ "gobyus"
		|| req.http.User-Agent ~ "Go-http-client"				# bad, the most biggest issue and mostly from China and arabic countries
		|| req.http.User-Agent ~ "^got "
		|| req.http.User-Agent ~ "GotSiteMonitor"
		|| req.http.User-Agent ~ "GrapeshotCrawler"				# bad
		|| req.http.User-Agent ~ "GT-C3595"
		|| req.http.User-Agent ~ "GuzzleHttp"
		# H
		|| req.http.User-Agent ~ "hackney"
		|| req.http.User-Agent ~ "Hello"
		|| req.http.User-Agent ~ "HotJava"
		|| req.http.User-Agent ~ "htInEdin"
		|| req.http.User-Agent ~ "HTTP Banner Detection"
		|| req.http.User-Agent ~ "hubspot"
		|| req.http.User-Agent ~ "HubSpot"
		# I
		|| req.http.User-Agent ~ "IAB ATQ"
		|| req.http.User-Agent ~ "IAS crawler"					# bad
		|| req.http.User-Agent ~ "ias-"							# bad
		|| req.http.User-Agent ~ "import.io"
		|| req.http.User-Agent ~ "Incutio"
		|| req.http.User-Agent ~ "INGRID/"
		|| req.http.User-Agent ~ "InfoSeek"
		|| req.http.User-Agent ~ "Inst%C3%A4llningar/"
		|| req.http.User-Agent ~ "Internet-structure-research-project-bot"
		|| req.http.User-Agent ~ "istellabot"
		|| req.http.User-Agent ~ "iVoox"
		# J
		|| req.http.User-Agent ~ "Java/"
		|| req.http.User-Agent ~ "Jersey"						# bad
		|| req.http.User-Agent ~ "Jetty"
		|| req.http.User-Agent ~ "JobboerseBot"
		# K
		|| req.http.User-Agent ~ "Kinza"
		|| req.http.User-Agent ~ "KOCMOHABT"
		|| req.http.User-Agent ~ "Kraphio"
		|| req.http.User-Agent ~ "Ktor"
		|| req.http.User-Agent ~ "kubectl"						# malicious
		# L
		|| req.http.User-Agent ~ "Liana"
		|| req.http.User-Agent ~ "LieBaoFast"					# bad
		|| req.http.User-Agent ~ "LightSpeed"
		|| req.http.User-Agent ~ "LightspeedSystemsCrawler"
		|| req.http.User-Agent ~ "linkdexbot"
#		|| req.http.User-Agent ~ "LinkedInBot"					# bad
		|| req.http.User-Agent ~ "linklooker"
		|| req.http.User-Agent ~ "ListenNotes"
		|| req.http.User-Agent ~ "Lycos"
		# M
		|| req.http.User-Agent ~ "magpie-crawler"
		|| req.http.User-Agent ~ "Mail.RU_Bot"
		|| req.http.User-Agent ~ "masscan"
		|| req.http.User-Agent ~ "MauiBot"
		|| req.http.User-Agent ~ "Mb2345Browser"				# bad
		|| req.http.User-Agent ~ "MegaIndex.ru"
		|| req.http.User-Agent ~ "Mercator"
		|| req.http.User-Agent ~ "MixnodeCache"
		|| req.http.User-Agent ~ "MJ12bot"						# good
#		|| req.http.User-Agent ~ "ms-office"
#		|| req.http.User-Agent ~ "MojeekBot"
		|| req.http.User-Agent ~ "MozacFetch"
		|| req.http.User-Agent ~ "MyTuner-ExoPlayerAdapter"
		# N
		|| req.http.User-Agent ~ "Needle"
		|| req.http.User-Agent ~ "NetcraftSurveyAgent"			# bad
		|| req.http.User-Agent ~ "netEstate"
		|| req.http.User-Agent ~ "NetSeer"
		|| req.http.User-Agent ~ "NetSystemsResearch"
		|| req.http.User-Agent ~ "newspaper"					# python3
		|| req.http.User-Agent ~ "Nimbostratus-Bot"				# bad
		|| req.http.User-Agent ~ "Nmap Scripting Engine"
		|| req.http.User-Agent ~ "node-fetch"					# malicious
		|| req.http.User-Agent ~ "Nutch"
		# O
		|| req.http.User-Agent ~ "oBot"
		|| req.http.User-Agent ~ "okhttp"
		|| req.http.User-Agent ~ "oncrawl.com"
		|| req.http.User-Agent ~ "OwlTail"
		# P
		|| req.http.User-Agent ~ "Pandalytics"
		|| req.http.User-Agent ~ "panscient.com"
		|| req.http.User-Agent ~ "PaperLiBot"
		|| req.http.User-Agent ~ "PetalBot"						# same as AspiegelBot
		|| req.http.User-Agent ~ "PhantomJS"
		|| req.http.User-Agent ~ "Photon/"  					# Automattic
		|| req.http.User-Agent ~ "PHP/"
		|| req.http.User-Agent ~ "pimeyes.com"
		|| req.http.User-Agent ~ "PocketCasts"
		|| req.http.User-Agent ~ "Podalong"
		|| req.http.User-Agent ~ "Podchaser-Parser"
		|| req.http.User-Agent ~ "Podimo"
		|| req.http.User-Agent ~ "PodParadise"
		|| req.http.User-Agent ~ "Podscribe"
		|| req.http.User-Agent ~ "Poster"						# malicious
		|| req.http.User-Agent ~ "print\("						# malicious
		|| req.http.User-Agent ~ "proximic"						# bad, really big issue, mostly from Amazon
		|| req.http.User-Agent ~ "python"
		|| req.http.User-Agent ~ "Python"
		# Q
		|| req.http.User-Agent ~ "Quantcastbot"
		|| req.http.User-Agent ~ "Qwantify"
		# R
		|| req.http.User-Agent ~ "R6_"
		|| req.http.User-Agent ~ "Radical-Edward"
		|| req.http.User-Agent ~ "radio.at"
		|| req.http.User-Agent ~ "radio.de"
		|| req.http.User-Agent ~ "radio.dk"
		|| req.http.User-Agent ~ "radio.es"
		|| req.http.User-Agent ~ "radio.fr"
		|| req.http.User-Agent ~ "radio.it"
		|| req.http.User-Agent ~ "radio.net"
		|| req.http.User-Agent ~ "RawVoice Generator"
		|| req.http.User-Agent ~ "Request-Promise"
		|| req.http.User-Agent ~ "RogerBot"
		|| req.http.User-Agent ~ "Rome Client"
		|| req.http.User-Agent ~ "Ruby"
		|| req.http.User-Agent ~ "rss-parser"
		|| req.http.User-Agent ~ "RSSGet"
		# S
		|| req.http.User-Agent ~ "safarifetcherd"
		|| req.http.User-Agent ~ "SafetyNet"
		|| req.http.User-Agent ~ "scalaj-http"
		|| req.http.User-Agent ~ "Scooter"
		|| req.http.User-Agent ~ "Scrapy"
		|| req.http.User-Agent ~ "Screaming Frog SEO Spider"
#		|| req.http.User-Agent ~ "SE 2.X MetaSr 1.0"
		|| req.http.User-Agent ~ "SearchAtlas"
		|| req.http.User-Agent ~ "Seekport"
		|| req.http.User-Agent ~ "seewithkids.com"				# good
		|| req.http.User-Agent ~ "SemanticScholarBot"
		|| req.http.User-Agent ~ "SemrushBot/1.0~bm"			# bad
		|| req.http.User-Agent ~ "SemrushBot/6~bl"				# good
		|| req.http.User-Agent ~ "SemrushBot-BA"
		|| req.http.User-Agent ~ "SEMrushBot"
		|| req.http.User-Agent ~ "SEOkicks"
		|| req.http.User-Agent ~ "serpstatbot"
		|| req.http.User-Agent ~ "SeznamBot"
		|| req.http.User-Agent ~ "Sidetrade"
		|| req.http.User-Agent ~ "SimplePie"
		|| req.http.User-Agent ~ "SiteBot"
		|| req.http.User-Agent ~ "Slack-ImgProxy"
		|| req.http.User-Agent ~ "Slurp"
		|| req.http.User-Agent ~ "SMTBot"
		|| req.http.User-Agent ~ "Sodes/"						# podcaster IP 209.6.245.67
		|| req.http.User-Agent ~ "Sogou"
		|| req.http.User-Agent ~ "socialmediascanner"
		|| req.http.User-Agent ~ "ssearch_bot"
		|| req.http.User-Agent ~ "SSL Labs"
		|| req.http.User-Agent ~ "SurdotlyBot"					# bad
		# T
		|| req.http.User-Agent ~ "Talous"
		|| req.http.User-Agent ~ "tamarasdartsoss.nl"
		|| req.http.User-Agent ~ "tapai"
#		|| req.http.User-Agent ~ "TelegramBot"
		|| req.http.User-Agent ~ "temnos.com"
		|| req.http.User-Agent ~ "Tentacles"					# bad
		|| req.http.User-Agent ~ "Test Certificate Info"		# malicious
		|| req.http.User-Agent ~ "The Incutio XML-RPC PHP Library"	# malicious
		|| req.http.User-Agent ~ "Thumbor"						# bad
		|| req.http.User-Agent ~ "TPA/1.0.0"
		|| req.http.User-Agent ~ "Trade Desk"
		|| req.http.User-Agent ~ "trendictionbot"
		|| req.http.User-Agent ~ "TrendsmapResolver"
		|| req.http.User-Agent ~ "TTD-content"					# bad
		|| req.http.User-Agent ~ "TTD-Content"					# good
		|| req.http.User-Agent ~ "Typhoeus"
		|| req.http.User-Agent ~ "TweetmemeBot"
		|| req.http.User-Agent ~ "Twingly"
		# U
		|| req.http.User-Agent ~ "UCBrowser"
		|| req.http.User-Agent ~ "uipbot"
		|| req.http.User-Agent ~ "UltraSeek"
		|| req.http.User-Agent ~ "um-IC"						# bad
		|| req.http.User-Agent ~ "um-LN"
		|| req.http.User-Agent ~ "User-Agent"
		|| req.http.User-Agent ~ "UniversalFeedParser"			# bad
		# V
		|| req.http.User-Agent ~ "VelenPublicWebCrawler"
		# W
		|| req.http.User-Agent ~ "^w3m"
		|| req.http.User-Agent ~ "WebZIP"
		|| req.http.User-Agent ~ "Wget"
		|| req.http.User-Agent ~ "Who.is"
		|| req.http.User-Agent ~ "willnorris"
		|| req.http.User-Agent ~ "Windows Live Writter"			# malicious
		|| req.http.User-Agent == "Wordpress"					# malicious
		|| req.http.User-Agent ~ "Wordpress.com"
		|| req.http.User-Agent ~ "wp.com"
		# X
		|| req.http.User-Agent ~ "XenForo"
		|| req.http.User-Agent ~ "XoviBot"
		# Y
		|| req.http.User-Agent ~ "YaBrowser"					# bad
		|| req.http.User-Agent ~ "YahooSeeker"
		|| req.http.User-Agent ~ "YaK"							# bad
		|| req.http.User-Agent ~ "Yandex"						# bad
		|| req.http.User-Agent ~ "YisouSpider"
		# Z
		|| req.http.User-Agent ~ "zgrab/"
		|| req.http.User-Agent ~ "zh_CN"						# malicious
		|| req.http.User-Agent ~ "zh-CN"						# malicious
		|| req.http.User-Agent ~ "zh-cn"						# malicious
		|| req.http.User-Agent ~ "ZmEu"
		## Others
		## CFNetwork, Darwin are always bots, but some are useful. 2345Explorer same thing, but practically always harmful
		## Dalvik is VM of android
		|| req.http.User-Agent ~ "eSobiSubscriber"
#		|| req.http.User-Agent ~ "Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.18"
		|| req.http.User-Agent ~ "Opera/9.80 (Windows NT 5.1; U; en) Presto/2.10.289 Version/12.01"
#		|| req.http.User-Agent ~ "Safari/14608.5.12 CFNetwork/978.2 Darwin/18.7.0 (x86_64)" #Maybe Apple, it is checking out mostly only touch-icon.png
		|| req.http.User-Agent ~ "Windows; U; MSIE 9.0; WIndows NT 9.0; de-DE"
#		|| req.http.User-Agent == "Mozilla/5.0(compatible;MSIE9.0;WindowsNT6.1;Trident/5.0)"
#		|| req.http.User-Agent == "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1)"
#		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.1; rv:3.4) Goanna/20180327 PaleMoon/27.8.3"
#		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"
		|| req.http.User-Agent == "Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; de-DE)"
#		|| req.http.User-Agent == "Mozilla/5.8"
		|| req.http.User-Agent ~ "Mozilla/4.0"
		|| req.http.User-Agent ~ "Windows NT 5.1; ru;"
		|| req.http.User-Agent ~ "Windows NT 5.2"
#		|| req.http.User-Agent ~ "(Windows NT 6.0)"
#		|| req.http.User-Agent == "Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko"
#		|| req.http.User-Agent == "'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36'"
#		|| req.http.User-Agent ~ "Mozilla/5.1 (Windows NT 6.0; WOW64)"
		|| req.http.User-Agent == "Linux Mozilla"
		|| req.http.User-Agent == "x22Mozilla/5.0"
		|| req.http.User-Agent ~ "Mozlila"
		) {
			#set req.http.User-Agent = "Bad Bad Bot";
			return(synth(666, "Forbidden Bot"));
			} 

# Empty user agents
	elseif ( req.http.User-Agent == "^$" || req.http.User-Agent == "-") {
			set req.http.User-Agent = "Potatoehead";
			return (synth(666, "Empty User Agent"));
			}

# Nice ones who doesn't follow limits of robots.txt		
	elseif (req.http.User-Agent ~ "Googlebot-Image") {
			if (!req.url ~ "/uploads/|/images/") {
				return(synth(403, "Forbidden"));
			} 
			unset req.http.User-Agent;
		}

# Useful bots				
	elseif (
		  req.http.User-Agent == "KatiskaWarmer"
		# Google
		|| req.http.User-Agent ~ "APIs-Google"
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
			#set req.http.User-Agent = "Good guy";
			#return(pipe);
			unset req.http.User-Agent;
			}

# Technical probes	
	elseif (
		# These are useful and we want to know if backend is working
		   req.http.User-Agent == "Varnish Health Probe"
		|| req.http.User-Agent ~ "Monit"
		|| req.http.User-Agent ~ "WP Rocket/"
		|| req.http.User-Agent ~ "UptimeRobot"
		|| req.http.User-Agent ~ "Matomo"
		) {
			#set req.http.User-Agent = "Probes";
			return(pipe);
			}
			
# Others, like real visitors
	else {
		unset req.http.User-Agent;
		}
	
		# That's all folk.
		
}    