#!/bin/csh -f

cd /cair-forecast/aqfs_farrow/scripts

#rm -r /home/vsingh/gfs*.o*

#SET THE DATE OR  ALLOW THE SCIPT TO USE TODAYS DATE
######################################################
#set cFDATE=$1
set cFDATEi='20150527'
set cFDATE=`date +%Y%m%d`
set cFTIME='00'
set cFDATE=`date -d "${cFDATE}" +%F`
echo $cFDATE

#GO TO THE Rplots directory and call R
######################################################
cd ./rplots
Rscript cmaq_maps_v1.R $cFDATE

#AFTER R HAS RUN GO TO THE PLOTS IN public_html
#Then run the webpage scripts
#######################################################
#cd /home/farrow/public_html/aq_r
#sed -e "s/@FFDate@/$cFDATE/g" run_html_junk.csh.sam  > run_html_junk.csh;
#sed -e "s/@FFDate@/$cFDATE/g" run_im2html_junk.csh.sam  > run_im2html_junk.csh;
#chmod 755 run_html_junk.csh 
#chmod 755 run_im2html_junk.csh
#./run_html_junk.csh > html.log
#./run_im2html_junk.csh
