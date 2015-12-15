#!/bin/csh -f

clear


set date_ini=20060505       # Initial date yyyymmdd
set date_end=`date -d "${date_ini} 2 day" +%Y%m%d` 
#set date_end=20060507       # End date yyyymmdd (Initial date and final dates are same for one day simulation)


set step_days=1  

set di=$date_ini

set FDate=`date -d "${date_ini} 0 day" +%F`    #YYYY-MM-DD 
set FFDate=`date -d "${FDate} 0 day" +%Y%m%d`
#set eDate=`date -d "${date_ini} 2 day" +%Y%m%d` 


echo $FFDate $FDate

while ( $di <= $date_end ) ; 

#Current date
set cDD=`date -d "${di}" +%F`
set nDD=`date -d "${di} 1 day" +%F`
set pDD=`date -d "${di} -1 day" +%F`

echo 'Running MCIP3 for Date:'$cDD
echo '*****************'


 sed -e "s/@cDate@/$cDD/g;s/@pDate@/$pDD/g;s/@nDate@/$nDD/g;\
s/@FDate@/$FDate/g"  run.mcip.d1 > run.mcip.d1.tmp;
  chmod +x run.mcip.d1.tmp
#  ./run.mcip.d1.tmp >& mcip_d1.log
  
echo 'Domain 1 finished'

 sed -e "s/@cDate@/$cDD/g;s/@pDate@/$pDD/g;s/@nDate@/$nDD/g;\
s/@FDate@/$FDate/g" run.mcip.d2 > run.mcip.d2.tmp;
  chmod +x run.mcip.d2.tmp
#  ./run.mcip.d2.tmp >& mcip_d2.log


echo 'Domain 2 finished'
echo 'Finished MCIP3...'
echo '*****************'


set di=`date -d "${di}H01 $step_days days" +%Y%m%d`
end
