#####################################################################################################
# ***--- Adopted from: remi.dannunzio@fao.org; 2017/11/02
# ***--- Edited_By: Fidel UWizeye; FAO_Uganda
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

system(paste0(workdir,"/ug500_2019stnl2_6bands.tif")) #||Check access for the raster multiband file
#||PERFORM SEGMENTATION USING THE OTB-SEG ALGORITHM
params <- c(5, # radius of smoothing (pixels) ||3 for Landsat or 5 for Sentinel 2 UGA
            200, # radius of proximity (pixels)||150 for Landsat or 300 for Sentinel 2 UGA
            0.1, # radiance threshold
            100, # iterations of algorithm
            50) # segment minimum size (pixels)||10=1hectare Landsat or 50=1/2hectare sentinel 2 UGA
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
