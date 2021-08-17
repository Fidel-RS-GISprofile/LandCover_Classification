#THIS SCRIPT EXTRACTS INDIVIDUAL BANDS FROM A MOSAIC 

rm(list = ls()); cat("\014") #Clear environment
#
require(raster) #Load required packages

# Define raster options
rasterOptions(progress = 'window', timer = T, chunksize = 1e+07,
              maxmemory = 1e+08, tmptime = 24)

workdir <- "C:/Users/F1User/Desktop/work/JUNE_OCT_Proj/BFAST/bfast2014_Samples2009_2013/0/" #Set working directory
setwd(workdir); getwd()

inputRaster <-"bfast_stack_1/bfast_st_1_p_O_1_H_ROC_T_OC_F_h_Sequential_2004_2009_2013_year2013.tif" #load input Mosaic/multiBand raster

r<-stack(inputRaster) #open your raster with n bands

# dataType(r)
nlayers(r)
# plot(r) #Plot it just to see if everything is ok

#Export and save each band as a seperate
for(i in 1:nlayers(r)){
  band<-r[[i]]
  #save raster in a separate file
  writeRaster(band,paste('Bfast14_year2013_',i,'.tif', sep=''), datatype ="INT2S")
}

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")

