Suomeksi: README-FI.md

# varnish_6.6
My working copy of stack Nginx+Varnish+Apache2 with several virtual hosts, bad-bot, unauth 403-urls, GeoIP etc.

Most of this works with older Varnis 6.x (<6.4) versions, but then you have to compile cookie VMOD. Or use ordinary regex.

Heads up - this is from live setup, so remember change at least urls.
And because of same reason I have some solution that suits for me, but surely not for you.

Always be really carefully when you do copy&paste from anywhere.

## The stack

The stack is:
- Nginx listening 80 and 443, redirecting from 80 to 443
- Nging is terminating SSL and taking care of HTTP/2
- Varnish is listening port 8080
- Apache2 is listening port 81

## The setup of Varnish

- default.vcl is doing general things
- all-cookie.vcl is cleaning cookies etc.
- all-vhost.vcl is including all virtual hosts
- sites-enabled/*.vcl are the sites
- ext/filtering/bad-bot.vcl is killing bots and is quite useless because Nginx is doing same thing (error 444). 
- ext/404.vcl is used to do some general 404- and 410 redirects (more or less just a test)
- ext/403.vcl stops knockers. Be really careful if you use something like this. It is easy to stop usefull stuff too.
- ext/monit.vcl is for monit and letsenctypt.vcl for Lets Encryt (it is from time I was trying Hitch; waste of time)
- error/*.html are special error pages, not in use

I'm using Fail2ban to ban IP of bots too. Overkill?

I've tried comment everything but all I've done are quite basic things and self explaining. Some doesn't work or do weird things.

## Efficiency of caching
- WordPress works just fine and caching rate is high
- WooCommerce isn't not so good, and I have some strange redirect issue when logging out; getting error 500. I'm using so called duct tape fix there. The issue isn't in Varbish I reckon, but WooCommerce/plugins. Related with that, or not, links to Gravity form when an url is generated by Offload SES doesn't work.
- It it just impossible to get Discourse behind Varnish. I can do some filtering and after that must pipe, pass isn't enough. An issue with cookies?
- MediaWiki caches only to unregistered users and an user who hasn't logged in on 30 days time. Cookie UserName must be allowed, unless it is impossible to login, but in same time ut stops caching. I can do filtering, though.
- Moodle must pass and it just hates Varnish. Moodle has its own way to cache, though. There must be some yet unsolved cookie issue.
- Gitea is really difficult to cache. Easier choice is filtering first and after that pass.

## Disclaimer
This README isn't accurate and things are changing all the time. Sorry, but I'm lazy and after all - this is more or less just another hobby to me.
