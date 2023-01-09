
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
library(beepr)

setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/")

##############  load stack 
predstack <- stack("praediktoren/stack/ma_pred_stack_20221209.grd")
names(predstack)

############## Load absence data (ÖFS areas as tiles)
absence_data <- st_read("trainingsdaten/abwesenheit/ofs_flaechen_abwesenheitsdaten_neu_neu.shp")
absence_data <- as(absence_data, "sf")
absence_data <- st_transform(absence_data, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
plot(absence_data)
absence_data$ID <- seq.int(nrow(absence_data))


############# load presence data
presence_data <- st_read("trainingsdaten/anwesenheit/biologische_stationen/anwesenheitsdaten_gbr_neu_20221028.shp")
presence_data <- as(presence_data, "sf")
crs(presence_data)
presence_data <- st_transform(presence_data, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
plot(presence_data)
presence_data$ID <- seq.int(nrow(presence_data))

#delete negative values
presence_data <- presence_data[-c(250,251,270,271),]
plot(presence_data)

class(presence_data)

#### absence points 
for (i in 1:nrow(absence_data)) {
  if(i==1){
    absence_data_sample <- st_sample(absence_data$geometry[i], size = 10)
    absence_data_points_list<-absence_data_sample
  }else{
    absence_data_sample <- st_sample(absence_data$geometry[i], size = 10)
    absence_data_points_list<-append(absence_data_points_list, absence_data_sample)
  }
}

absence_data_points_list_sf <- do.call(rbind, absence_data_points_list)
class(absence_data_points_list_sf)


absence_data_points_list_sf <- as.data.frame(absence_data_points_list_sf)

absence_data_points_list_sf$occurrence <- 0

absence_data_points_coor <- st_as_sf(absence_data_points_list_sf, coords = c("lon", "lat"), crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

presence_data <- presence_data[,-c(1,2,3)]

crs(absence_data_points_coor)

training_data <- rbind(absence_data_points_coor, presence_data)
class(training_data)

training_data$ID <- seq.int(nrow(training_data))

training_data_coor <- st_as_sf(training_data, coords = c("lon", "lat"), crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
class(training_data_coor)
st_write(training_data_coor, "trainingsdaten/trainingdata_20221209.shp")

training_data <-  read_sf("trainingsdaten/trainingdata_20221209.shp")

##########combine data
extr <- extract(predstack,training_data,df=TRUE)
training_data$PolyID <- 1:nrow(training_data) 
training_data_extr <- merge(extr,training_data,by.x="ID",by.y="PolyID")
names(training_data_extr)

training_data_extr$occurrence <- training_data$occurrence
training_data_extr <- training_data_extr[,-c(38)]

training_data_extr
names(training_data_extr)
training_data_extr$ndmi_9x9

#### write stack
write.csv(training_data_extr,"trainingsdaten/total_stack_20221209.csv")




