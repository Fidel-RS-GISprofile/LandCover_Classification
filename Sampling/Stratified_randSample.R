##################################################################################################
# -*- coding: utf-8 -*-
#Created on Wed Mar 08 12:55:41 2020
#Adopted from: GWA_toolbox 
#Object: Perfom a stratified random sampling from a classified map
# Strata are the integer numbers of the classified map
# NA values are ignored ////the final product has not .prj file
##################################################################################################
# **********   RASTER STRATIFIED RANDOM SAMPLING **********
###############################clear environment and console###############################
rm(list = ls()); cat("\014")

#required libraries
library(raster)
library(rgdal)

#Working directory
workdir <- "C:/Users/F1User/Desktop/work/classfn_test/"
setwd(workdir); getwd()

###################### LOADING DATA #############
Raster_to_be_sampled <- raster('lc_Test.tif')
Samples_per_strata <- 50
Attribute_name   <- stringr::coll('class_id')
Optional_Attribute_name_1 <- stringr::coll('cName')
Optional_Attribute_name_2 <- stringr::coll('descr')
Sample_Points    <- "rasterStratasamples11123.shp"  
layer_name       <- "rasterStratasamples11123"  


RastStratSamp<- function(Raster_to_be_sampled, Samples_per_strata, Attribute_name, 
                         Optional_Attribute_name_1,
                           Optional_Attribute_name_2){
Raster_to_be_sampled<-Raster_to_be_sampled[[1]]
atts<-c(Attribute_name, Optional_Attribute_name_1, Optional_Attribute_name_2)
num_atts<-nchar(atts) # put a test in here that requires short attribute names, if max(num_atts) 
# get the position of the attribute names
att_nums<-which(num_atts!=0)
    
# get the number of attributes to be added
num_atts<-length(att_nums)
# take a random sample for the raster
smp<-sampleStratified(Raster_to_be_sampled, size=Samples_per_strata, na.rm=T, sp=T, exp=50)
    
# smp<-1:400 - just for testing
# set up blank attribute colums for attribte table - sample (smp) should be taken first!
# sample number
num<-c(1:length(smp))
# map class
map_id<-smp@data[,2]
# get the cell number of the sample - used for making grid outline later
clnum<-smp@data[,1]
    
# blank data for additional attibutes
for (i in 1:num_atts){
      
  if (i==1){
        
    attx<-rep(0, length(smp))
   
} else {
        
    attx<-cbind(attx, rep(0, length(smp)))
        
   }
      
}
    
# join the sample number and the blank attributes
att<-as.data.frame(cbind(num, attx))
#att<-as.data.frame(cbind(map_id, num, attx)) # include map_id or not - not independent 
# if can be seen
    
# add the attirbute names
nms<-c('number', atts[att_nums])
#nms<-c('map_id', 'number', atts[att_nums]) # include map_id or not - not independent 
#if can be seen
names(att)<-nms
    
# combine the attributes with the sample
smp@data<-data.frame(att)
    
return(smp)
    
}
  
Result <- RastStratSamp(Raster_to_be_sampled, Samples_per_strata, Attribute_name, 
                        Optional_Attribute_name_1,
                          Optional_Attribute_name_2)

PointSamples <- writeOGR(Result, 
                         Sample_Points,
                         driver="ESRI Shapefile", layer = layer_name)

