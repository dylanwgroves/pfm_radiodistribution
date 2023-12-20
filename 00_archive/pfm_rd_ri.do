
/* Basics ______________________________________________________________________

	Project: Pfm4_audio_screening
	Purpose:Radio Randomization 
	Author: Martin Zuakulu, mzuakulu@poverty-action.org
	Date: 2022/05/5
________________________________________________________________________________*/


/* Load data ___________________________________________________________________*/

	use "${preloads}/radio.dta", clear

/* Generate ____________________________________________________________________*/

	drop rand_resp
	
forval i = 1/5000 {
	
	set seed `i'
	
	* Decide which villages get extras if there are a tie
	bys id_village_uid: gen rand_vill = runiform()
	bysort id_village_uid: replace rand_vill = rand_vill[1]				
	gen vill_extra = (rand_vill > 0.5)

	* Individual level randomization 

	* Generate Random Numbers 
	sort resp_id
	gen rand_resp = runiform()														

	* Assign Treatment using within-pair randomization 
	bysort id_village_uid: egen rand_resp_median = median(rand_resp)
	*bys id_village_uid: egen radio_rank = rank(rand_resp)

	gen treat_`i' = .
	replace treat_`i'=1 if rand_resp <= rand_resp_median & vill_extra == 1
	replace treat_`i'=1 if rand_resp < rand_resp_median & vill_extra == 0
	replace treat_`i'=0 if treat_`i'==.
	
	drop rand_vill vill_extra rand_resp rand_resp_median
	
}

	rename resp_id id_resp_uid 
	
* Save _________________________________________________________________________*/

	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd2_ri.dta", replace
stop