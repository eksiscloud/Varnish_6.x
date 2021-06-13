
# varnish_6.6
Tämä on (lähes) ajantasainen kopio käyttämästäni Nginx+Varnish+Apache2 pinosta. Hoidan useamman sivuston, filtteröin turhat botit sekä ison osan koputtelijoista, käytössä on GeoIP jne.

Suurimman osan pitäisi toimia myös vanhemmilla Varnish 6.x versioilla (<6.4), mutta silloin on käännettävä cookie VMOD. Tai käytettävä perinteistä regex-hässäkkää.

Ole hereillä - koska kyseessä on kopio live-järjestelmästä, niin jos hyödynnät, korvaa ainakin urlit.
Samasta syystä mukana on ratkaisuja, jotka sopivat minulle, mutta eivät taatusti sinulle.

Ylipäätään kannattaa aina olla varovainen, kun kopypeistaa asioita.

## Pinon perusteet

Käytössä on:
- Nginx kuuntelee portteja 80 ja 443, sekä kääntää 80 pyynnöt porttiin 443
- Nginx hoitaa SSL:n, HTTP/2:den sekä osan suodatuksista (kuten botit, geo-blokkauksen jne.)
- Varnish kuuntelee Nginxiä portissa 8080
- Apache2 kuuntelee Varnishia portissa 81

## Varnishin perusteet
- default.vcl tekee yleiset normalisoinnit lohkossa sub vcl_recv (ei return(...) lausekkeita) ja sen jälkeen kaiken muun
- all-common.vcl hoitaa cookiet
- all-vhost kertoo kaikkien sivustojen (virtual hosts) sijainnin ja ottaa ne käyttöön
- letsencrypt.vcl on Let's Enryptin oma backend

Käytän hieman, ehkä liikaakin call-kutsuja, mutta ne helpottavat default.vcl tiedoston lukemista.
- common.vcl sisältää kaikkia virtual hosteja koskevia sääntöjä ja sitä kutsutaan virtual hostin vcl_recv osassa
- wordpress-common.vcl sisältää jokaista WordPress-sivustoa koskevia sääntöjä ja rajoituksia, ja sitä kutsutaan sivuston vcl:ssä viimeisenä
- woocommerce-common.vcl on vain WooCommercea koskevia asioita, ja sitä kutsutaan woocommercea käyttävien sivustojen vcl:ssä

Yleistä säätöä tekee
- ext/addons/cors.vcl joka asettaa CORS tiedot; periaatteessa, ja käytännössäkin, tämä olisi kylläkin backendin urakka

Suodattavia asioita tekevät:
- ext/filtering/bad-bot.vcl joka estää listassa olevat roskabotit ja spiderit; käytännössä työtön, koska sama lista Nginxissä ei edes päästä roskia Varnishiin
- ext/filtering/403.vcl joka estää turhat kolkuttelut (jos url on tiedossa, joten logeja tulee seurattua)
- ext/filtering/nice-bot.vcl päästää hyödylliset user agentit sisälle
- ext/filtering/probes.vcl on serverin tekniikaan liittyvät, esim. sivutojen toimivuutta seuraavat
- ext/filtering/asn.vcl suodattaa ASN-tiedon mukaan. Se täydentää geo-blokkausta, kun koko maata ei voi estää, mutta määrätyn palveluntarjoajan verkosta tulee poikkeuksellisen paljon sontaa

Täysin hyödyttömiä header-säätöjä ovat:
- ext/general/cheshire_cat.vcl joka esittää Irvikissan kuvan
- ext/general/debugs.vcl joka liittää käyttäjän IP:n jne.; käytän niitä vain testaillessani meneekö joku läpi
- ext/general/x-heads.vcl joka esittää totaalisen turhaa ja tarpeetonta tietoa

Osa uudelleenohjauksista tehdään Varnishin puolella, vaikka frontina oleva Nginx saattaisi olla järkevämpi:
- ext/redirect/301sites.vcl tekee sivustojen pysyvämmät uudelleenohjaukset, joiden päästäminen backendiin on turhaa
- ext/redirect/404.vcl tekee muutaman koko serveriä koskevan uudelleenohjauksen - poistuva, koska hakukoneet uskovat jo
- ext/redirect/410sites.vcl on vain hakukoneita varten ja kattaa sellaisia kuolleita linkkejä varten jotka antaisivat useamman urlin
- ext/redirect/manipulate.vcl muuttaa pyydettyjä urleja, pääosin auttamassa hakuja

Monet kutsutuista vcl:stä liipaisee virheilmoituksen avulla Fail2Bannin. Ehkä liioittelua?

Olen yrittänyt kommentoida suunnilleen kaiken tekemäni. Suurin osa on täysin perusasioita ja loputkin voisi varmasti tehdä toisin ja paremminkin. Mutta en osaa tämän kummallisempaa.

## Vastuunpakoilua

Minulla tämä rakennelma toimii. Ainakin jotenkin. Kannattaa silti pitää kirkkaana mielessä, että joudun joka viikko korjaamaan jotain, kun huomaan Varnishin tekevän ihan muuta kuin mitä toivoin sen toteuttavan.


Bannaamiset ovat aina vaarallisia. Olen onnistunut estämään parhaimmillaan kaikki kävijäni. Iso osa Let's Encryptin boteista on Fail2Bannin blokkaamia oman virheen takia. Sama juttu osan Googlen ja Bingin bottien kanssa. Joten vaikka estäisitkin raskaalla kädellä, niin ole hereillä bannien kanssa.

Käyttämäni TTL:t ovat tehty aivan fiilispohjalta. Minulla ei ole minkäänlaista näkemystä, suunnitelmasta puhumattakaan.
