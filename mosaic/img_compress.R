#################***COMPRESS COUNTRY WIDE SENTINEL2 LARGE FILES***################################
# ***--- Created on 28th March 2020
# ***--- Contact: Fidel UWizeye; FAO_Uganda FAO; fidel.uwizeye@fao.org;fideluwizeye@gmail.com

rm(list = ls()); cat("\014") # clear environment

library(raster) # Load required libraries

cat("Start processing at", format(startTime),"/n")

# Set working directory
workdir   <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd()
img       <- "segClass_mmu_segs_50v1.tif"
input_tif <- raster(img)
img_out   <- "segClass_mmu_segs_50v1c.tif"

cat("Start processing at", format(Sys.time(), "%H:%M:%OS2"),"/n")
# Compress::: Option 1.(for compressing mosaic raster bands)
tif_options <- c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=6") #|| Compression options
img_compressed <- writeRaster(input_tif, img_out, datatype="INT4U",
                              options = tif_options, overwrite = FALSE)

# Compress::: Option 2.(for conerting final classification to byte)
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               paste0(workdir,img),
               paste0(workdir,img_out)
))

cat(paste("Finished processing", "at", format(Sys.time(), "%H:%M:%OS2")))
