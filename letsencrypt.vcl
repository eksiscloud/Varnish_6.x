vcl 4.1;

probe bottisondi {
    .request =
      "HEAD / HTTP/1.1"
      "Host: www.katiska.info"
      "Connection: close"
      "User-Agent: Varnish Health Probe";
	.timeout = 3s;
	.interval = 5s;
	.window = 5;
	.threshold = 3;
#				.url = "/ads.txt";
#				.timeout = 1s;
#				.interval = 5s;
#				.window = 5;
#				.threshold = 3;
}

backend certbot {
    .host = "127.0.0.1";
    .port = "81";
    .probe = bottisondi;
}

sub vcl_recv {
    if (req.url ~ "^/\.well-known/acme-challenge/") {
		if (req.http.User-Agent ~ "Let\'s Encrypt validation server") {
			set req.backend_hint = certbot;
			return(pipe);
		}
	}
}

sub vcl_pipe {
    if (req.backend_hint == certbot) {
        set req.http.Connection = "close";
        return(pipe);
    }
}