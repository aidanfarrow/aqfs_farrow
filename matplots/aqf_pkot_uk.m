clc;clear all;close all;

LON=ncread('GRIDCRO2D_MCIPOUT','LON');
LAT=ncread('GRIDCRO2D_MCIPOUT','LAT');



FDate='2014-01-01';


DataPath='L:\aqfs\data\';
OutPath=strcat(DataPath,FDate,'\images\');

mkdir (OutPath);

writerObj = VideoWriter(strcat(OutPath,'video.avi'));
writerObj.FrameRate=2;
writerObj.Quality=100;
open(writerObj);

for tdays=0:2
    
    %CDate='2014-01-02';
    CDate=datestr(datenum(FDate)+tdays,'yyyy-mm-dd');
    
    
    
    %L:\aqfs\data\2013-12-30\cmaq\cctm\2013-12-30
    ncfile=strcat(DataPath,FDate,'\cmaq\cctm\',CDate,'\CCTM_e2a.d02.',CDate,'.ACONC');
    
    TFLAG=ncread(ncfile,'TFLAG');
    CTime=int32(unique(TFLAG(2,:))/10000);
    
    
    VARLIST=ncreadatt(ncfile,'/','VAR-LIST'); %Read attr values
    CVARS=textscan(VARLIST,'%s');
    CMAQVARS=cellstr(CVARS{:});
    
    
    for iv=1:length(CMAQVARS)
        
        CMAQVARVAL=ncread(ncfile,CMAQVARS{iv});
        
        eval([CMAQVARS{iv} '=  CMAQVARVAL;']);
        
        %  eval([vars{i} '=  vals(i)'])
        
    end
    
    
    %PM25 =ASO4I + ASO4J + ANO3I + ANO3J + ANH4I + ANH4J + AORGAI + AORGAJ + 1.167*AORGPAI + 1.167*AORGPAJ + AORGBI + AORGBJ + AECI + AECJ + A25I + A25J
    PM25 =ASO4I + ASO4J + ANO3I + ANO3J + ANH4I + ANH4J                    + 1.167*AORGPAI + 1.167*AORGPAJ          + AECI + AECJ + A25I + A25J;
    
    
    
    
    %AA=ncread('CCTM_e2a.d02.2006-01-02.ACONC','CO');
    AA=PM25;
    
    S = shaperead('C:\Program Files (x86)\ArcGIS\Desktop10.0\ArcGlobeData\continent.shp');
    
    
    for i=1:length(CTime)
    %for i=1:1
        figure('visible','off');
        worldmap([50 60],[-8 2])
        geoshow(LAT',LON',double(AA(:,:,1,i))','DisplayType','texturemap');
        jet2=jet;
        colormap(jet2(15:end,:))
        colorbar
        caxis([0 40])
        
        stitle=strcat('PM2.5',{' '},CDate,{' '},sprintf('%02u',(CTime(i))),':00:00');
        title(stitle)
        %title({'PM2.5 (µg/m^3)',char(stitle)})
        
        hold on
        geoshow(S(3,1).Y, S(3,1).X,'Color',[.8 .8 .8]);%
        
        
        
        
        strcat(DataPath,FDate,'\cmaq\cctm\',CDate,'\CCTM_e2a.d02.',CDate,'.ACONC');
        
        
        %ifileout=strcat(int2str(i),'.png');
        ifileout=strcat(OutPath,CDate,'_',sprintf('%02u',(CTime(i))),'.png');
        print('-dpng','-r72',ifileout);
        
        F(i) = getframe(gca) ;
        %size(F(i).cdata)
        
        thisimage = imread(ifileout);
        writeVideo(writerObj, thisimage);
        
        close Figure 1    
    end

end

close(writerObj);


