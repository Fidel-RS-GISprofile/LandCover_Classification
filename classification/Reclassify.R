#################***Reclassify values of a Raster***################################

# Clear console and the environment
rm(list = ls()); cat("\014")

# Load libraries
library(raster)
library(rgeos)
library(rgdal)

# Working directory
workdir          <- "C:/Users/F1User/Desktop/work/LC19_FINAL_Report/editWETLANDS/"
setwd(workdir); getwd()

# Define raster options
rasterOptions(datatype = 'INT1U', progress = 'window', 
              timer = T, chunksize = 1e+07,
              maxmemory = 1e+08, tmptime = 24)
# Load images
img              <- "Sieve_10pxClass2019.tif"
img              <- raster(img)
img_out          <- "BuiltreclassPX12.tif"

#summary of the statistics of the raster
summary(img)

#map raster value to new values using a matrix
reclass_df <- c(0, 0,
                1, 1,
                2, 1,
                3, 1,
                4, 1,
                5, 1,
                6, 1,
                7, 1,
                8, 1,
                9, 1,
                10, 2,
                11, 1,
                12, 1,
                13, 1)


# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass_df, 
                    ncol = 2,
                    byrow = TRUE)
reclass_m # Check matrix

# reclassify the raster using the reclass object - reclass_m
reclass_img <- reclassify(img,
                          reclass_m, img_out)
