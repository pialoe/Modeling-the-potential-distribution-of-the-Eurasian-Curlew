rm(list=ls() )
library(sp)
library(sf) 
library(mapview)
library(raster)
library(rgdal)
library(tmap)
library(tmaptools)
library(stars)
library(CAST)
library(caret)
library(randomForest)
library(latticeExtra)


###############################################################################################
# stack
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/")

##### tree_cover_density 
tree_cover_density <- stack( "tree_cover_density/copernicus_treecover_crop_20221016.tif",     
                             "tree_cover_density/tree_cover_5x5_20221201.tif",
                             "tree_cover_density/tree_cover_9x9_20221201.tif",
                             "tree_cover_density/tree_cover_15x15_20221201.tif")
names(tree_cover_density)
names(tree_cover_density)<-c("tree_cover_density", "tree_cover_density_5x5", "tree_cover_density_9x9", "tree_cover_density_15x15")
names(tree_cover_density)

##### water_and_wetness 
water_and_wetness <- stack( "water_and_wetness/water_and_wetness_crop_20221016.tif",     
                            "water_and_wetness/water_and_wetness_5x5_20221201.tif",
                            "water_and_wetness/water_and_wetness_9x9_20221201.tif",
                            "water_and_wetness/water_and_wetness_15x15_20221201.tif")
names(water_and_wetness)
names(water_and_wetness)<-c("water_and_wetness", "water_and_wetness_5x5", "water_and_wetness_9x9", "water_and_wetness_15x15")
names(water_and_wetness)

##### imperviousness_density 
imperviousness_density <- stack( "imperviousness_density/imperviousness_density_crop_20221022.tif",     
                                 "imperviousness_density/imperviousness_density_5x5_20221201.tif",
                                 "imperviousness_density/imperviousness_density_9x9_20221201.tif",
                                 "imperviousness_density/imperviousness_density_15x15_20221201.tif")
names(imperviousness_density)
names(imperviousness_density)<-c("imperviousness_density", "imperviousness_density_5x5","imperviousness_density_9x9", "imperviousness_density_15x15")
names(imperviousness_density)

##### grassland_status 
grassland_status <- stack( "grassland_status/grassland_status_crop_20221019.tif",
                           "grassland_status/grassland_status_3x3_20221201.tif",  
                           "grassland_status/grassland_status_5x5_20221201.tif",
                           "grassland_status/grassland_status_9x9_20221201.tif")
names(grassland_status)
names(grassland_status)<-c("grassland_status", "grassland_status_3x3", "grassland_status_5x5","grassland_status_9x9")
names(grassland_status)

##### dlm agricultural area
dlm_lw <- stack( "dlm/dlm_landwirtschaft_20221024.tif",     
                 "dlm/dlm_landwirtschaft_5x5_20221201.tif",
                 "dlm/dlm_landwirtschaft_9x9_20221201.tif",
                 "dlm/dlm_landwirtschaft_15x15_20221201.tif")
names(dlm_lw)
names(dlm_lw)<-c("dlm_lw", "dlm_lw_5x5", "dlm_lw_9x9", "dlm_lw_15x15")
names(dlm_lw)

##### dlmall
dlm_all <- stack( "dlm/dlm_all_20221205.tif")
names(dlm_all)
names(dlm_all)<-c("dlm_all")
names(dlm_all)

##### ndvi 
ndvi <- stack( "ndvi_ndmi/ndvi_20221205.tif",     
               "ndvi_ndmi/ndvi_5x5_20221201.tif",
               "ndvi_ndmi/ndvi_9x9_20221201.tif",
               "ndvi_ndmi/ndvi_15x15_20221201.tif",
               "ndvi_ndmi/ndvi_5x5_sd_20221209.tif",
               "ndvi_ndmi/ndvi_9x9_sd_20221209.tif",
               "ndvi_ndmi/ndvi_15x15_sd_20221209.tif")

names(ndvi)
names(ndvi)<-c("ndvi", "ndvi_5x5", "ndvi_9x9", "ndvi_15x15","ndvi_sd_5x5", "ndvi_sd_9x9", "ndvi_sd_15x15")
names(ndvi)

##### ndmi 
ndmi <- stack( "ndvi_ndmi/ndmi_20221205.tif",     
               "ndvi_ndmi/ndmi_5x5_20221201.tif",
               "ndvi_ndmi/ndmi_9x9_20221201.tif",
               "ndvi_ndmi/ndmi_15x15_20221201.tif",
               "ndvi_ndmi/ndmi_5x5_sd_20221209.tif",
               "ndvi_ndmi/ndmi_9x9_sd_20221209.tif",
               "ndvi_ndmi/ndmi_15x15_sd_20221209.tif")

names(ndmi)
names(ndmi)<-c("ndmi", "ndmi_5x5", "ndmi_9x9", "ndmi_15x15", "ndmi_sd_5x5", "ndmi_sd_9x9", "ndmi_sd_15x15")
names(ndmi)

####check extent
extent(tree_cover_density)
extent(ndmi)
extent(ndvi)
extent(dlm_lw)
extent(water_and_wetness)
extent(imperviousness_density)
extent(dlm_all)
extent(grassland_status)

##### write stack
pred_stack <- stack(tree_cover_density, water_and_wetness, imperviousness_density,
                    grassland_status, dlm_lw, dlm_all, ndvi, ndmi)

names(pred_stack) 

## safe Stack
writeRaster(pred_stack,
            "/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/stack/ma_pred_stack_20221209.grd",
            overwrite=TRUE)

