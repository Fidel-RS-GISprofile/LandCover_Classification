############################# MERGE TILES #############
##########-Contact: Fidel UWizeye; FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com
# This script is better for merging single band rasters

############ CLEAR THE ENV & CONSOLE; #################################################
rm(list = ls()); cat("\014"); options(stringsAsFactors = FALSE)#read txt as txt

# Working directory
workdir <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd()

# Load imaged
imgs         <- "seg_SRmerging_50_block*.tif"
img_out      <- "seg_SRmerging_50_blockMerged.tif"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
################## MERGE ALL TILES COVERING AOI ###############################
system(sprintf("gdal_merge.py -v -co COMPRESS=LZW -co BIGTIFF=YES -o %s %s",
               paste0(workdir,img_out),
               paste0(workdir,imgs)
               ))

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
