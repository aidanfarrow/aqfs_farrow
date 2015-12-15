clc;clear all;close all;


sDate='2014-07-01';
eDate='2014-07-01';

for id=datenum(sDate):datenum(eDate)
    
    FDate=datestr(datenum(id),'yyyy-mm-dd');
    
    
    
    
    
    %FDate='2006-01-02';
    
    
    
    DataPath='/cair-forecast/aqfs/data/';
    %OutPath=strcat('/home/vsingh/public_html/aq/data/');
    OutPath=strcat('/cair-forecast/aqfs/data/2014/cmaq/');
    %OutPath=strcat('/cair-forecast/aqfs/data/2014/mcip/');
    
    for tdays=0:2
        
        CDate=datestr(datenum(FDate)+tdays,'yyyy-mm-dd');
         outdir=(strcat(OutPath,FDate,'/cmaq/cctm/',CDate,'/'));
        %outdir=(strcat(OutPath,FDate,'/meteo/MCIPOUT_d02/',CDate,'/'));
        
        mkdir(outdir)
        
        ncfile=strcat(DataPath,FDate,'/cmaq/cctm/',CDate,'/CCTM_e2a.d02.',CDate,'.ACONC')
%        ncfile=strcat(DataPath,FDate,'/meteo/MCIPOUT_d02/',CDate,'/METCRO2D_MCIPOUT');
        
        if exist(ncfile)
        else
            CDate
        end
         copyfile(ncfile,outdir)
        
    end
end
