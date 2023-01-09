
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

##############Load absence data 
absence_data <- st_read("trainingsdaten/abwesenheit/absence_data_citizen_science_20221211.shp")
absence_data <- as(absence_data, "sf")
absence_data <- st_transform(absence_data, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
plot(absence_data)
mapview(absence_data)
absence_data$ID <- seq.int(nrow(absence_data))


#punkte rausziehen

############# Load presence data 
presence_data <- st_read("trainingsdaten/anwesenheit/presence_data_citizen_science_20221214.shp")
presence_data <- as(presence_data, "sf")
crs(presence_data)
presence_data <- st_transform(presence_data, crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
plot(presence_data)
mapview(presence_data)


presence_data$ID <- seq.int(nrow(presence_data))

class(presence_data)


absence_data <- absence_data[,-c(1,2,3,4,5,6,7,8,9,10)]
absence_data$occurrence <- 0

presence_data <- presence_data[,-c(1,2,3,4,5,6,7,8,9,10,11,12,13)]
presence_data$occurrence <- 1

crs(absence_data)

training_data_citizen_science <- rbind(absence_data, presence_data)
class(training_data_citizen_science)

training_data_citizen_science$ID <- seq.int(nrow(training_data_citizen_science))

training_data_citizen_science <- st_as_sf(training_data_citizen_science, coords = c("lon", "lat"), crs ="+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
class(training_data_citizen_science)
st_write(training_data_citizen_science, "trainingsdaten/training_data_citizen_science_20221214.shp")

##########combine data
extr <- extract(predstack,training_data_citizen_science,df=TRUE)
training_data_citizen_science$PolyID <- 1:nrow(training_data_citizen_science) 
training_data_citizen_science_extr <- merge(extr,training_data_citizen_science,by.x="ID",by.y="PolyID")
names(training_data_citizen_science_extr)

training_data_citizen_science_extr$occurrence <- training_data_citizen_science$occurrence

training_data_citizen_science_extr
names(training_data_citizen_science_extr)
training_data_citizen_science_extr$ndmi_9x9

#### write stack
st_write(training_data_citizen_science_extr, "trainingsdaten/total_stack_citizen_science_20221214.csv")






