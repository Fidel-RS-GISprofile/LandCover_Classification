######## Segmentation and rasterization sentinel 2 for zonal AOI
# Working directory
workdir <- setwd("E:/R/data/")
mosaic_file_tif <-"mosaic/Nakasongola_area_2019.vrt"
segment_file_shp <- "segments/segments1.shp"
segment_file_tif <- "segments.tif"

params <- c(5,#spatial radius
            150,#range radius
            50)#minmum size
################### PROCESS - SEGMENTATION AS SHP
system(paste("otbcli_Segmentation -filter.meanshift.spatialr %s -filter.meanshift.ranger %s -mode.vector.minsize %s -mode.vector.tilesize 4096", 
             "-in",mosaic_file_tif,
             "-mode vector",
             "-mode.vector.out",segment_file_shp,
             "-filter meanshift",
             "-mode.vector.outmode ovw",
             params[1],
             params[2],
             params[3],
             sep=" "))

################### PROCESS - RASTERIZATION AS TIF
system(paste("otbcli_Rasterization -mode attribute",
             "-in",segment_file_shp,
             "-out",segment_file_tif,
             "-im",mosaic_file_tif,
             "-epsg",4326,
             sep=" "))

