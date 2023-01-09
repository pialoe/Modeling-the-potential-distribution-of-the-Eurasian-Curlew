
library(tmap)
library(raster)
library(tmaptools)
library(RColorBrewer)
library(mapview)
library(sp)
library(sf)
library(stringr)
library(OpenStreetMap)
setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/")

# load outline Steinfurt and Borken 
umriss <- read_sf('praediktoren/umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

#load trainingdata
trainingdata_bio_stat<- st_read("trainingsdaten/trainingdata_20221209.shp")
trainingdata_bio_stat <- trainingdata_bio_stat[-c(268,269,275,392,393,426,427,428,429),] 
trainingdata_bio_stat <- st_as_sf(trainingdata_bio_stat, coords = c("x", "y"))


plot(trainingdata_bio_stat) 
mapview(trainingdata_bio_stat) 

trainingdata_citizen_science <- read_sf("trainingsdaten/training_data_citizen_science_20221214.shp")
trainingdata_citizen_science <- trainingdata_citizen_science[-c(105,148, 167,180, 185,199,220,253,260,278,
                                                                335,336,358,372, 449,497,522,526,536,570,
                                                                573,580,599,610,620,627,649,652,707,712,751,
                                                                790,791,793,801,812,815,818,844,857,914),] 
trainingdata_citizen_science <- st_as_sf(trainingdata_citizen_science, coords = c("x", "y"))

plot(trainingdata_citizen_science) 
mapview(trainingdata_citizen_science) 

###create map model 1
map_trainingdata_bio_stat <- tm_shape(shp = umriss)+
  tm_polygons()+
  tm_shape(trainingdata_bio_stat,
           raster.downsample = FALSE) +
  tm_dots(title = "Trainingdata", 
          col = "occurrence", 
          style = 'cat',
          size = 0.2,
          palette = c("0"="#990000",  "1"='#006633'),#333333
          border.col = "white", 
          border.lwd = 3 , 
          legend.show = T,
          labels = c("0"='Absence', "1"='Presence'),)+
  tm_scale_bar(bg.color="white",position = c("right", "bottom"))+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("right","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 0.8,
            legend.text.size = 1,
            main.title = "Trainingdata Model 1",
            main.title.position = "center")+
  tm_compass(position = c("left","top"))
map_trainingdata_bio_stat
##save map
tmap_save(map_trainingdata_bio_stat, "maps/map_trainingdata_bio_stat.png")


###create map model 2
map_trainingdata_citizen_science <- tm_shape(shp = umriss)+
  tm_polygons()+
  tm_shape(trainingdata_citizen_science,
           raster.downsample = FALSE) +
  tm_dots(title = "Trainingdata", 
          col = "occurrence", 
          style = 'cat',
          size = 0.2,
          palette = c("0"="#990000",  "1"='#006633'),#333333
          border.col = "white", 
          border.lwd = 3 , 
          legend.show = T,
          labels = c("0"='Absence', "1"='Presence'),)+
  tm_scale_bar(bg.color="white",position = c("right", "bottom"))+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("right","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 0.8,
            legend.text.size = 1,
            main.title = "Trainingdata Model 2",
            main.title.position = "center")+
  tm_compass(position = c("left","top"))
map_trainingdata_citizen_science

##save map
tmap_save(map_trainingdata_citizen_science, "maps/map_trainingdata_citizen_science.png")

