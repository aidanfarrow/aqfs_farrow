##!/bin/bash
#!/bin/csh -f


clear

set date_ini=20040703       # Initial date yyyymmdd
set date_end=20040712       # End date yyyymmdd (Initial date and final dates are same for one day simulation)


set step_days=1  

set di=$date_ini

while ( $di <= $date_end ) ; 

set dim=`date -d "${di}H01 1 days" +%Y%m%d`
set giorno=`date -d "${di}H01 0 days" +%d`
set mese=`date -d "${di}H01 0 days" +%m`
set anno=`date -d "${di}H01 0 days" +%Y`



echo  $giorno $mese $anno 

		

set di=`date -d "${di}H01 $step_days days" +%Y%m%d`
end



