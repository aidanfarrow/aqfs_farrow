function AAm=read_CMAQ_nc(ncfile,FDate,CDate)
%DataPath (data path where files are located),
%FDate: Forecast data
%CDate: Date within forecast

%ncfile=strcat(DataPath,FDate,'/cmaq/cctm/',CDate,'/CCTM_e2a.d02.',CDate,'.ACONC');
% TFLAG=ncread(ncfile,'TFLAG');
% CTime=int32(unique(TFLAG(2,:))/10000);
%CTime=0:23; % this is by default in every file

VARLIST=ncreadatt(ncfile,'/','VAR-LIST'); %Read attr values
CVARS=textscan(VARLIST,'%s');
CMAQVARS=cellstr(CVARS{:});


for iv=1:length(CMAQVARS)
    CMAQVARVAL=ncread(ncfile,CMAQVARS{iv});
    eval([CMAQVARS{iv} '=  CMAQVARVAL;']);
end

%PM25 =ASO4I + ASO4J + ANO3I + ANO3J + ANH4I + ANH4J + AORGAI + AORGAJ + 1.167*AORGPAI + 1.167*AORGPAJ + AORGBI + AORGBJ + AECI + AECJ + A25I + A25J
PM25 =ASO4I + ASO4J + ANO3I + ANO3J + ANH4I + ANH4J                    + 1.167*AORGPAI + 1.167*AORGPAJ          + AECI + AECJ + A25I + A25J;
AAm{1}=PM25;
AAm{2}=O3*1000;
AAm{3}=(NO+NO2)*1000;
