#########################################
#R script to produce daily Forecast Plots
#Driven by /cair-forecast/aqfs_farrow/scripts/run_plots_R.sh
#########################################
library('rgdal')
library('ncdf')
library('animation')
library('maptools')
library('SpatialEpi')
setwd("/cair-forecast/aqfs_farrow/scripts/rplots")

#Get Variables from shellscript
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
chemR<-c(50,80,60)

#Read in shape file
#require(rgdal)
#S <- readShapePoly("/cair-forecast/aqfs_farrow/scripts/rplots/ArcGlobeData/continent.shp")

#Loop over the domains
#########################################
idom<-1:2
for (jdom in idom) {

    #Read in the grid file
    #########################################
    GridFile=open.ncdf(paste("/cair-forecast/aqfs/data/",cFDATE,"/meteo/MCIPOUT_d0",idom,"/",cFDATE,"/GRIDCRO2D_MCIPOUT",sep=""))
    GridFile
    LON=get.var.ncdf(GridFile,"LON")
    LAT=get.var.ncdf(GridFile,"LAT")
    oldgrid=cbind(LAT,LON)
    #print(oldgrid)

    #Set in/out data
    #########################################
    DataPath=file.path("/cair-forecast/aqfs/data/")
    OutPath1=file.path("/cair-forecast/aqfs_farrow/data/images",cFDATE)
    dir.create(OutPath1)
    OutPath=file.path("/cair-forecast/aqfs_farrow/data/images",cFDATE,"images_d01/")
    dir.create(OutPath)

    #Write video settings
    #####################################
    for (ic in chem1){
	vidname=paste(OutPath,ic,"_video.avi", sep="")}

    #Loop over days 0:2
    #####################################    
    for (tdays in 0:2){
    	CDate=as.Date(cFDATE)+tdays
	CDate#
	CTime<-0:23
        CTime

	#Open CMAQ ouput
	#################################
        ncfile=paste(DataPath,cFDATE,"/cmaq/cctm/",CDate,"/CCTM_e2a.d0",idom,".",CDate,".ACONC",sep="")
	AAm=open.ncdf(ncfile) #Vikas appeared to have selected the time step and only opened that data here.

	#Loop again over the chemistry
	#################################
	for (ic in chem1){
	    AA=paste(AAm,ic,sep="")

		#Loop over 24 hours (0:23)
	    	#############################
	    	for (i in CTime){
	    	    #Vikas sets some plot attributes here
		    #And these ones below
		    	  if (jdom ==1){
		     	  latmin=35
		    	  latmax=70
			  lonmin=-15
		    	  lonmax=35
		    	  gspace=5
		     	  cellsize=0.05
		     	  } else if (jdom ==2){
		     	  latmin=49
		     	  latmax=60
		     	  lonmin=-11
		     	  lonmax=2
		     	  gspace=2
		     	  cellsize=0.05
		     	  }
		     }
		
		newgrid=project.lonlat.to.M3(LON,LAT,AA)
#		[grid, referencing vector] = geoloc3grid(lat,lon,data,cellsize)		
#                [Z, refvec] = geoloc2grid(double(LAT'),double(LON'),double(AA(:,:,1,i))', cellsize);
#                
#                ax = axesm('mercator','MapLatLimit',latlim,...
#                    'MapLonLimit',lonlim,'Grid','on','Frame','on',...
#                    'MeridianLabel','on','ParallelLabel','on','MLabelParallel','south');
#                geoshow(Z, refvec,'DisplayType','texturemap')                  
#                
#                gridm ('MLineLocation',2*gspace,'MLabelLocation',2*gspace,'PLineLocation',gspace,'PLabelLocation',gspace)
#                geoshow(S(3,1).Y, S(3,1).X,'Color',[0 0 0],'Linewidth',1);
#                
#                fsz=12;
#                mycmap=load('MyColormaps');
#                colormap(mycmap.mycmap);
#                hc=colorbar('FontSize',fsz);
#                ylabel(hc,chem{3,ic},'FontSize',fsz);
#                caxis([0 chemR(ic)])
#                stitle=strcat(datestr(CDate),{' '},sprintf('%02u',(CTime(i))),':00 GMT');
#                title({chem{2,ic},char(stitle)},'FontSize',fsz+4)
#                tightmap
#                
#                ifileoutn=strcat(OutPath,chem{1,ic},'_',CDate,'_',sprintf('%02u',(CTime(i))))
#                
#                ifileoute=strcat(ifileoutn,'.eps');
#                ifileout=strcat(ifileoutn,'.png');
#                ifileout2=strcat(ifileoutn,'_sm.png');
#                ifileoutth=strcat(ifileoutn,'_th.png');
#           
#                print('-depsc',ifileoute);
#                
#                cmd1=['/usr/bin/convert -density 96'  '  '  ifileoute ' ' ifileout2];
#                cmd2=['/usr/bin/convert -density 24'  '  '  ifileoute ' ' ifileoutth];
#                cmd3=['/usr/bin/convert -density 150'  '  '  ifileoute ' ' ifileout];
#                system(cmd1);
#               
#                thisimage = uint8(imread(ifileout2)./256);               
#                writeVideo(wrObj{ic}, thisimage);                
#                system(cmd3);
#            end           
#        end
#    end
#    close(wrObj{1});
#    close(wrObj{2});
#    close(wrObj{3});
#end
#warning on;










		}
	}	
}
warnings()
print("R Complete")
