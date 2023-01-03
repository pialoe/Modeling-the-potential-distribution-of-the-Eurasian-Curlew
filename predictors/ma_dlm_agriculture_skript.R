rm(list=ls() )

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren")

library(sp)
library(sf) 
library(mapview)
library(raster)
library(tmap)


#load shapefile agricultural area (from DLM)
landwirtschaft <- read_sf('dlm/dlm_daten/veg01_f.shp')
landwirtschaft <- as(landwirtschaft, "sf")
landwirtschaft <- st_transform(landwirtschaft, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

#load outline Steinfurt and Borken 
umriss <- read_sf('umriss/umriss_gesamt.shp')
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

#crop to the area
dlm_lw_crop <- st_crop(landwirtschaft,umriss)


# Mode function
Mode <- function(x, na.rm = FALSE) {
  if(na.rm){
    x = subset(x, !is.na(x))
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}    

#empty Raster 
e <- extent(umriss)
projection <- crs(umriss)
r <- raster(e,
            crs = projection)
res(r) <- 10

#raster
dlm_raster <- rasterize(dlm_lw_crop, r, field= as.numeric(dlm_lw_crop$OBJART),
                        getCover=F, fun=Mode)

#Coordinate system WGS84
dlm_ext <- projectExtent(dlm_raster, crs="+proj=longlat +datum=WGS84 +no_defs")
dlm_proj <- projectRaster(dlm_raster, dlm_ext, method="ngb") 


dlm_raster_mask=mask(dlm_proj, umriss)

# save Raster 
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/dlm")
writeRaster(dlm_proj,"dlm_landwirtschaft_20221024.tif", overwrite = T)
