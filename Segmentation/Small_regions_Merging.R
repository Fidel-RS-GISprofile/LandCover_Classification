################### SMALL REGIONS MERGED USING OTB ############################
# Date: August 17, 2020
# Contact: Fidel UWizeye; FAO_Uganda; fidel.uwizeye@fao.org/fideluwizeye@gmail.com

# This script is better for implementing minmum mapable area in OTB(smallRegionsMerging)
# NOTE: TO RUN OTB (orfeo toolbox) IN COMMAND Line *OTB MUST BE INSTALLED on the system 

#################### CLEAR ENVIRONMENT AND CONSOLE ###########################
rm(list = ls()); cat("\014"); options(stringsAsFactors=FALSE)

workdir <- "~/lc_mapping2019fdl/data/" # Working directory
setwd(workdir); getwd()

# Set of Parameters
params <- c(5, 
            200, 
            100, 
            50) # minimum mapable size 50(pixels) or Half a hectare @sentinel 2

## Start processing
startTime <- Sys.time(); cat("Start time", format(startTime),"\n")

# Merge all generated segment tiles
system(sprintf("otbcli_LSMSSmallRegionsMerging -in %s -inseg %s -out %s -minsize %s -tilesizex 1024 -tilesizey 1024",
               paste0(workdir,"smooth_mosaic_block1A.tif"),
               paste0(workdir,"seg_lsms_5_200_100_50_block1A.tif"),
               paste0(workdir,"seg_SRmerging_50_block1A.tif"),
               params[4]
))
#
system(sprintf("otbcli_LSMSSmallRegionsMerging -in %s -inseg %s -out %s -minsize %s -tilesizex 1024 -tilesizey 1024",
               paste0(workdir,"smooth_mosaic_block1B.tif"),
               paste0(workdir,"seg_lsms_5_200_100_50_block1B.tif"),
               paste0(workdir,"seg_SRmerging_50_block1B.tif"),
               params[4]
))
#
system(sprintf("otbcli_LSMSSmallRegionsMerging -in %s -inseg %s -out %s -minsize %s -tilesizex 1024 -tilesizey 1024",
               paste0(workdir,"smooth_mosaic_block2A.tif"),
               paste0(workdir,"seg_lsms_5_200_100_50_block2A.tif"),
               paste0(workdir,"seg_SRmerging_50_block2A.tif"),
               params[4]
))
#
system(sprintf("otbcli_LSMSSmallRegionsMerging -in %s -inseg %s -out %s -minsize %s -tilesizex 1024 -tilesizey 1024",
               paste0(workdir,"smooth_mosaic_block2B.tif"),
               paste0(workdir,"seg_lsms_5_200_100_50_block2B.tif"),
               paste0(workdir,"seg_SRmerging_50_block2B.tif"),
               params[4]
))
# Calculate processing time
timeDiff <- Sys.time() - startTime; cat("Processing time", format(timeDiff), "\n")

