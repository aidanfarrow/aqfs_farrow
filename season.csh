#!/bin/csh

set di=$1
set jd=`date -d "${di}" +%j`                		#Julian Day ddd

set CuYYYY=`date -d "${di}H01 -1 days" +%Y`			#Current yest YYYY

set JDAY=$CuYYYY$jd						#Julian day YYYYddd format

## Script to get the season or summer time
set DMar="03 $CuYYYY"
set DOct="10 $CuYYYY"


set dMarLS=`cal $DMar | awk 'NF>0{a=$1} END{print a}'` #Last sunday in March
set dOctLS=`cal $DOct | awk 'NF>0{a=$1} END{print a}'` #Last sunday in October

set jdMar=`date -d $CuYYYY'03'$dMarLS +%j`  
set jdOct=`date -d $CuYYYY'10'$dOctLS +%j`  

echo $jdMar $jdOct

    if (( $jd < $jdMar ) || ( $jd >= $jdOct )) then
    set  SEASON="winter"
    else
    set  SEASON="summer"
    endif
    
    
    echo $SEASON


foreach DOMN ( 01 02  )
echo $DOMN
end
