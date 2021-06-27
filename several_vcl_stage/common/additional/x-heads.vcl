sub headers_x {
## let's set some extra just for fun
	set resp.http.Server = "Caffeine v64.19.57";	# strange, but if backend is in Nginx this will be overdriven and showing Server: nginx
	set resp.http.Powered-By = "Caol ila";			# perhaps the best mid-price single malt
	set resp.http.Callsign-VPS = "Basic stack";
	set resp.http.Callsign-W3 = "Laura";
	set resp.http.Callsign-Cache = "Emppa";
	set resp.http.Ccllsign-Object = "Rasmus";
	set resp.http.Callsign-Termination = "Aapo";
	set resp.http.Callsign-DB = "Tiitu";
	set resp.http.UX-Specialist = "Jakke Lehtonen";
	set resp.http.UX-Home = "https://www.eksis.one/";
	set resp.http.UX-Meme = "Keep calm and smoke your coffee and drink your smokes - it's just a user";
	set resp.http.UX-101 = "Good web-pages will die young";
	set resp.http.Site-Little-Code-Helper = "https://git.eksis.one/";
	set resp.http.Site-Dog-And-Food = "https://www.katiska.info/";
	set resp.http.Site-Soft-And-Personal = "https://www.jagster.fi/";
	set resp.http.Clacks-Overhead = "GNU Terry Pratchett";
	set resp.http.Why-not-X-headers = "https://tools.ietf.org/html/rfc6648";
}