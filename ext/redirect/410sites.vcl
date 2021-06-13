sub all_gone {

	If (req.http.host ~ "www.katiska.info") {
		if (req.url ~ "/lyhyet/") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/author") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/dia") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/course_") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/create-") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/lesson") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/assignment") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/jasenet") { return(synth(810, "Gone")); }
		elseif (req.url ~ "^/katiska/videot/kartanon-kannu-2011") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/venue") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/wdm_") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/wp-content/plugins/all-in-one-seo-pack") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/sensei-") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/blogi/kirjoittajista") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/koira/mita-kupissa-luuraa-osa-3-perjantai-tuijottelut") { return(synth(810, "Gone")); }
		elseif (req.url ~ "/znpb_template_mngr") { return(synth(810, "Gone")); }
		
		# Old wp-json leak'ish of users/authors. I'm using this only to stop nagging from Bing.
		elseif (req.url ~ "^/kirjoittaja/") {
			if (req.url !~ "(adurodiel|atmini|jagster|katiska|mkarulinna|osmaja|sinituulia|sivusto|sumppu|tehtailija|tiia)") {
				return(synth(810, "Gone"));
			}
		}
	# End of Katiska.info
	}

	
#The end of the sub
}