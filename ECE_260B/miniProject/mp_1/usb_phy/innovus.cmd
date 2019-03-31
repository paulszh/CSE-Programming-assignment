#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Tue Feb 27 23:39:14 2018                
#                                                     
#######################################################

#@(#)CDS: Innovus v15.23-s045_1 (64bit) 04/22/2016 12:32 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 15.23-s045_1 NR160414-1105/15_23-UB (database version 2.30, 317.6.1) {superthreading v1.26}
#@(#)CDS: AAE 15.23-s014 (64bit) 04/22/2016 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 15.23-s022_1 () Apr 22 2016 09:38:45 ( )
#@(#)CDS: SYNTECH 15.23-s008_1 () Apr 12 2016 21:52:59 ( )
#@(#)CDS: CPE v15.23-s045
#@(#)CDS: IQRC/TQRC 15.1.4-s213 (64bit) Tue Feb  9 17:31:28 PST 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
set init_pwr_net VDD
set init_gnd_net VSS
set init_verilog ./usb_phy.v
set init_design_netlisttype Verilog
set init_design_settop 1
set init_top_cell usb_phy
set init_lef_file /home/linux/ieng6/ee260b/public/data/libraries/techfiles/contest.lef
create_library_set -name WC_LIB -timing $libworst
create_library_set -name BC_LIB -timing $libworst
create_rc_corner -name Cmax -cap_table $captblworst -T 125
create_rc_corner -name Cmin -cap_table $captblworst -T -40
create_delay_corner -name WC -library_set WC_LIB -rc_corner Cmax
create_delay_corner -name BC -library_set BC_LIB -rc_corner Cmin
create_constraint_mode -name CON -sdc_file [list $sdc]
create_analysis_view -name WC_VIEW -delay_corner WC -constraint_mode CON
create_analysis_view -name BC_VIEW -delay_corner BC -constraint_mode CON
init_design -setup WC_VIEW -hold BC_VIEW
set_interactive_constraint_modes {CON}
setDesignMode -process 65
defIn usb_phy.def
setAnalysisMode -analysisType onChipVariation -cppr both
setDelayCalMode -reset
setDelayCalMode -SIAware true
setExtractRCMode -coupled true -engine postRoute
report_timing
setEcoMode -batchMode true
setEcoMode -refinePlace true
ecoChangeCell -inst FE_OFC1_fs_ce -cell in01m04
ecoChangeCell -inst FE_DBTC0_i_tx_phy_state_1_ -cell in01m03
ecoChangeCell -inst U419 -cell in01s02
ecoChangeCell -inst U424 -cell no02m04
ecoChangeCell -inst U427 -cell na02s01
ecoChangeCell -inst U430 -cell na02s02
ecoChangeCell -inst U432 -cell in01s04
ecoChangeCell -inst U433 -cell in01s01
ecoChangeCell -inst U434 -cell na02s02
ecoChangeCell -inst U437 -cell na02m08
ecoChangeCell -inst U466 -cell in01m02
ecoChangeCell -inst U487 -cell in01m02
ecoChangeCell -inst U490 -cell no02m02
ecoChangeCell -inst U498 -cell in01m01
ecoChangeCell -inst U550 -cell in01s01
ecoChangeCell -inst U613 -cell in01m01
ecoChangeCell -inst U614 -cell in01m01
ecoChangeCell -inst U420 -cell na02m01
ecoChangeCell -inst U421 -cell no02s02
ecoChangeCell -inst U422 -cell no04m04
ecoChangeCell -inst U425 -cell no04m06
ecoChangeCell -inst U429 -cell na02s02
ecoChangeCell -inst U431 -cell na02s02
ecoChangeCell -inst U452 -cell no03m03
ecoChangeCell -inst U463 -cell no02m01
ecoChangeCell -inst U471 -cell oa12s02
ecoChangeCell -inst U489 -cell oa22m02
ecoChangeCell -inst U499 -cell no02s01
ecoChangeCell -inst U532 -cell no02m04
ecoChangeCell -inst U535 -cell in01m02
ecoChangeCell -inst U548 -cell no02s01
ecoChangeCell -inst U551 -cell na03m02
ecoChangeCell -inst U571 -cell no02m02
ecoChangeCell -inst U416 -cell na02s01
ecoChangeCell -inst U418 -cell ao12m02
ecoChangeCell -inst U423 -cell na02m02
ecoChangeCell -inst U426 -cell no02s02
ecoChangeCell -inst U451 -cell na03s02
ecoChangeCell -inst U459 -cell na02m02
ecoChangeCell -inst U465 -cell in01m01
ecoChangeCell -inst U485 -cell in01m01
ecoChangeCell -inst U533 -cell in01m02
ecoChangeCell -inst U552 -cell in01m02
ecoChangeCell -inst U637 -cell na02m01
ecoChangeCell -inst U648 -cell in01m01
ecoChangeCell -inst U657 -cell ao22m01
ecoChangeCell -inst U693 -cell na03m01
ecoChangeCell -inst U438 -cell no02s01
ecoChangeCell -inst U442 -cell no02m01
ecoChangeCell -inst U443 -cell no02m04
ecoChangeCell -inst U444 -cell no02s02
ecoChangeCell -inst U447 -cell oa12s02
ecoChangeCell -inst U450 -cell in01m02
ecoChangeCell -inst U458 -cell no02m03
ecoChangeCell -inst U469 -cell na02s01
ecoChangeCell -inst U491 -cell oa12m02
ecoChangeCell -inst U553 -cell no02m02
ecoChangeCell -inst U625 -cell no02m01
ecoChangeCell -inst U660 -cell oa12m01
ecoChangeCell -inst U667 -cell no02m02
ecoChangeCell -inst U409 -cell ao12m01
ecoChangeCell -inst U413 -cell no02s02
ecoChangeCell -inst U414 -cell no02m02
ecoChangeCell -inst U417 -cell na02s03
ecoChangeCell -inst U445 -cell in01m01
ecoChangeCell -inst U448 -cell ao12m02
ecoChangeCell -inst U449 -cell in01s01
ecoChangeCell -inst U461 -cell ao12m01
ecoChangeCell -inst U462 -cell na02m03
ecoChangeCell -inst U484 -cell ao12m01
ecoChangeCell -inst U492 -cell ao12m02
ecoChangeCell -inst U500 -cell na03m02
ecoChangeCell -inst U512 -cell na03s02
ecoChangeCell -inst U628 -cell na02m02
ecoChangeCell -inst U643 -cell oa12m01
ecoChangeCell -inst U662 -cell ao12m01
ecoChangeCell -inst U687 -cell ao22m01
ecoChangeCell -inst U716 -cell na02m01
ecoChangeCell -inst U724 -cell no02m02
ecoChangeCell -inst U407 -cell no02s02
ecoChangeCell -inst U410 -cell na03s01
ecoChangeCell -inst U411 -cell na03s02
ecoChangeCell -inst U415 -cell no02s02
ecoChangeCell -inst U435 -cell no04m02
ecoChangeCell -inst U439 -cell in01s02
ecoChangeCell -inst U441 -cell na02m02
ecoChangeCell -inst U446 -cell in01s01
ecoChangeCell -inst U460 -cell oa22m01
ecoChangeCell -inst U468 -cell na03s02
ecoChangeCell -inst U483 -cell no02m02
ecoChangeCell -inst U501 -cell no02m02
ecoChangeCell -inst U688 -cell no02m01
ecoChangeCell -inst U690 -cell oa22m01
ecoChangeCell -inst U694 -cell oa22m01
ecoChangeCell -inst U704 -cell ao22m01
ecoChangeCell -inst U708 -cell ao22m01
ecoChangeCell -inst U710 -cell ao22m01
ecoChangeCell -inst U408 -cell na02s01
ecoChangeCell -inst U412 -cell ao22m01
ecoChangeCell -inst U436 -cell oa12m02
ecoChangeCell -inst U440 -cell ao12m02
ecoChangeCell -inst U456 -cell ao12m02
ecoChangeCell -inst U475 -cell na02m01
ecoChangeCell -inst U477 -cell na02m01
ecoChangeCell -inst U479 -cell na02m01
ecoChangeCell -inst U482 -cell no04m02
ecoChangeCell -inst U486 -cell ao22m01
ecoChangeCell -inst U718 -cell no02m01
ecoChangeCell -inst U722 -cell ao12m01
ecoChangeCell -inst U453 -cell oa22s01
ecoChangeCell -inst U454 -cell oa22s01
ecoChangeCell -inst U470 -cell oa22m01
ecoChangeCell -inst U472 -cell ao22m02
ecoChangeCell -inst U473 -cell oa12s01
ecoChangeCell -inst U474 -cell oa12s01
ecoChangeCell -inst U476 -cell oa12s01
ecoChangeCell -inst U478 -cell oa12s01
ecoChangeCell -inst U481 -cell ao12m02
ecoChangeCell -inst U495 -cell ao12m01
ecoChangeCell -inst U744 -cell oa12m01
ecoChangeCell -inst U455 -cell no02s01
ecoChangeCell -inst U457 -cell oa12m01
ecoChangeCell -inst U480 -cell no02s02
setEcoMode -batchMode false
routeDesign
report_timing
saveNetlist usb_phy_eco.v
rcOut -excNetFile excNet.rpt -spef usb_phy_eco.spef
defOut -routing usb_phy_eco.def
