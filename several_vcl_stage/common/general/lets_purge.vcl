sub my_purge {
	
	## Hard purge sets all values (TTL, grace, keep) to 0 sec (plus build-in TTL I reckon)
	#set req.http.purged = purge.hard();
	
	#if (req.http.purged == "0") {
	#	return (synth(404));
	#}
	#else {
	#	return (synth(200, req.http.purged + " items purged."));
	#}
	
	## zero values do same as hard purge
	set req.http.purged = purge.soft(
		std.duration(req.http.ttl,0s),
		std.duration(req.http.grace,15s),
		std.duration(req.http.keep,0s)
	);
	
	if (req.http.purged == "0") {
		return (synth(404));
	}
	else {
		return (synth(200, req.http.purged + " items purged."));
	}
# The end of the sub
}