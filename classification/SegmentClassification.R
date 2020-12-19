############################# OBIA- SEGMENT CLASSIFICATION #########################
# SCRIPT adopted from: Ned Horning[horning@amnh.org] & Wayne Walker[wwalker@whrc.org]
# Edited2020 by: Fidel UWizeye; FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com
# This script is better for classification of large sentinel 2 files OBIA

############ CLEAR THE ENV & CONSOLE; ##############################################
rm(list = ls()); cat("\014"); options(stringsAsFactors = FALSE)#read txt as txt

# include all the needed packages here #
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

# Load libraries
packages(randomForest)
packages(raster)
packages(rgdal)
packages(sp)

#############################  SET WORKING DIRECTORY & VARIABLES  ##################
workdir         <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd()
#Name and location of segment feature data CSV file 
segCsv          <- "segment_Stat/segStat.csv"

# Name and location of the segment raster image & Nodata value
segImage        <- "segments/seg_lsms_200_50_clump.tif"; nd <- 0

# Name and location of the classified image & Output classification 
# (enter TRUE or FALSE)
outImage <- "segments/segClass_lulc2019.tif"; classImage <- TRUE
# Output CSV file with class mapping information. If this output is not needed 
# you can enter two double or single-quotes (ââ or '')
outClassMapCSV <- "segment_Stat/Editable_class.csv"

# Data set name for the vector file containing training data. 
# & Enter EITHER the name (case sensitive and in quotes) or the column number of the 
# field containing class number
trainingDsn <- "Training_Data/TrainingData_final.shp"; classNum <- "class_id"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
############ READ VECTOR FILE ######################################################
cat("Reading the vector file\n")
trainingLayer <- strsplit(tail(unlist(strsplit(trainingDsn, "/")),
                               n=1), "\\.")[[1]] [1]
vec <- readOGR(trainingDsn, trainingLayer)
pts <- slot(vec, "data")

############ LOAD THE SEGMENT RASTER; ##############################################
segImg <- raster(segImage)
# Extract segment IDs under the point, line or polygon features
cat("Extracting segment IDs under the vector features\n")
exSegNums <- extract(segImg, vec, cellnumbers=TRUE)
if (is.matrix(exSegNums)) {
  exSegNums <- as.list(data.frame(t(exSegNums)))
}

# Remove NULL values from the list
exSegNums <- exSegNums[!sapply(exSegNums, is.null)]

# Select unique segment IDs under each vector features and associate the response 
# variable ("classNum") to the segment ID
trainSegs <- matrix(ncol=3, nrow=0)
for (i in 1:length(exSegNums)) {
  lineResponse <- pts[i,classNum]
  if (is.matrix(exSegNums[[i]])) { 
    segNums <- exSegNums[[i]][which(duplicated(exSegNums[[i]][,2]) == FALSE),]
  } else {
    segNums <- exSegNums[[i]]
  }
  
  if (is.matrix(segNums)) {
    trainSegs <- rbind(trainSegs, cbind(lineResponse, segNums))
  }
  else {
    trainSegs <- rbind(trainSegs, cbind(lineResponse, segNums[1], segNums[2]))
  }  
}

# Remove row names and add column names 
rownames(trainSegs) <- NULL
colnames(trainSegs) <- c("response", "cellNums", "segNums")

# Remove NA values from the list of unique segment IDs
trainSegs_no_na <- as.data.frame(na.omit(trainSegs))

# Read the CSV file with the segment feature information
segAtr <- read.csv(segCsv, header=TRUE)

# Remove NAs from the feature table
segAtr <- na.omit(segAtr)

#Create training data set by matching unique training segment IDs with segment 
#feature information 
train <- segAtr[match(trainSegs_no_na$segNums, segAtr$V1),]

# Remove NAs from the training data frame
train_no_na <- as.data.frame(na.omit(train))

# Create response variable data frame
response_no_na <- trainSegs_no_na[match(train_no_na$V1, 
                                        trainSegs_no_na$segNums), c(1,3)]
head(response_no_na)
############ RUN RF CLASSIFICATION ALGORITHM; ######################################
cat("Starting to calculate random forest object \n)")
randfor <- randomForest(as.factor(response_no_na$response) ~. , 
                        data=train_no_na[,-1], 
                        ntree=100, mtry=3,
                        proximity=TRUE, importance=T)

############ WRITE THE OUTPUT RASTER; ##############################################
# Reload the raster package.
bs <- blockSize(segImg)

# Calculate how many bands the output image should have
numBands <- classImage

# Create the output raster and begin writing to it.
img.out <- brick(segImg, values=FALSE, nl=numBands)
img.out <- writeStart(img.out, outImage, overwrite=TRUE, datatype='INT1U')

# Prediction
predValues <- predict(randfor, segAtr, type='response')
predValuesDF <- data.frame(segAtr$V1, predValues)

# Loop over blocks of the output raster from eCognition and write the new classified 
# value This looping method will allow for the input of larger rasters without 
# memory problems.
for (i in 1:bs$n) {
  cat("processing block", i, "of", bs$n, "\r")
  img <- getValues(segImg, row=bs$row[i], nrows=bs$nrows[i])
  outMatrix <- matrix(nrow=length(img), ncol=0)
  # Set the no data value to NA so it doesn't get converted to a predicted value
  is.na(img) <- img == nd
  if (classImage) {
    # Convert the segment ID to the predicted (numeric) class so that a 
    #nodata value can be set.
    outMatrix <- cbind(outMatrix, 
                       predValuesDF$predValues[match(img, predValuesDF$segAtr.V1)])
  }
  writeValues(img.out, outMatrix, bs$row[i])
}

# Finish saving and close the connection to the image.
img.out <- writeStop(img.out)

# Output class mapping CSV file if a filename was provided for outClassMapCSV
if (outClassMapCSV != "") {
  write.csv(predValuesDF, file=outClassMapCSV, row.names=FALSE)
}

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")

