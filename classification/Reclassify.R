#################***Reclassify values of a Raster***################################
# ***--- Created on 22nd July 2020
# Contact: fideluwizeye@gmail.com

# Clear console and the environment
rm(list = ls()); cat("\014")

# Load libraries
library(raster)
library(rgeos)
library(rgdal)

# Working directory
workdir          <- "C:/Users/F1User/Desktop/work/classfn_test/"
setwd(workdir); getwd()

# Load images
img              <- "obia1.tif"
img              <- raster(img)
img_out          <- "obia_reclass.tif"

#summary of the statistics of the raster
summary(img)

#map raster value to new values using a matrix
reclass_df <- c(0,0,
                1, 1,
                6, 2,
                7, 3,
                8, 4,
                9, 5,
                10, 6,
                11, 7,
                12, 8,
                13, 9,
                2, 10,
                3, 11,
                4, 12,
                5, 13)


# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass_df, 
                    ncol = 2,
                    byrow = TRUE)
reclass_m # Check matrix

# reclassify the raster using the reclass object - reclass_m
reclass_img <- reclassify(img,
                          reclass_m, img_out)
