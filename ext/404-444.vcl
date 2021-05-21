###### This worked but it didn't exacly what I hoped, so this sub is archived now

sub endless_void {

## One part of fight against scropt kiddies.
## Bunch of really simple rules I'm using to get error 444 effect. Similar as Nginx gives.
## Not the best workaround, but the only way I can do with my very limited skills.
##
## This is made for useless tries getting error 404. That's why all this must be included in vcl_backend_response.
##
## I'm redirecting requests to default virtual host of Nginx and serving error 444 from there.
## At same time Fail2ban will ban every request reaching default when a request is using plain IP-address or these redirects.
## If I just gives an error after 404 hit, that request shows up in 404-logs like in WordPress because of custom 404 page.
## log_not_found off; directive works only in the very last point, like when Nginx is serving its own building error 404.
##
## Example of virtual host in Nginx:
##
##	server {
##		listen 104.248.141.204:80 default;
##		server_name _;
##
##		access_log   /var/log/nginx/access-ip.log;
##		error_log    /var/log/nginx/error-ip.log;
##		# First must deny everything, as giving error 403
##		location / { 
##			deny all; 
##		}
##		# Then must deny root. Otherwise Nginx will serve Wellcome.. page
##		location = / {
##			deny all;
##		}
##		# Now all redirects, and other requests, get error 444
##		location ~*	{
##			try_files $uri $uri/ =444;
##		}
##	}

## And the fun begins

# Because I'm so lousy at regex, 404-444.vcl will be triggered when this is requested: 
	if (bereq.url !~ "/wp-json/") {

		# This watches only the root directory and some file types
		if (beresp.status == 404 && bereq.url ~ "^/([a-z0-9_\.-]+).(asp|aspx|php|js|jsp|rar|zip|tar|gz)") {
			set beresp.status = 999;
		}
		
	}

}

##### This was at vcl_deliver ########

	if (resp.status == 999) {
		return(synth(999, "http://104.248.141.204" + req.url));
	}

###### I had this at vcl_synth  #########

	if (resp.status == 999) {
	# I use special error status 999 to force 301 redirects
		set resp.http.Location = resp.reason;
		set resp.status = 301;
		return(deliver);
	}