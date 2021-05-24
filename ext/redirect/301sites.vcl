sub this_way {

	if (req.http.host ~ "www.katiska.info") {
		# these come from stupid theme structure
		if (req.url ~ "^/facebook-redirect") { return(synth(701, "https://www.facebook.com/groups/katiska")); }
		elseif (req.url ~ "^/twitter-redirect") { return(synth(701, "https://twitter.com/katiskatweet")); }
		elseif (req.url ~ "^/youtube-redirect/") { return(synth(701, "https://www.youtube.com/channel/UCxHt-5Vwd8oE_cUGGQqXruw")); }
		# known links from elsewhere
		elseif (req.url ~ "^/koulutukset/sumppupro") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/kurssit/allergisen-koiran-eliminaatio-kaytannossa") { return(synth(701, "https://www.katiska.info/tieto/koiran-allergia-hiiva-iho/allergisen-koiran-eliminaatio-kaytannossa/")); }
		elseif (req.url ~ "^/kurssit/kurkistus-kuivamuoniin") { return(synth(701, "https://www.katiska.info/tieto/koira-kuivamuona-taysruoka/kurkistus-kuivamuoniin/")); }
		elseif (req.url ~ "^/sanakirja/avital-calcium") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/avital-calcium/")); }
		elseif (req.url ~ "^/sanakirja/probalans-be-balans") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/probalans-be-balans/")); }
		elseif (req.url ~ "^/tieto/koira-ruoka-lisaravinne/lisaravinteiden-annostus-hakemisto") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/lisaravinteiden-annostus-hakemisto/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/103-mahdoton-kysymys-mika-on-hyva-ruokamerkki-koiralle") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/103-mahdoton-kysymys-mika-on-hyva-ruokamerkki-koiralle/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/106-nrc-uskovaisuus") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/106-nrc-uskovaisuus/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/113-kysy-ennen-kuin-ostat") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/113-kysy-ennen-kuin-ostat/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/118-perusta-aina-ennen-nippelia") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/118-perusta-aina-ennen-nippelia/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/122-pentujen-ruokintakerrat-taas") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/122-pentujen-ruokintakerrat-taas/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/126-takakorkea-koira") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/126-takakorkea-koira/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/128-koiran-munuaisruokinta") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/128-koiran-munuaisruokinta/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/129-venla-paiva-588") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/129-venla-paiva-588/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/130-koirallani-on-venahdys-tai-revahdys") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/130-koirallani-on-venahdys-tai-revahdys/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/134-fda-ja-lihojen-jaamat") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/134-fda-ja-lihojen-jaamat/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/135-koiralle-kuiduksi-kuidunlahdetta") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/135-koiralle-kuiduksi-kuidunlahdetta/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/71-furua-ja-kepitettya-jalostusta") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/71-furua-ja-kepitettya-jalostusta/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/72-varmojen-paivien-aitiys") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/72-varmojen-paivien-aitiys/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/77-venla-paiva-9") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/77-venla-paiva-9/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/78-venla-paiva-11") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/78-venla-paiva-11/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/97-kun-minakaan-en-piittaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/97-kun-minakaan-en-piittaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kaffepaussi-aktivoitua-pakkoliikuntaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-aktivoitua-pakkoliikuntaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kolmannen-pallin-sydrooma") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kolmannen-pallin-sydrooma/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/venla-paiva-1") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/venla-paiva-1/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/10-ulkonako") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/10-ulkonako/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/1-intro") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/1-intro/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/3-ymparisto") { return(synth(701, "https://www.katiska.info/tieto/koirat/ruokinnan-idea-podcast/3-ymparisto/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/9-tavat") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/9-tavat/")); }
		elseif (req.url ~ "^/tieto/podcastit-vlog/100-oikeat-tyokalut-ja-tukeva-perusta") { return(synth(701, "https://www.katiska.info/tieto/koirat/podcastit-vlog/100-oikeat-tyokalut-ja-tukeva-perusta/")); }
		# Another redirects. Can be cleaned after some times when Google/Bing/Duck are happy
		elseif (req.url ~ "(cart|checkout|my-account|ostoskori)") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/ejulkaisut/") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/kaffepaussin\-aika/feed/") { return(synth(701, "https://www.katiska.info/feed/podcast/kaffepaussi")); }
		elseif (req.url ~ "^/tieto/koirat/kurssit/agility\-ja\-koiran\-lihaksisto") { return(synth(701, "https://www.katiska.info/tieto/lihaksisto-ja-luusto/agility-ja-koiran-lihaksisto/")); }
		elseif (req.url ~ "^/tieto/koirat/kurssit/koiralle\-lihaa\-vatsan\-taydelta") { return(synth(701, "https://www.katiska.info/tieto/koira-ruokinta-liha/koiralle-lihaa-vatsan-taydelta/")); }
		elseif (req.url ~ "^/tieto/koirat/kurssit/ruokinnan\-idea/embed/") { return(synth(701, "https://www.katiska.info/tieto/ruoka/ruokinnan-idea/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/112\-vanha\-koira") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/112-vanha-koira/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/120\-koirapuistot\-narastyttavat\-koiraa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/120-koirapuistot-narastyttavat-koiraa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/121\-12\-vuotta\-hernekeittoa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/121-12-vuotta-hernekeittoa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/123\-koiran\-lihasjumeille\-magnesiumia") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/123-koiran-lihasjumeille-magnesiumia/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/124\-koiran\-omistaminen\-ei\-ole\-ihmisoikeus") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/124-koiran-omistaminen-ei-ole-ihmisoikeus/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/125\-koiran\-maksaruoka") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/125-koiran-maksaruoka/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/kaffepaussi\-lihaa\-ja\-helppoutta") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-lihaa-ja-helppoutta/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/kaffepaussi\-lisia\-ja\-kaarmeoljya") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-lisia-ja-kaarmeoljya/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/kaffepaussi\-pentujen\-vieroituksesta") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-pentujen-vieroituksesta/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/podcast\-136\-vuolaanavirtaa\-suolisto\-ongelmia") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/podcast-136-vuolaanavirtaa-suolisto-ongelmia/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit\-vlog/podcast\-137\-terveemmat\-mediasekarotuiset") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/podcast-137-terveemmat-mediasekarotuiset/")); }
		elseif (req.url ~ "^/tieto/rotuasiaa/podcast\-terveemmat\-mediasekarotuiset/") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/podcast-137-terveemmat-mediasekarotuiset/")); }
		elseif (req.url ~ "/koira-sisaelimisto/wiki") { return(synth(701, "https://meta.katiska.info/c/terve-koira/7")); }

	}
# The if the sub
}