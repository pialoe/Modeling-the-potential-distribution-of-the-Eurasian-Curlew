rm(list=ls() )

#Preprocess and crop Copernicus data
#Copernicus data
#load librarys
library(sp)
library(raster)
library(cop)
library(copTools)
library(rgdal)
library(gdalUtils)
library(sf)
library(mapview)

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/grassland_status/GRA_2018_010m_de_03035_v010/DATA/")

#read in files
files=list.files(pattern = ".tif")

#exclude dbf files
dbffiles = list.files(pattern='.dbf')
files=files[!files %in% dbffiles] 
#import all raster files in folder using lapply
cop <- lapply(files, raster)

#mosiac tiles 
cop_grass_status_crop=mosaic(cop[[4]],cop[[5]], cop[[11]], cop[[12]], fun="mean")
mapview(cop_grass_status_crop) #check

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/")

# load outline Steinfurt and Borken 
umriss <- read_sf('umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

mapview(umriss)
mapview(cop_grass_status_crop)

#check if crs are matching
crs(umriss) 
crs(cop[[1]])

#transform coordinates of cop coordinate system to gadm
cop_grass_status_crop_proj=projectRaster(from=cop_grass_status_crop, crs=crs(umriss)) 

mapview(cop_grass_status_crop_proj) #check 
crs(cop_grass_status_crop_proj)

#crop 
cop_grass_status_mask=mask(cop_grass_status_crop_proj, umriss)
mapview(cop_grass_status_mask) +mapview(umriss)
mapview(cop_grass_status_mask)

#save cropped but not aggregated file
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/grassland_status/")
writeRaster(cop_grass_status_mask, filename = "grassland_status_crop_20221019.tif", 
            overwrite=T)




