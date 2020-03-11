sub stop_pages {

## I'm really bad at regex, so heads up
## These suits for me but you may and will have different needs
## Synth error 666 is for fail2ban

#Knock, knock, who's there globally?
	if (
		req.url ~ "bitcoin"
		# wp-admin
	|| req.url ~ "/wp-admin/includes.php"
	|| req.url ~ "/wp-admin/plugin-install.php"
	|| req.url ~ "/wp-admin/user/root.php"
		# wp-content
	|| req.url ~ "/wp-content/jssor-slider/"
	|| req.url ~ "/wp-content/uploads/2018/10/seo_script.php"
	|| req.url ~ "/wp-content/vuln.php"
	|| req.url ~ "/wp-content/wp-link.php"
	|| req.url ~ "/wp-content/wp-moud.php"
		# wp-plugins
	|| req.url ~ "/wp-content/plugins/accessally/"
	|| req.url ~ "/wp-content/plugins/akismet/"
	|| req.url ~ "/wp-content/plugins/all-in-one-seo-pack/"
	|| req.url ~ "/wp-content/plugins/apikey/"
	|| req.url ~ "/wp-content/plugins/barclaycart/"
	|| req.url ~ "/wp-content/plugins/batchmove/"
	|| req.url ~ "/wp-content/plugins/blnmrpb/"
	|| req.url ~ "/wp-content/plugins/brizy/"
	|| req.url ~ "/wp-content/plugins/category-page-icons/"
	|| req.url ~ "/wp-content/plugins/CCSlider/"
	|| req.url ~ "/wp-content/plugins/cherry-plugin/"
	|| req.url ~ "/wp-content/plugins/contact-form-7/login.php"
	|| req.url ~ "/wp-content/plugins/contus-hd-flv-player/uploadVideo.php"
	|| req.url ~ "/wp-content/plugins/delete-all-comments/"
	|| req.url ~ "/wp-content/plugins/downloads-manager/"
	|| req.url ~ "/wp-content/plugins/e-preview.php/"
	|| req.url ~ "/wp-content/plugins/flexible-checkout-fields/"
	|| req.url ~ "/wp-content/plugins/formcraft/"
	|| req.url ~ "/wp-content/plugins/hd-webplayer/"
	|| req.url ~ "/wp-content/plugins/indeed-membership-pro/"
	|| req.url ~ "/wp-content/plugins/iwp-client/"
	|| req.url ~ "/wp-content/plugins/wp-mobile-detector/"
	|| req.url ~ "/wp-content/plugins/pricing-table-by-supsystic/"
	|| req.url ~ "/wp-content/plugins/profile-builder/"
	|| req.url ~ "/wp-content/plugins/profile-builder-pro/"
	|| req.url ~ "/wp-content/plugins/strong-testimonials/"
	|| req.url ~ "/wp-content/plugins/trx_addons/"
	|| req.url ~ "/wp-content/plugins/ungallery/"
	|| req.url ~ "/wp-content/plugins/uploadify/"
	|| req.url ~ "/wp-content/plugins/xlen/"
	|| req.url ~ "/wp-content/plugins/xXx/"
	|| req.url ~ "/wp-content/plugins/wd-google-maps/"
	|| req.url ~ "/wp-content/plugins/viral-optins/"
	|| req.url ~ "/wp-content/plugins/wordpress-database-reset/"
	|| req.url ~ "/wp-content/plugins/wp-central/"
	|| req.url ~ "/wp-content/plugins/wp-support-plus-responsive-ticket-system/"
	|| req.url ~ "/wp-content/plugins/wp-time-capsule/"
	|| req.url ~ "/wp-content/plugins/ultimate-member/"
		# wp-themes
	|| req.url ~ "/wp-content/themes/pagse.php"
	|| req.url ~ "/wp-content/themes/sahifa/header-cache.php.suspected"
	|| req.url ~ "/wp-content/themes/themes.php"
	|| req.url ~ "/wp-content/themes/twentynineteen/sass/"
	|| req.url ~ "/wp-content/themes/wp-conns.php"
	|| req.url ~ "/wp-content/themes/wp-sign.php"
		# wp-login
	|| req.url ~ "/backup/wp-login.php"
	|| req.url ~ "/blog/wp-login.php"
	|| req.url ~ "/cms/wp-login.php"
	|| req.url ~ "/news/wp-login.php"
	|| req.url ~ "/site/wp-login.php"
	|| req.url ~ "/test/wp-login.php"
	|| req.url ~ "/web/wp-login.php"
	|| req.url ~ "/website/wp-login.php"
	|| req.url ~ "/wordpress/wp-login.php"
		# wp-includes
	|| req.url ~ "/wp-includes/bad.db.php"
	|| req.url ~ "/wp-includes/wp-tmp.php"
		# wp-config
	|| req.url ~ "/wp-config.txt"
	|| req.url ~ "/wp-config.php~"
	|| req.url ~ "/wp-config.php.[1-99]"
	|| req.url ~ "/wp-config.php.disabled"
	|| req.url ~ "/wp-config.php.new"
	|| req.url ~ "/wp-config.php.swp"
	|| req.url ~ "/.wp-config.php.SWP"
	|| req.url ~ "/wp-config.xml"
	|| req.url ~ "^/wp-config.old"
	|| req.url ~ "^/wp-config.php.old"
	|| req.url ~ "^/wp-config.php.save"
	|| req.url ~ "^/wp-config.save"
		# A
	|| req.url ~ "Account/ValidateCode/"
	|| req.url ~ "Account/LoginToIbo"
	|| req.url ~ "^/adform/IFrameManager.html"
	|| req.url ~ "^/administrator/"
	|| req.url ~ "^/app-ads.txt"
	|| req.url ~ "^/app/member/"
	|| req.url ~ "^/apply"
	|| req.url ~ "^/assets/"
	|| req.url ~ "^/authorization/"
	|| req.url ~ "autodiscover.xml"
#	|| req.url ~ "avtogear63_ru_cron.php"
		# B
#	|| req.url ~ ".backup"
	|| req.url ~ "^/backup/"
#	|| req.url ~ "background-image-cropper"
	|| req.url ~ ".bak$"
	|| req.url ~ "/bitrix/"
	|| req.url ~ "^/bk/"
	|| req.url ~ "^/blog/$"
		# C
	|| req.url ~ "^/cache/accesson.php"
	|| req.url ~ "^captcha.php"
#	|| req.url ~ "changelog.txt"
	|| req.url ~ "^check.php"
	|| req.url ~ "^/cms/"
	|| req.url ~ "^/_config.cache.php"
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
	|| req.url ~ "/div.woocommerce-product-gallery__image"
	|| req.url ~ "^doc.php"
	|| req.url ~ "^downloader$"
		# E
	|| req.url ~ "^/edd-api"
	|| req.url ~ "^/.env"
		# F
	|| req.url ~ "/feed/wp-admin/"
	|| req.url ~ "/feed/wp-includes/"
	|| req.url ~ "^/.ftpconfig"
	|| req.url ~ "^/ftp-sync.json"
	|| req.url ~ "^/ftpsync.settings"
	|| req.url ~ "^/fullchain.pem"
	|| req.url ~ "^/functions.php"
		# G
	|| req.url ~ "^/.git/"
	|| req.url ~ "^/graphql$"
		# H
	|| req.url ~ "^/home/"
		# I
	|| req.url ~ "^/_input_3_vuln.htm"
	|| req.url ~ "IdentifyingCode/index"
	|| req.url ~ "img.ewww_webp_lazy_load"
	|| req.url ~ "^/inject.phtml"
	|| req.url ~ "^/index[0-9].php"
	|| req.url ~ "^/infe/verify/mkcode"
	|| req.url ~ "^/installation$"
	|| req.url ~ "^/installer.php"
		# J
	|| req.url ~ "/jm-ajax/upload_file"
		# .js 
	|| req.url ~ "^/banner_b.js"
	|| req.url ~ "bootstrap.min.js"
	|| req.url ~ "^/clipboard.min.js"
	|| req.url ~ "jquery-3.2.1.min.js"
	|| req.url ~ "jquery.ajaxchimp.min.js"
	|| req.url ~ "^/js/"
	|| req.url ~ "/mail-script.js"
#	|| req.url ~ "modx.js"
#	|| req.url ~ "mootools.js"
	|| req.url ~ "/popper.js"
	|| req.url ~ "^/pwa-sw.js"
	|| req.url ~ "^/pwa-amp-sw.js"
	|| req.url ~ "/stellar.js"
	|| req.url ~ "/theme.js"
		# K 
	|| req.url ~ "^/kauppa/wp-json"
		# L
	|| req.url ~ "^/lib/phpunit/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/lib/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "login.aspx"
	|| req.url ~ "^/v/user/login"
		# M
	|| req.url ~ "^/magento/"
	|| req.url ~ "magento_version"
	|| req.url ~ "^/main/"
	|| req.url ~ "^medias$"
	|| req.url ~ "^/myadmin/print.css"
	|| req.url ~ "^/mysql/print.css"
		# N
	|| req.url ~ "^/new/"
#	|| req.url ~ "newsr.php"
		# O
	|| req.url ~ "^/.old"
	|| req.url ~ "^/old/"
	|| req.url ~ "^/OLD/"
	|| req.url ~ ".orig"
	|| req.url ~ ".original"
#	|| req.url ~ "oo.aspx"
		# P
#	|| req.url ~ "pages.php"
	|| req.url ~ "phpmyadm"
	|| req.url ~ "phpMyAdmin"
	|| req.url ~ "phpmyadmin"
#	|| req.url ~ "phpshell.php"
#	|| req.url ~ "phpsysinfo"
#	|| req.url ~ "phpSQLiteAdmin"
	|| req.url ~ "^/phpunit/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/Util/PHP/eval-stdin.php"
#	|| req.url ~ "phpunit.xsd"
#	|| req.url ~ "phpwebalbum"
	|| req.url ~ "^/plugins/system/debug/debug.xml"
	|| req.url ~ "^/pma"
	|| req.url ~ "^/Pma"
	|| req.url ~ "^/pma/print.css"
	|| req.url ~ "^/portal/"
	|| req.url ~ "^/portfolio/"
	|| req.url ~ "^/public/"
		# R
#	|| req.url ~ ".rar"
#	|| req.url ~ "readme.txt"
#	|| req.url ~ "reflex-gallery"
#	|| req.url ~ "remote-sync.json"
#	|| req.url ~ "replace.php"
	|| req.url ~ "^/rss/catalog/notifystock"
	|| req.url ~ "^/rss/order/new"
		# S
	|| req.url ~ "^/.save"
	|| req.url ~ "^connectors/resource/s_eval.php"
	|| req.url ~ "^/cache/seo_script.php"
	|| req.url ~ "/sellers.json"
	|| req.url ~ "^/seo_script.php"
	|| req.url ~ "serviceAg/rest/loginProcess/login"
	|| req.url ~ "settings_auto.php"
#	|| req.url ~ "sftp-config.json"
#	|| req.url ~ "sftp.json"
	|| req.url ~ "^/shop/"
	|| req.url ~ "^/site/"
	|| req.url ~ "^/staging/"
	|| req.url ~ "^/store"
	|| req.url ~ "^/.svn/"
	|| req.url ~ "^/.sql"
		# T
	|| req.url ~ "^/test/*$"
	|| req.url ~ "^//test/"
	|| req.url ~ "^test.php"
	|| req.url ~ "^/temp/"
	|| req.url ~ "^/templates/protostar/html/modules.php"
	|| req.url ~ "^/tmp/"
		# U
	|| req.url ~ "/_ui/"
	|| req.url ~ "^/unzip.php"
	|| req.url ~ "^/unzipper.php"
	|| req.url ~ "^/urlreplace.php"
	|| req.url ~ "^/user/"
	|| req.url ~ "^/wp-json/wp/v2/users"
		# V
	|| req.url ~ "^/v[1-9]/"
	|| req.url ~ "^/validate.php"
	|| req.url ~ "^/vendor/"
	|| req.url ~ "^/vuln.htm"
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
	|| req.url ~ ".well-known/autoconfig/mail/config-v1.1.xml"
	|| req.url ~ "^/wool.php"
#	|| req.url ~ "^/wordpress/"
	|| req.url ~ "^/wp/"
	|| req.url ~ "^/wp[1-9]/"
#	|| req.url ~ "wp-po.php"
	|| req.url ~ "wp_admins_list.txt"
	|| req.url ~ "^/wp-counts.php"
	|| req.url ~ "^/wp-demos.php"
	|| req.url ~ "^/wp-engines.php$"
	|| req.url ~ "^/wp-interst.php"
	|| req.url ~ "^/wp-networks.php$"
	|| req.url ~ "^/wp-remote-upload.php"
	|| req.url ~ "^/wp-upload-class.php"
		# X 
	|| req.url ~ "^x.html"
	##
	|| req.url ~ "^/[2000-2020]/"
	|| req.url ~ "^/[1-9]/"

	) {
		return(synth(666, "The site is frozen"));
		}

	# Dead domain that bad bots try reach
	if (
		   req.url == "https://eksis.cloud"
		|| req.url == "http://eksis.cloud"
		) {
			return(synth(666, "Server is confused"));
			}
		
	#these are fake referers
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
# Want to visit Jagster.fi?
if (req.http.host == "jagster.fi" || req.http.host == "www.jagster.fi") {
		if (
			req.url ~ "/adminer"
		) {
			return(synth(666, "Server is confused"));
			}
	}
	
# will end here
}
