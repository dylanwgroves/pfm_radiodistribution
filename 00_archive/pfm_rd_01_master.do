
/* Overview ______________________________________________________________________

Project: Wellspring Tanzania, Natural Experiment
Purpose: Analysis Prelimenary Work
Author: dylan groves, dylanwgroves@gmail.com
Date: 2020/12/23l


	This mostly just subsets the data and does anything else necessary before
	running the analysis	
________________________________________________________________________________*/



/* _____________________________________________________________________________

Project: Wellspring Tanzania, WPP Experiment
Author: Dylan Groves, dylanwgroves@gmail.com
		Beatrice Montano, bm2955@columbia.edu
Date: 2020/04/02
________________________________________________________________________________*/
	
	
/* Introduction ________________________________________________________________*/
	
	clear all	
	clear matrix
	clear mata
	set more off
	global c_date = c(current_date)
	set maxvar 30000
	
	set seed 1956
		
		
/* Set Globals _________________________________________________________*/

	foreach user in  	"X:/" ///
						"/Users/BeatriceMontano" ///
						"/Users/Bardia" {
					capture cd "`user'"
					if _rc == 0 macro def path `user'
				}
	local dir `c(pwd)'
	global user `dir'
	display "${user}"


	foreach user in  	"X:/" ///
						"/Volumes/Secomba/BeatriceMontano/Boxcryptor" ///
						"/Volumes/Secomba/Bardia/Boxcryptor" {
							
					capture cd "`user'"
					if _rc == 0 macro def path `user'
				}
	local dir `c(pwd)'
	global userboxcryptor `dir'
	display "${userboxcryptor}"	
	
	do "${user}/Documents/pfm_.master/00_setup/pfm_paths_master.do"
	do "${user}/Documents/pfm_radiodistribution/02_indices/pfm_rd_indices_main.do"
	
	
	
**# Bookmark #1
/* Audio Screening 1 (as1_main) _____________________________________________________*/
	
	/* load data */
	use "${data}/03_final_data/pfm_appended_noprefix.dta", clear
	
	/* covariates 	*/
	global ids			id_resp_uid id_village_uid 
	
	global treat_vars 	t_rd id_resp_uid id_village_uid
	
	global uptake		rd_receive rd_stillhave rd_radio_2wks rd_radio_3months rd_radio_hrs
	
	global covars		b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
						b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
						b_resp_visittown b_resp_samevill16 ///
						b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa ///
						b_resp_tribe_nyakyusa b_resp_tribe_chagga b_resp_tribe_haya b_resp_tribe_ngoni 	///
						b_resp_tribe_kwere 	b_resp_tribe_pare b_resp_tribe_hehe	b_resp_tribe_makonde ///
						b_resp_tribe_nyamwezi b_resp_tribe_sukuma b_resp_tribe_masai b_resp_tribe_kurya ///
						b_resp_tribe_gogo b_resp_tribe_luguru b_resp_tribe_fipa b_resp_tribe_manyema ///
						b_resp_tribe_nyiramba b_resp_tribe_nyaturu b_resp_tribe_bena b_resp_tribe_ha ///
						b_resp_tribe_hangaza b_resp_tribe_iraqi b_resp_tribe_jaluo b_resp_tribe_jita ///
						b_resp_tribe_kinga b_resp_tribe_matengo	b_resp_tribe_mwera b_resp_tribe_ndali ///
						b_resp_tribe_ndendeule b_resp_tribe_nyambo b_resp_tribe_pogoro b_resp_tribe_sambaa	///
						b_resp_tribe_yao b_resp_tribe_zaramo b_resp_tribe_zigua	b_resp_tribe_zinza	b_resp_tribe_rangi	///
						b_resp_tribe_digo b_resp_tribe_bondei ///
						b_radio_2wks b_radio_3months b_media_news ///
						b_asset_radio b_asset_tv b_asset_cell ///
						b_ipv_reject b_fm_reject b_ge_earning
						

	/* basic cleaning */
	
		* keep sample
		keep if sample == "as"
		
		* treatment variables
		gen t_rd = .
			replace t_rd = 1 if treat_rd  == "Received radio"
			replace t_rd = 0 if treat_rd  == "No radio"
			lab var t_rd "Radio Distribution Treatment"

		* drop if missing 
		drop if missing(t_rd)
		
		* drop parent, friend, kid
		drop p_* f_* k_* kidssample_* treat_*

	/* clean key variables */
	
		* basics 	b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
		*			b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
		*			b_resp_visittown b_resp_samevill16
			* female 
			tab b_resp_female, m
				lab var b_resp_female "(Dummy) Respondent female?"
				lab def b_resp_female 0 "Male" 1 "Female", replace
				lab val b_resp_female b_resp_female
				
			* age 
			tab b_resp_age, m
				lab var b_resp_age "How old are you?"
				
			* muslim 
			tab b_resp_muslim, m
				lab var b_resp_muslim "(Dummy) Respondent muslim?"
				lab def b_resp_muslim 0 "Christian" 1 "Muslim", replace
				lab val b_resp_muslim b_resp_muslim
				
			* religious school 
			clonevar b_resp_religiousschool = resp_religiousschool
				replace b_resp_religiousschool = 0 if missing(b_resp_religiousschool)
				lab var b_resp_religiousschool "Did you attend religious school as a child?"
				lab val b_resp_religiousschool yesno
				
			* religiosity 
			tab b_resp_religiosity, m
				lab var b_resp_religiosity "How many times per week do you attend religious services?"
				
			* household size
			tab b_resp_numhh, m
				lab var b_resp_numhh "How many people are there in your household?"
				
			* kids ever?
			tab b_resp_kidsever, m
				lab var b_resp_kidsever "How many children have you ever had?"
			
			* household 
			tab b_resp_hhh, m
				
			* married?
			tab b_resp_married, m
			
			* education 
			tab b_resp_education, m
				replace b_resp_education = 16 if b_resp_education > 16
				lab var b_resp_education "What is your 	highest completed grade in school?"
			
			* visit town 
			clonevar b_resp_visittown = b_resp_visit_town 
			tab b_resp_visittown, m
				lab var b_resp_visittown "How often do you visit town?"
				
			* lived in village at 16
			clonevar b_resp_samevill16 = b_resp_samevillage 
			tab b_resp_samevill16, m
				lab var b_resp_samevill16 "Did you live in this village at 16 years old?"
		
		* language: b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa
		gen b_resp_language_swahili = (b_resp_lang_main == 1)
			lab var b_resp_language_swahili "Primary language Swahili?"
			
		gen b_resp_language_zigua = (b_resp_lang_main == 2)
			lab var b_resp_language_zigua "Primary language Zigua?"	
			
		gen b_resp_language_digo = (b_resp_lang_main == 5)
			lab var b_resp_language_digo "Primary language Digo?"		

		gen b_resp_language_sambaa = (b_resp_lang_main == 6)
			lab var b_resp_language_sambaa "Primary language Sambaa?"
			
		* tribe 
		forval i = 1/39 {	
			gen resp_tribe_`i' = (resp_tribe == `i')
		}			
		clonevar b_resp_tribe_nyakyusa 	= resp_tribe_1
		clonevar b_resp_tribe_chagga 	= resp_tribe_2
		clonevar b_resp_tribe_haya 		= resp_tribe_3
		clonevar b_resp_tribe_ngoni 	= resp_tribe_4
		clonevar b_resp_tribe_kwere 	= resp_tribe_5
		clonevar b_resp_tribe_pare		= resp_tribe_6
		clonevar b_resp_tribe_hehe		= resp_tribe_7
		clonevar b_resp_tribe_makonde	= resp_tribe_8
		clonevar b_resp_tribe_nyamwezi	= resp_tribe_9
		clonevar b_resp_tribe_sukuma	= resp_tribe_10
		clonevar b_resp_tribe_masai		= resp_tribe_11
		clonevar b_resp_tribe_kurya		= resp_tribe_12
		clonevar b_resp_tribe_gogo		= resp_tribe_13
		clonevar b_resp_tribe_luguru	= resp_tribe_14
		clonevar b_resp_tribe_fipa		= resp_tribe_15
		clonevar b_resp_tribe_manyema	= resp_tribe_16
		clonevar b_resp_tribe_nyiramba	= resp_tribe_17
		clonevar b_resp_tribe_nyaturu	= resp_tribe_18
		clonevar b_resp_tribe_bena		= resp_tribe_19
		clonevar b_resp_tribe_ha		= resp_tribe_20
		clonevar b_resp_tribe_hangaza	= resp_tribe_21
		clonevar b_resp_tribe_iraqi		= resp_tribe_22
		clonevar b_resp_tribe_jaluo		= resp_tribe_23
		clonevar b_resp_tribe_jita		= resp_tribe_24
		clonevar b_resp_tribe_kinga		= resp_tribe_25
		clonevar b_resp_tribe_matengo	= resp_tribe_26
		clonevar b_resp_tribe_mwera		= resp_tribe_27
		clonevar b_resp_tribe_ndali		= resp_tribe_28
		clonevar b_resp_tribe_ndendeule	= resp_tribe_29
		clonevar b_resp_tribe_nyambo	= resp_tribe_30
		clonevar b_resp_tribe_pogoro	= resp_tribe_31
		clonevar b_resp_tribe_sambaa	= resp_tribe_32
		clonevar b_resp_tribe_yao		= resp_tribe_33
		clonevar b_resp_tribe_zaramo	= resp_tribe_34
		clonevar b_resp_tribe_zigua		= resp_tribe_35
		clonevar b_resp_tribe_zinza		= resp_tribe_36
		clonevar b_resp_tribe_rangi		= resp_tribe_37
		clonevar b_resp_tribe_digo		= resp_tribe_38
		clonevar b_resp_tribe_bondei	= resp_tribe_39

		* media consumption b_radio_2wks b_radio_3months b_media_news
		clonevar b_radio_2wks = b_radio_listen
		tab b_radio_2wks, m 
			lab var b_radio_2wks "How often listen to radio in last 2 weeks?"
		clonevar b_radio_3months = b_radio_any 
		
		tab b_radio_3months, m
			lab var b_radio_3months "Ever listen to radio in last 3 months?"
		
		tab b_media_news, m
			lab var b_media_news "How often do you read or listen to the news?"
		
		* assets: b_asset_radio b_asset_tv b_asset_cell
		tab b_asset_radio, m 
			lab var b_asset_radio "Do you own a radio?"
		
		tab b_asset_tv, m 
			lab var b_asset_tv "Do you own a TV?"
			
		tab b_asset_cell, m 
			lab var b_asset_cell "Do you own a cell phone?"

		* gender equality:  b_ipv_reject b_fm_reject b_ge_earning
		clonevar b_ipv_reject = ipv_rej_disobey
			lab var b_ipv_reject "Reject IPV"
			
		tab b_fm_reject, m
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
			lab var b_ge_earning "Ok if women earn equally to men"
			
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = radio_listen 
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
			
	* here
	keep 	${treat_vars} ${uptake} ${covars}
	gen all = "yes"
	gen covars = "yes"
	gen as1 = "yes"
	gen as1_main = "yes"
	gen sample = "as1"
	
	* save
	tempfile temp_as1
	save `temp_as1', replace



	
**# Bookmark #2
/* Natural Experiment  _________________________________________________________*/

	/* load data */
	use "${data}/03_final_data/pfm_appended_noprefix.dta", clear
	
	/* covariates 	*/
	global treat_vars 	t_rd id_resp_uid id_village_uid
	
	global uptake		rd_receive rd_stillhave rd_radio_2wks rd_radio_3months rd_radio_hrs

	
	global covars		b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
						b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
						b_resp_visittown b_resp_samevill16 ///
						b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa ///
						b_resp_tribe_nyakyusa b_resp_tribe_chagga b_resp_tribe_haya b_resp_tribe_ngoni 	///
						b_resp_tribe_kwere 	b_resp_tribe_pare b_resp_tribe_hehe	b_resp_tribe_makonde ///
						b_resp_tribe_nyamwezi b_resp_tribe_sukuma b_resp_tribe_masai b_resp_tribe_kurya ///
						b_resp_tribe_gogo b_resp_tribe_luguru b_resp_tribe_fipa b_resp_tribe_manyema ///
						b_resp_tribe_nyiramba b_resp_tribe_nyaturu b_resp_tribe_bena b_resp_tribe_ha ///
						b_resp_tribe_hangaza b_resp_tribe_iraqi b_resp_tribe_jaluo b_resp_tribe_jita ///
						b_resp_tribe_kinga b_resp_tribe_matengo	b_resp_tribe_mwera b_resp_tribe_ndali ///
						b_resp_tribe_ndendeule b_resp_tribe_nyambo b_resp_tribe_pogoro b_resp_tribe_sambaa	///
						b_resp_tribe_yao b_resp_tribe_zaramo b_resp_tribe_zigua	b_resp_tribe_zinza	b_resp_tribe_rangi	///
						b_resp_tribe_digo b_resp_tribe_bondei ///
						b_radio_2wks b_radio_3months b_media_news ///
						b_asset_radio b_asset_tv b_asset_cell ///
						b_ipv_reject b_fm_reject b_ge_earning
						

	/* basic cleaning */
	
		* keep sample
		keep if sample == "ne"
		
		* treatment variables
		gen t_rd = .
			replace t_rd = 1 if treat_rd  == "Received radio"
			replace t_rd = 0 if treat_rd  == "No radio"
			lab var t_rd "Radio Distribution Treatment"
		
		* drop if missing 
		drop if missing(t_rd)
		
		* drop parent, friend, kid
		drop p_* f_* k_* kidssample_* treat_*
		
	/* clean key variables */
	
		* basics 	b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
		*			b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
		*			b_resp_visittown b_resp_samevill16
			* female 
			tab b_resp_female, m
				replace b_resp_female = resp_female if b_resp_female == .
				lab var b_resp_female "(Dummy) Respondent female?"
				lab def b_resp_female 0 "Male" 1 "Female", replace
				lab val b_resp_female b_resp_female
				
			* age 
			tab b_resp_age, m
				replace b_resp_age = resp_age if b_resp_age == .
				lab var b_resp_age "How old are you?"
				
			* muslim 
			tab b_resp_muslim, m
				replace b_resp_muslim = resp_muslim if b_resp_muslim == .
				lab var b_resp_muslim "(Dummy) Respondent muslim?"
				lab def b_resp_muslim 0 "Christian" 1 "Muslim", replace
				lab val b_resp_muslim b_resp_muslim
				
			* religious school 
			clonevar b_resp_religiousschool = resp_religiousschool
			tab b_resp_religiousschool, m
				replace b_resp_religiousschool = 0 if missing(b_resp_religiousschool)
				lab var b_resp_religiousschool "Did you attend religious school as a child?"
				lab val b_resp_religiousschool yesno
				
			* religiosity 
			tab b_resp_religiosity, m
				replace b_resp_religiosity = resp_religiosity if b_resp_religiosity == .
				lab var b_resp_religiosity "How many times per week do you attend religious services?"
				
			* household size
			drop b_resp_numhh
			clonevar b_resp_numhh = resp_hh_size
			tab b_resp_numhh 
				lab var b_resp_numhh "How many people are there in your household?"
				
			* kids ever?
			tab b_resp_kidsever, m
				replace b_resp_kidsever = resp_kids if b_resp_kidsever == .
				lab var b_resp_kidsever "How many children have you ever had?"
			
			* household 
			tab b_resp_hhh, m
				replace b_resp_hhh = 1 if s3q2 == 1 & b_resp_hhh == .
				replace b_resp_hhh = 0 if s3q2 > 1 & !missing(s3q2) & b_resp_hhh == .
				
				
			* married?
			tab b_resp_married, m
				replace b_resp_married = 1 if resp_rltn_status == 1 & resp_rltn_status == 2 & resp_rltn_status == 3 
			
			* education 
			tab b_resp_education, m
				replace b_resp_education = s3q16_school_grade if missing(b_resp_education)
				replace b_resp_education = 16 if b_resp_education > 16
				lab var b_resp_education "What is your 	highest completed grade in school?"
			
			* visit town 
			clonevar b_resp_visittown = resp_urbanvisit
			tab b_resp_visittown, m
				lab var b_resp_visittown "How often do you visit town?"
				
			* lived in village at 16
			clonevar b_resp_samevill16 = resp_livevill16 
			tab b_resp_samevill16, m
				lab var b_resp_samevill16 "Did you live in this village at 16 years old?"
		
		* language: b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa
		gen b_resp_language_swahili = (b_resp_lang_main == 1)
			lab var b_resp_language_swahili "Primary language Swahili?"
			
		gen b_resp_language_zigua = (b_resp_lang_main == 2)
			lab var b_resp_language_zigua "Primary language Zigua?"	
			
		gen b_resp_language_digo = (b_resp_lang_main == 5)
			lab var b_resp_language_digo "Primary language Digo?"		

		gen b_resp_language_sambaa = (b_resp_lang_main == 6)
			lab var b_resp_language_sambaa "Primary language Sambaa?"
			
		* tribe 
		forval i = 1/39 {	
			gen resp_tribe_`i' = (resp_tribe == `i')
		}			
		clonevar b_resp_tribe_nyakyusa 	= resp_tribe_1
		clonevar b_resp_tribe_chagga 	= resp_tribe_2
		clonevar b_resp_tribe_haya 		= resp_tribe_3
		clonevar b_resp_tribe_ngoni 	= resp_tribe_4
		clonevar b_resp_tribe_kwere 	= resp_tribe_5
		clonevar b_resp_tribe_pare		= resp_tribe_6
		clonevar b_resp_tribe_hehe		= resp_tribe_7
		clonevar b_resp_tribe_makonde	= resp_tribe_8
		clonevar b_resp_tribe_nyamwezi	= resp_tribe_9
		clonevar b_resp_tribe_sukuma	= resp_tribe_10
		clonevar b_resp_tribe_masai		= resp_tribe_11
		clonevar b_resp_tribe_kurya		= resp_tribe_12
		clonevar b_resp_tribe_gogo		= resp_tribe_13
		clonevar b_resp_tribe_luguru	= resp_tribe_14
		clonevar b_resp_tribe_fipa		= resp_tribe_15
		clonevar b_resp_tribe_manyema	= resp_tribe_16
		clonevar b_resp_tribe_nyiramba	= resp_tribe_17
		clonevar b_resp_tribe_nyaturu	= resp_tribe_18
		clonevar b_resp_tribe_bena		= resp_tribe_19
		clonevar b_resp_tribe_ha		= resp_tribe_20
		clonevar b_resp_tribe_hangaza	= resp_tribe_21
		clonevar b_resp_tribe_iraqi		= resp_tribe_22
		clonevar b_resp_tribe_jaluo		= resp_tribe_23
		clonevar b_resp_tribe_jita		= resp_tribe_24
		clonevar b_resp_tribe_kinga		= resp_tribe_25
		clonevar b_resp_tribe_matengo	= resp_tribe_26
		clonevar b_resp_tribe_mwera		= resp_tribe_27
		clonevar b_resp_tribe_ndali		= resp_tribe_28
		clonevar b_resp_tribe_ndendeule	= resp_tribe_29
		clonevar b_resp_tribe_nyambo	= resp_tribe_30
		clonevar b_resp_tribe_pogoro	= resp_tribe_31
		clonevar b_resp_tribe_sambaa	= resp_tribe_32
		clonevar b_resp_tribe_yao		= resp_tribe_33
		clonevar b_resp_tribe_zaramo	= resp_tribe_34
		clonevar b_resp_tribe_zigua		= resp_tribe_35
		clonevar b_resp_tribe_zinza		= resp_tribe_36
		clonevar b_resp_tribe_rangi		= resp_tribe_37
		clonevar b_resp_tribe_digo		= resp_tribe_38
		clonevar b_resp_tribe_bondei	= resp_tribe_39

		* media consumption b_radio_2wks b_radio_3months b_media_news
		clonevar b_radio_2wks = b_radio_listen
		tab b_radio_2wks, m 
			replace b_radio_2wks = radio_listen if missing(b_radio_2wks)
			lab var b_radio_2wks "How often listen to radio in last 2 weeks?"
		
		clonevar b_radio_3months = b_radio_any
		tab b_radio_3months, m
			replace b_radio_3months = radio_ever if missing(b_radio_3months)		
			lab var b_radio_3months "Ever listen to radio in last 3 months?"
		
		tab b_media_news, m
			replace b_media_news = radio_news if missing(b_media_news)
			lab var b_media_news "How often do you read or listen to the news?"
		
		* assets: b_asset_radio b_asset_tv b_asset_cell
		tab b_asset_radio, m 
			replace b_asset_radio = 1 if missing(b_asset_radio)
			lab var b_asset_radio "Do you own a radio?"
		
		tab b_asset_tv, m 
			replace b_asset_tv = asset_tv if missing(b_asset_tv)
			lab var b_asset_tv "Do you own a TV?"
			
		tab b_asset_cell, m 
			replace b_asset_cell = asset_cell if missing(b_asset_cell)
			lab var b_asset_cell "Do you own a cell phone?"

		* gender equality:  b_ipv_reject b_fm_reject b_ge_earning
		clonevar b_ipv_reject = ipv_rej_disobey
		tab b_ipv_reject, m
			lab var b_ipv_reject "Reject IPV"
			
		tab b_fm_reject, m
		replace b_fm_reject = fm_reject if missing(b_fm_reject)
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
		replace b_ge_earning = ge_earning if missing(b_ge_earning)
			lab var b_ge_earning "Ok if women earn equally to men"
			
			
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = radio_listen 
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
			
	* set 
	keep 	${treat_vars} ${uptake} ${covars}
	gen all = "yes"
	gen ne = "yes"
	gen covars = "yes"
	gen sample = "ne"
	
	* save
	tempfile temp_ne 
	save `temp_ne', replace

	
	
**# Bookmark #5
/* Audio Screening 2 ___________________________________________________________*/

	/* load data */
	use  "${data}/03_final_data/pfm_as2_merged.dta", clear
	rename as2_* *

	
	/* covariates 	*/
	global treat_vars 	t_rd id_resp_uid id_village_uid
	
	global uptake		rd_receive rd_stillhave rd_radio_2wks rd_radio_3months rd_radio_hrs
	
	global covars		b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
						b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
						b_resp_visittown b_resp_samevill16 ///
						b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa ///
						b_resp_tribe_nyakyusa b_resp_tribe_chagga b_resp_tribe_haya b_resp_tribe_ngoni 	///
						b_resp_tribe_kwere 	b_resp_tribe_pare b_resp_tribe_hehe	b_resp_tribe_makonde ///
						b_resp_tribe_nyamwezi b_resp_tribe_sukuma b_resp_tribe_masai b_resp_tribe_kurya ///
						b_resp_tribe_gogo b_resp_tribe_luguru b_resp_tribe_fipa b_resp_tribe_manyema ///
						b_resp_tribe_nyiramba b_resp_tribe_nyaturu b_resp_tribe_bena b_resp_tribe_ha ///
						b_resp_tribe_hangaza b_resp_tribe_iraqi b_resp_tribe_jaluo b_resp_tribe_jita ///
						b_resp_tribe_kinga b_resp_tribe_matengo	b_resp_tribe_mwera b_resp_tribe_ndali ///
						b_resp_tribe_ndendeule b_resp_tribe_nyambo b_resp_tribe_pogoro b_resp_tribe_sambaa	///
						b_resp_tribe_yao b_resp_tribe_zaramo b_resp_tribe_zigua	b_resp_tribe_zinza	b_resp_tribe_rangi	///
						b_resp_tribe_digo b_resp_tribe_bondei ///
						b_radio_2wks b_radio_3months b_media_news ///
						b_asset_radio b_asset_tv b_asset_cell ///
						b_ipv_reject b_fm_reject b_ge_earning
						

	/* basic cleaning */
		
		* treatment variables
		gen t_rd = .
			replace t_rd = 1 if e_radio_treat_txt == "Radio"
			replace t_rd = 0 if e_radio_treat_txt == "Flashlight"
			lab var t_rd "Radio Distribution Treatment"
		
		* drop if missing 
		drop if missing(t_rd)
		
	/* clean key variables */
	
		* basics 	b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
		*			b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
		*			b_resp_visittown b_resp_samevill16
			* female 
			tab b_resp_female, m
				lab var b_resp_female "(Dummy) Respondent female?"
				lab def b_resp_female 0 "Male" 1 "Female", replace
				lab val b_resp_female b_resp_female
				
			* age 
			tab b_resp_age, m
				lab var b_resp_age "How old are you?"
				
			* muslim 
			tab b_resp_muslim, m
				lab var b_resp_muslim "(Dummy) Respondent muslim?"
				lab def b_resp_muslim 0 "Christian" 1 "Muslim", replace
				lab val b_resp_muslim b_resp_muslim
				
			* religious school 
			tab b_resp_religiousschool, m
				replace b_resp_religiousschool = 0 if missing(b_resp_religiousschool)
				lab var b_resp_religiousschool "Did you attend religious school as a child?"
				lab val b_resp_religiousschool yesno
				
			* religiosity 
			tab b_resp_religiosity, m
				lab var b_resp_religiosity "How many times per week do you attend religious services?"
				
			* household size
			clonevar b_resp_numhh = b_resp_hh_nbr
			tab b_resp_numhh 
				lab var b_resp_numhh "How many people are there in your household?"
				
			* kids ever?
			clonevar b_resp_kidsever = b_resp_kidsborn
			tab b_resp_kidsever, m
				lab var b_resp_kidsever "How many children have you ever had?"
			
			* household 
			tab b_resp_hhh, m				
				
			* married?
			gen b_resp_married = (b_resp_rltn_statu == 1 | b_resp_rltn_statu == 2 | b_resp_rltn_statu == 3)
			tab b_resp_married, m
			
			* education 
			clonevar b_resp_education = b_resp_edu 
			tab b_resp_education, m
				replace b_resp_education = 16 if b_resp_education > 16
				lab var b_resp_education "What is your 	highest completed grade in school?"
			
			* visit town 
			tab b_resp_visittown, m
				lab var b_resp_visittown "How often do you visit town?"
				
			* lived in village at 16
			clonevar b_resp_samevill16 = b_resp_vill16
			tab b_resp_samevill16, m
				lab var b_resp_samevill16 "Did you live in this village at 16 years old?"
		
		* language: b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa
		gen b_resp_language_swahili = (b_resp_language == 1)
			lab var b_resp_language_swahili "Primary language Swahili?"
			
		gen b_resp_language_zigua = (b_resp_language == 2)
			lab var b_resp_language_zigua "Primary language Zigua?"	
			
		gen b_resp_language_digo = (b_resp_language == 5)
			lab var b_resp_language_digo "Primary language Digo?"		

		gen b_resp_language_sambaa = (b_resp_language == 6)
			lab var b_resp_language_sambaa "Primary language Sambaa?"
			
		* tribe 
		drop b_resp_tribe_*
		forval i = 1/39 {	
			gen resp_tribe_`i' = (b_resp_tribe == `i')
		}			
		clonevar b_resp_tribe_nyakyusa 	= resp_tribe_1
		clonevar b_resp_tribe_chagga 	= resp_tribe_2
		clonevar b_resp_tribe_haya 		= resp_tribe_3
		clonevar b_resp_tribe_ngoni 	= resp_tribe_4
		clonevar b_resp_tribe_kwere 	= resp_tribe_5
		clonevar b_resp_tribe_pare		= resp_tribe_6
		clonevar b_resp_tribe_hehe		= resp_tribe_7
		clonevar b_resp_tribe_makonde	= resp_tribe_8
		clonevar b_resp_tribe_nyamwezi	= resp_tribe_9
		clonevar b_resp_tribe_sukuma	= resp_tribe_10
		clonevar b_resp_tribe_masai		= resp_tribe_11
		clonevar b_resp_tribe_kurya		= resp_tribe_12
		clonevar b_resp_tribe_gogo		= resp_tribe_13
		clonevar b_resp_tribe_luguru	= resp_tribe_14
		clonevar b_resp_tribe_fipa		= resp_tribe_15
		clonevar b_resp_tribe_manyema	= resp_tribe_16
		clonevar b_resp_tribe_nyiramba	= resp_tribe_17
		clonevar b_resp_tribe_nyaturu	= resp_tribe_18
		clonevar b_resp_tribe_bena		= resp_tribe_19
		clonevar b_resp_tribe_ha		= resp_tribe_20
		clonevar b_resp_tribe_hangaza	= resp_tribe_21
		clonevar b_resp_tribe_iraqi		= resp_tribe_22
		clonevar b_resp_tribe_jaluo		= resp_tribe_23
		clonevar b_resp_tribe_jita		= resp_tribe_24
		clonevar b_resp_tribe_kinga		= resp_tribe_25
		clonevar b_resp_tribe_matengo	= resp_tribe_26
		clonevar b_resp_tribe_mwera		= resp_tribe_27
		clonevar b_resp_tribe_ndali		= resp_tribe_28
		clonevar b_resp_tribe_ndendeule	= resp_tribe_29
		clonevar b_resp_tribe_nyambo	= resp_tribe_30
		clonevar b_resp_tribe_pogoro	= resp_tribe_31
		clonevar b_resp_tribe_sambaa	= resp_tribe_32
		clonevar b_resp_tribe_yao		= resp_tribe_33
		clonevar b_resp_tribe_zaramo	= resp_tribe_34
		clonevar b_resp_tribe_zigua		= resp_tribe_35
		clonevar b_resp_tribe_zinza		= resp_tribe_36
		clonevar b_resp_tribe_rangi		= resp_tribe_37
		clonevar b_resp_tribe_digo		= resp_tribe_38
		clonevar b_resp_tribe_bondei	= resp_tribe_39

		* media consumption b_radio_2wks b_radio_3months b_media_news
		clonevar b_radio_2wks = b_radio_2wk
		tab b_radio_2wks, m 
			lab var b_radio_2wks "How often listen to radio in last 2 weeks?"
		
		clonevar b_radio_3months = b_radio_ever
		tab b_radio_3months, m
			lab var b_radio_3months "Ever listen to radio in last 3 months?"
		
		tab b_media_news, m
			lab var b_media_news "How often do you read or listen to the news?"
		
		* assets: b_asset_radio b_asset_tv b_asset_cell
		clonevar b_asset_radio = b_assets_radios
		tab b_asset_radio, m 
			lab var b_asset_radio "Do you own a radio?"
		
		clonevar b_asset_tv = b_assets_tv
		tab b_asset_tv, m 
			lab var b_asset_tv "Do you own a TV?"
			
		clonevar b_asset_cell = b_assets_cell
		tab b_asset_cell, m 
			lab var b_asset_cell "Do you own a cell phone?"

		* gender equality:  b_ipv_reject b_fm_reject b_ge_earning
		tab b_ipv_reject, m
			lab var b_ipv_reject "Reject IPV"
			
		clonevar b_fm_reject = b_ge_fm_reject
		tab b_fm_reject, m
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
			lab var b_ge_earning "Ok if women earn equally to men"
			
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		clonevar rd_receive = e_rd_receive
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		clonevar rd_stillhave = e_rd_stillhave
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = e_radio_listen 
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = e_radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = e_radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
		
	* set
	keep 	${treat_vars} ${uptake} ${covars}
	gen all = "yes"
	gen as2 = "yes"
	gen covars = "yes"
	gen as2_e_p = "yes"
	gen sample = "as2"
	
	* save
	tempfile temp_as2 
	save `temp_as2', replace

	
	
**# Bookmark #6
/* Community Media _____________________________________________________________*/

	/* load data */
	use  "${data}/03_final_data/pfm_cm_merged.dta", clear
	rename cm1_* b_*
	drop rd_treat_*
	
	/* covariates 	*/
	global treat_vars 	t_rd id_resp_uid id_village_uid
	
	global uptake		rd_receive rd_stillhave rd_radio_2wks rd_radio_3months rd_radio_hrs
	
	global covars		b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
						b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
						b_resp_visittown b_resp_samevill16 ///
						b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa ///
						b_resp_tribe_nyakyusa b_resp_tribe_chagga b_resp_tribe_haya b_resp_tribe_ngoni 	///
						b_resp_tribe_kwere 	b_resp_tribe_pare b_resp_tribe_hehe	b_resp_tribe_makonde ///
						b_resp_tribe_nyamwezi b_resp_tribe_sukuma b_resp_tribe_masai b_resp_tribe_kurya ///
						b_resp_tribe_gogo b_resp_tribe_luguru b_resp_tribe_fipa b_resp_tribe_manyema ///
						b_resp_tribe_nyiramba b_resp_tribe_nyaturu b_resp_tribe_bena b_resp_tribe_ha ///
						b_resp_tribe_hangaza b_resp_tribe_iraqi b_resp_tribe_jaluo b_resp_tribe_jita ///
						b_resp_tribe_kinga b_resp_tribe_matengo	b_resp_tribe_mwera b_resp_tribe_ndali ///
						b_resp_tribe_ndendeule b_resp_tribe_nyambo b_resp_tribe_pogoro b_resp_tribe_sambaa	///
						b_resp_tribe_yao b_resp_tribe_zaramo b_resp_tribe_zigua	b_resp_tribe_zinza	b_resp_tribe_rangi	///
						b_resp_tribe_digo b_resp_tribe_bondei ///
						b_radio_2wks b_radio_3months b_media_news ///
						b_asset_radio b_asset_tv b_asset_cell ///
						b_ipv_reject b_fm_reject b_ge_earning
						

	/* basic cleaning */
		
		* treatment variables
		gen t_rd = .
			replace t_rd = 1 if cm3_treat_rd_pull == "Radio"
			replace t_rd = 0 if cm3_treat_rd_pull == "Flashlight"
			lab var t_rd "Radio Distribution Treatment"
		
		* drop if missing 
		drop if missing(t_rd)
		
	/* clean key variables */
	
		* basics 	b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
		*			b_resp_numhh b_resp_kidsever b_resp_hhh b_resp_married b_resp_education ///
		*			b_resp_visittown b_resp_samevill16
			* female 
			replace b_resp_female = cm2_resp_gender if missing(b_resp_female)
			tab b_resp_female, m
				lab var b_resp_female "(Dummy) Respondent female?"
				lab def b_resp_female 0 "Male" 1 "Female", replace
				lab val b_resp_female b_resp_female

			* age 
			tab b_resp_age, m
				lab var b_resp_age "How old are you?"
				
			* muslim 
			tab b_resp_muslim, m
				lab var b_resp_muslim "(Dummy) Respondent muslim?"
				lab def b_resp_muslim 0 "Christian" 1 "Muslim", replace
				lab val b_resp_muslim b_resp_muslim
				
			* religious school 
			clonevar b_resp_religiousschool = cm2_resp_religiousschool
			tab b_resp_religiousschool, m
				replace b_resp_religiousschool = 0 if missing(b_resp_religiousschool)
				lab var b_resp_religiousschool "Did you attend religious school as a child?"
				lab val b_resp_religiousschool yesno
				
			* religiosity 
			tab b_resp_religiosity, m
				lab var b_resp_religiosity "How many times per week do you attend religious services?"
				
			* household size
			clonevar b_resp_numhh = b_resp_hh_size
			tab b_resp_numhh 
				lab var b_resp_numhh "How many people are there in your household?"
				
			* kids ever?
			clonevar b_resp_kidsever = b_resp_kids
			tab b_resp_kidsever, m
				lab var b_resp_kidsever "How many children have you ever had?"
			
			* household 
			gen b_resp_hhh = (b_resp_hhhrltn == 1)
			tab b_resp_hhh, m	
				lab var b_resp_hhh "Are you the head of household?"
				lab val b_resp_hhh yesno
				
			* married?
			tab b_resp_married, m
				replace b_resp_married = cm2_resp_married if missing(b_resp_married)
			
			* education 
			tab b_resp_education, m
				replace b_resp_education = 16 if b_resp_education > 16
				lab var b_resp_education "What is your 	highest completed grade in school?"

			* visit town 
			clonevar b_resp_visittown = b_resp_urbanvisit
				replace b_resp_visittown = cm2_resp_visittown if missing(b_resp_visittown) 
			tab b_resp_visittown, m		
				lab var b_resp_visittown "How often do you visit town?"
				
			* lived in village at 16
			clonevar b_resp_samevill16 = b_resp_livevill16
				replace b_resp_samevill16 = cm2_resp_vill16 if missing(b_resp_samevill16)
			tab b_resp_samevill16, m
				lab var b_resp_samevill16 "Did you live in this village at 16 years old?"
		
		* language: b_resp_language_swahili b_resp_language_zigua b_resp_language_digo b_resp_language_sambaa
		gen b_resp_language_swahili = (b_resp_language_main == 1)
			lab var b_resp_language_swahili "Primary language Swahili?"
			
		gen b_resp_language_zigua = (b_resp_language_main == 2)
			lab var b_resp_language_zigua "Primary language Zigua?"	
			
		gen b_resp_language_digo = (b_resp_language_main == 5)
			lab var b_resp_language_digo "Primary language Digo?"		

		gen b_resp_language_sambaa = (b_resp_language_main == 6)
			lab var b_resp_language_sambaa "Primary language Sambaa?"
			
		* tribe 
		drop b_resp_tribe_*
		forval i = 1/39 {	
			gen resp_tribe_`i' = (b_resp_tribe == `i')
		}			
		clonevar b_resp_tribe_nyakyusa 	= resp_tribe_1
		clonevar b_resp_tribe_chagga 	= resp_tribe_2
		clonevar b_resp_tribe_haya 		= resp_tribe_3
		clonevar b_resp_tribe_ngoni 	= resp_tribe_4
		clonevar b_resp_tribe_kwere 	= resp_tribe_5
		clonevar b_resp_tribe_pare		= resp_tribe_6
		clonevar b_resp_tribe_hehe		= resp_tribe_7
		clonevar b_resp_tribe_makonde	= resp_tribe_8
		clonevar b_resp_tribe_nyamwezi	= resp_tribe_9
		clonevar b_resp_tribe_sukuma	= resp_tribe_10
		clonevar b_resp_tribe_masai		= resp_tribe_11
		clonevar b_resp_tribe_kurya		= resp_tribe_12
		clonevar b_resp_tribe_gogo		= resp_tribe_13
		clonevar b_resp_tribe_luguru	= resp_tribe_14
		clonevar b_resp_tribe_fipa		= resp_tribe_15
		clonevar b_resp_tribe_manyema	= resp_tribe_16
		clonevar b_resp_tribe_nyiramba	= resp_tribe_17
		clonevar b_resp_tribe_nyaturu	= resp_tribe_18
		clonevar b_resp_tribe_bena		= resp_tribe_19
		clonevar b_resp_tribe_ha		= resp_tribe_20
		clonevar b_resp_tribe_hangaza	= resp_tribe_21
		clonevar b_resp_tribe_iraqi		= resp_tribe_22
		clonevar b_resp_tribe_jaluo		= resp_tribe_23
		clonevar b_resp_tribe_jita		= resp_tribe_24
		clonevar b_resp_tribe_kinga		= resp_tribe_25
		clonevar b_resp_tribe_matengo	= resp_tribe_26
		clonevar b_resp_tribe_mwera		= resp_tribe_27
		clonevar b_resp_tribe_ndali		= resp_tribe_28
		clonevar b_resp_tribe_ndendeule	= resp_tribe_29
		clonevar b_resp_tribe_nyambo	= resp_tribe_30
		clonevar b_resp_tribe_pogoro	= resp_tribe_31
		clonevar b_resp_tribe_sambaa	= resp_tribe_32
		clonevar b_resp_tribe_yao		= resp_tribe_33
		clonevar b_resp_tribe_zaramo	= resp_tribe_34
		clonevar b_resp_tribe_zigua		= resp_tribe_35
		clonevar b_resp_tribe_zinza		= resp_tribe_36
		clonevar b_resp_tribe_rangi		= resp_tribe_37
		clonevar b_resp_tribe_digo		= resp_tribe_38
		clonevar b_resp_tribe_bondei	= resp_tribe_39

		* media consumption b_radio_2wks b_radio_3months b_media_news
		clonevar b_radio_2wks = b_media_radio
			replace b_radio_2wks = cm2_radio_2wk if missing(b_radio_2wks)
		tab b_radio_2wks, m 
			lab var b_radio_2wks "How often listen to radio in last 2 weeks?"
	
		clonevar b_radio_3months = b_media_radio_ever
			replace b_radio_3months = cm2_radio_any_3mon if missing(b_radio_3months)
		tab b_radio_3months, m
			lab var b_radio_3months "Ever listen to radio in last 3 months?"
		
		tab b_media_news, m
			replace b_media_news = cm2_radio_news if missing(b_media_news)
			lab var b_media_news "How often do you read or listen to the news?"

		* assets: b_asset_radio b_asset_tv b_asset_cell
		clonevar b_asset_radio = b_assets_radio
			replace b_asset_radio = cm2_s16q1 if missing(b_asset_radio)
		tab b_asset_radio, m 
			lab var b_asset_radio "Do you own a radio?"
		
		clonevar b_asset_tv = b_assets_tv
			replace b_asset_tv = cm2_s16q3 if missing(b_asset_tv)
		tab b_asset_tv, m 
			lab var b_asset_tv "Do you own a TV?"

		clonevar b_asset_cell = b_assets_cell
			replace b_asset_cell = cm2_s16q5 if missing(b_asset_cell)
		tab b_asset_cell, m 
			lab var b_asset_cell "Do you own a cell phone?"

		* gender equality:  b_ipv_reject b_fm_reject b_ge_earning
		clonevar b_ipv_reject = b_ipv_rej_disobey
			replace b_ipv_reject = cm2_ipv_attitudes if missing(b_ipv_reject)
		tab b_ipv_reject, m
			lab var b_ipv_reject "Reject IPV"
			
		recode cm2_fm_attitude_1 (2 = 1)(1 = 0)
		recode cm2_fm_attitude_2 (2 = 0)(1 = 1)
		recode cm2_fm_attitude_3 (2 = 1)(1 = 0)
		egen cm2_fm_reject = rowtotal(cm2_fm_attitude_1 cm2_fm_attitude_2 cm2_fm_attitude_3)
		
		tab b_fm_reject, m
			replace b_fm_reject = cm2_fm_reject if missing(b_fm_reject)
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
			replace b_ge_earning = cm2_ge_equalearningok if missing(b_ge_earning)
			lab var b_ge_earning "Ok if women earn equally to men"
		
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		clonevar rd_receive = cm3_rd_receive
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		clonevar rd_stillhave = cm3_rd_stillhave
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = cm3_radio_listen
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = cm3_radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = cm3_radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
		
	* pools
	keep 	${treat_vars} ${uptake} ${covars}
	gen all = "yes"
	gen community = "yes"
	gen covars = "yes"
	gen sample = "cm"
	
	* save 
	tempfile temp_community 
	save `temp_community', replace



/* Append ______________________________________________________________________*/

	use `temp_as1', clear
	append using `temp_ne', force
	append using `temp_as2', force
	append using `temp_community', force
	
**# Bookmark #7
/* Create key variables ________________________________________________________*/

	* uptake
	rename rd_radio_3months rd_radio_3months_dum
		
	rename rd_radio_2wks rd_radio_2wks_freq
	
	gen rd_radio_2wks_dum = (rd_radio_2wks != 0)  
		lab var rd_radio_2wks_dum "(Dummy) Listened to radio in last two weeks?"
		
	rename rd_radio_hrs rd_radio_1day_hrs
	
	gen rd_radio_1day_dum = (rd_radio_1day_hrs > 0)
		lab var rd_radio_1day_dum "(Dummy) Listened to radio yesterday?"
	
	* covars
	foreach var of global covars {
		bys id_village_uid : egen vill_`var' = mean(`var')
		replace `var' = vill_`var' if `var' == . | `var' == .d | `var' == .r | `var' == .o
		drop vill_*
		
		tab `var', m
	}

	
/* Save ________________________________________________________________________*/

	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis.dta", replace
	
