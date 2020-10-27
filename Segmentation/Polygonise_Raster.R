############################# EXTRACT SPECTRAL SIGNATURE ON THE SEGMENTS #############
##########-Contact: Fidel UWizeye; FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com
# This script is better for calculating segment statistics (avg & sdv) sentinel 2

############ CLEAR THE ENV & CONSOLE; #################################################
rm(list = ls()); cat("\014"); options(stringsAsFactors = FALSE)#read txt as txt

# Working directory
workdir       <- "~/lc_mapping2019fdl/data/segments/"
setwd(workdir); getwd()

# Load images
img           <- "seg_SRmerging_50.tif"
shp_out       <- "seg_SRmerging_50.shp"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
# Polygonise; Apply only when polygon segments are required
system(sprintf("gdal_polygonize.py -f \"ESRI Shapefile\" %s %s",
               paste0(workdir,img),
               paste0(workdir,shp_out)
))

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
