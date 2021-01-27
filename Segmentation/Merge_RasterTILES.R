############################# MERGE TILES #############
##########-Contact: fideluwizeye@gmail.com
# This script is better for merging single band rasters

############ CLEAR THE ENV & CONSOLE; #################################################
rm(list = ls()); cat("\014"); options(stringsAsFactors = FALSE)#read txt as txt

# Working directory
workdir <- "E:/tmp_aug2020/"
setwd(workdir); getwd()

# Load imaged
imgs         <- "segClass_lulc2019_block1*.tif"
img_out      <- "segClass_lulc2019_block1merge.tif"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
################## MERGE ALL TILES COVERING AOI ###############################
system(sprintf("gdal_merge.py  COMPRESS=LZW -co BIGTIFF=YES -o %s %s",
               paste0(workdir,img_out),
               paste0(workdir,imgs)
               ))

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
