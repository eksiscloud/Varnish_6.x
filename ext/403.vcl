sub stop_pages {

## I'm really bad at regex, so heads up

#Knock, knock, who's there globally?
	if (
		# ##
	   req.url ~ "/[1-9].php"
	|| req.url ~ "^/0.php"
	|| req.url ~ "/[1-9][1-9][1-9][1-9].php"
	|| req.url ~ "^/403.php"
		# A
	|| req.url ~ "Account/ValidateCode/"
	|| req.url ~ "Account/LoginToIbo"
	|| req.url ~ "^/adform/"				# ad company, bot is usein regular UA
	|| req.url ~ "^/admin.php"
	|| req.url ~ "^/administrator/"
	|| req.url ~ "^/ajax/"
	|| req.url ~ "^/api/"
	|| req.url ~ "^/app/"
	|| req.url ~ "^/app/member/"
	|| req.url ~ "^/apply"
	|| req.url ~ "^/archive/"
	|| req.url ~ "^/assets/"
	|| req.url ~ "^/atutor"
	|| req.url ~ "^/authorization/"
	|| req.url ~ "autodiscover.xml"
		# B
	|| req.url ~ "^/backup/"
	|| req.url ~ ".bak$"
	|| req.url ~ "/bitrix/"
	|| req.url ~ "^/bk/"
	|| req.url ~ "/BLL.php"
	|| req.url ~ "^/_blog/"
	|| req.url ~ "^/blog/$"
	|| req.url ~ "BlogTypeView.do"
		# C
	|| req.url ~ "^/cache_.php"
	|| req.url ~ "^/cache/accesson.php"
	|| req.url ~ "^/captcha.php"
	|| req.url ~ "^/cgi-bin/test-cgi"
	|| req.url ~ "check.aspx"
	|| req.url ~ "^/check.php"
	|| req.url ~ "^/cms/"
	|| req.url ~ "^/compra/"
	|| req.url ~ "^/_config.cache.php"
	|| req.url ~ "^/console"
	|| req.url ~ "^/Content/"
	|| req.url ~ "^/content-post.php"
	|| req.url ~ "^/coollse.php"
	|| req.url ~ "/cox.php"
	|| req.url ~ "^/css/"
	|| req.url ~ "^/customizer.php"
	|| req.url ~ "/cv.php"
		# D
	|| req.url ~ "^/dana-na/"
	|| req.url ~ "^/data/"
	|| req.url ~ "^/database/"
	|| req.url ~ "^/database.sql"
	|| req.url ~ "^/db.copy.php"
	|| req.url ~ "^/config/database.yml"
	|| req.url ~ "^/config/databases.yml"
	|| req.url ~ "^/db/"
	|| req.url ~ "/db.php"
	|| req.url ~ "^/demo/"
	|| req.url ~ "^/deployment-config.json"
	|| req.url ~ "/desktopmodules/"
	|| req.url ~ "^/dev/"
	|| req.url ~ "^/DEV/"
	|| req.url ~ "/div.woocommerce-product-gallery__image"
	|| req.url ~ "^/doc.php"
	|| req.url ~ "^/downloader$"
		# E
	|| req.url ~ "^/ec-js"
	|| req.url ~ "^/EcNg"
	|| req.url ~ "^/edd-api"
	|| req.url ~ "/.env"
	|| req.url ~ "^/evox"
		# F
	|| req.url ~ "/fckeditor/"
	|| req.url ~ "/feed/wp-admin/"
	|| req.url ~ "/feed/wp-includes/"
	|| req.url ~ "^/_finance_doubledown"
	|| req.url ~ "^/form.php"
	|| req.url ~ "/fozi.php"
	|| req.url ~ "^/fr/"
	|| req.url ~ "^/.ftpconfig"
	|| req.url ~ "^/ftp-sync.json"
	|| req.url ~ "^/ftpsync.settings"
	|| req.url ~ "^/fullchain.pem"
	|| req.url ~ "^/functions.php"
		# G
	|| req.url ~ "^/general.php"
	|| req.url ~ "^/.git/"
	|| req.url ~ "^/graphql"
		# H
	|| req.url ~ "^/header-cache.php"
	|| req.url ~ "^/heibing"
	|| req.url ~ "^/HNAP[1-9]/"
	|| req.url ~ "^/HNAPI/"
	|| req.url ~ "^/home/"
	|| req.url ~ "/home.asp"
	|| req.url ~ "^/horde/"
	|| req.url ~ "ht.access"
	|| req.url ~ "/htmlV/"
		# I
	|| req.url ~ "^/i/"
	|| req.url ~ "^/_input_3_vuln.htm"
	|| req.url ~ "IdentifyingCode/index"
	|| req.url ~ "/idcsalud-client"
	|| req.url ~ "/.images.jpg/"
	|| req.url ~ "img.ewww_webp_lazy_load"
	|| req.url ~ "^/inject.phtml"
	|| req.url ~ "/index.asp"
	|| req.url ~ "^/index[0-9].php"
	|| req.url ~ "^/infe/verify/mkcode"
	|| req.url ~ "^/installation$"
	|| req.url ~ "^/installer.php"
	|| req.url ~ "^/installer-backup.php"
		# J
	|| req.url ~ "/jm-ajax/upload_file"
	|| req.url ~ "/js_inst/"
	|| req.url ~ "/.json"
		# .js 
	|| req.url ~ "adconfig-"
	|| req.url ~ "appconfig-"
	|| req.url ~ "^/banner_b.js"
	|| req.url ~ "bootstrap.min.js"
	|| req.url ~ "^/clipboard.min.js"
	|| req.url ~ "jquery-3.2.1.min.js"
	|| req.url ~ "jquery.ajaxchimp.min.js"
#	|| req.url ~ "^/js/"
	|| req.url ~ "/mail-script.js"
#	|| req.url ~ "matomo.js"
	|| req.url ~ "^/popper.js"
	|| req.url ~ "^/pwa-sw.js"
	|| req.url ~ "^/pwa-amp-sw.js"
	|| req.url ~ "rapid-init.js"
	|| req.url ~ "rapidworker-1.2.js"
	|| req.url ~ "/stellar.js"
	|| req.url ~ "/theme.js"
		# K
	|| req.url ~ "^/kauppa/wp-json"
		# L
	|| req.url ~ "/Leonas.php"
#	|| req.url ~ "^/lib/"
	|| req.url ~ "^/license.php"
	|| req.url ~ "^/.local"
#	|| req.url ~ "^/login/"
	|| req.url ~ "login.action"
	|| req.url ~ "login.aspx"
	|| req.url ~ "login.cgi"
	|| req.url ~ "/login?from"
	|| req.url ~ "^/v/user/login"
	|| req.url ~ "/luci"
	|| req.url ~ "^/lwes/"
		# M
	|| req.url ~ "^/magento/"
	|| req.url ~ "magento_version"
	|| req.url ~ "^/main/"
	|| req.url ~ "mainfunction.cgi"
	|| req.url ~ "/Mamha.php"
	|| req.url ~ "^/manager/"
#	|| req.url ~ "matomo.php"
	|| req.url ~ "^/medias$"
	|| req.url ~ "^/misc/"
	|| req.url ~ "^/myadmin/print.css"
	|| req.url ~ "^/mysql/print.css"
	|| req.url ~ "mysql.sql"
		# N
	|| req.url ~ "^/new/"
	|| req.url ~ "^/newsleter.php"
	|| req.url ~ "new_license.php"
	|| req.url ~ "nmaplowercheck"
		# O
	|| req.url ~ "^/.old"
	|| req.url ~ "^/old/"
	|| req.url ~ "^/OLD/"
	|| req.url ~ "^/oo.aspx"
	|| req.url ~ ".orig"
	|| req.url ~ ".original"
	|| req.url ~ "/owa/"
		# P
	|| req.url ~ "/pasts.php"
	|| req.url ~ "/phpminiadmin.php"
	|| req.url ~ "phpmyadm"
	|| req.url ~ "phpMyAdmin"
	|| req.url ~ "phpmyadmin"
	|| req.url ~ "^/phpunit/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "/picserror/"
	|| req.url ~ "^/plugins/system/debug/debug.xml"
	|| req.url ~ "^/pma"
	|| req.url ~ "^/Pma"
	|| req.url ~ "^/pma/print.css"
	|| req.url ~ "^/portal/"
	|| req.url ~ "^/priv.php"
	|| req.url ~ "^/.production"
	|| req.url ~ "^/pub/"
	|| req.url ~ "^/public/"
	|| req.url ~ "^/public_html/"
		# R
	|| req.url ~ "^/recommender/"
	|| req.url ~ "/related_users/"
	|| req.url ~ "^/.remote"
	|| req.url ~ "^/remote/"
	|| req.url ~ "^/replace.php"
	|| req.url ~ "^/rss/catalog/notifystock"
	|| req.url ~ "^/rss/order/new"
		# S
	|| req.url ~ "/s.php"
	|| req.url ~ "^/.save"
	|| req.url ~ "^connectors/resource/s_eval.php"
	|| req.url ~ "^/Scripts/"
	|| req.url ~ "^/cache/seo_script.php"
	|| req.url ~ "^/sdk"
	|| req.url ~ "^/search.php"
	|| req.url ~ "^/searchreplacedb2.php"
	|| req.url ~ "^/secret_sauce"
	|| req.url ~ "^/sellers.json"
	|| req.url ~ "^/seo_script.php"
	|| req.url ~ "serviceAg/rest/loginProcess/login"
	|| req.url ~ "settings_auto.php"
	|| req.url ~ "^/shared/"
	|| req.url ~ "^/shell.php"
	|| req.url ~ "^/shop/"
	|| req.url ~ "^/statics/"
	|| req.url ~ "^/sites/"
	|| req.url ~ "^/skin/"
	|| req.url ~ "/SQlite"
	|| req.url ~ "/SQLite"
	|| req.url ~ "/sqlite"
	|| req.url ~ "^/staging/"
	|| req.url ~ "^/static/"
	|| req.url ~ "^/store"
	|| req.url ~ "^/struts/"
	|| req.url ~ ".suspected"
	|| req.url ~ "^/.svn/"
	|| req.url ~ "^/SYS/"
		# T
	|| req.url ~ "Telerik.Web.UI.WebResource.axd"
	|| req.url ~ "^/temp/"
	|| req.url ~ "^/templates/"
	|| req.url ~ "^/test/*$"
	|| req.url ~ "^//test/"
	|| req.url ~ "^/test.php"
	|| req.url ~ "^/themes/"
	|| req.url ~ "^/tmp/"
	|| req.url ~ "/toutu/"
		# U
	|| req.url ~ "/_ui/"
	|| req.url ~ "^/unzip.php"
	|| req.url ~ "^/unzipper.php"
	|| req.url ~ "^/urlreplace.php"
	|| req.url ~ "^/user/"
#	|| req.url ~ "^/wp-json/wp/v2/users"
		# V
	|| req.url ~ "^/v[1-9]/"
	|| req.url ~ "^/validate.php"
	|| req.url ~ "VMobile Cheque DayBAKIT"
	|| req.url ~ "/vuln.htm"
	|| req.url ~ "/vuln.php"
		# /vendors/
	|| req.url ~ "/vendors/animate-css/"
	|| req.url ~ "/vendors/counter-up/"
	|| req.url ~ "/vendors/isotope/"
	|| req.url ~ "/vendors/linericon/"
	|| req.url ~ "/vendors/nice-select/"
	|| req.url ~ "/vendors/owl-carousel/"
	|| req.url ~ "/vendors/popup/"
	|| req.url ~ "/vendors/scroll/"
	|| req.url ~ "/vendors/swiper/"
	|| req.url ~ "^/vpn/"
		# W
	|| req.url ~ "^/wallet/"
	|| req.url ~ "wallet.dat"
	|| req.url ~ "\?wanna_play_with_me"
	|| req.url ~ "^/web/"
	|| req.url ~ "web.config.txt"
	|| req.url ~ "^/webconfig.txt.php"
	|| req.url ~ "^/webshop/"
	|| req.url ~ ".well-known/autoconfig/mail/config-v1.1.xml"
#	|| req.url ~ "^/wool.php"
	|| req.url ~ "^//"
	|| req.url ~ "^/wp/"
	|| req.url ~ "^/wp[1-9]/"
	|| req.url ~ "wp_admins_list.txt"
	|| req.url ~ "^/wp-ajax-hook.php"
	|| req.url ~ "^/wp-api.php"
	|| req.url ~ "wp-bk-report.php"
	|| req.url ~ "wp-block-plugin.php"
	|| req.url ~ "wp-block-plugin-[1-9].php"
	|| req.url ~ "wp-build-report.php"
	|| req.url ~ "wp-build-report-conf.php"
	|| req.url ~ "/wp-config.php[1-9]"
	|| req.url ~ "/wp-config.php.backup"
	|| req.url ~ "/wp-config[1-9].txt"
	|| req.url ~ "/wp-conten[1-9].php"
	|| req.url ~ "/wp-content/force-download.php"
	|| req.url ~ "/wp-content/uploads/file-manager/"
	|| req.url ~ "^/wp-counts.php"
	|| req.url ~ "wp-craft-report.php"
	|| req.url ~ "wp-craft-report-site.php"
	|| req.url ~ "^/wp-demos.php"
	|| req.url ~ "^/wp-engines.php$"
	|| req.url ~ "wp-hello-plugin.php"
	|| req.url ~ "wp-hello-plugin-[1-9].php"
	|| req.url ~ "^/wp-interst.php"
	|| req.url ~ "^/wp-networks.php$"
	|| req.url ~ "wp-pr.php"
	|| req.url ~ "^/wp-remote-upload.php"
	|| req.url ~ "wp-simple-plugin.php"
	|| req.url ~ "wp-simple-plugin-[1-9].php"
	|| req.url ~ "wp-upd.php"
	|| req.url ~ "^/wp-upload-class.php"
	|| req.url ~ "wp-xml.php"
	|| req.url ~ "wp-zip-plugin.php"
	|| req.url ~ "wp-zip-plugin-[1-9].php"
	|| req.url ~ "/wrm.php"
	|| req.url ~ "/wss.php"
		# X 
	|| req.url ~ "^/x.htm"
		# Y
	|| req.url ~ "^/yts/"
		# Z
	|| req.url ~ "^/.*.zip"
	) {
		return(synth(666, "The site is frozen"));
		}
		
	# Fake referers
	if (
		   req.http.Referer ~ "site.ru"
		|| req.http.Referer ~ "www.google.com.hk"
		|| req.http.Referer ~ "ivi-casinoz.ru"
		|| req.http.Referer ~ "zvuqa.net"
		|| req.http.Referer ~ "mp3for.pro"
		|| req.http.Referer ~ "www.facebook.net"
		|| req.http.Referer ~ "cn.bing.com"
		|| req.http.Referer ~ "api.gxout.com"
		|| req.http.Referer ~ "7ooo.ru"
		|| req.http.Referer ~ "oknativeplants.org"
		) {
			return(synth(666, "The site is frozen"));
			}

## Non exist php at the root of a wordpress
#if (
#	   !req.http.host == "pro.eksis.one"
#	|| !req.http.host == "pro.katiska.one"
#	|| !req.http.host == "stats.eksis.eu"
#	) {
#		if (req.url ~ "^/.*.php") {
#			if (
#				   !req.url ~ "^/index.php"
#				|| !req.url ~ "^/wp\-.*.php"
#				|| !req.url ~ "^/xmlrpc.php"
#				) {
#					return(synth(666, "Unknown request"));
#					}
#		}
#	}

## I have one domain where is directory wordpress. Elsewhere it should give error 666
#if (!req.http.host ~ "eksis.one" && req.url ~ "^/wordpress") {
#		return(synth(666, "The site is frozen"));
#	}

## These are per domain when I can't use generic ones
# Want to visit EksisONE?
if (req.http.host == "eksis.one" || req.http.host == "www.eksis.one") {
		if (
			   req.url ~ "/adminer/"
			|| req.url ~ "^/vendor/"
			|| req.http.User-Agent ~ "jetmon"
			|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		) {
			return(synth(666, "Server is confused"));
			}
	}
	
# Want to visit Jagster.fi?
if (req.http.host == "jagster.fi" || req.http.host == "www.jagster.fi") {
		if (
			   req.url ~ "/adminer/"
			|| req.url ~ "^/vendor/"
			|| req.http.User-Agent ~ "jetmon"
			|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		) {
			return(synth(666, "Server is confused"));
			}
	}
	
# Want to visit Katiska.info?
if (req.http.host == "katiska.info" || req.http.host == "www.katiska.info") {
		if (
			   req.url ~ "/adminer/"
			|| req.http.User-Agent ~ "jetmon"
			|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		) {
			return(synth(666, "Server is confused"));
			}
		
	}
	
# will end here
}