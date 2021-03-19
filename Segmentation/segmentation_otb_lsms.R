#####################################################################################################
# ***--- Adopted from: remi.dannunzio@fao.org; 2017/11/02
# Contact: fideluwizeye@gmail.com
# ***--- Objective: This script is used to implement OTB segmentation algorithm in R. 
########## OTB must be installed on your system #####################################################
rm(list = ls()); cat("\014"); options(stringsAsFactors=FALSE)# Read external files with TEXT as TEXT
 
library(Hmisc) #||Load require libraries
library(sp)
library(rgdal)
library(raster)
library(plyr)
library(foreign)
library(rgeos)
library(glcm)

workdir <- setwd("~/lc_mapping2019fdl/data/") #||Work directory
tmpdir <- paste0(workdir,"/tmp/")
if (!dir.exists(tmpdir)) 
  dir.create(tmpdir) #||Create a directory

segt_dir <- paste0(workdir,"/segments/")
if (!dir.exists(segt_dir))
  dir.create(segt_dir) #||Create a directory

mosaic_file  <- "tmp/smooth_3_10_0.1_100_10.tif"
segment_file <- "segments/tile1_segments.shp"
segment_tif  <- "segments/tile1_segments.tif"
scriptdir    <- "~/obia/scripts/"

system(paste0(workdir,"/WCS_AOI_/WCS_AOI_ls7542010.tif")) #||Check access for the raster multiband file
## Start processing
startTime <- Sys.time(); cat("Start time", format(startTime),"\n")
#||PERFORM SEGMENTATION USING THE OTB-SEG ALGORITHM
params <- c(3, # radius of smoothing (pixels) ||3 for Landsat or 5 for Sentinel 2 UGA
            10, # radius of proximity (pixels)||150 for Landsat or 300 for Sentinel 2 UGA
            0.1, # radiance threshold
            100, # iterations of algorithm
            10) # segment minimum size (pixels)||10=1hectare Landsat or 50=1/2hectare sentinel 2 UGA
#||Apply KMEAN shift algorith to raster band to do clustering
system(sprintf("otbcli_MeanShiftSmoothing -in %s -fout %s -foutpos %s -spatialr %s -ranger %s -thres %s -maxiter %s",
               "ug500_2019ls8_5bands.tif",
               paste0(tmpdir,"smooth_",paste0(params,collapse = "_"),".tif"),
               paste0(tmpdir,"tmp_position_",paste0(params,collapse = "_"),".tif"),
               params[1],
               params[2],
               params[3],
               params[4]
))
#||Generated segments and tiles
system(sprintf("otbcli_LSMSSegmentation -in %s -inpos %s -out %s -spatialr %s -ranger %s -minsize 0 -tmpdir %s -tilesizex 1024 -tilesizey 1024",
               paste0(tmpdir,"smooth_",paste0(params,collapse = "_"),".tif"),
               paste0(tmpdir,"tmp_position_",paste0(params,collapse = "_"),".tif"),
               paste0(segt_dir,"tmp_seg_lsms_",paste0(params,collapse = "_"),".tif"),
               params[1],
               params[2],
               tmpdir
))

#||Remove temporary files
system(sprintf("rm %s",
               paste0(tmpdir,"tmp*.tif")
))
print("***** Segmentaion complete *****")#||Notice for completion of the segmentation process

################### PROCESS - SEGMENTATION AS SHP
system(paste("otbcli_Segmentation -filter.meanshift.spatialr %s -filter.meanshift.ranger %s -mode.vector.minsize 5 %s -mode.vector.tilesize 4096", 
             "-in",mosaic_file,
             "-mode vector",
             "-mode.vector.out",segment_file,
             "-filter meanshift",
             "-mode.vector.outmode ovw",
             params[1],
             params[2],
             sep=" "))


################### PROCESS - CONVERT SEGMENTATION AS TIF
system(sprintf("python3 %s/oft-rasterize_attr_Int32.py -v %s -i %s -o %s -a %s",
               scriptdir,
               segment_file,
               mosaic_file,
               segment_tif,
               "DN"
))

# Calculate processing time
timeDiff <- Sys.time() - startTime; cat("The Processing time is", format(timeDiff), "\n")