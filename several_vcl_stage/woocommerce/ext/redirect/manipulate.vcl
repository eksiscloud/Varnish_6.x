sub new_direction {
	
	## Only WooCommerce hosts
	
	## URL manipulations, mostly searches(typos, strange spelling etc.)
		# For some reason if (req.url ~ <url>) {set req.url = <new-url>} doesn't work, must use regsub
		# Scandinavian and other alphabets than a-z must be coded
		# å = Å =
		# ä = \%C3\%A4 Ä =
		# ö = \%C3\%B6 Ö =

}