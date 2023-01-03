
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

# loadB08 and b11
B08 <- raster("B08.tif")

B11 <- raster("B11.tif")


#resample all to 10m and stack
B11_res <- resample(B11,B08)
senstack_all<- stack(B08,B11)


#calculate  NDMI 

senstack_all$NDMI <- (senstack_all$B08-senstack_all$B11)/(senstack_all$B08+senstack_all$B11)

#plot
pdf("NDMI.pdf")
plot(senstack_all$NDMI)
dev.off()

#save
writeRaster(senstack_all$NDMI,
            "predictors_ndmi.grd",
            overwrite=TRUE)

writeRaster(senstack_all$NDMI, filename = "ndmi_10m_20221118.tif", 
            overwrite=T)


