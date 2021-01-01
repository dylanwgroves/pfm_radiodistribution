/*______________________________________________________________________________

	Project: Pangani FM
	File: Radio Distribution CONSORT Data
	Date: 8/22/2019
	Author: Dylan Groves, dgroves@poverty-action.org
	Overview: This merges and appends are relevant datasets
_______________________________________________________________________________*/


/* NOTES _______________________________________________________________________*/

/* 

(1) Always code so that more liberal / equal / progressive to be a higher number

*/


/* Introduction ________________________________________________________________*/

	clear all
	

/* Run Globals (if necessary ____________________________________________________*/

	*do "X:\Documents\pfm_.master\00_setup\pfm_paths_master.do"

	
/* Import Data _________________________________________________________________*/

use "${data}/03_final_data/pfm_all.dta", replace


/* Tab Consort Data _____________________________________________________________*/

	** Eligibility: All respondents in NE (only treatment) and AS samples
	keep if treat_ne == 1 |sample_as == 1

	** Ultimate size
	tab treat_rd
		
		* Excluded if own radio
		tab radio_own
		
		* Exclude if would not listen to radio if owned one
		tab radio_wouldaccept
		
		* Exclude if did not consent
		tab svy_consent
		
		/* Ramainder were excluded for other reasons, (ie odd number of non-radio
		owners, so no matched pair) 
		br if treat_rd == . & radio_own == 0 & svy_consent == 1 & radio_wouldaccept == 1
		order treat_rd radio_own svy_consent radio_wouldaccept
		*/
		
		* Allocated to treatment 
		tab treat_rd rd_comply_received, m

		br if (treat_rd == 1 & rd_comply_received == 0) | (treat_rd == 0 & rd_comply_received == 1) | (treat_rd == 1 & rd_comply_received == .)
		order sample_ne ne_resp_id treat_rd rd_comply_received
		
		stop
		br if (treat_rd == 1 & rd_comply_received == 0) | (treat_rd == 0 & rd_comply_received == 1)