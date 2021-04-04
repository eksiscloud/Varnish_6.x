## Stage ##
sub vcl_recv {
  if (req.http.host == "duuni.eksis.xyz") {
		set req.backend_hint = stage;

	return(pipe);
	
}

}