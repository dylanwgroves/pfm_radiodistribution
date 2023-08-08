
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
	




/* Subset Data _________________________________________________________________*/	
	
	
	/* Get correct sample */
	drop treat
	rename treat_rd treat
	keep if treat != .
	
	
/* Generate variables __________________________________________________________*/

	gen sample = "as2"
	
	gen sample_num = 3
	
	gen block_rd = id_village_uid
	
/* Create indices ______________________________________________________________*/

	gen crime_local_short = crime_local/3 
	gen crime_femtravel_short = gbv_travel_risky_long/3
	gen crime_femboda_short = gbv_boda_risky_long/3

	egen crime_index = rowmean(crime_natl crime_local_short crime_femtravel_short crime_femboda_short)
		
/* Save ________________________________________________________________________*/

	save "${data_rd}/pfm_rd2_analysis.dta", replace
	
	
/* Uptake ______________________________________________________________________*/


/* Rename variables
	foreach var of varlist radio_stations_* {
		tab `var' if treat == 1
	}
	
stop
	

/* Generate any necessary variables ____________________________________________*/

	/* Endline and Attrition */
	replace endline = endline_as if sample == "as"
		replace endline = endline_ne if sample == "ne"
		replace endline = 0 if endline == .
		keep if endline == 1													// Assuming we only want folks we found at endline?

	/* Encode Sample */
	encode sample, gen(sample_num)
	
	/* Encode Block */
	encode rd_block, gen(block_rd)
	
		/* Set as treatment to missing */
	gen treatment_group = treat_as
		replace treatment_group = 2 if treatment_group == .
			
	/* RI Treatment Variables */
	drop treat_*
	rename rd_treat_* treat_*
	
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
	
/* Create baseline variables  __________________________________________________

	radios were distributed after midline of the AS survey, so can use that as
	the baseline
*/

	replace b_ge_school = m_s5q4_gh_school if sample == "as"
	replace b_em_reject_story = (1 - m_s4q1_fm_yesself) if sample == "as"
	replace b_ipv_rej_disobey = m_s8q3a_ipv_disobey  if sample == "as"
	replace b_ipv_norm_rej = (1-m_s11q1_ipv_hitnorm)  if sample == "as"
	replace b_values_elders = b_values_trustelders  if sample == "as"

	
/* Filling Missing Baseline Values _____________________________________________*/

		#d ;
		/* Lasso Covariates */
		global cov_lasso	resp_age resp_female resp_muslim b_resp_standard7 b_resp_married 
							b_resp_religiosity b_resp_literate b_resp_lang_swahili 
							b_resp_yrsvill 
							b_resp_numhh b_resp_numkid b_resp_numolder b_resp_numyounger b_resp_numadult 
							b_ge_index b_ge_raisekids b_ge_earning b_ge_leadership b_ge_noprefboy 
							b_fm_reject 
							b_ipv_rej_disobey b_ipv_norm_rej
							b_radio_any
							b_values_likechange b_values_techgood 
							b_values_elders b_values_respectauthority
							b_asset_cell b_asset_tv b_asset_radio_num
							
							;
							
			#d cr
			
			foreach var of global cov_lasso {
				bys id_village_uid : egen vill_`var' = mean(`var')
				replace `var' = vill_`var' if `var' == . | `var' == .d | `var' == .r
			}
			

	
