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
library(ggplot2)
library(stringr)
library(sptm)
library(devtools)



setwd("/Users/pialoettert/Documents/masterdesaster/masterarbeit/")

##############  load tack 
total_stack <- read.csv("trainingsdaten/total_stack_citizen_science_20221214.csv")

# Modify column names                          
total_stack                                                                          
total_stack <- total_stack[,-c(37)]

total_stack$occurrence <- as.factor(total_stack$occurrence)

#ensure that no NA is included in predictors
total_stack_incomplete_cases<-total_stack[!complete.cases(total_stack),]

total_stack <- total_stack[complete.cases(total_stack),]

#load trainingsdata
test <- read_sf("trainingsdaten/training_data_citizen_science_20221214.shp")
test <- test[-c(105,148, 167,180, 185,199,220,253,
                260,278,335,336,358,372, 449,497,
                522,526,536,570,573,580,599,610,620,
                627,649,652,707,712,751,790,791,793,
                801,812,815,818,844,857,914),] 


total_stack$geometry <- test$geometry

test <- st_as_sf(test, coords = c("x", "y"))

# plot species data on the map
plot(test) 
mapview(test) 


# change names
test[, 2] <- sapply(test[, 2], as.character)
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

png(file="maps/trainids_blocks_citizenscience_20221231.png", width = 100, height=100,units="mm", res = 200)
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

total_stack[, 39] <- sapply(total_stack[, 39], as.character)
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
                   metric="ROC", #Roc
                   ntree=500, #number of trees
                   tuneGrid=data.frame("mtry"=2:35),  #tuning
                   trControl=trainControl(method="cv", #10 fold blocked CV
                                          index=traincontrol_block_cv$index,
                                          indexOut = traincontrol_block_cv$indexOut,
                                          summaryFunction=twoClassSummary,
                                          classProbs = TRUE,
                                          savePredictions = TRUE), #folds
                   savePrediction=TRUE)  #cl=cl
warnings()
model

# variable importance
plot(varImp(model)) 
plot(model)

varimp_citizen_science <- (varImp(model)) 
png(filename="VarImp_model2.png", width=700, height=300)
plot(varimp_citizen_science, main="Model 2", 
     cex.lab=5, cex.axis=5, cex.main=10)
dev.off()

#save model
saveRDS(model,file="model/ma_ffs_Model_citizen_science_2022-12-23.RDS") # modell speichern!

## load predstack
pred_stack <- stack("praediktoren/stack/ma_pred_stack_20221223.grd")

#####prediction
predict<-predict(pred_stack, model, savePrediction=TRUE)
mapview(predict)
writeRaster(predict,"model/prediction_citizen_science_20221223.grd",overwrite=TRUE) # Ausschreiben!

predict_prob<-predict(pred_stack, model, type = "prob", savePrediction=TRUE)
mapview(predict_prob)
writeRaster(predict_prob,"model/prediction_prob_citizen_science_20221223.grd",overwrite=TRUE) # Ausschreiben!

#classificationStats
model$pred$mtry
model$pred
model$bestTune$mtry
validationDat <- model$pred
classificationStats(validationDat$pred,
                    validationDat$obs,
                    prob=validationDat$presence) 
