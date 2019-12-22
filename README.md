# varnish_6.x
My working copy of stack Nginx+Varnish+Apache2 with several virtual hosts, bad-bot, closed 403-urls etc.

Heads up - this is from live setup, so remember change at least urls.

The stack is:
- Nginx listening 80 and 443, redirecting from 80 to 443
- Nging is ternminating SSL and taking care HTTP/2
- Varnish is listening port 8080
- Apache2 is listening port 81
