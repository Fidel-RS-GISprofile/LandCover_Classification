############################# CREATE A MULTI BAND RASTER FROM SINGLE BANDS #############
# ***--- Created on 28th March 2020
# ***--- Contact: fidel.uwizeye@fao.org or fideluwizeye@gmail.com

rm(list = ls()); cat("\014") #Clear the environment

library(raster) #Load libraries

workdir <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd() #Set a working directory

band1 <- "smoothband1.tif" #Loading bands from the working directory
band2 <- "smoothband2.tif" 
band3 <- "smoothband3.tif"
band4 <- "smoothband4.tif"
band5 <- "smoothband5.tif"
band6 <- "smoothband6.tif"
#band7 <- "band7.tif"
#Output mult-band raster    
Output_Raster <- "smoothMosaic_2019stnl2.tif"

startTime <- Sys.time(); cat("Start processing time", format(startTime),"/n")
#Stack the bands together
multiBand <- stack(band1, band2, band3, band4, band5,band6)  

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
#Set band names("blue", "green", "red", "nir", "swir1", "swir2", "TWI")
#compress options
tif_options <- c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=6")
#craete and save a composite multi-band raster
writeRaster(multiBand, Output_Raster, datatype="INT2S", 
                         options = tif_options, 
                         overwrite=TRUE)

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")