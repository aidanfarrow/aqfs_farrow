#!/bin/csh -f


cd /cair-forecast/aqfs/scripts

cd ./matplots
/cair-forecast/usr/local/MATLAB/R2012a/bin/matlab -nodesktop -nosplash < cmaq_maps_v3.m > mplot.log


cd /home/vsingh/public_html/aq
./run_html.csh > html.log
./run_im2html.csh

