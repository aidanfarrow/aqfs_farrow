##!/bin/bash
#!/bin/csh -f


clear

#di=date input in format YYYYMMDD
#di=20040301
echo 'Type date in format YYYYMMDD:' 
#set read di
set di=20060504


#Current date
set DD=`date -d "${di}" +%F`
set DDn=`date -d "${di} 1 day" +%F`
set DDp=`date -d "${di} -1 day" +%F`

#Current date parmeters
set dd=`date -d "${di}" +%d`
set mm=`date -d "${di}" +%m`
set yy=`date -d "${di}" +%Y`


#Next date parameters
set ddf=`date -d "${di} 1 day" +%d`
set mmf=`date -d "${di} 1 month" +%m`
set yyf=`date -d "${di} 1 years" +%Y`


#Previous date parameters
set ddp=`date -d "${di} -1 day" +%d`
set mmp=`date -d "${di} -1 month" +%m`
set yyp=`date -d "${di} -1 years" +%Y`


#Julian date
set jd=`date -d "${di}" +%j`

#Number of days in month
set dmp=$yy$mmf"01"
set nd=`date -d "${dmp} -1 day" +%d`

set lastsun= date -d "last saturday" +"%b-%d-%Y" 

#Last sunday of a month
cal 09 2013 | awk 'NF>1{a=$1} END{print a}'


echo $di

echo 'Full Date:' $DD
echo 'Full Date:' $DDn
echo 'Full Date:' $DDp
echo 'CDate:' $dd
echo 'CMonth:' $mm
echo 'Cyear:' $yy
echo
echo 'FDate:' $ddf
echo 'FMonth:' $mmf
echo 'Fyear:' $yyf
echo
echo 'PDate:' $ddp
echo 'PMonth:' $mmp
echo 'Pyear:' $yyp
echo
echo 'Julian day:' $jd
echo 'Number of days in month:' $nd
