rm(list=ls())
library(raster)
library(caret)
library(CAST)
library(spatialsample)
library(remotes)
library(blockCV)
library(sf)
library(ggplot2)
library(mapview)
library(stringr)
library(ggplot2)
library(devtools)
library(sptm)


setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/")

##############  load stack 
total_stack <- read.csv("trainingsdaten/total_stack_20221209.csv")
# Modify column names
colnames(total_stack) <- colnames(total_stack)[2:ncol(total_stack)]                                
total_stack                                                                     

total_stack$occurrence <- as.factor(total_stack$occurrence)

#ensure that no NA is included in predictors
total_stack_incomplete_cases<-total_stack[!complete.cases(total_stack),]

total_stack <- total_stack[complete.cases(total_stack),]


#load trainingdata
test <- read_sf("trainingsdaten/trainingdata_20221209.shp")
test <- test[-c(268,269,275,392,393,426,427,428,429),] 

test<- test[,-c(2)]
test <- st_as_sf(test, coords = c("x", "y"))

# plot species data on the map
plot(test) 

# change names
test[, 1] <- sapply(test[, 1], as.character)
test$occurrence2 <- str_replace(test$occurrence, "0", "absence")
test$occurrence2 <- str_replace(test$occurrence, "1", "presence")
test

# spatial blocking by specified range with random assignment
trainids_blocks_2 <- spatialBlock(speciesData = test,
                                  species = "occurrence2",
                                  theRange = 10000, # size of the blocks
                                  k = 10,
                                  selection = "random")



map<-trainids_blocks_2$plots + geom_sf(data = test, alpha = 0.5)

plot(trainids_blocks_2)

png(file="maps/trainids_blocks_biologische_st_20221231.png", width = 100, height=100,units="mm", res = 200)
plot(trainids_blocks_2)
dev.off()


trainids_blocks_2$folds
trainids_blocks_2$foldID
folds <- trainids_blocks_2$folds

folds

#extract only index (first element) from list of folds
trainids_block_index<-sapply(folds,"[[",1)
trainids_block_indexout<-sapply(folds,"[[",2)

trainids_block_index

trainids_block_indexout


?trainControl
traincontrol_block_cv<-trainControl(method="cv",index=trainids_block_index, indexOut = trainids_block_indexout)

traincontrol_block_cv
traincontrol_block_cv$index
traincontrol_block_cv$indexOut

names(total_stack)
levels(total_stack$occurrence)
total_stack$occurrence2 <- factor(total_stack$occurrence,levels=c("1","0"))
levels(total_stack$occurrence2)

total_stack[, 40] <- sapply(total_stack[, 40], as.character)
total_stack$occurrence2 <- str_replace(total_stack$occurrence2, "0", "absence")
total_stack$occurrence2 <- str_replace(total_stack$occurrence2, "1", "presence")

names(total_stack)

total_stack2 <- total_stack[,-c(37)]
names(total_stack2)


#train model mit buffered CV
model <- CAST::ffs(total_stack2[,c("tree_cover_density","tree_cover_density_5x5","tree_cover_density_9x9",
                                  "tree_cover_density_15x15","water_and_wetness","water_and_wetness_5x5",
                                  "water_and_wetness_9x9","water_and_wetness_15x15","imperviousness_density",
                                  "imperviousness_density_5x5","imperviousness_density_9x9","imperviousness_density_15x15",
                                  "grassland_status","grassland_status_3x3","grassland_status_5x5","grassland_status_9x9",
                                  "dlm_lw","dlm_lw_5x5","dlm_lw_9x9","dlm_lw_15x15","dlm_all","ndvi","ndvi_5x5",
                                  "ndvi_9x9","ndvi_15x15","ndvi_sd_5x5", "ndvi_sd_9x9", "ndvi_sd_15x15", 
                                  "ndmi","ndmi_5x5","ndmi_9x9","ndmi_sd_5x5", "ndmi_sd_9x9", "ndmi_sd_15x15" )], #predictors
                   total_stack2$occurrence2, #response
                   method="rf", #randomForest
                   metric="ROC", #roc
                   ntree=500, #number of trees
                   tuneGrid=data.frame("mtry"=2:35),   #tuning
                   trControl=trainControl(method="cv", #10 fold blocked CV
                                          index=traincontrol_block_cv$index,
                                          indexOut = traincontrol_block_cv$indexOut,
                                          summaryFunction=twoClassSummary,
                                          classProbs = TRUE,
                                          savePredictions = TRUE), #folds
                   savePrediction=TRUE)  #cl=cl
model

# variable importance
plot(varImp(model)) 
plot(model)

varimp_biostat <- (varImp(modelbio)) 
png(filename="VarImp_model1.png", width=700, height=300)
plot(varimp_biostat, main="Model 1", 
     cex.lab=5, cex.axis=5, cex.main=10)
dev.off()()

#save model
saveRDS(model,file="model/ma_ffs_Model_1_biological_station.RDS") 

## load predstack
pred_stack <- stack("praediktoren/stack/ma_pred_stack_20221209.grd")

#####prediction
predict<-predict(pred_stack, model, savePrediction=TRUE)
mapview(predict)
writeRaster(predict,"model/prediction_biostat_20221226.grd",overwrite=TRUE) # Ausschreiben!

predict_prob<-predict(pred_stack, model, type = "prob", savePrediction=TRUE)
mapview(predict_prob)
writeRaster(predict_prob,"model/prediction_probability_biological_stations.grd",overwrite=TRUE) # Ausschreiben!

#classificationStats
model$pred$mtry
model$pred
model$bestTune$mtry
validationDat
validationDat <- model$pred
classificationStats(validationDat$pred,
                    validationDat$obs,
                    prob=validationDat$presence) 
