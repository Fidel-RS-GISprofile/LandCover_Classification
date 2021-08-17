################### UNSUPERVISED CLASSIFICATION FOR Stnl 2 ###################################
#Created on July 17, 2020
# Contact: fideluwizeye@gmail.com

rm(list = ls()); cat("\014") #Clear environment

library(raster) #load packages
library(RStoolbox)

################ WORKING DIRECTORY & PARAM ###################################################
workdir <- "D:/files2021/WCS_lc2010/"
setwd(workdir)

rst <- "wcs_tile1_2010_4bands.tif"
rst <- stack(rst)
img_out <- "usSupe2010lc4b.tif"

################ USSUPER CLASS ###############################################################
olpar <- par(no.readonly = TRUE); par(mfrow=c(1,2)) # back-up par

#Run classification
set.seed(200)
img_unS_class <- unsuperClass(rst, nSamples = 1000, nClasses = 15, nStarts = 100)
img <- writeRaster(img_unS_class$map, img_out, 
                   options=c("COMPRESS=LZW"), overwrite = TRUE,
                   datatype = "INT2S")
par(olpar) # reset par
print("*********COMPLETE**********")
