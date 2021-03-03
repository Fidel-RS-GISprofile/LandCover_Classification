####****** Random Forest Unsupervised classification******################################

rm(list = ls()); cat("\014") #Clear environment

library(raster) #load packages
library(cluster)
library(clusterCrit)
library(randomForest)
library(RStoolbox)

workdir <- "C:/Users/F1User/Desktop/work/classfn_test/"
setwd(workdir) # set a working directory 
rst <- "tile3West_ls82020.tif"
rst <- stack(rst) #input a multiband raster

## returns the values of the raster dataset and write them in a matrix. 
v <- getValues(rst)
i <- which(!is.na(v)) #NAs for too large files show an error, please ignore.
v <- na.omit(v) #Remove all NAs

#The KMEAN clusters are used to train another random Forest model for classification.
## unsupervised randomForest classification using kmeans
vx<-v[sample(nrow(v), 500),]
rf = randomForest(vx)
rf_prox <- randomForest(vx,ntree = 1000, proximity = TRUE)$proximity

E_rf <- kmeans(rf_prox, 25, 
               iter.max = 100, 
               nstart = 100)

rf <- randomForest(vx,as.factor(E_rf$cluster),
                   ntree = 500)

rf_raster<- predict(rst,rf)

# plot(rf_raster, col=c("yellow", "darkgreen","pink", "orange", "pink","darkgreen", 
#                       "darkgreen", "blue", "green", "pink", "pink", "pink"))

writeRaster(rf_raster,"ls8ug_RF2019_25.tif", overwrite=TRUE)
print("*********COMPLETE**********")
