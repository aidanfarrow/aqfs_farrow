#!/bin/csh -f

#setenv PATH .:/bin:/usr/bin

#lftp -c "pget -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2013112900/gfs.t00z.pgrb2bf24"
#set gfsdir="ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2013122900/"

cd /cair-forecast/aqfs/scripts/dnld_gfs

#set cFDATE=$1
#set cFDATE='20140106'
set cFDATE=`date +%Y%m%d`
set cFTIME='00'



set pFDATE=`date -d "${cFDATE} -1 day" +%Y%m%d`

echo $cFDATE

setenv DNLOPATH /cair-forecast/aqfs/inDATA/GFS

mkdir ${DNLOPATH}/gfs.${cFDATE}${cFTIME}

#GFS GDAS
#lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gdas.20140107/gdas1.t00z.pgrbf00.grib2"

#Download GFS previous day
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.${pFDATE}12/gfs.t12z.pgrb2f00 -o ${DNLOPATH}/gfs.${cFDATE}${cFTIME}/GFS.${pFDATE}12_00.grib2"
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.${pFDATE}18/gfs.t18z.pgrb2f00 -o ${DNLOPATH}/gfs.${cFDATE}${cFTIME}/GFS.${pFDATE}18_00.grib2"

#foreach FHR ( 00 03 06 09  )
foreach FHR ( 00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 )


#lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 16 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.${cFDATE}${cFTIME}/gfs.t${cFTIME}z.pgrb2f${FHR} -o ./gfs.${cFDATE}${cFTIME}/GFS.${cFDATE}${cFTIME}_${FHR}.grib2"


 sed -e "s/@cFDATE@/$cFDATE/g;s/@cFTIME@/$cFTIME/g;s/@FHR@/$FHR/g" lftpget.csh.sam > lftpget.csh.t;
	
chmod +x lftpget.csh.t
/usr/local/bin/qsub lftpget.csh.t
#./lftpget.csh.t


#cd ..

end


