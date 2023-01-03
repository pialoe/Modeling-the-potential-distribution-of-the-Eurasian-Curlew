
rm(list=ls() )

library(raster)
library(cop)
library(copTools)
library(rgdal)
library(gdalUtils)
library(sf)
library(mapview)
library(tiff)

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/ndvi_ndmi/images")
# load b04 and b08
senstack_10 <- stack("B04.tif",
                     "B08.tif")


#calculate  NDVI 
senstack_10$NDVI <- (senstack_10$B08-senstack_10$B04)/(senstack_10$B08+senstack_10$B04)

#plot
pdf("NDVI.pdf")
plot(senstack_10$NDVI)
dev.off()

#save
writeRaster(senstack_10$NDVI,
            "predictors_ndvi.grd",
            overwrite=TRUE)

writeRaster(senstack_10$NDVI, filename = "ndvi_10m_20221118.tif", 
            overwrite=T)
