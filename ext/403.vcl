sub stop_pages {

#Knock, knock, who's there globally?
	if (
		req.url ~ "bitcoin"
		# wp-admin
	|| req.url ~ "wp-admin/class-wp-main.php"
	|| req.url ~ "wp-admin/css/post.php"
	|| req.url ~ "wp-admin/newsletter.php"
		# wp-content
	|| req.url ~ "wp-content/plugins/akismet/_inc/form.js"
	|| req.url ~ "wp-content/plugins/apikey/apikey.php"
	|| req.url ~ "wp-content/plugins/contact-form-7/login.php"
	|| req.url ~ "wp-content/plugins/delete-all-comments/delete-all-comments.php"
	|| req.url ~ "wp-content/plugins/ultimate-member/core/lib/upload/um-image-upload.php"
	|| req.url ~ "wp-content/themes/sahifa/header-cache.php.suspected"
	|| req.url ~ "wp-content/themes/twentynineteen/sass/site/post.php"
	|| req.url ~ "wp-content/themes/walser/themify/css/themify-ui.css"
	|| req.url ~ "wp-content/themes/wp-conns.php"
	|| req.url ~ "wp-content/uploads/2018/10/seo_script.php"
	|| req.url ~ "wp-content/wflogs/rules.php"
		# wp-includes
	|| req.url ~ "wp-includes/class.wp.php"
	|| req.url ~ "wp-includes/css/dist/components/post.php"
	|| req.url ~ "wp-includes/js/tinymce/plugins/tabfocus/post.php"
	|| req.url ~ "wp-includes/js/tinymce/plugins/wpautoresize/post.php"
	|| req.url ~ "wp-includes/SimplePie/Content/post.php"
	|| req.url ~ "wp-includes/SimplePie/XML/post.php"
		# wp-login
	|| req.url ~ "backup/wp-login.php"
	|| req.url ~ "blog/wp-login.php"
	|| req.url ~ "cms/wp-login.php"
	|| req.url ~ "news/wp-login.php"
	|| req.url ~ "site/wp-login.php"
	|| req.url ~ "test/wp-login.php"
	|| req.url ~ "web/wp-login.php"
	|| req.url ~ "website/wp-login.php"
	|| req.url ~ "wordpress/wp-login.php"
		# wp-config
	|| req.url ~ "wp-config.txt"
	|| req.url ~ "wp-config.php~"
	|| req.url ~ "wp-config.php.swp"
	|| req.url ~ "wp-config.xml"
		# A
	|| req.url ~ "administrator"
	|| req.url ~ "app-ads.txt"
	|| req.url ~ "autodiscover.xml"
		# B
	|| req.url ~ ".backup"
	|| req.url ~ "/backup/"
	|| req.url ~ ".bak"
		# C
	|| req.url ~ "changelog.txt"
	|| req.url ~ "cms"
#	|| req.url ~ "/customizer.php"
		# D
	|| req.url ~ "config/database.yml"
	|| req.url ~ "config/databases.yml"
	|| req.url ~ "/demo/"
	|| req.url ~ "deployment-config.json"
	|| req.url ~ "dev"
		# E
	|| req.url ~ "edd-api"
	|| req.url ~ ".env"
		# F
	|| req.url ~ "home/favicon.ico"
	|| req.url ~ ".ftpconfig"
	|| req.url ~ "ftp-sync.json"
	|| req.url ~ "ftpsync.settings"
	|| req.url ~ "/fullchain.pem"
	|| req.url ~ "/functions.php"
		# G
	|| req.url ~ ".git"
		# H
	|| req.url ~ "/home/"
		# I
	|| req.url ~ "installer.php"
		# L
	|| req.url ~ "login.aspx"
		# M
	|| req.url ~ "magento"
	|| req.url ~ "/main/"
	|| req.url ~ "modx.js"
	|| req.url ~ "mootools.js"
		# N
	|| req.url ~ "/new/"
	|| req.url ~ "newsr.php"
		# O
	|| req.url ~ ".old"
	|| req.url ~ ".orig"
	|| req.url ~ ".original"
	|| req.url ~ "oo.aspx"
		# P
	|| req.url ~ "phpmyadm"
	|| req.url ~ "phpMyAdmin"
	|| req.url ~ "phpmyadmin"
	|| req.url ~ "phpshell.php"
	|| req.url ~ "phpsysinfo"
	|| req.url ~ "phpSQLiteAdmin"
	|| req.url ~ "phpwebalbum"
	|| req.url ~ "pma"
	|| req.url ~ "Pma"
	|| req.url ~ "portal"
	|| req.url ~ "/pwa-sw.js"
	|| req.url ~ "/pwa-amp-sw.js"
		# R
	|| req.url ~ ".rar"
	|| req.url ~ "readme.txt"
	|| req.url ~ "remote-sync.json"
	|| req.url ~ "replace.php"
		# S
#	|| req.url ~ ".save"
	|| req.url ~ "/connectors/resource/s_eval.php"
	|| req.url ~ "cache/seo_script.php"
	|| req.url ~ "sftp-config.json"
	|| req.url ~ "sftp.json"
	|| req.url ~ ".sql"
		# T
	|| req.url ~ "/test/"
	|| req.url ~ "tmp"
		# U
	|| req.url ~ "unzip.php"
	|| req.url ~ "unzipper.php"
	|| req.url ~ "urlreplace.php"
#	|| req.url ~ "wp-json/wp/v2/users"
		# W
	|| req.url ~ "wallet"
	|| req.url ~ "/web/"
	|| req.url ~ "webconfig.txt.php"
	|| req.url ~ "wool.php"
	|| req.url ~ "/wordpress/"
	|| req.url ~ "/wp/"
	|| req.url ~ "wp-po.php"
	) {
		return(synth(429, "Forbidden URL"));
		}

## These are just examples

# Want to visit Katiska?
if (req.http.host == "katiska.info" || req.http.host == "www.katiska.info") {
		if (
			req.url ~ "/adminer"
			|| req.url ~ "/_adminer"
		) {
			return(synth(429, "Forbidden URL"));
			}
	}
	
# Want to visit KatiskaPro?
if (req.http.host == "pro.katiska.info") {
		if (
			req.url ~ "/adminer"
			|| req.url ~ "/_adminer"
		) {
			return(synth(429, "Forbidden URL"));
			}
	}
	
# Want to visit EksisONE?
if (req.http.host == "eksis.one" || req.http.host == "www.eksis.one") {
		if (
			req.url ~ "/adminer"
			|| req.url ~ "/_adminer"
			|| req.url ~ "^eksis.cloud"
		) {
			return(synth(429, "Forbidden URL"));
			}
	}


}
