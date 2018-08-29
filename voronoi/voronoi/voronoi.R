library(plyr)
library(ggplot2)
library(lattice)
library(rgdal)
library(rgeos)
library(spatstat)
library(sp)
library(maptools)
library(maps)
library(RColorBrewer)
library(grDevices)
library(reshape2)
library(knitr)
library(base64enc)
library(nlme)
suppressPackageStartupMessages(library(googleVis))


f <- readOGR(dsn="/Users/alexa/Desktop/Guatemala/map/GTM_adm2.shp")


f2=f[f$OBJTYPE!="Havflate"]
guatemala=gUnaryUnion(f2)


towers <- read.csv("/Users/alexa/Desktop/Guatemala/data/lon_lat_v2.csv", sep=",")
towers <- transform(towers, LON=as.numeric(LON), LAT=as.numeric(LAT))
towers <- na.omit(object = towers)


coordinates(towers) <- c("LON", "LAT")
proj4string(towers) <- CRS("+init=epsg:4326")
towers <- as.data.frame(coordinates(towers))


bboks.guatemala=bbox(guatemala)
bboks.owin=owin(bboks.guatemala[1,], bboks.guatemala[2,])
tow.ppp=as.ppp(coordinates(towers), W=bboks.owin)
diagram=dirichlet(tow.ppp)
diagram.poly=as(diagram, "SpatialPolygons")
proj4string(diagram.poly)=proj
diagram.poly.f=gIntersection(diagram.poly, f, byid=TRUE)
pal <- colorRampPalette(c("green","white","red"))
plot(diagram.poly.f, col=pal(4463), border="blue")