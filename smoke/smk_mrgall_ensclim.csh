#!/bin/csh -f
#
# Version @(#)$Id: smk_mrgall_nctox.csh,v 1.7 2007/06/29 13:48:38 bbaek Exp $
# Path    $Source: /afs/isis/depts/cep/emc/apps/archive/smoke/smoke/scripts/run/smk_mrgall_nctox.csh,v $
# Date    $Date: 2007/06/29 13:48:38 $
#
# This script sets up needed environment variables for merging
# emissions in SMOKE and calls the scripts that run the SMOKE programs. 
#
# Script created by : M. Houyoux, CEP Environmental Modeling Center 
#
#*********************************************************************

## Set optional customized SMKMERGE output file names
## setenv SMKMERGE_CUSTOM_OUTPUT  N  # Y define your own output file names from SMKMERGE

## Set Assigns file name
setenv ASSIGNS_FILE ./ASSIGNS.ensclim.cmaq.cb05.sh

## Set source category
setenv SMK_SOURCE    E          # source category to process
setenv MRG_SOURCE    ABP        # source category to merge

## Set programs to run...

## For merging from matrices
setenv RUN_SMKMERGE  N          # run merge program
#      NOTE: in sample script, not used because nonroad is treated as a separate category

## For merging from previously generated gridded Smkmerge outputs
setenv RUN_MRGGRID   Y          # run gridded file merge program
#      NOTE: in sample script, Mrggrid used to create merged model-ready CMAQ files

## Program-specific controls...

## For Smkmerge
setenv MRG_LAYERS_YN        Y   # Y produces layered output
setenv MRG_SPCMAT_YN        Y   # Y produces speciated output 
setenv MRG_TEMPORAL_YN      Y   # Y produces temporally allocated output
setenv MRG_GRDOUT_YN        Y   # Y produces a gridded output file
setenv MRG_REPCNY_YN        N   # Y produces a report of emission totals by county
setenv MRG_REPSTA_YN        N   # Y produces a report of emission totals by state
setenv MRG_GRDOUT_UNIT      moles/s   # units for the gridded output file
setenv MRG_TOTOUT_UNIT      moles/day # units for the state and county reports
setenv SMK_ASCIIELEV_YN     N   # Y creates an ASCII elevated point sources file
setenv SMK_REPORT_TIME      230000    # hour for reporting daily emissions
#      EXPLICIT_PLUMES_YN see "Multiple-program controls" below
#      SMK_AVEDAY_YN    see "Multiple-program controls" below
#      SMK_EMLAYS       see "Multiple-program controls" below
#      SMK_PING_METHOD  see "Multiple-program controls" below

## For Mrggrid
setenv MRG_DIFF_DAYS        N   # Y allows data from different days to be merged
#      MRGFILES         see "Script settings" below
#      MRGGRID_MOLE     see "Script settings" below

## Multiple-program controls
setenv EXPLICIT_PLUME_YN    N   # Y processes only sources using explicit plume rise
setenv SMK_EMLAYS           18  # number of emissions layers
setenv SMK_AVEDAY_YN        N   # Y uses average-day emissions instead of annual emissions
setenv SMK_MAXERROR         100 # maximum number of error messages in log file
setenv SMK_MAXWARNING       100 # maximum number of warning messages in log file
setenv SMK_PING_METHOD      0   # 1 processes and outputs PinG sources

## Script settings
setenv MRGFILES "AGTS_L BGTS_L PGTS3D_L" # logical file names to merge
#setenv MRGFILES "AGTS_L PGTS3D_L" # logical file names to merge
setenv MRGGRID_MOLE         Y   # Y outputs mole-based file, musy be consistent with MRGFILES
setenv SRCABBR              abp # abbreviation for naming log files
setenv PROMPTFLAG           N   # Y prompts for user input
setenv AUTO_DELETE          Y   # Y automatically deletes I/O API NetCDF output files
setenv AUTO_DELETE_LOG      Y   # Y automatically deletes log files
setenv DEBUGMODE            N   # Y runs program in debugger
setenv DEBUG_EXE            pgdbg # debugger to use when DEBUGMODE = Y

## Assigns file override settings
# setenv SPC_OVERRIDE  cmaq.cb4p25  # chemical mechanism override
# setenv INVTABLE_OVERRIDE          # inventory table override

##############################################################################

## Loop through days to run Smkmerge and Mrggrid
#
source $ASSIGNS_FILE   # Invoke Assigns file
setenv RUN_PART2 Y
setenv RUN_PART4 Y
set cnt = 0
set g_stdate_sav = $G_STDATE
while ( $cnt < $EPI_NDAY )

   @ cnt = $cnt + $NDAYS
   source $ASSIGNS_FILE   # Invoke Assigns file to set new dates

   if ( $MRGGRID_MOLE == Y ) then
      setenv OUTFILE $EGTS_L
   else 
      setenv OUTFILE $EGTS_S
   endif

   source smk_run.csh     # Run programs
   setenv G_STDATE_ADVANCE $cnt

end
setenv RUN_PART2 N
setenv RUN_PART4 N
unsetenv G_STDATE_ADVANCE

#
## Ending of script
#
exit( 0 )
