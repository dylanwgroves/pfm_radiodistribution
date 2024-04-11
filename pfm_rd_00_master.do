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

	* balance
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_balance.texdoc"
	
	* first stage
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_firststage.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_firststage_topics.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_firststage_stations.texdoc"
	
	* gender
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_em.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_ipv.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_gender.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_wpp.texdoc"

	
	* national id 
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_nationalid.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_nationalid_short.texdoc"

	
	* crime 
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_crime.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_crime_report.texdoc"
	
	* knowledge
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_enviroknow.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_healthknow.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_hivknow.texdoc"
	
	* political knowledge and participation 
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_ppart.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_presponsibility.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_ptrust.texdoc"	
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_pknow.texdoc"

	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_ccm.texdoc"

	* prejucide 
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_open_thermo.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_open_marry.texdoc"
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_open_nbr.texdoc"

	* identity / values
	texdoc do "${code}/pfm_radiodistribution/05_tables/pfm_rd_tables_results_identityvalues.texdoc"
	
	

	
	