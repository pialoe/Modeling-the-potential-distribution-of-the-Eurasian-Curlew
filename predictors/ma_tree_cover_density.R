
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

#setwd("C:/Users/Dana/sciebo/UHI_Projekt_Fernerkundung/Daten_roh/FE_Urban_Atlas_Tree_Cover (Copernicus)/40c4f17ce65366ae2881787e2ae2a1d1680f5328/TCD_2018_010m_de_03035_v020/TCD_2018_010m_de_03035_v020/DATA/")
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/tree_cover_density/TCD_2018_010m_de_03035_v020/DATA/")

#read in files
files=list.files(pattern = ".tif")

#exclude dbf files
dbffiles = list.files(pattern='.dbf')
files=files[!files %in% dbffiles] 
#import all raster files in folder using lapply
cop <- lapply(files, raster)

#mosiac tiles 
cop_treecover_crop=mosaic(cop[[4]],cop[[5]], cop[[11]], cop[[12]], fun="mean")
mapview(cop_treecover_crop) 

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/")

# load outline Steinfurt and Borken 
umriss <- read_sf('umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

mapview(umriss)
mapview(cop_treecover_crop)

#check if crs are matching
crs(umriss) 
crs(cop[[1]])

#transform coordinates of cop coordinate system to gadm
cop_treecover_crop_proj=projectRaster(from=cop_treecover_crop, crs=crs(umriss)) 

mapview(cop_treecover_crop_proj) 
crs(cop_treecover_crop_proj)

##mask
cop_treecover_mask=mask(cop_treecover_crop_proj, umriss)
mapview(cop_treecover_mask) +mapview(umriss)
mapview(cop_treecover_mask)

#save file
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/tree_cover_density/")
writeRaster(cop_treecover_mask, filename = "copernicus_treecover_crop.tif", 
            overwrite=T)





