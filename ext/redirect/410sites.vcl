sub all_gone {

	If (req.http.host ~ "www.katiska.info") {
		if (req.url ~ "/lyhyet/") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/dia") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/course_") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/create-") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/lesson") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/assignment") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/katiska/videot/kartanon-kannu-2011") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/venue") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/wdm_") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/sensei-") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/blogi/kirjoittajista") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/koira/mita-kupissa-luuraa-osa-3-perjantai-tuijottelut") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/znpb_template_mngr") { return(synth(810, "Gone")); }
		
	} 
	elseif (req.http.host ~ "www.eksis.one") {
		if (req.url =="/testi/testi/") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/testi2/resti2/") { return(synth(810, "Gone")); }
	}

	
#The end of the sub
}