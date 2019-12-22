vcl 4.1;

probe bottisondi {
				.url = "/ads.txt";  # must be a real url, not made by wordpress
				.timeout = 1s;
				.interval = 5s;
				.window = 5;
				.threshold = 3;
}

backend certbot {
    .host = "127.0.0.1";
    .port = "81";
    .probe = bottisondi;
}

sub vcl_recv {
    if (req.url ~ "^/\.well-known/acme-challenge/") {
        set req.backend_hint = certbot;
        return(pipe);
    }
}

sub vcl_pipe {
    if (req.backend_hint == certbot) {
        set req.http.Connection = "close";
        return(pipe);
    }
}
