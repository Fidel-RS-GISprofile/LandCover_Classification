################### CLIP RASTER TO TILE EXTENT ###############################
# Date: August 17, 2020
# Contact: Fidel UWizeye; FAO_Uganda; fidel.uwizeye@fao.org/fideluwizeye@gmail.com

#################### CLEAR ENVIRONMENT AND CONSOLE ###########################
rm(list = ls()); cat("\014"); options(stringsAsFactors=FALSE)

workdir <- "D:/files2020/lc_mosaic19/tmp/"
setwd(workdir); getwd()

img          <- "smooth_stnlMosaic_432c.tif"
img_tile     <- "smooth_S2Mosaic19"

cat("Start processing", format(Sys.time(), "%H:%M:%OS2"),"\n")
################### CLIP RASTER TO TILE EXTENT ###############################
system(sprintf("gdal_translate -projwin 29.5595117251065531 4.2432287586666542 32.5412566974460660 1.4813309615706780 %s %s",
               img,
               paste0(workdir,img_tile,"_block1A",".tif")
))
system(sprintf("gdal_translate -projwin 32.5401574462513850 4.2433658352063004 35.0358446537846504 1.4830715459760875 %s %s",
               img,
               paste0(workdir,img_tile,"_block1B",".tif")
))
system(sprintf("gdal_translate -projwin 29.5677036892554597 1.4838030216458022 32.0471777002621252 -1.4923420203314666 %s %s",
               img,
               paste0(workdir,img_tile,"_block2A",".tif")
))
system(sprintf("gdal_translate -projwin 32.0468565410301167 1.4840096480266554 35.0309896562695897 -1.4925498363220808 %s %s",
               img,
               paste0(workdir,img_tile,"_block2B",".tif")
))
cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")

