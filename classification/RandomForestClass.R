#################### SUPERVISED CLASSIFICATION RANDOM FOREST #########################
##########-Adopted from GWA_toolbox
##########-Contact: Fidel UWizeye; FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com
# This script is better for classification of large sentinel 2 files

################################# CLEAR ENVIRONMENT AND CONSOLE ######################
rm(list = ls()); cat("\014")

# TODO: make sure that the training date crs matches the raster crs. 
# TODO: remove any NA values in training data. Give warning if some 
#training data is outside extent.
# TODO: if classification returns only NA - make warning that
#mask needs to have NA values defined.

#####-Check for packages required, and if they are not installed, instal them.########
tryCatch(find.package("maptools"), 
         error=function(e) install.packages("maptools", lib=file.path(.Library[1])))
tryCatch(find.package("randomForest"), 
         error=function(e) install.packages("randomForest", lib=file.path(.Library[1])))
tryCatch(find.package("snow"), 
         error=function(e) install.packages("snow", lib=file.path(.Library[1])))
tryCatch(find.package("snowfall"), 
         error=function(e) install.packages("snowfall", lib=file.path(.Library[1])))
tryCatch(find.package("parallel"), 
         error=function(e) install.packages("parallel", lib=file.path(.Library[1])))

########################### LOAD REQUIRED LIBRARIES ##################################
library(raster)
library(maptools)
library(randomForest)
library(snow)
library(snowfall)
library(rgdal)
library(parallel)

######################## WORKING DIRECTORY ###########################################
workdir <- "~/lc_mapping2019fdl/data/"
setwd(workdir)
cores <- detectCores()

######################## RASTER OPTIONS AND PARAMETERS ###############################
rasterOptions(chunksize = 1e+07, maxmemory = 1e+08, tmptime = 24, 
              progress = "text", timer = TRUE, overwrite = TRUE, datatype = "INT2S")
Number_of_Trees <- 100
img <- "smooth_stnl2UG19_7band.tif" #input multiband image
img <- stack(img) 
Output_img <- "ug500_stnl2lc19_1v6.tif" #Output classification

######################## LOAD TRAINING DATA ##########################################
Training_Data <- "Training_Data/TrainingData_final.shp"
Training_Data <- rgdal::readOGR(Training_Data) #classification Training data.
Class_ID_Field <- "class_id" #Set class id field.

######################## START PROCESSING ############################################
startTime <- Sys.time()
cat("Start time", format(startTime),"/n")
# first make sure that the class ID field is not a factor, & change it to numeric
if (class(eval(parse(text = paste('Training_Data@data$', Class_ID_Field, 
                                  sep = '')))) == 'factor'){
eval(parse(text = paste0('Training_Data@data$', 
                         Class_ID_Field, '<- as.numeric(as.character(Training_Data@data$', 
                         Class_ID_Field, '))')))
}

################# EXTRACT TRAINING DATA IN PARALLEL USING SNOWFALL ###################
# First, if the training data are vector polygons they must be coverted to points
# to speed things up
if (class(Training_Data)[1] == 'SpatialPolygonsDataFrame'){
# rasterize
poly_rst <- rasterize(Training_Data, img[[1]], field = Class_ID_Field)
# convert pixels to points
Training_Data_P <- rasterToPoints(poly_rst, spatial=TRUE)
# give the point ID the 'Class_ID_Field' name
names(Training_Data_P@data) <- Class_ID_Field
# note for some strange reason, the crs of the spatial points did not match the imagery!
# here the crs of the sample points is changed back to match the input imagery
crs(Training_Data_P) <- crs(img[[1]])
}

################# EXTRACT TRAINING DATA IN PARALLEL USING SNOWFALL ###################
imgl <- unstack(img)
sfInit(parallel=TRUE, cpus = cores)
sfLibrary(raster)
sfLibrary(rgdal)
if (class(Training_Data)[1] == 'SpatialPolygonsDataFrame'){
data <- sfSapply(imgl, extract, y = Training_Data_P)
} else {
data <- sfSapply(imgl, extract, y = Training_Data)
}
sfStop()
data <- data.frame(data)
names(data) <- names(img)

############# ADD CLASSIFICATION ID TO THE MODEL TRAINING DATA #######################
if (class(Training_Data)[1] == 'SpatialPolygonsDataFrame'){
data$LUC <- as.vector(eval(parse(text = paste('Training_Data_P@data$', Class_ID_Field, 
                                              sep = ''))))
} else {
data$LUC <- as.vector(eval(parse(text = paste('Training_Data@data$', Class_ID_Field, 
                                              sep = ''))))
}

###################### RUN RANDOM FOREST #############################################
RandomForestModel <- randomForest(data[,1:(ncol(data)-1)], as.factor(data$LUC), 
                                  ntree = Number_of_Trees, mtry=3,
                                  importance = T, scale = F)

###################### GET OUT-OF-BAG ERROR ##########################################
OOBE <- as.data.frame(RandomForestModel[[5]])

###################### CLASSIFY THE IMAGE ############################################
beginCluster(cores)
map_rf <- clusterR(img, raster::predict, args = list(model = RandomForestModel, 
                                                     na.rm = TRUE))
endCluster()
gc()

##################### WRITE AND SAVE THE CLASSIFIED IMAGE ############################
LULC_yr <- writeRaster(map_rf, Output_img) #Process complete

#################### CALCULATE PROCESSING TIME #######################################
endTime <- format(Sys.time(), "%H:%M:%OS2"); timeDiff <- Sys.time() - startTime
cat("Processing time", format(timeDiff), "/n")
