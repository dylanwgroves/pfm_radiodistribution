
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

	/* Trust */
	gen ptixknow_trustnat = (ptixknow_sourcetrust == 2)
		replace ptixknow_trustnat = . if ptixknow_sourcetrust == .
	
		gen p_ptixknow_trustnat = (p_ptixknow_sourcetrust == 2)
		replace p_ptixknow_trustnat = . if p_ptixknow_sourcetrust == .
	
	gen ptixknow_trustloc = (ptixknow_sourcetrust == 1)
		replace ptixknow_trustloc = . if ptixknow_sourcetrust == .
		
		gen p_ptixknow_trustloc = (p_ptixknow_sourcetrust == 1)
		replace p_ptixknow_trustloc = . if p_ptixknow_sourcetrust == .
	
	/* Responsibility for Dev */
	gen ptixpref_respnat = (ptixpref_responsibility == 4)
		replace ptixpref_respnat = . if ptixpref_responsibility == .
		
		gen p_ptixpref_respnat = (p_ptixpref_responsibility == 4)
		replace p_ptixpref_respnat = . if p_ptixpref_responsibility == .
		
	/* Prejudice */
	rename prej_yesneighbor_*	prej_yesnbr_*
		
		rename p_prej_yesneighbor_*	p_prej_yesnbr_*
	
/* Save ________________________________________________________________________*/

	save "${data_rd}/pfm_rd_analysis_balance.dta", replace
	
