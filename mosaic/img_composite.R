############################# CREATE A MULTI BAND RASTER FROM SINGLE BANDS #############

rm(list = ls()); cat("\014") #Clear the environment

library(raster) #Load libraries

# Define raster options
rasterOptions(datatype = 'INT1U', progress = 'window', 
              timer = T, chunksize = 1e+07,
              maxmemory = 1e+08, tmptime = 24)

workdir <- "D:/files2021/finalEditing/"
setwd(workdir); getwd() #Set a working directory

band1 <- "mosaicB_1.tif" #Loading bands from the working directory
band2 <- "mosaicB_2.tif" 
band3 <- "mosaicB_3.tif"
# band4 <- "band4.tif"
# band5 <- "band5.tif"
# band6 <- "band6.tif"
# band7 <- "twiT1_clip.tif"
    
Output_Raster <- "C:/Users/F1User/Desktop/work/tmp/mosaic3Bclip.tif" #Output mult-band raster

startTime <- Sys.time(); cat("Start processing time", format(startTime),"/n")
#Stack the bands together
multiBand <- stack(band1, band2, band3)  

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
#Set band names("blue", "green", "red", "nir", "swir1", "swir2", "TWI")
#compress options
tif_options <- c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=6")
#craete and save a composite multi-band raster
writeRaster(multiBand, Output_Raster, datatype="INT2S", 
                         options = tif_options, 
                         overwrite=TRUE)

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
