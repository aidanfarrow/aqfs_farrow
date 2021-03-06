#/bin/csh -fx
#
## HEADER ##################################################################
#
#  SMOKE ASSIGNS file (sets up for area, biogenic, mobile, nonroad, and point sources)
#
#  Version @(#)$Id: ASSIGNS.nctox.cmaq.cb4p25_wtox.us12-nc,v 1.5 2007/06/29 13:37:47 bbaek Exp $
#  Path    $Source: /afs/isis/depts/cep/emc/apps/archive/smoke/smoke/assigns/ASSIGNS.nctox.cmaq.cb4p25_wtox.us12-nc,v $
#  Date    $Date: 2007/06/29 13:37:47 $
#
#  Scenario Description:
#     This assigns file sets up the environment variables for use of 
#     SMOKE Version 2.1 outside of the Models-3 system.
#
#  Usage:
#     source <Assign>
#     Note: First set the SMK_HOME env variable to the base SMOKE installation
#
## END HEADER ##############################################################

## I/O Naming

 set FDATE=2015-10-02
 set RDATE=2015-10-04
 #set RYEAR=`echo $RDATE | cut -c1-4`
 set RYEAR=2015
 set IJDAY=2015277
 set ISEASON=summer
 set DOMN=02





   setenv SMK_HOME /cair-forecast/aqfs/exe/smoke-v2.6/gfortran
   setenv SMOKE_EXE gfortran
   source $SMK_HOME/scripts/platform

   setenv DINOUTDIR /cair-forecast/aqfs/scripts/smoke/data
#Vikas

   setenv INVID     ensclim     # Inventory input identifier
   setenv INVOP     ensclim     # Base year inventory output name
   setenv INVEN     ensclim     # Base year inventory name with version

   setenv ABASE     ensclim     # Area base case output name
   setenv BBASE     ensclim     # Biogenics base case output name
   setenv MBASE     ensclim     # Mobile base case output name
   setenv PBASE     ensclim     # Point base case output name

   setenv EBASE     ensclim     # Output merged base case name

   setenv METSCEN      d$DOMN   	# Met scenario name
   setenv GRID         d$DOMN   	# Gridding root for naming
   setenv IOAPI_GRIDNAME_1 MCIPOUT_d$DOMN # Grid selected from GRIDDESC file
   setenv IOAPI_ISPH   19                	# Specifies spheroid type associated with grid
   setenv SPC          cmaq.cb05p25_ensclim  	# Speciation type

## Mobile episode variables
   setenv EPI_STDATE $IJDAY   # Julian start date
   setenv EPI_STTIME  000000     # start time (HHMMSS)
   setenv EPI_RUNLEN  250000     # run length (HHHMMSS)
   setenv EPI_NDAY         1     # number of full run days

## Per-period environment variables
   setenv G_STDATE $EPI_STDATE      # Julian start date
   setenv G_STTIME    000000	  # start time (HHMMSS)
   setenv G_TSTEP      10000	  # time step  (HHMMSS)
   setenv G_RUNLEN    250000	  # run length (HHMMSS)
#   setenv ESDATE   20THEDATE	  # Start date of emis time-based files/dirs Vikas
   setenv ESDATE   $RDATE	  # Start date of emis time-based files/dirs Vikas
   setenv MSDATE   $ESDATE	  # Start date of met  time-based files
   setenv NDAYS     	   1	  # Duration in days of each emissions file
   setenv MDAYS     	   1	  # Duration in days of met  time-based files
   setenv YEAR       $RYEAR	  # Base year for year-specific files


## Reset days if overrides are available
   if ( $?G_STDATE_ADVANCE ) then
       set date = $G_STDATE
       @ date = $date + $G_STDATE_ADVANCE
       setenv G_STDATE $date 
       setenv ESDATE `$IOAPIDIR/datshift $G_STDATE 0`
   endif

## User-defined I/O directory settings
   setenv SMK_SUBSYS  $SMK_HOME/subsys              # SMOKE subsystem dir
   setenv SMKROOT     $SMK_SUBSYS/smoke             # System root dir
## setenv SMKDAT      $SMK_HOME/data                # Data root dir
   setenv SMKDAT      $DINOUTDIR
   setenv ASSIGNS     $SMKROOT/assigns              # smoke assigns files
#
## Override speciation setting, if override variable is set
if ( $?SPC_OVERRIDE ) then
   if ( $SPC != " " ) then
      setenv SPC $SPC_OVERRIDE
   endif
endif
#
## Override year setting, if override variable is set
if ( $?YEAR_OVERRIDE ) then
   setenv YEAR $YEAR_OVERRIDE
endif
#
## Make changes to names for future year and/or control strategy
set outstat = 0
source $ASSIGNS/set_case.scr
if ( $status > 0 ) then
   set outstat = 1
endif

## Set dependent directory names
#
source $ASSIGNS/set_dirs.scr
  # Override output directory of merged files - Vikas
  setenv OUTPUT /cair-forecast/aqfs/data/$FDATE/emiss/anthropo/$RDATE
  mkdir -p $OUTPUT
  
## Check script settings
source $ASSIGNS/check_settings.scr

##########  SMOKE formatted raw inputs #############
#
## Area-source input files
if ( $SMK_SOURCE == 'A' ) then
   setenv ARINV     $INVDIR/area/arinv.stationary.lst           # Stationary area emission inventory
   setenv REPCONFIG $INVDIR/area/REPCONFIG.area.txt             # Default report configurations
   setenv NRINV     $INVDIR/nonroad/arinv.nonroad.lst           # Nonroad mobile emission inventory
   setenv ARTOPNT   $INVDIR/other/ar2pt_14OCT03_1999.txt        # area-to-point assignments
#  setenv AGPRO     # Area gridding surrogates, now defined in the SRGDESC file
   setenv AGREF     $GE_DAT/amgref.ensclim.txt	  	  	# Area gridding x-ref 
   setenv ATPRO     $GE_DAT/amptpro.ensclim.$ISEASON.txt	  	# Temporal profiles Vikas
   setenv ATREF     $GE_DAT/amptref.ensclim.txt    	                # Area temporal x-ref
endif
#
## Biogenic input files
if ( $SMK_SOURCE == 'B' ) then
   setenv BGUSE   $SMKDAT/inventory/beld2/beld.5.us36.txt  # Gridded landuse
   setenv METLIST $INVDIR/biog/metlist.tmpbio.txt   # Meteorology file list for temperatures
   setenv RADLIST $INVDIR/biog/radlist.tmpbio.txt   # Meteorology file list for solar radiation
   setenv BFAC    $GE_DAT/bfac.summer.txt     # Default biogenic emission factors
   setenv S_BFAC  $GE_DAT/bfac.summer.txt     # Summer biogenic emission factors
   setenv W_BFAC  $GE_DAT/bfac.winter.txt     # Winter biogenic emission factors
   setenv BCUSE   $GE_DAT/landuse.dat         # County landuse
   setenv B3FAC   $GE_DAT/b3fac.beis3_efac_v0.98.txt
   setenv B3XRF   $GE_DAT/b3tob2B.xrf         # Beld3 to Beld2 cross-reference
   setenv BELD3_TOT $INVDIR/biog/beld3.${IOAPI_GRIDNAME_1}.output_tot.ncf
   setenv BELD3_A   $INVDIR/biog/beld3.${IOAPI_GRIDNAME_1}.output_a.ncf
   setenv BELD3_B   $INVDIR/biog/beld3.${IOAPI_GRIDNAME_1}.output_b.ncf
   setenv SOILINP  $STATIC/soil.beis312.$GRID.$SPC.ncf  # NO soil input file
endif

if ( $SMK_SOURCE == 'B' || $MRG_BIOG == 'Y' ) then
   setenv BGPRO   $GE_DAT/bgpro.12km_041604.nc.txt         # Biogenic gridding surrogates
endif

#
## Mobile source input files
if ( $SMK_SOURCE == 'M' ) then
   setenv MBINV     $INVDIR/mobile/mbinv.lst               # mobile emissions
   setenv VMTMIX    $INVDIR/mobile/vmtmix.txt              # VMT mix (for EMS input)
   setenv MEPROC    $INVDIR/mobile/meproc.txt              # Mobile emission processes
   setenv MCODES    $INVDIR/mobile/mcodes.txt              # mobile codes
   setenv MCREF     $INVDIR/mobile/mcref.$MSCEN.txt        # County cross-reference file
   setenv MVREF     $INVDIR/mobile/mvref.$MSCEN.txt        # County settings file
   setenv M6MAP     $INVDIR/mobile/m6map.txt               # MOBILE6 vehicle mapping file
   setenv METLIST   $INVDIR/mobile/metlist.premobl.txt     # Episode meteorology files list
   setenv SPDREF    $INVDIR/mobile/spdref.$MSCEN.txt       # Speed cross-reference file
   setenv SPDPRO    $INVDIR/mobile/spdpro.$MSCEN.txt       # Speed profiles file
   setenv REPCONFIG $INVDIR/mobile/REPCONFIG.mobile.txt    # Default report configurations
#  setenv MGPRO     # Mobile gridding surrogates, now defined in the SRGDESC file
   setenv MGREF     $GE_DAT/amgref_us_051704.txt           # Mobile gridding x-ref 
   setenv MTPRO     $GE_DAT/amptpro.m3.default.us+can.txt  # Temporal profiles
   setenv MTREF     $GE_DAT/amptref.m3.us+can.cair.txt     # Mobile temporal x-ref
endif
#
## Point source input files
if ( $SMK_SOURCE == 'P' ) then
   setenv PTINV      $INVDIR/point/ptinv.lst                 # EMS-95 point emissions
   setenv PTDAY      $INVDIR/point/ptday.lst                 # daily point emis
   setenv PTHOUR     $INVDIR/point/pthour.lst                # hourly point emis
   setenv PELVCONFIG $INVDIR/point/pelvconfig.top50.txt      # elevated source selection
   setenv REPCONFIG  $INVDIR/point/repconfig.point.txt       # Default report configurations
   #      PTMPLIST                                           # Set automatically by script
   setenv PTPRO      $GE_DAT/amptpro.ensclim.$ISEASON.txt       # Temporal profiles Vikas
   setenv PTREF      $GE_DAT/amptref.ensclim.txt                 # Point temporal x-ref
   setenv PSTK       $GE_DAT/pstk.m3.txt                     # Replacement stack params
endif
#
## Shared input files
   setenv METDAT /cair-forecast/aqfs/data/$FDATE/meteo/MCIPOUT_d$DOMN/$RDATE

   setenv INVTABLE    $INVDIR/other/invtable_nonroad.cb4.120202.txt # Inventory table
   setenv NHAPEXCLUDE $INVDIR/other/nhapexclude.1999.txt  	    # NONHAPVOC exclusions x-ref
   setenv GRIDDESC    $METDAT/GRIDDESC           	    # Grid descriptions.
#   setenv GRIDDESC    $GE_DAT/GRIDDESC.ensclim_d$DOMN           	    # Grid descriptions.
   setenv COSTCY      $GE_DAT/costcy.ensclim.txt         	    # country/state/county info
   setenv HOLIDAYS    $GE_DAT/holidays_uk.txt             	    # holidays for day change
   setenv SCCDESC     $GE_DAT/scc_desc_ensclim.txt            	    # SCC descriptions
   setenv SRGDESC     $GE_DAT/SRGDESC_ensclim_d$DOMN     # surrogate descriptions
   setenv SRGPRO_PATH $GE_DAT/Surrogates_ensclim_d$DOMN/ # surrogate files path Vikas
   setenv ORISDESC    $GE_DAT/oris_info.txt              	    # ORIS ID descriptions
   setenv MACTDESC    $GE_DAT/mact_desc.txt              	    # MACT descriptions
   setenv NAICSDESC   $GE_DAT/naics_desc.txt             	    # NAICS descriptions
   setenv GSCNV       $GE_DAT/gscnv.txt                  	    # ROG to TOG conversion facs
   setenv GSREF       $GE_DAT/gsref.$SPC.txt             	    # Speciation x-ref
   setenv GSPRO       $GE_DAT/gspro.$SPC.txt             	    # Speciation profiles
#   setenv PROCDATES   $GE_DAT/procdates.txt             	     # time periods that Temporal should process

   # For cases when GSREF and GSPRO is not a shared file.
   if ( $?SMK_SOURCE && $?SPC_SRC_SPECIFIC ) then
      if ( $SMK_SOURCE == A && $SPC_SRC_SPECIFIC == Y ) then
         set file1 = $GE_DAT/gsref.$SPC.a.txt
         set file2 = $GE_DAT/gspro.$SPC.a.txt
      endif
      if ( $SMK_SOURCE == M && $SPC_SRC_SPECIFIC == Y ) then
         set file1 = $GE_DAT/gsref.$SPC.m.txt
         set file2 = $GE_DAT/gspro.$SPC.m.txt
      endif
      if ( $SMK_SOURCE == P && $SPC_SRC_SPECIFIC == Y ) then
         set file1 = $GE_DAT/gsref.$SPC.p.txt
         set file2 = $GE_DAT/gspro.$SPC.p.txt
      endif
      if ( -e $file1 ) then
         setenv GSREF $file1
      endif
      if ( -e $file2 ) then
         setenv GSPRO $file2
      endif
   endif
#
## Override shared inputs
if ( $?INVTABLE_OVERRIDE ) then
   if ( $INVTABLE_OVERRIDE != " " ) then
      setenv INVTABLE $INVDIR/other/$INVTABLE_OVERRIDE
   endif
endif

#
## Miscellaeous input files
   if ( $RUN_MRGGRID == Y ) then
      setenv FILELIST   $INVDIR/other/filelist.mrggrid.txt
   endif
   if ( $RUN_GEOFAC == Y ) then
      setenv AGTS     $OUTPUT/no_file_set
      setenv GEOMASK  $INVDIR/other/no_file_set
      setenv SPECFACS $INVDIR/other/no_file_set
      setenv AGTSFAC  $INVDIR/other/no_file_set
   endif
   if ( $RUN_PKTREDUC == Y ) then
      setenv GCNTL_OUT $INVDIR/no_file_set   # 
   endif
   if ( $RUN_SMK2EMIS == Y ) then
      setenv VNAMMAP  $GE_DAT/VNAMMAP.dat
      setenv UAM_AGTS $OUTPUT/uam_agts_l.$ESDATE.$NDAYS.$GRID.$ASCEN.ncf
      setenv UAM_BGTS $OUTPUT/uam_bgts_l.$ESDATE.$NDAYS.$GRID.$BSCEN.ncf
      setenv UAM_MGTS $OUTPUT/uam_mgts_l.$ESDATE.$NDAYS.$GRID.$MSCEN.ncf
      setenv UAM_PGTS $OUTPUT/uam_pgts_l.$ESDATE.$NDAYS.$GRID.$PSCEN.ncf
      setenv UAM_EGTS $OUTPUT/uam_egts_l.$ESDATE.$NDAYS.$GRID.$ESCEN.ncf
   endif
   if( $RUN_UAMEMIS == Y ) then
      setenv UAMEMIS $OUTPUT/no_file_set
      setenv E2DNCF  $OUTPUT/e2dncf.ncf
   endif

## Meteorology IO/API input files (MCIP output files)
#
###   setenv METDAT /cair-forecast/aqfs/data/$FDATE/meteo/MCIPOUT_d$DOMN/$RDATE
   if ( $SMK_SOURCE == 'B' || $SMK_SOURCE == 'M' || $SMK_SOURCE == 'P' ) then
      setenv GRID_CRO_2D $METDAT/GRIDCRO2D_MCIPOUT
      setenv GRID_CRO_3D $METDAT/GRIDCRO3D_MCIPOUT
      setenv MET_CRO_2D  $METDAT/METCRO2D_MCIPOUT
      setenv MET_CRO_3D  $METDAT/METCRO3D_MCIPOUT
      setenv MET_DOT_3D  $METDAT/METDOT3D_MCIPOUT
      setenv MET_FILE1   $MET_CRO_3D
      setenv MET_FILE2   $MET_CRO_2D
   endif

#
##########################################################################
#
## Output and Intermediate files
#
## Area source intermediate and output files
#
if ( $SMK_SOURCE == 'A' ) then
   setenv ASCC     $INVOPD/ASCC.$FYIOP.txt
   setenv REPINVEN $REPSTAT/repinven.a.$INVOP.txt
   setenv ATSUPNAME $SMKDAT/run_${ASCEN}/scenario/atsup.$ASCEN.
   setenv ATSUP    $ATSUPNAME.$G_STDATE.txt
   setenv ASSUP    $SMKDAT/run_${ABASE}/static/assup.$SPC.$ABASE.txt
   setenv AGSUP    $SMKDAT/run_$ABASE/static/agsup.$GRID.$ABASE.txt
   setenv ACREP    $REPSTAT/acrep.$ASCEN.rpt           
   setenv APROJREP $REPSTAT/aprojrep.$ASCEN.rpt
   setenv AREACREP $REPSTAT/areacrep.$ASCEN.rpt
   setenv ACSUMREP $REPSTAT/acsumrep.$ASCEN.rpt
   setenv ACTLWARN $REPSTAT/actlwarn.$ASCEN.txt
   setenv AREA_O   $INVOPD/area.map.$FYINV.txt
   setenv ARINV_O  $ARDAT/arinv_o.$FYINV.orl.txt

   setenv NSCC     $INVOPD/NSCC.$FYIOP.txt
   setenv NEPINVEN $REPSTAT/repinven.nr.$INVOP.txt
   setenv NTSUPNAME $SMKDAT/run_${ASCEN}/scenario/ntsup.$ASCEN.
   setenv NTSUP    $NTSUPNAME.$G_STDATE.txt
   setenv NSSUP    $SMKDAT/run_${ABASE}/static/nssup.$SPC.$ABASE.txt
   setenv NGSUP    $SMKDAT/run_$ABASE/static/ngsup.$GRID.$ABASE.txt
   setenv NCREP    $REPSTAT/ncrep.$ASCEN.rpt           
   setenv NPROJREP $REPSTAT/nprojrep.$ASCEN.rpt
   setenv NREACREP $REPSTAT/nreacrep.$ASCEN.rpt
   setenv NCSUMREP $REPSTAT/ncsumrep.$ASCEN.rpt
   setenv NCTLWARN $REPSTAT/nctlwarn.$ASCEN.txt
   setenv NROAD_O  $INVOPD/nroad.map.$FYINV.txt
   setenv NRINV_O  $NRDAT/nrinv_o.$FYINV.ida.txt
endif

if ( $SMK_SOURCE == A || $RUN_SMKMERGE == Y && $MRG_AREA == Y ) then
   setenv AREA     $INVOPD/area.map.$FYIOP.txt   # Area inventory map
   setenv ATMPNAME $SMKDAT/run_$ASCEN/scenario/atmp.$ASCEN.
   setenv ATMP     $ATMPNAME$G_STDATE.ncf
   setenv ASMAT_S  $SMKDAT/run_$ABASE/static/asmat_s.$SPC.$ABASE.ncf
   setenv ASMAT_L  $SMKDAT/run_$ABASE/static/asmat_l.$SPC.$ABASE.ncf
   setenv ARMAT_L  $SMKDAT/run_$ASCEN/static/armat_l.$SPC.$ASCEN.ncf
   setenv ARMAT_S  $SMKDAT/run_$ASCEN/static/armat_s.$SPC.$ASCEN.ncf
   setenv ARSUP    $SMKDAT/run_$ASCEN/static/arsup.$ASCEN.txt
   setenv ACMAT    $SMKDAT/run_$ASCEN/static/acmat.$ASCEN.ncf          
   setenv AGMAT    $SMKDAT/run_$ABASE/static/agmat.$GRID.$ABASE.ncf
   setenv APMAT    $SMKDAT/run_$ASCEN/static/apmat.$ASCEN.ncf

   setenv NROAD    $INVOPD/nroad.map.$FYIOP.txt  # Nonroad inventory map
   setenv NTMPNAME $SMKDAT/run_$ASCEN/scenario/ntmp.$ASCEN.
   setenv NTMP     $NTMPNAME$G_STDATE.ncf
   setenv NSMAT_S  $SMKDAT/run_$ABASE/static/nsmat_s.$SPC.$ABASE.ncf
   setenv NSMAT_L  $SMKDAT/run_$ABASE/static/nsmat_l.$SPC.$ABASE.ncf
   setenv NRMAT_L  $SMKDAT/run_$ASCEN/static/nrmat_l.$SPC.$ASCEN.ncf
   setenv NRMAT_S  $SMKDAT/run_$ASCEN/static/nrmat_s.$SPC.$ASCEN.ncf
   setenv NRSUP    $SMKDAT/run_$ASCEN/static/nrsup.$ASCEN.txt
   setenv NCMAT    $SMKDAT/run_$ASCEN/static/ncmat.$ASCEN.ncf          
   setenv NGMAT    $SMKDAT/run_$ABASE/static/ngmat.$GRID.$ABASE.ncf
   setenv NPMAT    $SMKDAT/run_$ASCEN/static/npmat.$ASCEN.ncf
endif

## Biogenic source intermediate and output files
#
if ( $SMK_SOURCE == 'B' ) then
   setenv BGRD      $INVOPD/bgrd.summer.$GRID.$BSCEN.ncf  # Summer/default normalized bio emis
   setenv BGRDW     $INVOPD/bgrd.winter.$GRID.$BSCEN.ncf  # Winter grd normalized bio emis
   setenv BIOSEASON $GE_DAT/bioseason.$YEAR.us36.ncf
   setenv B3GRD     $INVOPD/b3grd.$GRID.$BSCEN.ncf
   setenv SOILOUT   $STATIC/soil.beis312.$GRID.$SPC.ncf  # NO soil output file
endif

if ( $SMK_SOURCE == 'B' || $MRG_BIOG == 'Y' ) then

   setenv BGDIRI /cair-forecast/aqfs/data/$FDATE/emiss/biogenic/$RDATE
   setenv BGTS_L $BGDIRI/b3gts_l.$RDATE.d$DOMN.ensclim.ncf
#   setenv BGTS_L    ../data/emiss/biogenic/THEDATE/b3gts_l.$ESDATE.$NDAYS.$GRID.ensclim.ncf #Vikas
   setenv BGTS_S    $B_OUT/b3gts_s.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv B3GTS_L   $B_OUT/b3gts_l.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv B3GTS_S   $B_OUT/b3gts_s.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv BGTS_L_O  $B_OUT/bgts_l_o.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv BGTS_S_O  $B_OUT/bgts_s_o.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv B3GTS_L_O $B_OUT/b3gts_l_o.$ESDATE.$NDAYS.$GRID.$MSB.ncf
   setenv B3GTS_S_O $B_OUT/b3gts_s_o.$ESDATE.$NDAYS.$GRID.$MSB.ncf
endif

# Mobile source intermediate and output files 
#
if ( $SMK_SOURCE == 'M' ) then
   setenv MSCC     $INVOPD/MSCC.$FYIOP.txt
   setenv REPINVEN $REPSTAT/repinven.m.$INVOP.txt
   setenv MTSUPNAME $SMKDAT/run_${MSCEN}/scenario/mtsup.$MSCEN.
   setenv MTSUP    $MTSUPNAME.$G_STDATE.txt
   setenv MSSUP    $SMKDAT/run_${MBASE}/static/mssup.$SPC.$MBASE.txt
   setenv MGSUP    $SMKDAT/run_$MBASE/static/mgsup.$GRID.$MBASE.txt
   setenv MCREP    $REPSTAT/mcrep.$MSCEN.rpt           
   setenv MPROJREP $REPSTAT/mprojrep.$MSCEN.rpt
   setenv MREACREP $REPSTAT/mreacrep.$MSCEN.rpt
   setenv MCSUMREP $REPSTAT/mcsumrep.$MSCEN.rpt
   setenv MCTLWARN $REPSTAT/mctlwarn.$MSCEN.txt
   #      HOURLYT      automaticall set and created by emisfac_run.scr script
   #      MEFLIST      automatically set and created by smk_run.scr script
   setenv SPDSUM       $STATIC/spdsum.$MSCEN.txt        # Speed summary file
   setenv DAILYGROUP   $STATIC/group.daily.$MSCEN.txt   # Daily group file
   setenv WEEKLYGROUP  $STATIC/group.weekly.$MSCEN.txt  # Weekly group file
   setenv MONTHLYGROUP $STATIC/group.monthly.$MSCEN.txt # Monthly group file
   setenv EPISODEGROUP $STATIC/group.episode.$MSCEN.txt # Episode length group file
   setenv MOBL_O   $INVOPD/mobl.map.$FYINV.txt
   setenv MBINV_O  $MBDAT/mbinv_o.$FYINV.emis.txt
   setenv MBINV_AO $MBDAT/mbinv_o.$FYINV.actv.txt
endif

if ( $SMK_SOURCE == M || $RUN_SMKMERGE == Y && $MRG_MOBILE == Y ) then
   setenv MOBL     $INVOPD/mobl.map.$FYIOP.txt   # Mobile inventory map
   setenv MTMPNAME $SMKDAT/run_$MSCEN/scenario/mtmp.$MSCEN.
   setenv MTMP     $MTMPNAME$G_STDATE.ncf
   setenv MSMAT_L  $SMKDAT/run_$MBASE/static/msmat_l.$SPC.$MBASE.ncf
   setenv MSMAT_S  $SMKDAT/run_$MBASE/static/msmat_s.$SPC.$MBASE.ncf    
   setenv MRMAT_L  $SMKDAT/run_$MSCEN/static/mrmat_l.$SPC.$MSCEN.ncf    
   setenv MRMAT_S  $SMKDAT/run_$MSCEN/static/mrmat_s.$SPC.$MSCEN.ncf
   setenv MRSUP    $SMKDAT/run_$MSCEN/static/mrsup.$MSCEN.txt
   setenv MCMAT    $SMKDAT/run_$MSCEN/static/mcmat.$MSCEN.ncf           
   setenv MUMAT    $SMKDAT/run_$MBASE/static/mumat.$GRID.$MBASE.ncf
   setenv MGMAT    $SMKDAT/run_$MBASE/static/mgmat.$GRID.$MBASE.ncf
   setenv MPMAT    $SMKDAT/run_$MSCEN/static/mpmat.$MSCEN.ncf           
endif

## Point source intermediate and output files
#
if ( $SMK_SOURCE == 'P' ) then
   setenv PDAY      $INVOPD/pday.$INVOP.ncf       # Point NetCDF day-specific
   setenv PHOUR     $INVOPD/phour.$INVOP.ncf      # Point NetCDF hour-specific
   setenv PHOURPRO  $INVOPD/phourpro.$INVOP.ncf   # Pt NetCDF src-spec dnl profs
   setenv REPINVEN  $REPSTAT/repinven.p.$INVOP.txt
   setenv PTREF_ALT $INVOPD/ptref.smkout.txt      # Point temporal x-ref
   setenv PTSUPNAME $SMKDAT/run_${PSCEN}/scenario/ptsup.$PSCEN.
   setenv PTSUP     $PTSUPNAME.$G_STDATE.txt
   setenv PSSUP     $SMKDAT/run_${PBASE}/static/pssup.$SPC.$PBASE.txt
   setenv PCREP     $REPSTAT/pcrep.$PSCEN.rpt           
   setenv PPROJREP  $REPSTAT/pprojrep.$PSCEN.rpt
   setenv PREACREP  $REPSTAT/preacrep.$PSCEN.rpt
   setenv PCSUMREP  $REPSTAT/pcsumrep.$PSCEN.rpt
   setenv PCTLWARN  $REPSTAT/pctlwarn.$PSCEN.txt
   setenv PNTS_O    $INVOPD/pnts.map.$FYINV.txt
   setenv PTINV_O   $PTDAT/ptinv_o.$FYINV.orl.txt
   setenv REPPELV   $REPSTAT/reppelv.$PSCEN.rpt
endif

if ( $SMK_SOURCE == P || $RUN_SMKMERGE == Y && $MRG_POINT == Y ) then
   setenv PNTS     $INVOPD/pnts.map.$FYIOP.txt   # Point inventory map
   setenv PSCC     $INVOPD/PSCC.$FYIOP.txt       # Point unique SCC list
   setenv PTMPNAME $SMKDAT/run_$PSCEN/scenario/ptmp.$PSCEN.
   setenv PTMP     $PTMPNAME$G_STDATE.ncf
   setenv PSMAT_L  $SMKDAT/run_$PBASE/static/psmat_l.$SPC.$PBASE.ncf
   setenv PSMAT_S  $SMKDAT/run_$PBASE/static/psmat_s.$SPC.$PBASE.ncf
   setenv PRMAT_L  $SMKDAT/run_$PSCEN/static/prmat_l.$SPC.$PSCEN.ncf
   setenv PRMAT_S  $SMKDAT/run_$PSCEN/static/prmat_s.$SPC.$PSCEN.ncf
   setenv PRSUP    $SMKDAT/run_$PSCEN/static/prsup.$PSCEN.txt
   setenv PCMAT    $SMKDAT/run_$PSCEN/static/pcmat.$PSCEN.ncf
   setenv PGMAT    $SMKDAT/run_$PBASE/static/pgmat.$GRID.$PBASE.ncf
   setenv PPMAT    $SMKDAT/run_$PSCEN/static/ppmat.$PSCEN.ncf
   setenv STACK_GROUPS $OUTPUT/stack_groups.$GRID.$PBASE.ncf
   setenv PLAY     $SMKDAT/run_$PBASE/scenario/play.$ESDATE.$NDAYS.$GRID.$MSPBAS.ncf
   setenv PLAY_EX  $SMKDAT/run_$PBASE/scenario/play_ex.$ESDATE.$NDAYS.$GRID.$MSPBAS.ncf
   setenv PELV     $STATIC/PELV.$PBASE.txt       # Elev/PinG pt source list
endif

#
## Conditional settings
   if ( $SMK_SOURCE == A && $NONROAD == Y ) then
      setenv ARINV   $NRINV
      setenv AREA    $NROAD  
      setenv ATMP    $NTMP   
      setenv ATMPNAME $NTMPNAME
      setenv ASMAT_S $NSMAT_S
      setenv ASMAT_L $NSMAT_L
      setenv ARMAT_S $NRMAT_S
      setenv ARMAT_L $NRMAT_L
      setenv ARSUP   $NRSUP  
      setenv ACMAT   $NCMAT 
      setenv AGMAT   $NGMAT  
      setenv APMAT   $NPMAT  
      setenv ASCC    $NSCC     
      setenv REPINVEN $NEPINVEN 
      setenv ATSUP    $NTSUP    
      setenv ATSUPNAME $NTSUPNAME
      setenv ASSUP    $NSSUP    
      setenv AGSUP    $NGSUP    
      setenv ACREP    $NCREP    
      setenv APROJREP $NPROJREP 
      setenv AREACREP $NREACREP
      setenv ACSUMREP $NCSUMREP
      setenv ACTLWARN $NCTLWARN
      setenv AREA_O   $NROAD_O 
      setenv ARINV_O  $NRINV_O 
   endif

   if ( $SMK_SOURCE == A ) then
      unsetenv NRINV NCNTL NROAD NTMP NTMPNAME NSMAT_S NSMAT_L NRMAT_S NRMAT_L NRSUP NCMAT NGMAT NPMAT
      unsetenv NSCC NEPINVEN NTSUP NTSUPNAME NSSUP NGSUP NCREP NPROJREP NREACREP NCSUMREP NROAD_O NRINV_O
   endif

# Cumstomized Smkmerge output file names when merging all souce sectors
# If using Smkmerge to merge all sectors
   
   if ( $SMKMERGE_CUSTOM_OUTPUT == Y && $RUN_SMKMERGE == Y ) then

         setenv EOUT  $OUTPUT/egts_l.$ESDATE.$NDAYS.$SPC.$GRID.$ESCEN.ncf 
         setenv AOUT  $A_OUT/agts_l.$ESDATE.$NDAYS.$GRID.$ASCEN.ncf 
         setenv BOUT  $B_OUT/bgts_l_o.$ESDATE.$NDAYS.$GRID.$MSB.ncf
         setenv MOUT  $M_OUT/mgts_l.$ESDATE.$NDAYS.$GRID.$MSCEN.ncf
         setenv POUT  $P_OUT/pgts3d_l.$ESDATE.$NDAYS.$GRID.$PSCEN.ncf
         setenv PING  $OUTPUT/pingts_l.$ESDATE.$NDAYS.$GRID.$PSCEN.ncf 
         setenv ELEV  $OUTPUT/elevts_l.$ESDATE.$NDAYS.$GRID.$PSCEN.txt 
         setenv REPEG $REPSCEN/rep_${MM}_all_${ESDATE}_${GRID}_${SPC}.txt
         setenv REPAG $REPSCEN/rep_${MM}_ar_${ESDATE}_${GRID}_${SPC}.txt
         setenv REPBG $REPSCEN/rep_${MM}_bg_${ESDATE}_${GRID}_${SPC}.txt
         setenv REPMG $REPSCEN/rep_${MM}_mb_${ESDATE}_${GRID}_${SPC}.txt
         setenv REPPG $REPSCEN/rep_${MM}_pt_${ESDATE}_${GRID}_${SPC}.txt
         setenv AGTS_L    $AOUT 
         setenv PGTS_L    $POUT
         setenv PGTS3D_L  $POUT
         setenv EGTS_L    $EOUT
         setenv REPB3GTS_L $REPSCEN/repb3gts_l.$ESDATE.$NDAYS.$GRID.$BSCEN.rpt
         setenv REPB3GTS_S $REPSCEN/repb3gts_s.$ESDATE.$NDAYS.$GRID.$BSCEN.rpt
    else

      source $ASSIGNS/setmerge_files.scr    #  Define merging output file names 

    endif

#  Create and change permissions for output directories
   $ASSIGNS/smk_mkdir

   if ( $status > 0 ) then
      set outstat = 1   
   endif
#
#  Get system-specific flags
   source $ASSIGNS/sysflags

   if ( $status > 0 ) then
      set outstat = 1   
   endif

#  Delete appropriate NetCDF files for the programs that are being run
   if ( -e $ASSIGNS/smk_rmfiles.scr ) then
      $ASSIGNS/smk_rmfiles.scr
   else
      echo "NOTE: missing smk_rmfiles.scr in ASSIGNS directory for"
      echo "      automatic removal of SMOKE I/O API intermediate and"
      echo "      output files"
   endif
#
#  Unset temporary environment variables
   source $ASSIGNS/unset.scr

if ( $outstat == 1 ) then
   echo "ERROR: Problem found while setting up SMOKE."
   echo "       See messages above."
   exit( 1 )
endif

