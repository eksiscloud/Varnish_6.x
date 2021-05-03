sub stop_pages {

## I'm really bad at regex, so heads up
## There is a lot WordPress plugins & themes what you might use, so comment those when needed
## I'm killing most of 404 situations at vcl_backend_response. Here only trying an url triggers the error.

#Knock, knock, who's there globally?
	if (
		# ##
	   req.url ~ "^//"
	|| req.url ~ "^/[1-9]/"
	|| req.url ~ "^/[1-9][1-9][1-9][1-9]/"
#	|| req.url ~ "^/[a-z]/"
		# Plugins /wp-content/plugins
	|| req.url ~ "/cherry-plugin/"
	|| req.url ~ "/ct-ultimate-gdpr/"
	|| req.url ~ "/e-signature/"
	|| req.url ~ "/formcraft/"
	|| req.url ~ "/ioptimization/"
	|| req.url ~ "/iva-business-hours-pro/"
	|| req.url ~ "/kaswara/"
	|| req.url ~ "/official-facebook-pixel/"
	|| req.url ~ "/sf-booking/"
	|| req.url ~ "/SimplePie/"
	|| req.url ~ "/store-locator-le/"
	|| req.url ~ "/super-forms/"
	|| req.url ~ "/woocommerce-upload-files/"
	|| req.url ~ "/worprees-plugin-bug-dar/"
	|| req.url ~ "/wp-curriculo-vitae/"
	|| req.url ~ "/wp-db-backup/"
	|| req.url ~ "/wp-file-manager/"
	|| req.url ~ "/wp-hotel-booking/"
		# /wp-admin/
	|| req.url ~ "/wp-admin/admin-ajax.php\?action\=revslider_show_image\&img\=../wp-config.php"
	|| req.url ~ "/wp-admin/asd.php"
	|| req.url ~ "/wp-admin/class-adminsbar.php"
	|| req.url ~ "/wp-admin/css/Marvins.php"
	|| req.url ~ "/wp-admin/images/uni.php"
	|| req.url ~ "/wp-admin/network/"
	|| req.url ~ "/wp-admin/upload_index.php"
	|| req.url ~ "/wp-admin/user/back-up.php"
	|| req.url ~ "/wp-admin/user/wp-select.php"
	|| req.url ~ "/wp-admin/wp-signups.php"
		# /wp-includes/
	|| req.url ~ "/wp-includes/blocks/content-po.php"
	|| req.url ~ "/wp-includes/customize/class-wp-customize-background-image-setting-ajax.php"
	|| req.url ~ "/wp-includes/Requests/IPv4.php"
	|| req.url ~ "/wp-includes/Requests/IRI-meta.php"
	|| req.url ~ "/wp-includes/sodium_compat/namespaced/Core/Curve25519/GeP4.php"
	|| req.url ~ "/wp-includes/js/crop/locales.php"
	|| req.url ~ "/wp-includes/js/jcrop/Jcrop.php"
	|| req.url ~ "/wp-includes/Text/Diff/Renderer/ma.php"
	|| req.url ~ "/wp-includes/theme-compat/back-up.php"
	|| req.url ~ "/wp-includes/js/thickbox/preview.php"
	|| req.url ~ "/wp-includes/wlwmanifest.xml"
		# /wp-content/
	|| req.url ~ "/wp-content/bees.php"
	|| req.url ~ "/wp-content/force-download.php"
	|| req.url ~ "/wp-content/plugins/wp-types.php"
	|| req.url ~ "/wp-content/themes/wp-update.php"
	|| req.url ~ "/wp-content/uploads/file-manager/"
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
		# JS
	|| req.url ~ "bootstrap.min.js"
	|| req.url ~ "jquery-3.2.1.min.js"
	|| req.url ~ "jquery.ajaxchimp.min.js"
		# A
	|| req.url ~ "\.aspx"
	|| req.url ~ "Account/ValidateCode/"
	|| req.url ~ "Account/LoginToIbo"
	|| req.url ~ "^/actuator/"
	|| req.url ~ "^/adform/"				# ad company, bot is using regular UA
	|| req.url ~ "^/Admin"
	|| req.url ~ "^/administrator/"
	|| req.url ~ "^/air-venturi-controls"
	|| req.url ~ "^/ajax/"
	|| req.url ~ "/alternate-lite/"
	|| req.url ~ "/apismtp/"
	|| req.url ~ "^/app/"
	|| req.url ~ "^/apply"
	|| req.url ~ "^/archive/"
#	|| req.url ~ "^/assets/"
	|| req.url ~ "^/at-domino"
	|| req.url ~ "^/at-grizzle-suvi-lehto"
	|| req.url ~ "^/atutor"
	|| req.url ~ "^/authorization/"
	|| req.url ~ "autodiscover.xml"
		# B
	|| req.url ~ "^/backup/"
	|| req.url ~ "backup.sql"
	|| req.url ~ ".bak$"
	|| req.url ~ "/bitrix/"
	|| req.url ~ "^/bk/"
	|| req.url ~ "^/_blog/"
	|| req.url ~ "^/blog/"
	|| req.url ~ "^/blogs/"
	|| req.url ~ "BlogTypeView.do"
	|| req.url ~ "/boaform/"
	|| req.url ~ "/brandfolder/"
		# C
	|| req.url ~ "^/cache/accesson.php"
	|| req.url ~ "/candidate-application-form/"
	|| req.url ~ "/catalog/bedding-bed-bath.jsp"
	|| req.url ~ "^/CFIDE/"
	|| req.url ~ "^/cgi-bin/config.exp"
	|| req.url ~ "^/checkout/"
	|| req.url ~ "^/cgi-bin/test-cgi"
	|| req.url ~ "^/cms/"
	|| req.url ~ "^/codes$"
	|| req.url ~ "^/compra/"
	|| req.url ~ "^/config/config.ini"
	|| req.url ~ "^/config.ini"
	|| req.url ~ "/configuration.php.[1-9]"
	|| req.url ~ "/configuration.php.backup"
	|| req.url ~ "/configuration.php.old"
	|| req.url ~ "^/console"
	|| req.url ~ "^/Content/"
	|| req.url ~ "^/cv/"
		# D
	|| req.url ~ "^/dana-na/"
	|| req.url ~ "^/database/"
	|| req.url ~ "^/database.sql"
	|| req.url ~ "/db_dump.sql"
	|| req.url ~ "^/config/database.yml"
	|| req.url ~ "^/config/databases.yml"
	|| req.url ~ "^/db/"
	|| req.url ~ "^/demo/"
	|| req.url ~ "^/deployment-config.json"
	|| req.url ~ "/desktopmodules/"
	|| req.url ~ "^/dev/"
	|| req.url ~ "^/DEV/"
	|| req.url ~ "/div.woocommerce-product-gallery__image"
	|| req.url ~ "^/downloader$"
		# E
	|| req.url ~ "^/ec-js"
	|| req.url ~ "^/EcNg"
	|| req.url ~ "^/edd-api"
	|| req.url ~ "/engl/slem.php"
	|| req.url ~ "/\.env"
	|| req.url ~ "/env.example"
	|| req.url ~ "^/error.phtml"
	|| req.url ~ "/errors/"
	|| req.url ~ "^/evox"
		# F
	|| req.url ~ "/fckeditor/"
	|| req.url ~ "/feature/legal-notices.jsp"
	|| req.url ~ "/feed/wp-admin/"
	|| req.url ~ "/feed/wp-includes/"
	|| req.url ~ "^/_finance_doubledown"
	|| req.url ~ "^/fr/"
	|| req.url ~ "^/\.ftpconfig"
	|| req.url ~ "^/ftp-sync.json"
	|| req.url ~ "^/ftpsync.settings"
	|| req.url ~ "^/fullchain.pem"
		# G
	|| req.url ~ "^/genre/"
	|| req.url ~ "^/\.git/"
	|| req.url ~ "^/graphql"
		# H
	|| req.url ~ "^/heibing"
	|| req.url ~ "^/HNAP[1-9]/"
	|| req.url ~ "^/HNAPI/"
	|| req.url ~ "^/home/"
	|| req.url ~ "^/horde/"
	|| req.url ~ "ht.access"
	|| req.url ~ "/htmlV/"
	|| req.url ~ "^/hudson"
		# I
	|| req.url ~ "^/i/"
	|| req.url ~ "/_input_3_vuln.htm"
	|| req.url ~ "IdentifyingCode/index"
	|| req.url ~ "/idcsalud-client"
	|| req.url ~ "/idx-config"
	|| req.url ~ "/_ignition/"
	|| req.url ~ "/\.images.jpg/"
	|| req.url ~ "^/include/"
	|| req.url ~ "/inc/settings.php"
	|| req.url ~ "/indeed-smart-popup/"
	|| req.url ~ "^/inject.phtml"
	|| req.url ~ "/themes/index.php"
	|| req.url ~ "^/infe/verify/mkcode"
	|| req.url ~ "^/install.php"
	|| req.url ~ "^/installation$"
		# J
	|| req.url ~ "/jm-ajax/upload_file"
	|| req.url ~ "/js/html5.php"
	|| req.url ~ "/js_inst/"
	|| req.url ~ "/js/mctabs.php"
	|| req.url ~ "^/js/lib/"
	|| req.url ~ "^/js/mage/"
	|| req.url ~ "^/js/varien/"
		# K
	|| req.url ~ "/katiskainfo.sql"
	|| req.url ~ "^/kauppa/wp-json"
		# L
	|| req.url ~ "/themes/loader.php"
	|| req.url ~ "^/\.local"
	|| req.url ~ "login.action"
	|| req.url ~ "login.asp"
	|| req.url ~ "login.cgi"
	|| req.url ~ "/login\?from"
	|| req.url ~ "login.jsp"
	|| req.url ~ "^/v/user/login"
	|| req.url ~ "^/lostpassword"
	|| req.url ~ "^/lucee/"
	|| req.url ~ "/luci"
	|| req.url ~ "^/lwes/"
		# M
	|| req.url ~ "^/magento/"
	|| req.url ~ "magento_version"
	|| req.url ~ "^/main/"
	|| req.url ~ "mainfunction.cgi"
	|| req.url ~ "^/manager/"
	|| req.url ~ "^/maximo/"
	|| req.url ~ "mdocuments-library"
	|| req.url ~ "^/__media__//"
	|| req.url ~ "^/medias$"
	|| req.url ~ "/media-library-assistant/"
	|| req.url ~ "/mifs/"
	|| req.url ~ "^/misc/"
	|| req.url ~ "^/modules/"
	|| req.url ~ "^/myadmin/"
	|| req.url ~ "^/mysql/"
	|| req.url ~ "mysql.sql"
		# N
	|| req.url ~ "^/new/"
	|| req.url ~ "^/news/"
	|| req.url ~ "nmaplowercheck"
		# O
	|| req.url ~ "^/.old"
	|| req.url ~ "^/old/"
	|| req.url ~ "^/OLD/"
	|| req.url ~ "/owa/"
		# P
	|| req.url ~ "phpMyAdmin"
	|| req.url ~ "^/phpmyadmin"
	|| req.url ~ "^/phpunit/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/src/Util/PHP/eval-stdin.php"
	|| req.url ~ "^/phpunit/Util/PHP/eval-stdin.php"
	|| req.url ~ "/picserror/"
	|| req.url ~ "/plugins/backup_index.php"
	|| req.url ~ "/plugins/press/"
	|| req.url ~ "^/plugins/system/debug/debug.xml"
	|| req.url ~ "^/pma"
	|| req.url ~ "^/Pma"
	|| req.url ~ "^/pma/print.css"
	|| req.url ~ "/pomo/"
	|| req.url ~ "/portal/"
	|| req.url ~ "^/\.production"
	|| req.url ~ "/PSIGW/"
	|| req.url ~ "^/pub/"
	|| req.url ~ "^/public/"
	|| req.url ~ "^/public_html/"
		# Q
	|| req.url ~ "/quadmenu/"
		# R
	|| req.url ~ "^/recommender/"
	|| req.url ~ "/related_users/"
	|| req.url ~ "^/\.remote"
	|| req.url ~ "^/remote/"
	|| req.url ~ "/rms_unique_wp_mu_pl_fl_nm.php"
	|| req.url ~ "^/replacelivedb"
	|| req.url ~ "^/rss/catalog/notifystock"
	|| req.url ~ "^/rss/order/new"
		# S
	|| req.url ~ "^/\.save"
	|| req.url ~ "^connectors/resource/s_eval.php"
	|| req.url ~ "^/Scripts/"
	|| req.url ~ "^/cache/seo_script.php"
	|| req.url ~ "^/sdk/"
	|| req.url ~ "^/search_replace_bd"
	|| req.url ~ "^/search-replace-bd"
	|| req.url ~ "^/Search_Replace_DB"
	|| req.url ~ "^/Search-Replace-DB"
	|| req.url ~ "^/Search_Replace_Db"
	|| req.url ~ "^/Search-Replace-Db"
	|| req.url ~ "^/search_replace_db"
	|| req.url ~ "^/search-replace-db"
	|| req.url ~ "^/Search-Replace-bd-master"
	|| req.url ~ "^/Search-Replace-BD-master"
	|| req.url ~ "^/Search_Replace_BD_master"
	|| req.url ~ "^/search_replace_bd_master"
	|| req.url ~ "^/search_replace_db_master"
	|| req.url ~ "^/Search_Replace_DB_master"
	|| req.url ~ "^/searchreplacedb2.php"
	|| req.url ~ "^/searchreplacegetweb"
	|| req.url ~ "^/search-replace-web"
	|| req.url ~ "^/secret_sauce"
	|| req.url ~ "^/sellers.json"
	|| req.url ~ "serviceAg/rest/loginProcess/login"
	|| req.url ~ "^/shared/"
	|| req.url ~ "^/shell"
	|| req.url ~ "^/shop/"
	|| req.url ~ "^/statics/"
#	|| req.url ~ "^/site/"
	|| req.url ~ "/site.sql"
	|| req.url ~ "^/sites/"
	|| req.url ~ "^/skin/"
	|| req.url ~ "/solr/"
	|| req.url ~ "source.sql"
	|| req.url ~ "/SQlite"
	|| req.url ~ "/SQLite"
	|| req.url ~ "/sqlite"
	|| req.url ~ "/staging/"
	|| req.url ~ "^/static/"
	|| req.url ~ "^/store/"
	|| req.url ~ "^/struts/"
	|| req.url ~ "/superforms"
	|| req.url ~ ".suspected"
	|| req.url ~ "^/\.svn"
	|| req.url ~ "^/SYS/"
		# T
	|| req.url ~ "telerik"
	|| req.url ~ "Telerik"
	|| req.url ~ "/telescope/"
	|| req.url ~ "^/temp/"
	|| req.url ~ "^/templates/"
	|| req.url ~ "^/test/"
	|| req.url ~ "/Text/Diff/"
	|| req.url ~ "^/themes/"
	|| req.url ~ "/theplus_elementor_addon/"
	|| req.url ~ "^/tmp/"
	|| req.url ~ "/toutu/"
	|| req.url ~ "^/TP/"
		# U
	|| req.url ~ "/_ui/"
	|| req.url ~ "/upgrade/myaccount/order_status_login.jsp"
		# V
#	|| req.url ~ "^/v[1-9]/"
	|| req.url ~ "VMobile\ Cheque\ DayBAKIT"
	|| req.url ~ "^/vpn/"
	|| req.url ~ "/vuln.htm"
		# W
	|| req.url ~ "^/wallet/"
	|| req.url ~ "wallet.dat"
	|| req.url ~ "^/web/"
	|| req.url ~ "web.config.txt"
	|| req.url ~ "/web.rar"
	|| req.url ~ "web.sql"
	|| req.url ~ "^/webshop/"
	|| req.url ~ "^/website/"
	|| req.url ~ "\.well-known/autoconfig/mail/config-v1.1.xml"
	|| req.url ~ "^/w00tw00t"
	|| req.url ~ "^/wordpress/"
	|| req.url ~ "/wordpress/wp-admin/"
	|| req.url ~ "/wordpress/wp-login.php"
	|| req.url ~ "/wordpress/xmlrpc.php"
	|| req.url ~ "^/wp/"
	|| req.url ~ "^/wp[1-9]/"
	|| req.url ~ "wp-con-new"
	|| req.url ~ "wp-con-old"
	|| req.url ~ "/wp-content/wp2.php"
	|| req.url ~ "wp_admins_list.txt"
	|| req.url ~ "/wp-config-backup"
	|| req.url ~ "/wp-config.php[1-9]"
	|| req.url ~ "/wp-config[1-9]"
	|| req.url ~ "/wp-config.[1-9]"
	|| req.url ~ "/wp-config[1-9].txt"
	|| req.url ~ "/wp-config.php.backup"
	|| req.url ~ "/wp-config-save"
	|| req.url ~ "/wp_config.php.old"
	|| req.url ~ "/wp-configuration.php_orig"
	|| req.url ~ "/wp-configuration.php_original"
	|| req.url ~ "/wp-strongs"
	|| req.url ~ "/wpstaff"
		# X 
	|| req.url ~ "^/x.htm"
		# Y
	|| req.url ~ "^/YMfQ"
	|| req.url ~ "^/yts/"
		# Z
	) {
	#if (std.ip(req.http.X-Real-IP, "0.0.0.0") !~ ipslist) {
	#	return(synth(666, "The site is unreachable"));
	#	}
		return(synth(403, "Security issue"));
	}
		
	# Fake referers
	# These shouldn't be active, because nginx is taking care of them
	if (
		   req.http.Referer ~ "site.ru"
		|| req.http.Referer ~ "www.google.com.hk"
		|| req.http.Referer ~ "google.ru"
		|| req.http.Referer ~ "ivi-casinoz.ru"
		|| req.http.Referer ~ "zvuqa.net"
		|| req.http.Referer ~ "mp3for.pro"
		|| req.http.Referer ~ "www.facebook.net"
		|| req.http.Referer ~ "clan.su"
		|| req.http.Referer ~ "cn.bing.com"
		|| req.http.Referer ~ "api.gxout.com"
		|| req.http.Referer ~ "7ooo.ru"
		|| req.http.Referer ~ "oknativeplants.org"
		|| req.http.Referer ~ "pcreparatieamersfoort.nl"
		|| req.http.Referer ~ "bassin.ru"
		|| req.http.Referer ~ "mytuner-radio.com"			# podcast\-service, lies UA as googlebot
		|| req.http.Referer ~ "jasacucisofasemarang.net"
		|| req.http.Referer ~ "coffre\-fort\-pro.com"
		|| req.http.Referer ~ "howtovinyl.com"
		|| req.http.Referer ~ "yorkguildhallorchestra.com"
		|| req.http.Referer ~ "lyndon.com"
		|| req.http.Referer ~ "hangprolift.com"
		|| req.http.Referer ~ "elizabethtownrent.com"
		|| req.http.Referer ~ "glitteratinaillounge.com"
		|| req.http.Referer ~ "micasademadera.com"
		|| req.http.Referer ~ "kancelaria-skarzysko.pl"
		|| req.http.Referer ~ "sauvellevodka.com"
		|| req.http.Referer ~ "stemgen.net"
		|| req.http.Referer ~ "turtlecoverealty.com"
		|| req.http.Referer ~ "buchhandlung\-langenargen.de"
		|| req.http.Referer ~ "johnsmithphotography.net"
		|| req.http.Referer ~ "howtoplayroulette.biz"
		|| req.http.Referer ~ "smogsimple.com"
		|| req.http.Referer ~ "miltonrow.com"
		|| req.http.Referer ~ "istanaorganik.com"
		|| req.http.Referer ~ "nicoleroeschfitness.com"
		|| req.http.Referer ~ "alexandriacolorworks.com"
		|| req.http.Referer ~ "stuntmasterscup.com"
		|| req.http.Referer ~ "up888dream.com"
		|| req.http.Referer ~ "rcrrs.com"
		|| req.http.Referer ~ "almatatour.com"
		|| req.http.Referer ~ "etrafika.net"
		) {
			return(synth(666, "The site is frozen"));
		}


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
	
# Want to visit pro.katiska.info?
if (req.http.host == "pro.katiska.info") {
		if (
			   req.url ~ "wp-login.php"
			|| req.url ~ "xmlrpc.php"
		) {
			return(synth(666, "Server is confused"));
			}
		
	}

# Want to visit pro.eksis.one?
if (req.http.host == "pro.eksis.one") {
		if (
			   req.url ~ "wp-login.php"
			|| req.url ~ "xmlrpc.php"
		) {
			return(synth(666, "Server is confused"));
			}
		
	}
	
# will end here
}