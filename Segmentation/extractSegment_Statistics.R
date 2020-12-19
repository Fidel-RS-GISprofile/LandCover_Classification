################ EXTRACT SPECTRAL SIGNATURE ON THE SEGMENTS **SEPAL TOOL**############
##########-Contact: fidel.uwizeye@fao.org or fideluwizeye@gmail.com
# This script is better for calculating segment statistics (avg & sdv) sentinel 2

################## CLEAR ENVIRONMENT AND CONSOLE ####################################
rm(list = ls()); cat("\014"); options(stringsAsFactors = FALSE)#read txt as txt

# Working directory
workdir <- "~/lc_mapping2019fdl/data/"
setwd(workdir); getwd()

# Load Data
mosaic_file           <- "smooth_mosaic_.tif"
segment_tif           <- "segments/seg_lsms_200_50_clump.tif"
segtVals_txt          <- "tmp/tmp_segStat"
segtVals_csv          <- "segment_Stat/segStat.csv"

cat("!Start process at", format(Sys.time(), "%H:%M:%OS2"), "\n")
################### PROCESS - EXTRACT SPECTRAL SIGNATURE ON THE SEGMENTS ############
system(sprintf("oft-stat -i %s -o %s -um %s",
               mosaic_file,
               paste0(workdir,segtVals_txt,".txt"),
               segment_tif))

################################# SAVE SPECTRAL SIGNATURE AS CSV ####################
segtVals_txt1 <- read.table(paste0(workdir,segtVals_txt,".txt"))
write.table(segtVals_txt1, file=segtVals_csv, sep=",", 
            col.names=TRUE, row.names=FALSE)

cat("!Process completed at", format(Sys.time(), "%H:%M:%OS2"), "\n")
