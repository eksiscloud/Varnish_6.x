## Discourse ##
sub vcl_recv {
  if (req.http.host == "meta.katiska.info") {
		set req.backend_hint = meta;

	return(pipe);
	
}

}