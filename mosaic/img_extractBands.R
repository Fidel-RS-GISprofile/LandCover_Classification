#THIS SCRIPT EXTRACTS INDIVIDUAL BANDS FROM A MOSAIC 
# ***--- Created on 28th March 2020
# Contact: Fidel UWizeye; FAO_Uganda FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com

rm(list = ls()); cat("\014") #Clear environment
#
require(raster) #Load required packages
#
workdir <- "~/lc_mapping2019fdl/data/" #Set working directory
setwd(workdir); getwd()

inputRaster <-"smooth_stnl2UG19_7band.tif" #load input multiBand raster

r<-stack(inputRaster) #open your raster with n bands

dataType(r)
nlayers(r) 
plot(r) #Plot it just to see if everything is ok

#Export and save each band as a seperate
for(i in 4:nlayers(r)){
  band<-r[[i]]
  #save raster in a separate file
  writeRaster(band,paste('smoothband',i,'.tif', sep=''),datatype ="INT2S")
}

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
