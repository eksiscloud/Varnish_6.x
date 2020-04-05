# varnish_6.x
My working copy of stack Nginx+Varnish+Apache2 with several virtual hosts, bad-bot, closed 403-urls etc.

Heads up - this is from live setup, so remember change at least urls.

The stack is:
- Nginx listening 80 and 443, redirecting from 80 to 443
- Nging is ternminating SSL and taking care HTTP/2
- Varnish is listening port 8080
- Apache2 is listening port 81

I'm using Fail2ban to ban IP of bots too. Overkill?

jail.local:

[varnish-666]
port = http,https
filter = varnish-666
logpath  = /var/log/varnish/varnishncsa.log
maxretry = 1
findtime = 24h
bantime = -1
enabled = true

filter:

[Definition]
failregex = ^<HOST>\, .*  - - .* "(GET|POST|HEAD).*HTTP.*" 666 .* .* .*$

ignoreregex =
