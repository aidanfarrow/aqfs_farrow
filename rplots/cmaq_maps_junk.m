clc;clear all;close all;
warning off


% Dont forget to change this file if you change the domain.
%/cair-forecast/aqfs/data/2014-01-12/meteo/MCIPOUT_d02/2014-01-14


FDate='';
%FDate=datestr(date,'yyyy-mm-dd');

    chem={'PM25'  'O3' 'NOx' ;
        'PM2.5' 'O3' 'NOx' ;
        '(\mug/m^3)' 'ppbV' 'ppbV'};
    %    '(\mug/m^3)' 'ppbV' 'ppbV'};
    
    chemR=[50 80 60];
     S = shaperead('./ArcGlobeData/continent.shp');

for idom=1:2
    
    sdom=num2str(idom);
    
    % GridFile=strcat('/cair-forecast/aqfs/data/',FDate,'/meteo/MCIPOUT_d02/',FDate,'/GRIDCRO2D_MCIPOUT');
    GridFile=strcat('/cair-forecast/aqfs/data/',FDate,'/meteo/MCIPOUT_d0',sdom,'/',FDate,'/GRIDCRO2D_MCIPOUT');
    
    LON=ncread(GridFile,'LON');
    LAT=ncread(GridFile,'LAT');

    
    DataPath='/cair-forecast/aqfs/data/';
    %OutPath=strcat(DataPath,FDate,'/images/');
%     OutPath=strcat('/home/vsingh/public_html/aq/data/',FDate,'/images_d0',sdom,'/');
    OutPath=strcat('/cair-forecast/aqfs/data/images/',FDate,'/images_d0',sdom,'/')
    
    if exist(OutPath,'dir')
    rmdir(OutPath,'s');
    end
    mkdir (OutPath);
    
    
    

    
    
    for ic=1:size(chem,2)
        
        vidname=strcat(OutPath,chem{1,ic},'_video.avi');
        wrObj{ic} = VideoWriter(vidname);
        wrObj{ic}.FrameRate=2;
        wrObj{ic}.Quality=100;
        open(wrObj{ic});
    end
    
   
    
    for tdays=0:2
        
        
        CDate=datestr(datenum(FDate)+tdays,'yyyy-mm-dd');
        %    ncfile=strcat(DataPath,FDate,'\cmaq\cctm\',CDate,'\CCTM_e2a.d02.',CDate,'.ACONC');
        %     TFLAG=ncread(ncfile,'TFLAG');
        %     CTime=int32(unique(TFLAG(2,:))/10000);
        CTime=0:23; % this is by default in every file
        
        %   ncfile=strcat(DataPath,FDate,'/cmaq/cctm/',CDate,'/CCTM_e2a.d02.',CDate,'.ACONC');
        ncfile=strcat(DataPath,FDate,'/cmaq/cctm/',CDate,'/CCTM_e2a.d0',sdom,'.',CDate,'.ACONC')
        %     AAm=read_CMAQ_nc(DataPath,FDate,CDate);
        AAm=read_CMAQ_nc(ncfile,FDate,CDate);
        
        for ic=1:size(chem,2)
            
            AA=AAm{ic};
            
            
            for i=1:length(CTime)
                %                       for i=1:1
                figure('visible','off','renderer','zbuffer');
                %set(gcf,'PaperPosition',[0.0, 0.0, 16, 18 ]);
                %hg=worldmap([49.8 60],[-11 2]);
                %             hg=worldmap([35 70],[-15 40]);
                %            geoshow(LAT',LON',double(AA(:,:,1,i))','DisplayType','surface');
                
                
                
                
                
                if idom==1
                    
                    latlim=[35 70];lonlim=[-15 35];gspace=5;
                    cellsize=0.25;
                elseif idom==2
                    latlim=[49 60];lonlim=[-11 2];gspace=2;
                    cellsize=0.05;
                end
                
                
                [Z, refvec] = geoloc2grid(double(LAT'),double(LON'),double(AA(:,:,1,i))', cellsize);
                
                ax = axesm('mercator','MapLatLimit',latlim,...
                    'MapLonLimit',lonlim,'Grid','on','Frame','on',...
                    'MeridianLabel','on','ParallelLabel','on','MLabelParallel','south');
                %set(ax,'Visible','off')
                geoshow(Z, refvec,'DisplayType','texturemap');
                % geoshow(LAT',LON',double(AA(:,:,1,i))','DisplayType','texturemap');
                % alpha(0.90);
                
                
                %gridm ('MLineLocation',2,'MLabelLocation',2,'PLineLocation',2,'PLabelLocation',2)
                gridm ('MLineLocation',2*gspace,'MLabelLocation',2*gspace,'PLineLocation',gspace,'PLabelLocation',gspace)
                geoshow(S(3,1).Y, S(3,1).X,'Color',[0 0 0],'Linewidth',1);%
                
                fsz=12;
                %             colormap(jet2(15:end,:))
                mycmap=load('MyColormaps');
                colormap(mycmap.mycmap);
                %cbone=flipud(bone);cjet=jet;colormap([cbone(1:48,:);cjet(16:end,:)]);
                hc=colorbar('FontSize',fsz);
                %ylabel(hc,'(\mug/m^3)','FontSize',12);
                ylabel(hc,chem{3,ic},'FontSize',fsz);
                caxis([0 chemR(ic)])
                stitle=strcat(datestr(CDate),{' '},sprintf('%02u',(CTime(i))),':00 GMT');
                %title('PM2.5','FontSize',16)
                title({chem{2,ic},char(stitle)},'FontSize',fsz+4)
                tightmap
                % setm(gca,'FontSize',10)
                
                %            ifileoute=strcat(OutPath,chem{1,ic},'_',CDate,'_',sprintf('%02u',(CTime(i))),'.eps');
                ifileoutn=strcat(OutPath,chem{1,ic},'_',CDate,'_',sprintf('%02u',(CTime(i))))
                
                ifileoute=strcat(ifileoutn,'.eps');
                ifileout=strcat(ifileoutn,'.png');
                ifileout2=strcat(ifileoutn,'_sm.png');
                ifileoutth=strcat(ifileoutn,'_th.png');
                
                
                
                print('-dpng','-r72',ifileout2);
                %print('-depsc',ifileoute);
                
                cmd1=['/usr/bin/convert -density 96' ' ' ifileoute ' ' ifileout2];
                cmd2=['/usr/bin/convert -density 24' ' ' ifileoute ' ' ifileoutth];
                cmd3=['/usr/bin/convert -density 150' ' ' ifileoute ' ' ifileout];
%                system(cmd1);
                %system(cmd2);
                
                thisimage = uint8(imread(ifileout2)./256);
                %thisimage = imcrop(thisimage, [100 5 536 545]);
                %         writeVideo(writerObj, thisimage);
                %         writeVideo(writerObjt, thisimage);
                writeVideo(wrObj{ic}, thisimage);
                
%                 system(cmd3);
                
                delete(ifileoute)
                
                %print('-dpng','-r144',ifileout);
                
                %        close Figure 1
                
            end
            %    close(writerObjt);
            
        end
        
        
        
        
        %close(writerObj);
    end
    close(wrObj{1});
    close(wrObj{2});
    close(wrObj{3});
end
warning on;



