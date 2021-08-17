#################***COMPRESS COUNTRY WIDE SENTINEL2 LARGE FILES***################################
# ***--- Created on 28th March 2020
# ***--- Contact: fideluwizeye@gmail.com

rm(list = ls()); cat("\014") # clear environment

library(raster) # Load required libraries

# Set working directory
workdir   <- "C:/Users/F1User/Desktop/work/LC19_FINAL_Report/"
setwd(workdir); getwd()
img       <- "24March2021_lulc2019_i500m_bufferCLIP.tif"
input_tif <- raster(img)
img_out   <- "24March2021_lulc2019_i500m_bufferCLIPcomp.tif"

cat("Start processing at", format(Sys.time(), "%H:%M:%OS2"),"/n")
# Compress::: Option 1.(for compressing mosaic raster bands)
tif_options <- c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=6") #|| Compression options
img_compressed <- writeRaster(input_tif, img_out, datatype="INT1U",
                              options = tif_options, overwrite = FALSE)

# Compress::: Option 2.(for conerting final classification to byte)
# system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
#                paste0(workdir,img),
#                paste0(workdir,img_out)
# ))

cat(paste("Finished processing", "at", format(Sys.time(), "%H:%M:%OS2")))
