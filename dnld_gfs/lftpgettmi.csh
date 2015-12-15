#!/bin/csh -f

mkdir y1998
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 8 ftp://ftp.ssmi.com/tmi/bmaps_v04/y1998/m05/tmi_19980501v4_d3d.gz -o ./y1998/tmi_19980501v4_d3d.gz"


