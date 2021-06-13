sub asn_name {

	# Heads up: ASN can and quite often will ban more than just one company
	if (
		   req.http.x-asn ~ "adsafe-"						# Integral Ad Science, Inc., US
		|| req.http.x-asn ~ "alibaba"						# Alibaba (US) Technology Co., Ltd., US,CN
		|| req.http.x-asn ~ "bladeservers"					# LeaseVPS, NL, AU
		|| req.http.x-asn ~ "chinanet-backbone"				# big part of China
		|| req.http.x-asn ~ "chinatelecom"					# a lot and couple more, CN
		|| req.http.x-asn == "cogent-174"					# BlackHOST Ltd., NL
		|| req.http.x-asn == "contabo"						# Contabo Inc., US
		|| req.http.x-asn ~ "digital energy technologies"	# BG
		|| req.http.x-asn == "dreamhost-as"					# New Dream Network, LLC, US
		|| req.http.x-asn ~ "dreamscape"					# Vodien Internet Solutions Pte Ltd, HK, SG, AU
		|| req.http.x-asn ~ "go-daddy-com-llc"				# GoDaddy.com US (GoDaddy isn't serving any useful services too often)
		|| req.http.x-asn ~ "idcloudhost"					# PT. SIBER SEKURINDO TEKNOLOGI, ID
		|| req.http.x-asn ~ "int-network"					# IP Volume inc, SC
		|| req.http.x-asn ~ "logineltdas"					# Karolio IT paslaugos, LT, US, GB
		|| req.http.x-asn == "ponynet"						# FranTech Solutions, US
		|| req.http.x-asn == "squitter-networks"			# ABC Consultancy etc, NL
		|| req.http.x-asn ~ "whg-network"					# Web Hosted Group Ltd, GB
		|| req.http.x-asn == "wii"							# Wholesale Internet, Inc US
		) {
			return(synth(403, "Forbidden organization: " + std.toupper(req.http.x-asn)));
		}

# The end of the sub
}