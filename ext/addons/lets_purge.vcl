sub my_purge {
	set req.http.purged = purge.hard();
	
	if (req.http.purged == "0") {
		return (synth(404));
	}
	else {
		return (synth(200, req.http.purged + " items purged."));
	}
	
	#set req.http.purged = purge.soft(std.duration(req.http.ttl,0s),
	#std.duration(req.http.grace,0s),
	#std.duration(req.http.keep,0s));
	#
	#if (req.http.purged == "0") {
	#	return (synth(404));
	#}
	#else {
	#	return (synth(200, req.http.purged + " items purged."));
	#}
}