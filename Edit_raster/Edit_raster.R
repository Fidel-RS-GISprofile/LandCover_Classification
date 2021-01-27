################## EDIT RASTER USING A MASK LAYER #########################
# Contact: fideluwizeye@gmail.com
# This script uses a mask layer to edit a land cover layer

# Clear console and the environment
rm(list = ls()); cat("\014")

# Load library
library(raster)
library(rgdal)
library(rpanel)

# Working directory 
workdir <- "C:/Users/F1User/Desktop/work/editMask_19/"
setwd(workdir); getwd()
tmp_dir         <- "tmp/" # Auto create a tmp directory
if (!dir.exists(tmp_dir))
  dir.create(tmp_dir) 

# Define raster options
rasterOptions(datatype = 'INT1U', progress = 'window', 
              timer = T, chunksize = 1e+07, tmpdir = tmp_dir,
              maxmemory = 1e+08, tmptime = 24)

# Load images
img_LULC      <- "lulc2019_baseV1edit81.tif"
img_LULC      <- raster(img_LULC)
img_Edited    <- "lulc2019_baseV1edit82.tif"

# Load mask layer(s)
EditClass_msk <- "3to3_4to3.tif"
EditClass_msk <- raster(EditClass_msk)
EditClass_msk1 <- "7to7.tif"
EditClass_msk1 <- raster(EditClass_msk1)
# EditClass_msk2 <- "E:/tmp_aug2020/editing_masks/8to7_8.tif"
# EditClass_msk2 <- raster(EditClass_msk2)
# EditClass_msk3 <- "E:/tmp_aug2020/editing_masks/8to7_9.tif"
# EditClass_msk3 <- raster(EditClass_msk3)
# EditClass_msk4 <- "E:/tmp_aug2020/editing_masks/8to7_10to5_6to9.tif"
# EditClass_msk4 <- raster(EditClass_msk4)
# EditClass_msk5 <- "E:/tmp_aug2020/editing_masks/8to7_10.tif"
# EditClass_msk5 <- raster(EditClass_msk5)

panel <- rp.control(title = "Progess Message. . .", size = c(500, 50))
rp.text(panel, "Editing raster. . .", font="Arial", pos = c(10, 10), 
        title = 'bottom', name = 'prog_panel')

# Assign class areas in Landcover to corresponding edit classes in the mask 
#(Class ID as integers)
img_LULC[EditClass_msk == 1 ] <- as.integer(1) # Edit class 1_Plantation broadleaved
img_LULC[EditClass_msk == 2 ] <- as.integer(2) # Edit class 2_Plantation coniferous
img_LULC[EditClass_msk == 3 ] <- as.integer(3) # Edit class 3_THF
img_LULC[EditClass_msk == 4 ] <- as.integer(3) # Edit class 4_THF_low stock
img_LULC[EditClass_msk == 5 ] <- as.integer(5) # Edit class 5_Woodland
img_LULC[EditClass_msk == 6 ] <- as.integer(6) # Edit class 6_Bushland
img_LULC[EditClass_msk == 7 ] <- as.integer(7) # Edit class 7_Grassland
img_LULC[EditClass_msk == 8 ] <- as.integer(8) # Edit class 8_Wetland
img_LULC[EditClass_msk == 9 ] <- as.integer(9) # Edit class 9_Subsistence Farmland
img_LULC[EditClass_msk == 10 ] <- as.integer(10) # Edit class 10_Commercial Farmland
img_LULC[EditClass_msk == 11 ] <- as.integer(11) # Edit class 11_Built_up
img_LULC[EditClass_msk == 12 ] <- as.integer(9) # Edit class 12_Water
img_LULC[EditClass_msk == 13 ] <- as.integer(13) # Edit class 13_Impediment

# Save edited raster
writeRaster(img_LULC, img_Edited)
rp.control.dispose(panel)
removeTmpFiles(h=0)
print("*********COMPLETE**********")
