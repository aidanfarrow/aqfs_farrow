#!/bin/csh -f




#set SFDATE=20120517  					# Date of forecast (YYYYMMDD)
#set EFDATE=20120522

#set FDate=`date -d "${FDatei} 0 day" +%F`    #YYYY-MM-DD



#set date_ini=`date -d "${FDate} 0 day" +%Y%m%d`       # Initial date yyyymmdd (Date comes from FDate, that is forecast date)
#set date_end=`date -d "${date_ini} 2 day" +%Y%m%d` 

set date_ini=20140206       # Initial date yyyymmdd (Date comes from FDate, that is forecast date)
set date_end=20140210


#rm -r aqfs.log
rm -r /home/vsingh/aqf.*
echo $date_ini $date_end

set step_days=1  
set di=$date_ini


while ( $di <= $date_end ) ;  # Date loop for three days


set FFDATE=`date -d "${di}" +%Y%m%d`				#Current date

set ddd=`date -d "${di}" +%F`	

#mv ../data/${ddd} ../data/${ddd}.bak22

sed -e "s/@FFDate@/$FFDATE/g" all.exe.run.sam > all.exe.run.tmp;
#sed -e "s/@FFDate@/$FFDATE/g" all.exe.run.32.sam > all.exe.run.d${ddd};
qsub all.exe.run.tmp
  


echo  $FFDATE $ddd

set di=`date -d "${di}H01 $step_days days" +%Y%m%d`
end  # Date loop end
