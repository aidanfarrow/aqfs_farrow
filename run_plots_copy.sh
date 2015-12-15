#!/bin/csh -f

#source /home/vsingh/.cshrc

#set PATH=.:/usr/lib64/mpich2/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/mpi/gcc/mvapich2-1.6/bin:/home/chemel/public/wps-v3.2.1d/gfortran:/home/chemel/public/nco-v4.2.1/gcc/bin:/home/chemel/public/ncview-v2.1.1/gcc/bin:/soft/idl_8.0/idl/idl80/bin:/home/xin/bin:/home/xin/sources/Jblob-2.0.10:/home/chemel/public/ncl_ncarg-v6.1.2/gcc/bin:/home/xin/bin:/home/xin/bin:/usr/bin
#set LD_LIBRARY_PATH=/cair-forecast/usr/local/MATLAB/R2012a/sys/os/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/bin/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/extern/lib/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/runtime/glnxa64:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64/server:/cair-forecast/usr/local/MATLAB/R2012a/sys/java/jre/glnxa64/jre/lib/amd64:/usr/lib64/mpich2/lib:/home/chemel/public/libpng-v1.5.12/gcc/lib:/cair-forecast/netcdf-v4.2.1.1/gfortran/lib/:/usr/lib64/mpich2/lib/

date #Aidan Check
echo "Check 1" #Aidan Check

cd /cair-forecast/aqfs/scripts

#rm -r aqfs.log
rm -r /home/vsingh/gfs*.o*

#set cFDATE=$1
#set cFDATEi='20150527'
set cFDATE=`date +%Y%m%d`
set cFTIME='00'


set cFDATE=`date -d "${cFDATE}" +%F`
echo $cFDATE

#rm /home/vsingh/aqf.${pFDATE}.o*

echo "Check 2" #Aidan Check

cd /cair-forecast/aqfs/scripts/matplots
pwd #Aidan
echo "Check 3" #Aidan Check

#sed -e "s/@FFDate@/$cFDATE/g" cmaq_maps_junk.m.sam  > cmaq_maps_junk.m;
#/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_v2.m > mplot.log
#/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_junk.m > mplot.log
#/soft/MATLAB/R2013b/bin/matlab -nodesktop -nosplash < cmaq_maps_junk.m > mplot.log
/soft/MATLAB/R2013b/bin/matlab -nodesktop -nosplash < /cair-forecast/aqfs/scripts/matplots/cmaq_maps_v3_copy.m > /cair-forecast/aqfs/scripts/mplot3_copy.log

echo "Check 4" #Aidan Check

cd /home/vsingh/public_html/aq
pwd #Aidan
echo "Check 5" #Aidan Check

sed -e "s/@FFDate@/$cFDATE/g" run_html_junk.csh.sam  > run_html_junk.csh;
sed -e "s/@FFDate@/$cFDATE/g" run_im2html_junk.csh.sam  > run_im2html_junk.csh;

echo "Check 6" #Aidan Check

chmod 755 run_html_junk.csh 
chmod 755 run_im2html_junk.csh


./run_html_junk.csh > /cair-forecast/aqfs/scripts/html_copy.log
echo "Check 7" #Aidan Check
./run_im2html_junk.csh > /cair-forecast/aqfs/scripts/run_im2html_junk_copy.log
echo "Check 8" #Aidan Check
