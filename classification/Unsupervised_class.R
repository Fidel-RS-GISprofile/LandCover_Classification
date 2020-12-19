################### UNSUPERVISED CLASSIFICATION FOR Stnl 2 ###################################
#Created on July 17, 2020
# Contact: fidel.uwizeye@fao.org or fideluwizeye@gmail.com

rm(list = ls()); cat("\014") #Clear environment

library(raster) #load packages
library(RStoolbox)

################ WORKING DIRECTORY & PARAM ###################################################
workdir <- "~/downloads/LULC_classTesting/tile3West_ls82020/"
setwd(workdir)

rst <- "tile3West_ls82020.tif"
rst <- stack(rst)
img_out <- "usSupeTEst.tif"

################ USSUPER CLASS ###############################################################
olpar <- par(no.readonly = TRUE); par(mfrow=c(1,2)) # back-up par

#Run classification
set.seed(200)
img_unS_class <- unsuperClass(rst, nSamples = 1000, nClasses = 10, nStarts = 100)
img <- writeRaster(img_unS_class$map, img_out, 
                   options=c("COMPRESS=LZW"), overwrite = TRUE,
                   datatype = "INT2S")
par(olpar) # reset par
print("*********COMPLETE**********")
