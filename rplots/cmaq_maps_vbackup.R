
#########################################
#R script to produce daily Forecast Plots
#Driven by /cair-forecast/aqfs_farrow/scripts/run_plots_R.sh
#########################################
library('rgdal')
library('ncdf')

print('hello world')
setwd("/cair-forecast/aqfs_farrow/scripts/rplots")

#Get Variables
#########################################
args <- commandArgs(trailingOnly = TRUE)
cFDATE=as.Date(args[1])
cFDATE

#Set some arrays for later
#########################################
chem1<-c("PM25","O3","NOx")
chem2<-c("PM2.5","O3","NOx")
chem3<-c("m^3","ppbV","ppbV")
chem<-cbind(chem1,chem2,chem3)
chem

chemR<-c(50,80,60)

#I've skipped over reading in the shape file, presumably it is just a base map so I'm ignoring it

#Make a vector with the domain names in them
idom<-c(1,2)


#Read in the grid file
#########################################
#GridFile
GridFile=open.ncdf(file.path("/cair-forecast/aqfs/data/",cFDATE,"/meteo/MCIPOUT_d01",cFDATE,"/GRIDCRO2D_MCIPOUT"))
#summary(GridFile)
LON=get.var.ncdf(GridFile,"LON")
LAT=get.var.ncdf(GridFile,"LAT")
#plot(LON,LAT)

#Set in/out data
#########################################
DataPath=file.path("/cair-forecast/aqfs/data/")
OutPath=file.path("/cair-forecast/aqfs_farrow/data/images",cFDATE)
dir.create(OutPath)
OutPath=file.path("/cair-forecast/aqfs_farrow/data/images",cFDATE,"images_d01/")
dir.create(OutPath)


GridFile=open.ncdf(file.path("/cair-forecast/aqfs/data/",cFDATE,"/meteo/MCIPOUT_d01",cFDATE,"/GRIDCRO2D_MCIPOUT"))
#summary(GridFile)
LON=get.var.ncdf(GridFile,"LON")
LAT=get.var.ncdf(GridFile,"LAT")
#plot(LON,LAT)
