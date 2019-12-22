sub stop_pages {

#Knock, knock, who's there globally?
	if (
	req.url ~ ".sql"
	|| req.url ~ "functions.php"
	|| req.url ~ "administrator"
	|| req.url ~ "oo.aspx"
	|| req.url ~ "wp-config.txt"
	|| req.url ~ "wp-config.php~"
	|| req.url ~ "webconfig.txt.php"
	|| req.url ~ "wp-config.php.swp"
	|| req.url ~ "/backup"
	|| req.url ~ "/pwa-sw.js"
	|| req.url ~ "/pwa-amp-sw.js"
	|| req.url ~ "/customizer.php"
	|| req.url ~ "config/database.yml"
	|| req.url ~ "config/databases.yml"
	|| req.url ~ "newsr.php"
	|| req.url ~ "changelog.txt"
	|| req.url ~ "readme.txt"
	|| req.url ~ "login.aspx"
	|| req.url ~ "ftpsync.settings"
	|| req.url ~ "deployment-config.json"
	|| req.url ~ "sftp.json"
	|| req.url ~ "ftp-sync.json"
	|| req.url ~ "remote-sync.json"
	|| req.url ~ ".ftpconfig"
	|| req.url ~ "sftp-config.json"
	|| req.url ~ "phpMyAdmin"
	|| req.url ~ "pma"
	|| req.url ~ "modx.js"
	|| req.url ~ "wp-config.xml"
	|| req.url ~ "mootools.js"
	|| req.url ~ "magento"
	|| req.url ~ "bitcoin"
	|| req.url ~ "wallet"
	|| req.url ~ "app-ads.txt"
	|| req.url ~ "blog/wp-login.php"
	|| req.url ~ ".old"
	|| req.url ~ ".bak"
	|| req.url ~ ".backup"
	|| req.url ~ ".orig"
	|| req.url ~ ".original"
	|| req.url ~ ".save"
	|| req.url ~ ".git"
	|| req.url ~ ".rar"
	|| req.url ~ "tmp"
	|| req.url ~ "dev"
	|| req.url ~ "wp-json/wp/v2/users"
	|| req.url ~ "autodiscover.xml"
	|| req.url ~ "portal"
	|| req.url ~ "cms"
	|| req.url ~ "/fullchain.pem"
	) {
		return(synth(429, "Forbidden URL"));
		}

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