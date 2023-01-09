rm(list=ls() )

library(raster)
library(cop)
library(copTools)
library(rgdal)
library(gdalUtils)
library(sf)
library(mapview)
library(tiff)
library(beepr)


beep(sound = 9)
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/")

###############################################################################
### tree cover
tree_cover<-raster("tree_cover_density/copernicus_treecover_crop_20221016.tif")
plot(tree_cover)

extent(tree_cover)

tree_cover_3x3 <- focal(tree_cover,w=matrix(1/9,3,3), fun=mean)
tree_cover_5x5 <- focal(tree_cover,w=matrix(1/25,5,5), fun=mean)
tree_cover_9x9 <- focal(tree_cover,w=matrix(1/81,9,9), fun=mean)
tree_cover_11x11 <- focal(tree_cover,w=matrix(1/121,11,11), fun=mean)
tree_cover_15x15 <- focal(tree_cover,w=matrix(1/225,15,15), fun=mean)


plot(tree_cover_3x3)
plot(tree_cover_5x5)
plot(tree_cover_9x9)
plot(tree_cover_11x11)
plot(tree_cover_15x15)

#Write results!
writeRaster(tree_cover_3x3, filename = "tree_cover_density/tree_cover_3x3_20221201.tif", overwrite=T)
writeRaster(tree_cover_5x5, filename = "tree_cover_density/tree_cover_5x5_20221201.tif", overwrite=T)
writeRaster(tree_cover_9x9, filename = "tree_cover_density/tree_cover_9x9_20221201.tif", overwrite=T)
writeRaster(tree_cover_11x11, filename = "tree_cover_density/tree_cover_11x11_20221201.tif", overwrite=T)
writeRaster(tree_cover_15x15, filename = "tree_cover_density/tree_cover_15x15_20221201.tif", overwrite=T)

###############################################################################
####ndvi
ndvi<-raster("ndvi_ndmi/ndvi_20221205.tif")
plot(ndvi)

extent(ndvi)
ndvi <- resample(ndvi,tree_cover)
extent(ndvi)

#mean
ndvi_3x3 <- focal(ndvi,w=matrix(1/9,3,3), fun=mean)
ndvi_5x5 <- focal(ndvi,w=matrix(1/25,5,5), fun=mean)
ndvi_9x9 <- focal(ndvi,w=matrix(1/81,9,9), fun=mean)
ndvi_11x11 <- focal(ndvi,w=matrix(1/121,11,11), fun=mean)
ndvi_15x15 <- focal(ndvi,w=matrix(1/225,15,15), fun=mean)

#sd
ndvi_5x5_sd <- focal(ndvi,w=matrix(1/25,5,5), fun=sd)
ndvi_9x9_sd <- focal(ndvi,w=matrix(1/81,9,9), fun=sd)
ndvi_15x15_sd <- focal(ndvi,w=matrix(1/225,15,15), fun=sd)

extent(ndvi_15x15)

plot(ndvi_3x3)
plot(ndvi_5x5)
plot(ndvi_9x9)
plot(ndvi_11x11)
plot(ndvi_15x15)

#Write results!
writeRaster(ndvi, filename = "ndvi_ndmi/ndvi_20221205.tif", overwrite=T)
writeRaster(ndvi_3x3, filename = "ndvi_ndmi/ndvi_3x3_20221201.tif", overwrite=T)
writeRaster(ndvi_5x5, filename = "ndvi_ndmi/ndvi_5x5_20221201.tif", overwrite=T)
writeRaster(ndvi_9x9, filename = "ndvi_ndmi/ndvi_9x9_20221201.tif", overwrite=T)
writeRaster(ndvi_11x11, filename = "ndvi_ndmi/ndvi_11x11_20221201.tif", overwrite=T)
writeRaster(ndvi_15x15, filename = "ndvi_ndmi/ndvi_15x15_20221201.tif", overwrite=T)

writeRaster(ndvi_5x5_sd, filename = "ndvi_ndmi/ndvi_5x5_sd_20221209.tif", overwrite=T)
writeRaster(ndvi_9x9_sd, filename = "ndvi_ndmi/ndvi_9x9_sd_20221209.tif", overwrite=T)
writeRaster(ndvi_15x15_sd, filename = "ndvi_ndmi/ndvi_15x15_sd_20221209.tif", overwrite=T)

###############################################################################
####ndmi
ndmi<-raster("ndvi_ndmi/ndmi_20221205.tif")
plot(ndmi)

extent(ndmi)
ndmi <- resample(ndmi,tree_cover)

#mean
ndmi_3x3 <- focal(ndmi,w=matrix(1/9,3,3), fun=mean)
ndmi_5x5 <- focal(ndmi,w=matrix(1/25,5,5), fun=mean)
ndmi_9x9 <- focal(ndmi,w=matrix(1/81,9,9), fun=mean)
ndmi_15x15 <- focal(ndmi,w=matrix(1/225,15,15), fun=mean)

extent(ndmi_3x3)

#sd
#ndmi_3x3 <- focal(ndmi,w=matrix(1/9,3,3), fun=sd)
ndmi_9x9_sd <- focal(ndmi,w=matrix(1/81,9,9), fun=sd)
ndmi_5x5_sd <- focal(ndmi,w=matrix(1/25,5,5), fun=sd)
ndmi_15x15_sd <- focal(ndmi,w=matrix(1/225,15,15), fun=sd)

plot(ndmi_3x3)
plot(ndmi_5x5)
plot(ndmi_9x9)
plot(ndmi_11x11)
plot(ndmi_15x15)

#Write results!
writeRaster(ndmi, filename = "ndvi_ndmi/ndmi_20221205.tif", overwrite=T)
writeRaster(ndmi_3x3, filename = "ndvi_ndmi/ndmi_3x3_20221201.tif", overwrite=T)
writeRaster(ndmi_5x5, filename = "ndvi_ndmi/ndmi_5x5_20221201.tif", overwrite=T)
writeRaster(ndmi_9x9, filename = "ndvi_ndmi/ndmi_9x9_20221201.tif", overwrite=T)
writeRaster(ndmi_11x11, filename = "ndvi_ndmi/ndmi_11x11_20221201.tif", overwrite=T)
writeRaster(ndmi_15x15, filename = "ndvi_ndmi/ndmi_15x15_20221201.tif", overwrite=T)

writeRaster(ndmi_5x5_sd, filename = "ndvi_ndmi/ndmi_5x5_sd_20221209.tif", overwrite=T)
writeRaster(ndmi_9x9_sd, filename = "ndvi_ndmi/ndmi_9x9_sd_20221209.tif", overwrite=T)
writeRaster(ndmi_15x15_sd, filename = "ndvi_ndmi/ndmi_15x15_sd_20221209.tif", overwrite=T)

###############################################################################
### water_and_wetness
water_and_wetness<-raster("water_and_wetness/water_and_wetness_crop_20221016.tif")
plot(water_and_wetness)

water_and_wetness_3x3 <- focal(water_and_wetness,w=matrix(1/9,3,3), fun=mean)
water_and_wetness_5x5 <- focal(water_and_wetness,w=matrix(1/25,5,5), fun=mean)
water_and_wetness_9x9 <- focal(water_and_wetness,w=matrix(1/81,9,9), fun=mean)
water_and_wetness_11x11 <- focal(water_and_wetness,w=matrix(1/121,11,11), fun=mean)
water_and_wetness_15x15 <- focal(water_and_wetness,w=matrix(1/225,15,15), fun=mean)


plot(water_and_wetness_3x3)
plot(water_and_wetness_5x5)
plot(water_and_wetness_9x9)
plot(water_and_wetness_11x11)
plot(water_and_wetness_15x15)

#Write results!
writeRaster(water_and_wetness_3x3, filename = "water_and_wetness/water_and_wetness_3x3_20221201.tif", overwrite=T)
writeRaster(water_and_wetness_5x5, filename = "water_and_wetness/water_and_wetness_5x5_20221201.tif", overwrite=T)
writeRaster(water_and_wetness_9x9, filename = "water_and_wetness/water_and_wetness_9x9_20221201.tif", overwrite=T)
writeRaster(water_and_wetness_11x11, filename = "water_and_wetness/water_and_wetness_11x11_20221201.tif", overwrite=T)
writeRaster(water_and_wetness_15x15, filename = "water_and_wetness/water_and_wetness_15x15_20221201.tif", overwrite=T)

###############################################################################
### imperviousness_density
imperviousness_density<-raster("imperviousness_density/imperviousness_density_crop_20221022.tif")
plot(imperviousness_density)

imperviousness_density_3x3 <- focal(imperviousness_density,w=matrix(1/9,3,3), fun=mean)
imperviousness_density_5x5 <- focal(imperviousness_density,w=matrix(1/25,5,5), fun=mean)
imperviousness_density_9x9 <- focal(imperviousness_density,w=matrix(1/81,9,9), fun=mean)
imperviousness_density_11x11 <- focal(imperviousness_density,w=matrix(1/121,11,11), fun=mean)
imperviousness_density_15x15 <- focal(imperviousness_density,w=matrix(1/225,15,15), fun=mean)


plot(imperviousness_density_3x3)
plot(imperviousness_density_5x5)
plot(imperviousness_density_9x9)
plot(imperviousness_density_11x11)
plot(imperviousness_density_15x15)

#Write results!
writeRaster(imperviousness_density_3x3, filename = "imperviousness_density/imperviousness_density_3x3_20221201.tif", overwrite=T)
writeRaster(imperviousness_density_5x5, filename = "imperviousness_density/imperviousness_density_5x5_20221201.tif", overwrite=T)
writeRaster(imperviousness_density_9x9, filename = "imperviousness_density/imperviousness_density_9x9_20221201.tif", overwrite=T)
writeRaster(imperviousness_density_11x11, filename = "imperviousness_density/imperviousness_density_11x11_20221201.tif", overwrite=T)
writeRaster(imperviousness_density_15x15, filename = "imperviousness_density/imperviousness_density_15x15_20221201.tif", overwrite=T)


###############################################################################
### grassland_status
grassland_status<-raster("grassland_status/grassland_status_crop_20221019.tif")
plot(grassland_status)

grassland_status_3x3 <- focal(grassland_status,w=matrix(1/9,3,3), fun=mean)
grassland_status_5x5 <- focal(grassland_status,w=matrix(1/25,5,5), fun=mean)
grassland_status_9x9 <- focal(grassland_status,w=matrix(1/81,9,9), fun=mean)
grassland_status_11x11 <- focal(grassland_status,w=matrix(1/121,11,11), fun=mean)
grassland_status_15x15 <- focal(grassland_status,w=matrix(1/225,15,15), fun=mean)

plot(grassland_status_3x3)
plot(grassland_status_5x5)
plot(grassland_status_9x9)
plot(grassland_status_11x11)
plot(grassland_status_15x15)

#Write results!
writeRaster(grassland_status_3x3, filename = "grassland_status/grassland_status_3x3_20221201.tif", overwrite=T)
writeRaster(grassland_status_5x5, filename = "grassland_status/grassland_status_5x5_20221201.tif", overwrite=T)
writeRaster(grassland_status_9x9, filename = "grassland_status/grassland_status_9x9_20221201.tif", overwrite=T)
writeRaster(grassland_status_11x11, filename = "grassland_status/grassland_status_11x11_20221201.tif", overwrite=T)
writeRaster(grassland_status_15x15, filename = "grassland_status/grassland_status_15x15_20221201.tif", overwrite=T)


###############################################################################
### dlm_landwirtschaft
dlm_landwirtschaft<-raster("dlm/dlm_landwirtschaft_20221024.tif")
plot(dlm_landwirtschaft)

extent(dlm_landwirtschaft)

dlm_landwirtschaft_3x3 <- focal(dlm_landwirtschaft,w=matrix(1/9,3,3), fun=mean)
dlm_landwirtschaft_5x5 <- focal(dlm_landwirtschaft,w=matrix(1/25,5,5), fun=mean)
dlm_landwirtschaft_9x9 <- focal(dlm_landwirtschaft,w=matrix(1/81,9,9), fun=mean)
dlm_landwirtschaft_11x11 <- focal(dlm_landwirtschaft,w=matrix(1/121,11,11), fun=mean)
dlm_landwirtschaft_15x15 <- focal(dlm_landwirtschaft,w=matrix(1/225,15,15), fun=mean)

plot(dlm_landwirtschaft_3x3)
plot(dlm_landwirtschaft_5x5)
plot(dlm_landwirtschaft_9x9)
plot(dlm_landwirtschaft_11x11)
plot(dlm_landwirtschaft_15x15)


values(dlm_landwirtschaft)[is.na(values(dlm_landwirtschaft))]<-0
values(dlm_landwirtschaft)

#mean((values(dlm_lw$dlm_lw)), na.rm=T)
#values(dlm_landwirtschaft_3x3)
values(dlm_landwirtschaft_3x3)[is.na(values(dlm_landwirtschaft_3x3))]<-0
#mean((values(dlm_landwirtschaft_3x3)), na.rm=T)
values(dlm_landwirtschaft_3x3)

#values(dlm_landwirtschaft_5x5)
values(dlm_landwirtschaft_5x5)[is.na(values(dlm_landwirtschaft_5x5))]<-0
#values(dlm_landwirtschaft_5x5)

#values(dlm_landwirtschaft_9x9)
values(dlm_landwirtschaft_9x9)[is.na(values(dlm_landwirtschaft_9x9))]<-0
#values(dlm_landwirtschaft_9x9)

#values(dlm_landwirtschaft_11x11)
values(dlm_landwirtschaft_11x11)[is.na(values(dlm_landwirtschaft_11x11))]<-0
#values(dlm_landwirtschaft_11x11)

#values(dlm_landwirtschaft_15x15)
values(dlm_landwirtschaft_15x15)[is.na(values(dlm_landwirtschaft_15x15))]<-0
#values(dlm_landwirtschaft_15x15)


#Write results!
writeRaster(dlm_landwirtschaft, filename = "dlm/dlm_landwirtschaft_20221205.tif", overwrite=T)
writeRaster(dlm_landwirtschaft_3x3, filename = "dlm/dlm_landwirtschaft_3x3_20221201.tif", overwrite=T)
writeRaster(dlm_landwirtschaft_5x5, filename = "dlm/dlm_landwirtschaft_5x5_20221201.tif", overwrite=T)
writeRaster(dlm_landwirtschaft_9x9, filename = "dlm/dlm_landwirtschaft_9x9_20221201.tif", overwrite=T)
writeRaster(dlm_landwirtschaft_11x11, filename = "dlm/dlm_landwirtschaft_11x11_20221201.tif", overwrite=T)
writeRaster(dlm_landwirtschaft_15x15, filename = "dlm/dlm_landwirtschaft_15x15_20221201.tif", overwrite=T)

##### dlm gesamt (10m)####)#########################################################################
dlm_all <- stack( "dlm/dlm_raster_all_20221201.tif")

extent(dlm_all)
dlm_all <- resample(dlm_all,tree_cover)
extent(dlm_all)

#Write results
writeRaster(dlm_all, filename = "dlm/dlm_all_20221205.tif", overwrite=T)

