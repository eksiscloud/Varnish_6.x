sub this_way {
	
	##### Quite long lasting redirects. Out there MUST be easier solution. This is more or less just a nightmare.

	if (req.http.host ~ "www.katiska.info") {
		# these come from stupid theme structure
		if (req.url ~ "^/facebook-redirect") { return(synth(701, "https://www.facebook.com/groups/katiska")); }
		elseif (req.url ~ "^/twitter-redirect") { return(synth(701, "https://twitter.com/katiskatweet")); }
		elseif (req.url ~ "^/youtube-redirect/") { return(synth(701, "https://www.youtube.com/channel/UCxHt-5Vwd8oE_cUGGQqXruw")); }
		# known links from elsewhere
		elseif (req.url ~ "^/avainsana") { return(synth(701, "https://www.katiska.info/tieto/katiskan-kaytto-sisalto/avainsanat-eli-tagit/")); }
		elseif (req.url ~ "^/blogi/avainsana") { return(synth(701, "https://www.katiska.info/tieto/katiskan-kaytto-sisalto/avainsanat-eli-tagit/")); }
		elseif (req.url ~ "^/koulutukset/sumppupro") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/kurssit/agi-faktori-i") { return(synth(701, "https://www.katiska.info/tieto/fyysisesta-treenista/agilityn-riskit/")); }
		elseif (req.url ~ "^/kurssit/agility-ja-lihaksisto") { return(synth(701, "https://www.katiska.info/tieto/lihaksisto-ja-luusto/agility-ja-koiran-lihaksisto/")); }
		elseif (req.url ~ "^/kurssit/allergia-pahkinankuoressa") { return(synth(701, "https://www.katiska.info/tieto/koiran-allergia-hiiva-iho/koiran-allergia-pahkinankuoressa/")); }
		elseif (req.url ~ "^/kurssit/allergisen-koiran-eliminaatio-kaytannossa") { return(synth(701, "https://www.katiska.info/tieto/koiran-allergia-hiiva-iho/allergisen-koiran-eliminaatio-kaytannossa/")); }
		elseif (req.url ~ "^/kurssit/ehjana-elakkeelle") { return(synth(701, "https://www.katiska.info/tieto/fyysisesta-treenista/kilpakoira-ehjana-elakkeelle/")); }
		elseif (req.url ~ "^/kurssit/ensimmainen-koira") { return(synth(701, "https://www.katiska.info/tieto/koira-kasvava-pentu/ikioma-ensimmainen-koira/")); }
		elseif (req.url ~ "^/kurssit/haimatulehdus") { return(synth(701, "https://www.katiska.info/tieto/koira-sairaus-elimet/sairas-haima-koiran-haimatulehdus/")); }
		elseif (req.url ~ "^/kurssit/hiiva-ikuinen-riesa") { return(synth(701, "https://www.katiska.info/tieto/koira-sairaus-elimet/onko-koiran-hiiva-ikuinen-riesa/")); }
		elseif (req.url ~ "^/kurssit/koiran-narastys") { return(synth(701, "https://www.katiska.info/tieto/koira-terveys-narastys/koiran-narastys/")); }
		elseif (req.url ~ "^/kurssit/koiran-ruokinta-perusteet") { return(synth(701, "https://www.katiska.info/tieto/ruoka/koiran-ruokinta-perusteet/")); }
		elseif (req.url ~ "^/kurssit/kurkistus-kuivamuoniin") { return(synth(701, "https://www.katiska.info/tieto/koira-kuivamuona-taysruoka/kurkistus-kuivamuoniin/")); }
		elseif (req.url ~ "^/kurssit/lihaa-vatsan-taydelta") { return(synth(701, "https://www.katiska.info/tieto/koira-ruokinta-liha/koiralle-lihaa-vatsan-taydelta/")); }
		elseif (req.url ~ "^/kurssit/liikkuvan-koiran-ruokinta") { return(synth(701, "https://www.katiska.info/tieto/liikkuvan-ruokinta-yleisesti/liikkuvan-koiran-ruokinta/")); }
		elseif (req.url ~ "^/kurssit/liikkuvan-koiran-rutiinitarkastus") { return(synth(701, "https://www.katiska.info/tieto/lihashuolto/koiran-lihaksiston-rutiinitarkastus/")); }
		elseif (req.url ~ "^/kurssit/pennun-ruoka-ja-kasvu") { return(synth(701, "https://www.katiska.info/tieto/koira-kasvava-pentu/pennun-ruokinta-ja-kasvu-2/")); }
		elseif (req.url ~ "^/kurssit/perustyokalut") { return(synth(701, "https://www.katiska.info/tieto/ruoka/koiran-ruokinnan-laskeminen-perustyokalut/")); }
		elseif (req.url ~ "^/kurssit/ravintokouluttaja") { return(synth(701, "https://store.katiska.info/tuote/ravintokouluttaja/")); }
		elseif (req.url ~ "^/kurssit/ruokinnan-idea") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/ruokinnan-idea-podcast/")); }
		elseif (req.url ~ "^/kurssit/ruuansulatuksen-perusteet") { return(synth(701, "https://www.katiska.info/tieto/koira-sisaelimisto/koiran-ruuansulatuksen-perusteet/")); }
		elseif (req.url ~ "^/kurssit/sairas-haima") { return(synth(701, "https://www.katiska.info/tieto/koira-sairaus-elimet/sairas-haima-koiran-haimatulehdus/")); }
		elseif (req.url ~ "^/kurssit/urheilukoirien-palauttaminen") { return(synth(701, "https://www.katiska.info/tieto/palauttaminen/urheileva-koira-ja-palauttaminen/")); }
		elseif (req.url ~ "^/ravitsemus/hiilihydraatit-ravitsemus/wiki") { return(synth(701, "https://www.koiranravitsemus.fi/aihe/Hiilihydraatit")); }
		elseif (req.url ~ "^/ravitsemus/rasva-ravitsemus/rasva-on-aina-rasva") { return(synth(701, "https://www.katiska.info/tieto/rasvat/rasva-ruokinnassa/")); }
		elseif (req.url ~ "^/sanakirja/avital-calcium") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/avital-calcium/")); }
		elseif (req.url ~ "^/sanakirja/probalans-be-balans") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/probalans-be-balans/")); }
		elseif (req.url ~ "^/selko/$") { return(synth(701, "https://selko.katiska.info/")); }
		elseif (req.url == "^/tieto/infokortti/") { return(synth(701, "https://www.katiska.info/tieto/avainsana/infokortti/")); }
		elseif (req.url ~ "^/tieto/koira-aloittelijat") { return(synth(701, "https://www.katiska.info/tieto/avainsana/perusteet/")); }
		elseif (req.url ~ "^/tieto/koira-ruoka-lisaravinne/lisaravinteiden-annostus-hakemisto") { return(synth(701, "https://www.katiska.info/tieto/lisaravinteiden-annostus/lisaravinteiden-annostus-hakemisto/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/103-mahdoton-kysymys-mika-on-hyva-ruokamerkki-koiralle") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/103-mahdoton-kysymys-mika-on-hyva-ruokamerkki-koiralle/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/106-nrc-uskovaisuus") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/106-nrc-uskovaisuus/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/113-kysy-ennen-kuin-ostat") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/113-kysy-ennen-kuin-ostat/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/114-hevosmessuilla-markaa-merisuolaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/114-hevosmessuilla-markaa-merisuolaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/115-maallikon-valkoinen-takki") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/115-maallikon-valkoinen-takki/")); }
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
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/76-astmapohinaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/76-astmapohinaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/78-venla-paiva-11") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/78-venla-paiva-11/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/97-kun-minakaan-en-piittaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/97-kun-minakaan-en-piittaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kaffepaussi-aktivoitua-pakkoliikuntaa") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-aktivoitua-pakkoliikuntaa/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kaffepaussi-kuitua-ja-laksatiiveja") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-kuitua-ja-laksatiiveja/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kaffepaussi-kuoleman-vastuu") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kaffepaussi-kuoleman-vastuu/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/kolmannen-pallin-sydrooma") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/kolmannen-pallin-sydrooma/")); }
		elseif (req.url ~ "^/tieto/koirat/podcastit-vlog/venla-paiva-1") { return(synth(701, "https://www.katiska.info/tieto/podcastit-vlog/venla-paiva-1/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/10-ulkonako") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/10-ulkonako/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/1-intro") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/1-intro/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/3-ymparisto") { return(synth(701, "https://www.katiska.info/tieto/koirat/ruokinnan-idea-podcast/3-ymparisto/")); }
		elseif (req.url ~ "^/tieto/koirat/ruokinnan-idea-podcast/9-tavat") { return(synth(701, "https://www.katiska.info/tieto/ruokinnan-idea-podcast/9-tavat/")); }
		elseif (req.url ~ "^/tieto/podcastit-vlog/100-oikeat-tyokalut-ja-tukeva-perusta") { return(synth(701, "https://www.katiska.info/tieto/koirat/podcastit-vlog/100-oikeat-tyokalut-ja-tukeva-perusta/")); }
		# Missing images, because I started to use CDN and changed sizes. It is just URL question, but I don't know how to fix it. This is mostly only for Facebook.
		elseif (req.url ~ "^/wp-content/uploads/2011/01/061205-132849-237x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/061205-132849.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/01/070402-113223-225x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/070402-113223.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/03/73014sj5qwz4hp-300x204.jpg") { return(synth(701, "https://cdn.katiska.info/kb/73014sj5qwz4hp.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/05/070926-181638-300x276.jpg") { return(synth(701, "https://cdn.katiska.info/kb/070926-181638.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/07/3307717696_a4f3b65005_o-300x209.jpg") { return(synth(701, "https://cdn.katiska.info/kb/3307717696_a4f3b65005_o.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/07/4551462096_2424b24711_b-200x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/4551462096_2424b24711_b.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2011/10/mala-koira-300x203.jpg") { return(synth(701, "https://cdn.katiska.info/kb/mala-koira.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2013/04/IMG_0738-e1365753541793-224x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/IMG_0738-e1365753541793.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2014/01/how-much-is-much-574x1024.jpg") { return(synth(701, "https://cdn.katiska.info/kb/how-much-is-much.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2014/05/ID-10071393-300x237.jpg") { return(synth(701, "https://cdn.katiska.info/kb/ID-10071393.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2014/11/20130609-untitled-001-300x216.jpg") { return(synth(701, "https://cdn.katiska.info/kb/20130609-untitled-001.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2015/03/pahkinankuori-292x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/pahkinankuori.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2015/08/koira-vai-susi-1024x410.jpg") { return(synth(701, "https://cdn.katiska.info/kb/koira-vai-susi.jpg")); }
		elseif (req.url ~ "^/wp-content/uploads/2015/11/trust-luomu-239x300.jpg") { return(synth(701, "https://cdn.katiska.info/kb/trust-luomu.jpg")); }
		# Another redirects. Can be cleaned after some times when Google/Bing/Duck are happy
		elseif (req.url ~ "^/e-julkaisut/muut-e-kirjat/abc-antioksidantit-diat") { return(synth(701, "https://www.katiska.info/tieto/koira-tarve-vitamiini/antioksidantit/")); }
		elseif (req.url ~ "^/infokortit") { return(synth(701, "https://www.katiska.info/tieto/avainsana/infokortti/")); }
		elseif (req.url ~ "(cart|checkout|my-account|ostoskori)") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/ejulkaisut/") { return(synth(701, "https://store.katiska.info/")); }
		elseif (req.url ~ "^/kaffepaussin\-aika/feed/") { return(synth(701, "https://www.katiska.info/feed/podcast/kaffepaussi")); }
		elseif (req.url ~ "^/ruokinta/raaka-aineet/kaalikeittoa-ja-nokkosta") { return(synth(701, "https://www.katiska.info/tieto/koira-tarve-mineraali/fytaatti/")); }
		elseif (req.url ~ "^/ruokinta/raaka-aineet/pellavansiemen") { return(synth(701, "https://www.katiska.info/tieto/koira-tarve-yleinen/kuitu-lihasta/")); }
		elseif (req.url ~ "^/sitemap.xml") { return(synth(701, "https://www.katiska.info/sitemap_index.xml")); }
		elseif (req.url ~ "^/tagit") { return(synth(701, "https://www.katiska.info/avainsanat/")); }
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
		elseif (req.url ~ "^/kurssit/raakaruokinnan-suunnittelu") { return(synth(701, "https://www.katiska.info/tieto/koira-ruokinta-liha/koiran-raakaruokinnan-suunnittelu/")); }
		

	}
	
# The if the sub
}