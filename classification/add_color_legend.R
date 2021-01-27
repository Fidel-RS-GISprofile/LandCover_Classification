############ ADD UGA COLOR LEGEND #########################################
# Contact: fideluwizeye@gmail.com
# This script adds a color legend to a single band raster layer

# Clear console and the environment
rm(list = ls()); cat("\014")

# Load library
library(raster)

# working directory
workdir     <- "E:/tmp_aug2020/"
setwd(workdir); getwd()

# Load images
img             <- "lulc2019_UGA500m_buffercliped.tif"
img             <- raster(img)
img_out         <- "C:/Users/F1User/Desktop/work/progress/lulc2019_UGA500m_buffer.tif"

numClasses      <- 14 # Number of classes in the Land cover map (0,1,2...14)
# Read the uga color legend:(Match the number of colors with number of classes)
col_legend   <- c("#ffffff", "#fbb5f8", "#f20ebd", "#29ba49", 
                  "#48ee83", "#98c372", "#9e481f", "#fbb0a6", 
                  "#69d9ff", "#feff9f", "#ffbd0d", "#969696", 
                  "#0887ff", "#080092")

if (numClasses != 0) {
  # Add the uga color legend to raster
  colortable(img) <- col_legend
  # Save the raster
  writeRaster(img, img_out)
}
