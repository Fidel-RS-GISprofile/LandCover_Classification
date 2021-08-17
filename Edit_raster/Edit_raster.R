################## EDIT RASTER USING A MASK LAYER #########################
# This script uses a mask layer to edit a land cover layer

# Clear console and the environment
rm(list = ls()); cat("\014")

# Load library
library(raster)
library(rgdal)
library(rpanel)

# Working directory 
workdir <- "E:/tmp_aug2020/editing_masks/"
setwd(workdir); getwd()
tmp_dir         <- "tmp/" # Auto create a tmp directory
if (!dir.exists(tmp_dir))
  dir.create(tmp_dir) 

# Define raster options
rasterOptions(datatype = 'INT1U', progress = 'window', 
              timer = T, chunksize = 1e+07, tmpdir = tmp_dir,
              maxmemory = 1e+08, tmptime = 24)

# Load images
img_LULC      <- "lc2019_swEDIT28.tif"
img_LULC      <- raster(img_LULC)
img_Edited    <- "lc2019_swEDIT29.tif"

# Load mask layer(s)
EditClass_msk <- "4to6.tif"
EditClass_msk <- raster(EditClass_msk)
EditClass_msk1 <- "10to7_2.tif"
EditClass_msk1 <- raster(EditClass_msk1)
EditClass_msk2 <- "10to7_3.tif"
EditClass_msk2 <- raster(EditClass_msk2)
# EditClass_msk3 <- "2_5to5_7to7.tif"
# EditClass_msk3 <- raster(EditClass_msk3)
# EditClass_msk4 <- "2_8to8.tif"
# EditClass_msk4 <- raster(EditClass_msk4)
# EditClass_msk5 <- "2_1to5.tif"
# EditClass_msk5 <- raster(EditClass_msk5)
# EditClass_msk6 <- "2_1to7_2to7_8to7.tif"
# EditClass_msk6 <- raster(EditClass_msk6)
# EditClass_msk7 <- "2_2to11_8to11.tif"
# EditClass_msk7 <- raster(EditClass_msk7)
# EditClass_msk8 <- "2_2to9.tif"
# EditClass_msk8 <- raster(EditClass_msk8)
# EditClass_msk9 <- "1_10to7_6.tif"
# EditClass_msk9 <- raster(EditClass_msk9)
# EditClass_msk10 <- "2_1to3_5to3_6to5.tif"
# EditClass_msk10 <- raster(EditClass_msk10)
# EditClass_msk11 <- "2_1to3_5to3_6to5_1.tif"
# EditClass_msk11 <- raster(EditClass_msk11)

panel <- rp.control(title = "Progess Message. . .", size = c(500, 50))
rp.text(panel, "Editing raster. . .", font="Arial", pos = c(10, 10), 
        title = 'bottom', name = 'prog_panel')

# Assign class areas in Landcover to corresponding edit classes in the mask 
#(Class ID as integers)
img_LULC[EditClass_msk == 4 ] <- as.integer(6) # Edit class 1_Plantation broadleaved
img_LULC[EditClass_msk1 == 10 ] <- as.integer(7) # Edit class 2_Plantation coniferous
img_LULC[EditClass_msk2 == 10 ] <- as.integer(7) # Edit class 3_THF
img_LULC[EditClass_msk == 7 ] <- as.integer(7) # Edit class 4_THF_low stock
img_LULC[EditClass_msk == 8 ] <- as.integer(8) # Edit class 5_Woodland
img_LULC[EditClass_msk == 10 ] <- as.integer(7) # Edit class 6_Bushland
img_LULC[EditClass_msk1 == 4 ] <- as.integer(4) # Edit class 7_Grassland
img_LULC[EditClass_msk1 == 5 ] <- as.integer(5) # Edit class 8_Wetland
img_LULC[EditClass_msk1 == 8 ] <- as.integer(8) # Edit class 9_Subsistence Farmland
img_LULC[EditClass_msk1 == 10 ] <- as.integer(7) # Edit class 10_Commercial Farmland
img_LULC[EditClass_msk1 == 12 ] <- as.integer(12) # Edit class 11_Built_up
# img_LULC[EditClass_msk1 == 2 ] <- as.integer(11) # Edit class 12_Water
# img_LULC[EditClass_msk7 == 8 ] <- as.integer(11) # Edit class 13_Impediment
# img_LULC[EditClass_msk7 == 2 ] <- as.integer(11) # Edit class 11_Built_up
# img_LULC[EditClass_msk7 == 8 ] <- as.integer(11) # Edit class 12_Water
# img_LULC[EditClass_msk8 == 2 ] <- as.integer(9) # Edit class 13_Impediment

# Save edited raster
writeRaster(img_LULC, img_Edited)
rp.control.dispose(panel)
removeTmpFiles(h=0)
print("*********COMPLETE**********")
