
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
install.packages("beppr")
library(beppr)



setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/imperviousness_density/IMD_2018_010m_de_03035_v020/DATA/")


#read in files
files=list.files(pattern = ".tif")


#exclude dbf files
dbffiles = list.files(pattern='.dbf')
files=files[!files %in% dbffiles] 
#import all raster files in folder using lapply
cop <- lapply(files, raster)

#mosiac the two tiles that cover MS
imperviousness_density=mosaic(cop[[4]],cop[[5]], cop[[11]], cop[[12]], fun="mean")
mapview(imperviousness_density) #check


setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/")

# load outline Steinfurt and Borken 
umriss <- read_sf('umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

mapview(umriss)
mapview(cop_imperviousness_density)

#check if crs are matching
crs(umriss) 
crs(cop[[1]])

#transform coordinates of cop coordinate system to gadm
imperviousness_density_proj=projectRaster(from=imperviousness_density, crs=crs(umriss)) 

mapview(imperviousness_density_proj) #check 
crs(imperviousness_density_proj)


#crop 
imperviousness_density_mask=mask(imperviousness_density_proj, umriss)
mapview(imperviousness_density_mask) +mapview(umriss)
mapview(imperviousness_density_mask)

#save cropped but not aggregated file
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/imperviousness_density/")
writeRaster(cop_imperviousness_density_crop, filename = "copernicus_imperviousness_density_crop_10m.tif", 
            overwrite=T)




