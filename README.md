# varnish_6.x
My working copy of stack Nginx+Varnish+Apache2 with several virtual hosts, bad-bot, closed 403-urls etc.

Heads up - this is from live setup, so remember change at least urls.
And because of same reason I have some solution that suits for me, but surely not for you.

Always be really carefully when you do copy&paste from anywhere.

##The stack

The stack is:
- Nginx listening 80 and 443, redirecting from 80 to 443
- Nging is terminating SSL and taking care of HTTP/2
- Varnish is listening port 8080
- Apache2 is listening port 81

##The setup of Varnish

- default.vcl is doing general things
- all-common.vcl is cleaning cookies etc.
- all-vhost.vcl is including all virtual hosts
- /sites-enabled/*.vcl are the sites
- /ext/bad-bot.vcl is killing bots and is quite useless because Nginx is doing same thing (error 444). 
- /ext/404.vcl is used to do some general 404- and 410 redirects (more or less just a test)
- /ext/403.vcl stops knockers. Be really careful if you use something like this. It is easy to stop usefull stuff too.
- /ext/monit.vcl is for monit and letsenctypt.vcl for Lets Encryt (it is from time I was trying Hitch; waste of time)
- /error/*.html are special error pages, not in use

I'm using Fail2ban to ban IP of bots too. Overkill?

I've tried comment everything but everything is quite basic thigs and self explaining. Some doesn't work or do weird things.

