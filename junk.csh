#!/bin/csh -f
#PBS -N test-aqf-Final
#PBS -q forecast
#PBS -l nodes=1
#PBS -l walltime=12:00:00
#PBS -k oe
#PBS -j oe
#PBS -m abe
#PBS -M v.singh3@herts.ac.uk,x.francis@herts.ac.uk


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


#!/bin/csh



setenv MPIRUN /usr/local/bin/mpiexec



echo '<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo Job terminated
echo '<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'







