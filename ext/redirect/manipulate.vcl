sub new_direction {

	if (req.http.host ~ "www.katiska.info") {
		## URL manipulations, mostly searches(typos, strange spelling etc.)
		# For some reason if (req.url ~ <url>) {set req.url = <new-url>} doesn't work, must use regsub
		# Scandinavian and other alphabets must be coded
		# å = Å =
		# ä = \%C3\%A4 Ä =
		# ö = \%C3\%B6 Ö =
		
		# Serches
		if (req.url ~ "\?s=be$") { set req.url = regsub(req.url, "\?s=be$", "\?s=be-vitamiini"); }
		elseif (req.url ~ "\?s=glucosamiini") { set req.url = regsub(req.url, "\?s=glucosamiini", "\?s=glukosamiini"); }
		elseif (req.url ~ "\?s=(.*)juonti") { set req.url = regsub(req.url, "\?s=(.*)juonti", "\?s=juominen"); }
		elseif (req.url ~ "\?s=koiran\+vitamiinintarve") { set req.url = regsub(req.url, "\?s=koiran\+vitamiinintarve", "\?s=koiran\+vitamiinin\+tarve"); }
		elseif (req.url ~ "\?s=(punkki|punkin)esto") { set req.url = regsub(req.url, "\?s=(punkki|punkin)esto", "\?s=punkkih\%C3\%A4\%C3\%A4t\%C3\%B6"); }
		elseif (req.url ~ "\?s=rabdomyoloosi") { set req.url = regsub(req.url, "\?s=rabdomyoloosi", "\?s=asidoosi"); }
		elseif (req.url ~ "\?s=syyl\%C3\%A4$") { set req.url = regsub(req.url, "\?s=syyl\%C3\%A4$", "\?s=syyl\%C3\%A4t"); }
		elseif (req.url ~ "\?s=t\%C3\%A4yslihapulla") { set req.url = regsub(req.url, "\?s=t\%C3\%A4yslihapullat", "\?s=lihapulla"); }
		elseif (req.url ~ "\?s=(nappulat|nappularuokinta)") { set req.url = regsub(req.url, "\?s=(nappulat|nappularuokinta)", "\?s=kuivamuona"); }
		elseif (req.url ~ "\?s=nivelterveys") { set req.url = regsub(req.url, "\?s=nivelterveys", "\?s=nivelet"); }
		elseif (req.url ~ "\?s=washout") { set req.url = regsub(req.url, "\?s=washout", "\?s=wash-out"); }
		elseif (req.url ~ "\?s=virtsa(|tiekide|kide|tiekiteet|kiteet)") { set req.url = regsub(req.url, "\?s=virtsa(|tiekide|kide|tiekiteet|kiteet)", "\?s=virtsatiekivet"); }
		elseif (req.url ~ "\?s=vischy") { set req.url = regsub(req.url, "\?s=vischy", "\?s=vichy"); }
		elseif (req.url ~ "\?s=vitamiinilista") { set req.url = regsub(req.url, "\?s=vitamiinilista", "\?s=vitamiinit"); }

	}
	
}