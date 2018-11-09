


socialMedia <- c("facebook",
	"vine.co",
	"free.facebook.com",
	"facebook.gt",
	"msn",
	"0.facebook.com",
	"google_plus",
	"facebook.com.gt",
	"facebook_media",
	"twitter",
	"hi5.com",
	"twitter.com",
	"t.co",
	"pinterest",
	"facebook.com",
	"fb.me",
	"msn.com",
	"instagram",
	"fbcdn.net",
	"2bunnylabs.com",
	"foursquare",
	"facebook.net")

intlNews <- c("bbc",
	"epimg.net",
	"nytimes.com",
	"huffingtonpost.it",
	"elmundo.com.sv",
	"cnn.com",
	"huffingtonpost.jp",
	"el-mundo.net",
	"radioformula.com.mx",
	"eluniversal.com.mx",
	"bbc.com",
	"bbcamerica.com",
	"tvnotas.com.mx",
	"huffpost.com",
	"eltiempo.com.ec",
	"eltiempo.com",
	"huffingtonpost.com",
	"foxnews.com",
	"telegraph.co.uk",
	"econ.st",
	"huff.to",
	"bbclatinoamerica.com",
	"bbci.co.uk",
	"eluniversal.com.co",
	"peopleenespanol.com",
	"infobae.com",
	"elmundo.com",
	"fivethirtyeight.com",
	"huffingtonpost.fr",
	"bbc.co.uk",
	"nbcnews.com",
	"uni.vi",
	"economist.com",
	"bbc.in",
	"huffingtonpost.es",
	"huffingtonpost.co.uk",
	"cnn.it",
	"abc.es",
	"elmundo.es",
	"esmas.com",
	"ideal.es",
	"elmundo.com.ve",
	"cnn",
	"foxnews",
	"univision.com",
	"eluniverso.com",
	"rpp.com.pe",
	"jsonline.com",
	"semana.com",
	"elpais.com",
	"20minutos.es",
	"huffingtonpost.ca")

ntlNews <- c("elquetzalteco.com.gt",
	"publinews.gt",
	"prensalibre.com.gt",
	"republica.gt",
	"s21.com.gt",
	"sonora.com.gt",
	"diariodigital.gt",
	"contrapoder.com.gt",
	"canalantigua.tv",
	"prensalibre.com",
	"relato.gt",
	"agn.com.gt",
	"s02.gt",
	"prensalibre",
	"emisoras.com.gt",
	"guatevision.com",
	"republicagt.com",
	"lahora.com.gt",
	"chapintv.com",
	"lahora.gt",
	"deguate.com",
	"nuestrodiario.com",
	"emisorasunidas.com",
	"soy502.com",
	"elperiodico.com.gt",
	"plazapublica.com.gt",
	"elperiodico.com",
	"nuestrodiario.com.gt",
	"noti7.com.gt")


other <- c("other",
	"consejosgratis.es",
	"gigya.com",
	"rcn1.com.gt")

cats <- c("social", "intlNews", "ntlNews", "other")

getCategory <- function(serviceLabel) {
	if (serviceLabel %in% socialMedia)
		return(factor("social", levels= cats))

	if (serviceLabel %in% intlNews)
		return(factor("intlNews", levels= cats))
	
	if (serviceLabel %in% ntlNews)
		return(factor("ntlNews", levels= cats))

	if (serviceLabel %in% other)
		return(factor("other", levels= cats))

	stop(past0("UNKNOWN SERVICE CATEGORY: ", serviceLabel)) 
}


