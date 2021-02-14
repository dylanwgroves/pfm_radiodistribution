
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
	

/* Load Data ___________________________________________________________________*/	

	use "${data}/03_final_data/pfm_appended_noprefix.dta", clear
	

/* Subset Data _________________________________________________________________*/	
	
	
	/* Get correct sample */
	rename rd_treat treat
	keep if treat != .
	

/* Generate any necessary variables ____________________________________________*/

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
	
/* Outcomes ____________________________________________________________________*/

	/* Responsibility for Dev */
	gen ptixpref_respnat = (ptixpref_responsibility == 4)
		replace ptixpref_respnat = . if ptixpref_responsibility == .
		
		gen p_ptixpref_respnat = (p_ptixpref_responsibility == 4)
		replace p_ptixpref_respnat = . if p_ptixpref_responsibility == .
		
	gen ptixpref_resploc = (ptixpref_responsibility == 2)
		replace ptixpref_respnat = . if ptixpref_responsibility == .
		
		gen p_ptixpref_resploc = (p_ptixpref_responsibility == 2)
		replace p_ptixpref_resploc = . if p_ptixpref_responsibility == .
		
	gen ptixpref_respcom = (ptixpref_responsibility == 1)
		replace ptixpref_respcom = . if ptixpref_responsibility == .
		
		gen p_ptixpref_respcom = (p_ptixpref_responsibility == 1)
		replace p_ptixpref_respcom = . if p_ptixpref_responsibility == .
		
		
	/* Prejudice */
	rename prej_yesneighbor_*	prej_yesnbr_*
		
		rename p_prej_yesneighbor_*	p_prej_yesnbr_*
	
/* Filling Missing Baseline Values _____________________________________________*/

		#d ;
		/* Lasso Covariates */
		global cov_lasso	resp_female 
							resp_muslim 
							b_resp_religiosity
							b_values_likechange 
							b_values_techgood 
							b_values_respectauthority 
							b_fm_reject
							b_ge_raisekids 
							b_ge_earning 
							b_ge_leadership 
							b_ge_noprefboy 
							b_radio_any 
							b_resp_lang_swahili 
							b_resp_literate 
							b_resp_standard7 
							b_resp_married 
							b_resp_hhh 
							b_resp_numkid
							;
							
			#d cr
			
			foreach var of global cov_lasso {
				bys id_village_uid : egen vill_`var' = mean(`var')
				replace `var' = vill_`var' if `var' == .
			}
	

/* Save ________________________________________________________________________*/

	save "${data_rd}/pfm_rd_analysis.dta", replace
	
