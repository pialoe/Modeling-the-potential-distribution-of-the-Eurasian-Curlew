rm(list=ls() )

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren")

library(sp)
library(sf) 
library(mapview)
library(raster)
library(tmap)


#load shapefiles 
dlmlist_all <- list.files("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/dlm/dlm_daten", pattern = "*_f.shp", full.names = TRUE)

str(dlmlist_all)
dlmlist_all

#Namen  for list
names(dlmlist_all) <- c("geb01_f.shp","geb02_f.shp","geb03_f.shp","gew01_f.shp","gew02_f.shp","rel01_f.shp",
                        "sie01_f.shp","sie02_f.shp","sie03_f.shp","sie04_f.shp","veg01_f.shp","veg02_f.shp",
                        "veg03_f.shp","veg04_f.shp","ver01_f.shp","ver03_f.shp","ver04_f.shp","ver05_f.shp",
                        "ver06_f.shp")

dlmlist <- lapply(dlmlist_all, read_sf)
dlmlist_all_2 <- lapply(dlmlist_all, read_sf)

# load outline Steinfurt and Borken 
umriss <- read_sf('umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

str(dlmlist)
head(dlmlist)

#extract important Variabeln 
for (i in seq(dlmlist)){
  layer <- dlmlist[[i]]
  layer <- layer[,3]
  dlmlist[[i]] <- layer
}

# remove administrative layer 
dlm_wo <- dlmlist[4:19]

#combine to one spdf 
combinedShp <- do.call("rbind", args=dlm_wo)


#crop to the area
umriss <- st_transform(umriss,crs(combinedShp))

dlm_crop <- st_crop(combinedShp,umriss)



#tmap
tm_shape(dlm_crop) +
  tm_polygons("OBJART") +
  tm_fill(style="cat")  +
  tmap_options(max.categories = 36) +
  tm_layout(legend.outside = TRUE) 


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
dlm_raster <- rasterize(dlm_crop, r, field= as.numeric(dlm_crop$OBJART),
                        getCover=F, fun=Mode)

#Coordinate system WGS84
dlm_ext <- projectExtent(dlm_raster, crs="+proj=longlat +datum=WGS84 +no_defs")
dlm_proj <- projectRaster(dlm_raster, dlm_ext, method="ngb") 

plot(dlm_raster)
mapview(dlm_raster)

# mask
dlm_raster_mask=mask(dlm_raster, umriss)

plot(dlm_raster_mask)


# save raster 
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/praediktoren/dlm")
writeRaster(dlm_raster_mask,"dlm_raster_all_20221201.tif", overwrite = T)
