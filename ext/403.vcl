sub stop_pages {

## I'm really bad at regex, so heads up

#Knock, knock, who's there globally?
	if (
		# A
	   req.url ~ "Account/ValidateCode/"
	|| req.url ~ "Account/LoginToIbo"
	|| req.url ~ "^/adform/IFrameManager.html"
	|| req.url ~ "^/administrator/"
	|| req.url ~ "^/ajax/"
	|| req.url ~ "^/api/"
	|| req.url ~ "^/app/"
	|| req.url ~ "^/app/member/"
	|| req.url ~ "^/apply"
	|| req.url ~ "^/archive/"
	|| req.url ~ "^/assets/"
	|| req.url ~ "^/authorization/"
	|| req.url ~ "autodiscover.xml"
		# B
	|| req.url ~ "^/backup/"
	|| req.url ~ ".bak$"
	|| req.url ~ "/bitrix/"
	|| req.url ~ "^/bk/"
	|| req.url ~ "^/_blog/"
	|| req.url ~ "^/blog/$"
	|| req.url ~ "BlogTypeView.do"
		# C
	|| req.url ~ "^/cache/accesson.php"
	|| req.url ~ "^/captcha.php"
	|| req.url ~ "^/check.php"
	|| req.url ~ "^/cms/"
	|| req.url ~ "^/compra/"
	|| req.url ~ "^/_config.cache.php"
	|| req.url ~ "^/Content/"
	|| req.url ~ "^/css/"
	|| req.url ~ "^/customizer.php"
		# D
	|| req.url ~ "^/data/"
	|| req.url ~ "^/database/"
	|| req.url ~ "^/config/database.yml"
	|| req.url ~ "^/config/databases.yml"
	|| req.url ~ "^/db/"
	|| req.url ~ "^/demo/"
	|| req.url ~ "^/deployment-config.json"
	|| req.url ~ "^/dev/"
	|| req.url ~ "^/DEV/"
	|| req.url ~ "/div.woocommerce-product-gallery__image"
	|| req.url ~ "^/doc.php"
	|| req.url ~ "^/downloader$"
		# E
	|| req.url ~ "^/ec-js"
	|| req.url ~ "^/EcNg"
	|| req.url ~ "^/edd-api"
	|| req.url ~ "/eksis-cloud/"
	|| req.url ~ "/.env"
		# F
	|| req.url ~ "/fckeditor/"
	|| req.url ~ "/feed/wp-admin/"
	|| req.url ~ "/feed/wp-includes/"
	|| req.url ~ "^/_finance_doubledown"
	|| req.url ~ "^/fr/"
	|| req.url ~ "^/.ftpconfig"
	|| req.url ~ "^/ftp-sync.json"
	|| req.url ~ "^/ftpsync.settings"
	|| req.url ~ "^/fullchain.pem"
	|| req.url ~ "^/functions.php"
		# G
	|| req.url ~ "^/.git/"
	|| req.url ~ "^/graphql"
		# H
	|| req.url ~ "^/heibing"
	|| req.url ~ "^/home/"
		# I
	|| req.url ~ "^/i/"
	|| req.url ~ "^/_input_3_vuln.htm"
	|| req.url ~ "IdentifyingCode/index"
	|| req.url ~ "/idcsalud-client"
	|| req.url ~ "img.ewww_webp_lazy_load"
	|| req.url ~ "^/inject.phtml"
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
	|| req.url ~ "^/js/"
	|| req.url ~ "/mail-script.js"
	|| req.url ~ "matomo.js"
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
	|| req.url ~ "^/lib/phpunit/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/.local"
	|| req.url ~ "login.aspx"
	|| req.url ~ "^/v/user/login"
	|| req.url ~ "^/lwes/"
		# M
	|| req.url ~ "^/magento/"
	|| req.url ~ "magento_version"
	|| req.url ~ "^/main/"
	|| req.url ~ "mainfunction.cgi"
	|| req.url ~ "^/manager/"
	|| req.url ~ "matomo.php"
	|| req.url ~ "^/medias$"
	|| req.url ~ "^/myadmin/print.css"
	|| req.url ~ "^/mysql/print.css"
	|| req.url ~ "mysql.sql"
		# N
	|| req.url ~ "^/new/"
		# O
	|| req.url ~ "^/.old"
	|| req.url ~ "^/old/"
	|| req.url ~ "^/OLD/"
	|| req.url ~ "^/oo.aspx"
	|| req.url ~ ".orig"
	|| req.url ~ ".original"
		# P
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
	|| req.url ~ "^/.production"
	|| req.url ~ "^/pub/"
	|| req.url ~ "^/public/"
	|| req.url ~ "^/public_html/"
		# R
	|| req.url ~ "^/recommender/"
	|| req.url ~ "/related_users/"
	|| req.url ~ "^/.remote"
	|| req.url ~ "^/rss/catalog/notifystock"
	|| req.url ~ "^/rss/order/new"
		# S
	|| req.url ~ "^/.save"
	|| req.url ~ "^connectors/resource/s_eval.php"
	|| req.url ~ "^/Scripts/"
	|| req.url ~ "^/cache/seo_script.php"
	|| req.url ~ "^/secret_sauce"
	|| req.url ~ "^/sellers.json"
	|| req.url ~ "^/seo_script.php"
	|| req.url ~ "serviceAg/rest/loginProcess/login"
	|| req.url ~ "settings_auto.php"
	|| req.url ~ "^/shared/"
	|| req.url ~ "^/shop/"
	|| req.url ~ "^/statics/"
	|| req.url ~ "^/sites/"
	|| req.url ~ "^/skin/"
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
		# W
	|| req.url ~ "^/wallet/"
	|| req.url ~ "wallet.dat"
	|| req.url ~ "^/web/"
	|| req.url ~ "web.config.txt"
	|| req.url ~ "^/webconfig.txt.php"
	|| req.url ~ "^/webshop/"
	|| req.url ~ ".well-known/autoconfig/mail/config-v1.1.xml"
	|| req.url ~ "^/wool.php"
	|| req.url ~ "^//"
	|| req.url ~ "^/wordpress/*$"
	|| req.url ~ "^/wordpress/wp-admin/*$"
	|| req.url ~ "^/wp/"
	|| req.url ~ "^/wp[1-9]/"
	|| req.url ~ "wp_admins_list.txt"
	|| req.url ~ "^/wp-counts.php"
	|| req.url ~ "^/wp-demos.php"
	|| req.url ~ "^/wp-engines.php$"
	|| req.url ~ "^/wp-interst.php"
	|| req.url ~ "^/wp-networks.php$"
	|| req.url ~ "^/wp-remote-upload.php"
	|| req.url ~ "^/wp-upload-class.php"
		# X 
	|| req.url ~ "^/x.htm"
		# Y
	|| req.url ~ "^/yts/"
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
		|| req.http.Referer ~ "www.facebook.net/"
		) {
			return(synth(666, "The site is frozen"));
			}

## These are per domain when I can't use generic ones
# Want to visit EksisONE?
if (req.http.host == "eksis.one" || req.http.host == "www.eksis.one") {
		if (
			   req.url ~ "/adminer"
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
			   req.url ~ "/adminer"
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
			   req.url ~ "/adminer"
			|| req.http.User-Agent ~ "jetmon"
			|| req.http.User-Agent ~ "Jetpack by WordPress.com"
		) {
			return(synth(666, "Server is confused"));
			}
	}
	
# will end here
}
