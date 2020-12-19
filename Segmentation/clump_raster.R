################### CLUMP RASTER ######################## 2020
######### Recategorizes data in a raster map by grouping cells 
######### that form physically discrete areas into unique categories.
# Contact: fidel.uwizeye@fao.org or fideluwizeye@gmail.com

#################### CLEAR ENVIRONMENT AND CONSOLE ###########################
rm(list = ls()); cat("\014"); options(stringsAsFactors=FALSE)

# Set working directory
workdir       <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd()

# Load images 
img           <- "seg_SRmerging_50_blockMerged.tif"
img_clumped   <- "seg_SRmerging_50_blocks_clump.tif"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
#################### CLUMP THE RESULTS TO OBTAIN UNIQUE ID PER POLYGON #######
system(sprintf("oft-clump -i %s -o %s -um %s",
               paste0(workdir,img),
               paste0(workdir,img_clumped),
               paste0(workdir,img)
))

cat(paste("Finished processing", "at", format(Sys.time(), "%H:%M:%OS2")))
