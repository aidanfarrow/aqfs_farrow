#!/bin/csh -f
#PBS -N gfs2015100200_072
#PBS -q forecast
#PBS -p +32
#PBS -l nodes=1
#PBS -l walltime=00:05:00
#PBS -k oe
#PBS -j oe
##PBS -m abe
##PBS -M v.singh3@herts.ac.uk 

echo '<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo -n 'Job is running on node(s) '; cat $PBS_NODEFILE
echo '<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo PBS_O_HOST      = $PBS_O_HOST
echo PBS_O_QUEUE     = $PBS_O_QUEUE
echo PBS_QUEUE       = $PBS_QUEUE
echo PBS_O_WORKDIR   = $PBS_O_WORKDIR
echo PBS_ENVIRONMENT = $PBS_ENVIRONMENT
echo PBS_JOBID       = $PBS_JOBID
echo PBS_JOBNAME     = $PBS_JOBNAME
echo PBS_NODEFILE    = $PBS_NODEFILE
echo PBS_O_HOME      = $PBS_O_HOME
echo PBS_O_PATH      = $PBS_O_PATH
echo '<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'

cd $PBS_O_WORKDIR

setenv DNLOPATH /cair-forecast/aqfs/inDATA/GFS
#mkdir ./gfs.2015100200

#lftp -c "pget -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2013122900/gfs.t00z.pgrb2bf09"
#lftp -c "pget -c -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2015100200/gfs.t00z.pgrb2bf072"

#lftp -c "net:timeout 5; set net:reconnect-interval-base 5; set net:max-retries 5; pget -c -n 8 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2015100200/gfs.t00z.pgrb2bf072 -o ./gfs.2015100200/"

#to donalowed GFS
#lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; pget -c -n 1 ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2015100200/gfs.t00z.pgrb2bf072 -o ./gfs.2015100200/GFS.2015100200_072.grib2"
lftp -c "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15; get -c ftp://140.90.101.180/pub/data/nccf/com/gfs/prod/gfs.2015100200/gfs.t00z.pgrb2.1p00.f072 -o ${DNLOPATH}/gfs.2015100200/GFS.2015100200_072.grib2"


#gfs.t18z.pgrb2.0p50.f000



#To Download MACC
#lftp -u macc,12Macc09 ftp.cnrm-game-meteo.fr -e "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15;pget -c -n 1 /ENS/HRES_ENS_2015100200+0072.grib2;bye"
#lftp -u macc,12Macc09 ftp.cnrm-game-meteo.fr -e "set net:timeout 5; set net:reconnect-interval-base 2; set net:max-retries 15;pget -c -n 1 /NETCDF/HRES_ENS_2015100200+0072.nc;bye"
#HRES_ENS_2014010600-006.nc
