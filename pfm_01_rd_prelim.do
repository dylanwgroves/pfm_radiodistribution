
/* Overview ______________________________________________________________________

Project: Wellspring Tanzania, Natural Experiment
Purpose: Analysis Prelimenary Work
Author: dylan groves, dylanwgroves@gmail.com
Date: 2020/12/23l


	This mostly just subsets the data and does anything else necessary before
	running the analysis	
________________________________________________________________________________*/


/* Introduction ________________________________________________________________*/
	
	
	clear all	
	clear matrix
	clear mata
	set more off
	global c_date = c(current_date)
	set seed 1956
	set maxvar 30000
	
	
	
/* Save RI treatments elsewhere ________________________________________________*/

	use "X:/Dropbox/Wellspring Tanzania Papers/wellspring_01_master/01_data/03_final_data/pfm_appended_noprefix.dta", clear

	/* RI Treatment Variables 	*/
	drop treat_*
	rename rd_treat_* treat_*
	keep id_resp_uid treat_* 
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd1_ri.dta", replace


	
/*______________________________________________________________________________

							AUDIO SCREENING 1
________________________________________________________________________________*/


/* Load Data ___________________________________________________________________*/		

	use "X:/Dropbox/Wellspring Tanzania Papers/wellspring_01_master/01_data/03_final_data/pfm_appended_noprefix.dta", clear
	drop treat_*
	lab def treat 0 "control" 1 "treat", replace
	drop rd_treat_*
	drop resp_id


/* Subset Data _________________________________________________________________*/	
	
	
	/* Get correct sample */
	rename rd_treat treat
	keep if treat != .
	
	foreach var of varlist radio_stations_* {
		tab `var' if treat == 1
	}


/* Generate any necessary variables ____________________________________________*/

	/* Endline and Attrition */
	replace endline = endline_as if sample == "as"
		replace endline = endline_ne if sample == "ne"
		replace endline = 0 if endline == .
		keep if endline == 1													// Assuming we only want folks we found at endline?
	
	/* Set NE treatment to missing
	gen treatment_group = treat_as
		replace treatment_group = 2 if treatment_group == .
	 */
	
	/* Uptake */
	replace rd_receive = 0 if rd_receive == . & (endline_ne == 1 | endline_as == 1)
	replace rd_stillhave = 0 if rd_receive == 0
	
	/* Radio listening */
	gen radio_listen_twoweek = 1 if radio_listen == 1 | radio_listen == 2 | radio_listen == 3
		replace radio_listen_twoweek = 0 if radio_listen == 0
		
	gen radio_listen_hrperday = 1 if radio_listen == 2 | radio_listen == 3
		replace radio_listen_hrperday = 0 if radio_listen == 0 | radio_listen == 1

	/* Tribe */
	gen resp_tribe_sambaa = (resp_tribe == 32)
	gen resp_tribe_digo = (resp_tribe == 38)

	/* Prej thermo */
	replace prej_thermo_out_eth = prej_thermo_digo 
		replace prej_thermo_out_eth = . if resp_tribe_digo == 1
	
	/* Tribe Self */
	gen prej_thermo_in_eth = prej_thermo_sambaa if resp_tribe_sambaa == 1
		replace prej_thermo_in_eth = prej_thermo_digo if resp_tribe_digo == 1
		
	/* Religious Centrism */
	gen prej_thermo_in_rel = prej_thermo_muslims if resp_muslim == 1
		replace prej_thermo_in_rel = prej_thermo_christians if resp_muslim == 0
			
	/* Index */
	egen prej_thermo_index = rowmean(prej_thermo_chinese prej_thermo_out_rel prej_thermo_out_eth prej_thermo_kenyan)
	
	/* Government responsibility */
	gen ptixpref_resp_gov = ptixpref_resp_locgov + ptixpref_resp_natgov
	
	/* Health Knowledge Index */
	egen healthknow_index = rowmean(healthknow_notradmed healthknow_nowitchcraft healthknow_vaccines healthknow_vaccines_imp hivknow_index)
	
	/* Household labor index */
	drop hhlabor_index
	egen hhlabor_index = rowmean(hhlabor_chores_dum hhlabor_kids_dum hhlabor_money_dum)
	
	/* Household decisions */
	drop hhdecision_index 
	egen hhdecision_index = rowmean(hhdecision_health_dum hhdecision_school_dum hhdecision_hhfix_dum)
	
	/* Crime */
	gen ptixpref_rank_crime_short = (ptixpref_rank_crime-1)/8
	gen crime_index = (ptixpref_rank_crime-1)/8
	
	
/* Create baseline variables  __________________________________________________

	radios were distributed after midline of the AS survey, so can use that as
	the baseline


	replace b_ge_school = m_s5q4_gh_school if sample == "as"
	replace b_em_reject_story = (1 - m_s4q1_fm_yesself) if sample == "as"
	replace b_ipv_rej_disobey = m_s8q3a_ipv_disobey  if sample == "as"
	replace b_ipv_norm_rej = (1-m_s11q1_ipv_hitnorm)  if sample == "as"
	replace b_values_elders = b_values_trustelders  if sample == "as"
*/
	
/* Save ________________________________________________________________________*/

	merge 1:1 id_resp_uid using "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd1_ri.dta", gen(_merge_ri1)
	keep if _merge_ri1==1 | _merge_ri1==3
	
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd1_analysis.dta", replace

	
	
	
/*______________________________________________________________________________

							AUDIO SCREENING 2
________________________________________________________________________________*/



/* Load Data ___________________________________________________________________*/	

	use "${data}/03_final_data/pfm_as2_merged.dta", clear
	rename as2_* *
	drop e_id_village_uid
	rename e_* *
	drop treat
	rename treat_rd treat
	drop treat_* 
	lab def treat 0 "control" 1 "treat", replace 

	
/* Subset Data _________________________________________________________________*/	
	
	/* Get correct sample */
	keep if treat != .
	
	
/* Generate variables __________________________________________________________*/
	
	gen rd_block = id_village_uid
	
	gen resp_muslim = b_resp_muslim 
	*gen resp_age = b_resp_age 
	gen b_resp_numhh = b_resp_hh_nbr
	gen b_resp_lang_swahili =  b_resp_swahili
	gen b_radio_any = b_radio_ever
	gen b_asset_cell = b_assets_cell	
	gen b_asset_tv = b_assets_tv
	gen b_asset_radio_num = b_assets_radios_num
	
/* Create indices ______________________________________________________________*/

	gen crime_local_short = crime_local/3 
	gen crime_femtravel_short = gbv_travel_risky_long/3
	gen crime_femboda_short = gbv_boda_risky_long/3

	egen crime_index = rowmean(crime_natl crime_local_short crime_femtravel_short crime_femboda_short)
	
/* Save ________________________________________________________________________*/

	merge 1:1 id_resp_uid using "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd2_ri.dta", gen(_merge_ri2) force	
	keep if _merge_ri2==1 | _merge_ri2==3
	
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd2_analysis.dta", replace
	

/*______________________________________________________________________________

							COMMUNITY SCREENING
________________________________________________________________________________*/
	
	
/* Load Data ___________________________________________________________________*/	
	
	use "${data}/03_final_data/pfm_cm_merged.dta", clear
	rename cm3_* *
	rename cm2_* b_*
	
	gen treat = 1 if treat_rd_pull == "Radio"
		replace treat = 0 if treat_rd_pull == "Flashlight"
	keep if treat != .
	
	gen rd_block = id_village_uid

	*drop treat
	lab def treat 0 "control" 1 "treat", replace 
	
	rename rd_treat_* treat_*
	
	gen b_resp_muslim = (resp_religion == 3)

	gen b_resp_numhh = b_resp_hh_nbr
		replace b_resp_numhh = cm1_resp_hh_size if b_resp_numhh == .
	gen b_resp_lang_swahili =  cm1_resp_swahili
		replace b_resp_lang_swahili = (b_resp_language == 1) if b_resp_lang_swahili == .
	gen b_radio_any = b_radio_any_3mon
		replace b_radio_any = cm1_media_radio_ever if b_radio_any == .
	gen b_asset_cell = b_s16q5 	
		replace b_asset_cell = cm1_assets_cell if b_asset_cell == .
	gen b_asset_tv = b_s16q3 
		replace b_asset_tv =  cm1_assets_tv if b_asset_tv == .
	gen b_asset_radio_num = b_s16q2
		replace b_asset_radio_num = 0 if b_s16q1 == 0
		replace b_asset_radio_num = cm1_assets_radio_num if b_asset_radio_num == .
		
/* Create indices ______________________________________________________________*/

	gen crime_local_short = crime_local/3 
	*gen crime_femtravel_short = gbv_travel_risky_long/3
	*gen crime_femboda_short = gbv_boda_risky_long/3

	egen crime_index = rowmean(crime_natl crime_local_short)
	
/* Save ________________________________________________________________________*/

	save "C:\Users\grovesd\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\01 Data/pfm_rd3_analysis.dta", replace

/*______________________________________________________________________________

								COMBINE
________________________________________________________________________________*/

	
	
/* Append ______________________________________________________________________*/

	use "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd1_analysis.dta", clear
	
	append using "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd2_analysis.dta", force
	
	append using "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd3_analysis.dta", force

	
/* Create key variables ________________________________________________________*/

	/* Encode Sample */
	encode sample, gen(sample_num)

	/* Encode Block */
	encode rd_block, gen(block_rd)
	
	/* Ptix Know */
	cap drop ptixknow_index 
	egen ptixknow_index = rowmean(ptixknow_natl_vp ptixknow_natl_ports ptixknow_natl_justice ptixknow_natl_pm ptixknow_em_aware ptixknow_fopo_ruto ptixknow_fopo_kenyatta ptixknow_fopo_trump ptixknow_fopo_biden)
	
	/* IPV */
	egen ipv_reject_index = rowmean(ipv_rej_disobey_long ipv_reject_long_gossip)
	
	/* Prejudice */
	
	
/* Filling Missing Baseline Values _____________________________________________*/

	#d ;
	/* Lasso Covariates 
	resp_age 
	*/
	global cov_lasso	resp_female resp_muslim b_resp_standard7 	 
						b_resp_religiosity b_resp_lang_swahili 
						b_resp_numhh 
						b_radio_any
						b_asset_cell b_asset_tv b_asset_radio_num				
						;
						
		#d cr
		
		foreach var of global cov_lasso {
			bys id_village_uid : egen vill_`var' = mean(`var')
			replace `var' = vill_`var' if `var' == . | `var' == .d | `var' == .r
		}

/* Save ________________________________________________________________________*/

	gen all = "all"
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis.dta", replace


