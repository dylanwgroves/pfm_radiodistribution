/* Basics ______________________________________________________________________

Project: Wellspring Tanzania, Radio Distribution
Purpose: Master
Author: dylan groves, dylanwgroves@gmail.com
Date: 2021/04/26
________________________________________________________________________________*/


/* Introduction ________________________________________________________________*/
	
	clear all	
	clear matrix
	clear mata
	set more off
	global c_date = c(current_date)
	set seed 1956

/* Paths and master ____________________________________________________________*/	

	do "${code}/pfm_.master/00_setup/pfm_paths_master.do"
	do "${code}/pfm_.master/pfm_master.do"

	
/* RD prelim ___________________________________________________________________*/

	do "${code}/pfm_rd/pfm_rd_prelim.do"

	
/* Balance _____________________________________________________________________*/

	do "${code}/pfm_rd/pfm_rd_02_balance.do"
	
/* Analysis ____________________________________________________________________*/

	do "${code}/pfm_ne/pfm_rd_03_analysis.do"
	
/* Tables ______________________________________________________________________*/

	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_01_balance.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_samplesum.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_02_uptake.texdoc"
	
	** Prejudice
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_02_uptake_topics.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_prejudice_nbr.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_prejudice_marry.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_prejudice_thermo.texdoc"
	
	** Gender
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_wpp_ge.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_ipv.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_fm_em.texdoc"
	
	** Political Interest and Knowledge
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_ptixknow.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_ptixint_ptixpart.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_healthknow.texdoc"

	/* Values and Preferences */
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_values.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_ptixpref1.texdoc"
	texdoc do "${code}/pfm_radiodistribution/pfm_rd_04_tables_03_ptixpref2_ranks.texdoc"

		
	
	
	