sub asn_name {

	# Heads up: ASN can and quite often will stop more than just one company
	# Just coming from some ASN doesn't be reason to hard banning
	if (
		   req.http.x-asn ~ "alibaba"						# Alibaba (US) Technology Co., Ltd., US,CN
		|| req.http.x-asn ~ "bladeservers"					# LeaseVPS, NL, AU
		|| req.http.x-asn ~ "chinanet-backbone"				# big part of China
		|| req.http.x-asn ~ "chinatelecom"					# a lot and couple more, CN
		|| req.http.x-asn == "cogent-174"					# BlackHOST Ltd., NL
		|| req.http.x-asn == "contabo"						# Contabo Inc., US
		|| req.http.x-asn ~ "cypresstel"					# Cypress Telecom Limited, HK
		|| req.http.x-asn ~ "digital energy technologies"	# BG
		|| req.http.x-asn ~ "dreamscape"					# Vodien Internet Solutions Pte Ltd, HK, SG, AU
		|| req.http.x-asn ~ "go-daddy-com-llc"				# GoDaddy.com US (GoDaddy isn't serving any useful services too often)
		|| req.http.x-asn ~ "idcloudhost"					# PT. SIBER SEKURINDO TEKNOLOGI, PT Cloud Hosting Indonesia, ID
		|| req.http.x-asn ~ "int-network"					# IP Volume inc, SC
		|| req.http.x-asn ~ "logineltdas"					# Karolio IT paslaugos, LT, US, GB
		|| req.http.x-asn ~ "networksdelmanana"				# Yaroslav Kharitonova, UY via HN from RU
		|| req.http.x-asn == "njix"							# laceibaserver.com, DE, US
		|| req.http.x-asn ~ "online sas"					# IP Pool for Iliad-Entreprises Business Hosting Customers, FR
		|| req.http.x-asn ~ "scalaxy"						# xWEBltd, actually RU using NL and identifying as GB
		|| req.http.x-asn ~ "reliablesite"					# Dedires llc, GB from PSE
		|| req.http.x-asn == "squitter-networks"			# ABC Consultancy etc, NL
		|| req.http.x-asn ~ "tefincomhost"					# Packethub S.A., NordVPN, FI, PA
		|| req.http.x-asn ~ "whg-network"					# Web Hosted Group Ltd, GB
		|| req.http.x-asn == "wii"							# Wholesale Internet, Inc US
		) {
			std.log("stopped ASN: " + req.http.x-asn);
			return(synth(403, "Forbidden organization: " + std.toupper(req.http.x-asn)));
		}
		
	# These are really bad ones and will be banned by Fail2ban
	if (
		   req.http.x-asn ~ "adsafe-"						# Integral Ad Science, Inc., US
		|| req.http.x-asn == "as_delis"						# Serverion BV, NL
		|| req.http.x-asn ~ "deltahost-as"					# DeltaHost, NL but actually UA
		|| req.http.x-asn == "dreamhost-as"					# New Dream Network, LLC, US
		|| req.http.x-asn == "ponynet"						# FranTech Solutions, US
		) {
			std.log("banned ASN: " + req.http.x-asn);
			return(synth(666, "Severe security issues: " + std.toupper(req.http.x-asn)));
		}

# The end of the sub
}