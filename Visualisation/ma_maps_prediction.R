rm(list=ls())

library(raster)
library(caret)
library(CAST)
library(remotes)
library(sf)
library(ggplot2)
library(mapview)
library(tmap)
library(RColorBrewer)

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/")

predict_prob_citizen_science <- stack("model/prediction_probability_citizen_science.grd")
predict_citizen_science <- stack("model/prediction_citizen_science_20221223.grd")


predict_prob_biostat <- stack("model/prediction_probability_biological_stations.grd")
predict_biostat <- stack("model/prediction_biostat_20221226.grd")

# load outline Steinfurt and Borken 
umriss <- read_sf('praediktoren/umriss/umriss_gesamt.shp')
plot(umriss)
umriss <- as(umriss, "sf")
umriss <- st_transform(umriss, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")


##Visualisation
## model 1 biological stations
map_biostat <-   tm_shape(shp = umriss)+
  tm_polygons(col="black")+
  tm_shape(predict_biostat, 
           raster.downsample = FALSE)+
  tm_raster(title = "Predicted Habitat 
            (Model 1)",
            style = 'cat',
            breaks = c(1,1.2,1.4,1.6,1.8,2),
            labels = c("absence","presence"))+
  tm_scale_bar(bg.color="white")+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("left","bottom"),
            legend.bg.color = "white",
            bg.color="white",
            legend.bg.alpha = 0.8,
            legend.outside=T,
            legend.title.size = 1,
            legend.outside.size = 0.5)+
  tm_compass(position = c("left","top"))

map_biostat

tmap_save(map_biostat, "maps/predict_biostat_20221231_cat.png")


map_prob_biostat <-   tm_shape(shp = umriss)+
  tm_polygons(col="black")+
  tm_shape(predict_prob_biostat, 
           raster.downsample = FALSE)+
  tm_raster(title = "distribution probability
            (Model 1)",
            style = 'cont',
            breaks = c(0 ,0.2,0.4,0.6,0.8, 1),
            labels = c("100 %","80 %","60 %","40 %","20 %","0 %"),
            palette = "-viridis")+
  tm_scale_bar(bg.color="white")+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("left","bottom"),
            legend.bg.color = "white",
            bg.color="white",
            legend.bg.alpha = 0.8,
            legend.outside=T,
            legend.title.size = 1,
            legend.outside.size = 0.5)+
  tm_compass(position = c("left","top"))
map_prob_biostat

tmap_save(map_prob_biostat, "maps/predict_prob__biostat_20221231.png")

#cividis 
## model 2 citizen science
map_citizen_science <-   tm_shape(shp = umriss)+
  tm_polygons(col="black")+
  tm_shape(predict_citizen_science, 
           raster.downsample = FALSE)+
  tm_raster(title = "Predicted Habitat 
            (Model 2)",
            style = 'cat',
            breaks = c(1,1.2,1.4,1.6,1.8,2),
            labels = c("absence","presence"))+
  tm_scale_bar(bg.color="white")+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("left","bottom"),
            legend.bg.color = "white",
            bg.color="white",
            legend.bg.alpha = 0.8,
            legend.outside=T,
            legend.title.size = 1,
            legend.outside.size = 0.5)+
  tm_compass(position = c("left","top"))
map_citizen_science 

tmap_save(map_citizen_science, "maps/predict_citizen_science_20221231.png")


map_prob_citizen_science <-   tm_shape(shp = umriss)+
  tm_polygons(col="black")+
  tm_shape(predict_prob_citizen_science, 
           raster.downsample = FALSE)+
  tm_raster(title = "distribution probability
            (Model 2)",
            style = 'cont',
            breaks = c(0 ,0.2,0.4,0.6,0.8, 1),
            labels = c("100 %","80 %","60 %","40 %","20 %","0 %"),
            palette = "-viridis")+
  tm_scale_bar(bg.color="white")+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.position = c("left","bottom"),
            legend.bg.color = "white",
            bg.color="white",
            legend.bg.alpha = 0.8,
            legend.outside=T,
            legend.title.size = 1,
            legend.outside.size = 0.5)+
  tm_compass(position = c("left","top"))
map_prob_citizen_science

tmap_save(map_prob_citizen_science, "maps/predict_prob_citizen_science_20221231.png")

