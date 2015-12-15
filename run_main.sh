#!/bin/csh -f

#source /home/vsingh/.cshrc

#set PATH=.:/usr/lib64/mpich2/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/mpi/gcc/mvapich2-1.6/bin:/home/chemel/public/wps-v3.2.1d/gfortran:/home/chemel/public/nco-v4.2.1/gcc/bin:/home/chemel/public/ncview-v2.1.1/gcc/bin:/soft/idl_8.0/idl/idl80/bin:/home/xin/bin:/home/xin/sources/Jblob-2.0.10:/home/chemel/public/ncl_ncarg-v6.1.2/gcc/bin:/home/xin/bin:/home/xin/bin:/usr/bin
#set LD_LIBRARY_PATH=/cair-forecast/usr/local/MATLAB/R2012a/sys/os/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/bin/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/extern/lib/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/runtime/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64/server:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64:/usr/lib64/mpich2/lib:/home/chemel/public/libpng-v1.5.12/gcc/lib:/cair-forecast/netcdf-v4.2.1.1/gfortran/lib/:/usr/lib64/mpich2/lib/



cd /cair-forecast/aqfs/scripts

#rm -r aqfs.log
rm -r /home/vsingh/gfs*.o*

#set cFDATE=$1
#set cFDATE='20150521'
set cFDATE=`date +%Y%m%d`
set cFTIME='00'


set pFDATE=`date -d "${cFDATE} -1 day" +%Y%m%d`
echo $cFDATE

#rm /home/vsingh/aqf.${pFDATE}.o*


setenv DNLOPATH /cair-forecast/aqfs/inDATA/GFS
mkdir ${DNLOPATH}/gfs.${cFDATE}${cFTIME}

#Download GFS previous day
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; get -c ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.${pFDATE}12/gfs.t12z.pgrb2.1p00.f000 -o ${DNLOPATH}/gfs.${cFDATE}${cFTIME}/GFS.${pFDATE}12_000.grib2"
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; get -c ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.${pFDATE}18/gfs.t18z.pgrb2.1p00.f000 -o ${DNLOPATH}/gfs.${cFDATE}${cFTIME}/GFS.${pFDATE}18_000.grib2"

#gfs.t18z.pgrb2.0p50.f000


cd ./dnld_gfs
foreach FHR ( 000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 051 054 057 060 063 066 069 072 )

 sed -e "s/@cFDATE@/$cFDATE/g;s/@cFTIME@/$cFTIME/g;s/@FHR@/$FHR/g" lftpget.csh.sam > lftpget.csh.t;

chmod +x lftpget.csh.t
/usr/local/bin/qsub lftpget.csh.t
sleep 10
end

sleep 150

cd ..

sed -e "s/@FFDate@/$cFDATE/g" all.exe.run.sam > all.exe.run.tmp;
 
/usr/local/bin/qsub all.exe.run.tmp

sleep 7500

cd ./matplots
#/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_v2.m > mplot.log
#/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_junk.m > mplot.log
#/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_v3.m > mplot.log
/soft/MATLAB/R2013b/bin/matlab -nodesktop -nosplash < cmaq_maps_v3.m > mplot.log

cd /home/vsingh/public_html/aq
./run_html.csh > html.log
./run_im2html.csh
