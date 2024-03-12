
/* Basics ______________________________________________________________________

	Project: Pfm4_audio_screening
	Purpose:Radio Randomization 
	Author: Martin Zuakulu, mzuakulu@poverty-action.org
	Date: 2022/05/5
________________________________________________________________________________*/
// The first randomization is for 18 villages: 

 use "C:\Users\grovesd\Dropbox\Wellspring Tanzania Papers\wellspring_01_master\01_data\01_raw_data/pfm5_pangani_clean.dta", clear 

drop if radio_treat == . 
	
	* Set seed
	isid resp_id, sort
	
forval i = 1/5000 {
	
	set seed 1956		

	* Decide which villages get extras if there are a tie --------------------------
	bys id_village_uid: gen rand_vill = runiform()
	bysort id_village_uid: replace rand_vill = rand_vill[1]				
	gen vill_extra = (rand_vill > 0.5)

	* Individual level randomization -----------------------------------------------

	* Generate Random Numbers ------------------------------------------------------
	sort resp_id
	gen rand_resp = runiform()														

	* Assign Treatment using within-pair randomization -----------------------------
	bysort id_village_uid: egen rand_resp_median = median(rand_resp)
	*bys id_village_uid: egen radio_rank = rank(rand_resp)

	gen treat_`i' = .
	replace treat_`i' =1 if rand_resp <= rand_resp_median & vill_extra == 1
	replace treat_`i'=1 if rand_resp < rand_resp_median & vill_extra == 0
	replace treat_`i'=0 if radio_treat==.

}

	 
	keep id_village_uid resp_id resp_name treat_* 
	
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rduzikwasa_ri.dta"