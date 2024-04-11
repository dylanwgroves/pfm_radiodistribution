
/* Overview ______________________________________________________________________

Project: Wellspring Tanzania, Radio Distribution
Purpose: Analysis Prelimenary Work
Author: dylan groves, dylanwgroves@gmail.com
Date: 2023/12/11


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
	
	do "${user}/Documents/pfm_radiodistribution/02_indices/pfm_rd_indices_main.do"
		

/* Set Globals _________________________________________________________*/

	foreach user in  	"X:/" ///
						"C:\Users\grovesd" ///
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
	
	
	

/* Audio Screening 1 (as1_main) _____________________________________________________*/
	
	/* load data */
	use "${data}/03_final_data/pfm_as_merged.dta", clear
	rename as_* *
	
	/* covariates 	*/
	global ids			id_resp_uid id_village_uid 
	
	global treat_vars 	t_rd id_resp_uid id_village_uid
	
	global type			radio_type_music radio_type_sports radio_type_news radio_type_rltnship radio_type_social radio_type_relig
	
	global stations		radio_stations_voa radio_stations_tbc radio_stations_efm radio_stations_breeze radio_stations_pfm radio_stations_clouds radio_stations_rmaria radio_stations_rone radio_stations_huruma radio_stations_mwambao radio_stations_wasafi radio_stations_nuru radio_stations_uhuru radio_stations_bbc radio_stations_sya radio_stations_tk radio_stations_kenya radio_stations_imani radio_stations_freeafrica radio_stations_abood radio_stations_uhurudar radio_stations_upendo radio_stations_kiss radio_stations_times
	
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
		*keep if sample == "as"
		
		* treatment variables
		gen t_rd = rd_treat
			lab var t_rd "Radio Distribution Treatment"

		* drop if missing 
		drop if missing(t_rd)
		
		* drop parent, friend, kid
		drop p_* f_* k_* e_kidssample_* //treat_*

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
			clonevar b_resp_religiousschool = e_resp_religiousschool
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
			gen resp_tribe_`i' = (e_resp_tribe == `i')
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
		clonevar b_ipv_reject = m_ipv_rej_disobey
			lab var b_ipv_reject "Reject IPV"
			
		tab b_fm_reject, m
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
			lab var b_ge_earning "Ok if women earn equally to men"
			
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		*rename e_rd_* rd_*
		rename e_radio_listen radio_listen
		rename e_radio_listen_hrs radio_listen_hrs
		rename e_radio_ever radio_ever
		
		rename e_rd_receive rd_receive 
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		rename e_rd_stillhave rd_stillhave
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = radio_listen 
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
		
	* here
	*keep 	${treat_vars} ${covars} ${comply} ${firststage} radio_stations_* radio_type_*
	gen all = "yes"
	gen covars = "yes"
	gen as1 = "yes"
	gen as1_main = "yes"
	cap drop sample
	gen sample = "as1"
	
	rename e_radio_type_* radio_type_* 
		rename radio_type_rltnship radio_type_romance
		
	rename e_radio_stations_* radio_stations_*

	* save
	tempfile temp_as1
	save `temp_as1', replace


**# Bookmark #2
/* Natural Experiment  _________________________________________________________*/

	/* load data */
	use "${data}/03_final_data/pfm_ne_merged.dta", clear
		rename ne_* *

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
		gen t_rd = rd_treat
			lab var t_rd "Radio Distribution Treatment"
		
		* drop if missing 
		drop if missing(t_rd)
		
		* drop parent, friend, kid
		*drop p_* f_* k_* kidssample_* treat_*
		
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
				replace b_resp_age = e_resp_age if b_resp_age == .
				lab var b_resp_age "How old are you?"
				
			* muslim 
			tab b_resp_muslim, m
				replace b_resp_muslim = e_resp_muslim if b_resp_muslim == .
				lab var b_resp_muslim "(Dummy) Respondent muslim?"
				lab def b_resp_muslim 0 "Christian" 1 "Muslim", replace
				lab val b_resp_muslim b_resp_muslim
				
			* religious school 
			clonevar b_resp_religiousschool = e_resp_religiousschool
			tab b_resp_religiousschool, m
				replace b_resp_religiousschool = 0 if missing(b_resp_religiousschool)
				lab var b_resp_religiousschool "Did you attend religious school as a child?"
				lab val b_resp_religiousschool yesno
				
			* religiosity 
			tab b_resp_religiosity, m
				*replace b_resp_religiosity = resp_religiosity if b_resp_religiosity == . // this is an outcome, cant be imputed
				lab var b_resp_religiosity "How many times per week do you attend religious services?"
				
			* household size
			drop b_resp_numhh
			clonevar b_resp_numhh = e_resp_hh_size
			tab b_resp_numhh 
				lab var b_resp_numhh "How many people are there in your household?"
				
			* kids ever?
			tab b_resp_kidsever, m
				replace b_resp_kidsever = e_resp_kids if b_resp_kidsever == .
				lab var b_resp_kidsever "How many children have you ever had?"
			
			* household 
			tab b_resp_hhh, m
				replace b_resp_hhh = 1 if e_s3q2 == 1 & b_resp_hhh == .
				replace b_resp_hhh = 0 if e_s3q2 > 1 & !missing(e_s3q2) & b_resp_hhh == .				
				
			* married?
			tab b_resp_married, m
				replace b_resp_married = 1 if e_resp_rltn_status == 1 & e_resp_rltn_status == 2 & e_resp_rltn_status == 3 
			
			* education 
			tab b_resp_education, m
				replace b_resp_education = e_s3q16_school_grade if missing(b_resp_education)
				replace b_resp_education = 16 if b_resp_education > 16
				lab var b_resp_education "What is your 	highest completed grade in school?"
			
			* visit town 
			clonevar b_resp_visittown = e_resp_urbanvisit
			tab b_resp_visittown, m
				lab var b_resp_visittown "How often do you visit town?"
				
			* lived in village at 16
			clonevar b_resp_samevill16 = e_resp_livevill16 
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
			gen resp_tribe_`i' = (e_resp_tribe == `i')
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
			replace b_radio_2wks = e_radio_listen if missing(b_radio_2wks)
			lab var b_radio_2wks "How often listen to radio in last 2 weeks?"
		
		clonevar b_radio_3months = b_radio_any
		tab b_radio_3months, m
			replace b_radio_3months = e_radio_ever if missing(b_radio_3months)		
			lab var b_radio_3months "Ever listen to radio in last 3 months?"
		
		clonevar b_media_news = b_radio_news
			replace b_media_news = e_radio_news if missing(b_media_news)
			lab var b_media_news "How often do you read or listen to the news?"
		
		* assets: b_asset_radio b_asset_tv b_asset_cell
		tab b_asset_radio, m 
			replace b_asset_radio = 1 if missing(b_asset_radio)
			lab var b_asset_radio "Do you own a radio?"
		
		tab b_asset_tv, m 
			replace b_asset_tv = e_asset_tv if missing(b_asset_tv)
			lab var b_asset_tv "Do you own a TV?"
			
		tab b_asset_cell, m 
			replace b_asset_cell = e_asset_cell if missing(b_asset_cell)
			lab var b_asset_cell "Do you own a cell phone?"

		* gender equality:  b_ipv_reject b_fm_reject b_ge_earning
		clonevar b_ipv_reject = b_ipv_rej_disobey
		tab b_ipv_reject, m
			lab var b_ipv_reject "Reject IPV"
			
		tab b_fm_reject, m
		replace b_fm_reject = b_fm_reject if missing(b_fm_reject)
			lab var b_fm_reject "Reject force marriage"
			lab def b_fm_reject 0 "accept" 1 "reject", replace
			lab val b_fm_reject b_fm_reject
			
		tab b_ge_earning, m 
		replace b_ge_earning = b_ge_earning if missing(b_ge_earning)
			lab var b_ge_earning "Ok if women earn equally to men"
			
			
	/* dependent variables */
		
		* uptake: rd_receive rd_stillhave rd_radio_2wks rd_radio_3months
		tab e_rd_receive, m
			replace e_rd_receive = 0 if missing(e_rd_receive)
		
		tab e_rd_stillhave, m
			replace e_rd_stillhave = 0 if missing(e_rd_stillhave)
			
		clonevar e_rd_radio_2wks = e_radio_listen 
			lab var e_rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar e_rd_radio_3months = e_radio_ever
			lab var e_rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar e_rd_radio_hrs = e_radio_listen_hrs
			lab var e_rd_radio_hrs "How many hours per day listen to the radio?"
			
		rename e_radio_type_* radio_type_* 
			rename radio_type_rltnship radio_type_romance
			
	* set 
	*keep 	${treat_vars} ${covars} ${comply} ${firststage} radio_stations_* radio_type_*
	gen all = "yes"
	gen ne = "yes"
	gen covars = "yes"
	cap drop sample
	gen sample = "ne"
	
	* save
	tempfile temp_ne 
	save `temp_ne', replace

	

**# Bookmark #5
/* Audio Screening 2 ___________________________________________________________*/

	/* load data */
	use  "${data}/03_final_data/pfm_as2_merged.dta", clear
	rename as2_* *
	*drop rd_treat_* 
	*drop treat_*
	
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
		gen t_rd = e_radio_treat
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
			
		rename e_radstat_* radio_stations_*
			rename radio_stations_maria radio_stations_rmaria
			rename radio_stations_sautiyaamerica radio_stations_sya
			rename radio_stations_rf radio_stations_freeafrica 
			
		rename e_radio_type_* radio_type_*
			rename radio_type_ptix radio_type_news
			rename radio_type_community radio_type_social
			rename radio_type_religious radio_type_relig 
				replace radio_type_relig = radio_type_religmusic if missing(radio_type_relig)
			
	* set
	*keep 	${treat_vars} ${covars} ${comply} ${firststage} radio_stations_* radio_type_*
	gen as2 = "yes"
	gen covars = "yes"
	gen as2_e_p = "yes"
	cap drop sample
	gen sample = "as2"
	gen all = "yes"
	
	* save
	tempfile temp_as2 
	save `temp_as2', replace
	
	
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
		gen t_rd = cm3_radio_treat
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
				replace b_resp_muslim = 1 if cm3_resp_religion == 3 & missing(b_resp_muslim)
				replace b_resp_muslim = 0 if cm3_resp_religion == 2 & missing(b_resp_muslim)
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
		rename cm3_rd_* rd_*
		
		tab rd_receive, m
			replace rd_receive = 0 if missing(rd_receive)
		
		tab rd_stillhave, m
			replace rd_stillhave = 0 if missing(rd_stillhave)
			
		clonevar rd_radio_2wks = cm3_radio_listen
			lab var rd_radio_2wks "How often listen to radio in last 2 weeks?"		
		
		clonevar rd_radio_3months = cm3_radio_ever
			lab var rd_radio_3months "Ever listen to radio in last 3 months?"
			
		clonevar rd_radio_hrs = cm3_radio_listen_hrs
			lab var rd_radio_hrs "How many hours per day listen to the radio?"
		
		
		* stations 
		rename cm3_radio_stns_* radio_stations_*
			rename radio_stations_maria radio_stations_rmaria
			rename radio_stations_sautiyaamerica radio_stations_sya
			rename radio_stations_rf radio_stations_freeafrica 
			
		rename cm3_radio_type_* radio_type_*
			rename radio_type_ptix radio_type_news
			rename radio_type_community radio_type_social
			rename radio_type_religious radio_type_relig 
				replace radio_type_relig = radio_type_religmusic if missing(radio_type_relig)
	
	rename t_rd t_rd_s 
		gen t_rd = 1 if t_rd_s == "Radio"
		replace t_rd = 0 if t_rd_s == "Flashlight"
	
	* pools
	*keep 	${treat_vars} ${covars} ${comply} ${firststage} radio_stations_* radio_type_*
	gen all = "yes"
	gen community = "yes"
	gen covars = "yes"
	cap drop sample
	gen sample = "cm"
	
	* save 
	tempfile temp_community 
	save `temp_community', replace

/* Append ______________________________________________________________________*/

	use `temp_as1', clear
	append using `temp_ne', force
	append using `temp_as2', force
	append using `temp_community', force

	save "${user}\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\01 Data/pfm_rd_analysis_appendNOTclean.dta", replace


/* Create key variables ________________________________________________________*/
	
	use "${user}\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\01 Data/pfm_rd_analysis_appendNOTclean.dta", clear

	* block 
		replace id_village_uid = cm3_id_village_code if sample == "cm"
		encode id_village_uid, gen(block_vill)

		replace rd_block = id_village_uid if rd_block == ""
		encode rd_block, gen(block)

		
	/* compliance */
		rename e_rd_stillhave_show rd_stillhave_show
		replace rd_stillhave_show = 0 if missing(rd_stillhave_show)
		
		*replace rd_working = e_rd_working if missing(rd_working)
		
		rename e_rd_working rd_working
		replace e_rd_working = 0 if missing(rd_working)
		
		rename e_rd_controls rd_controls
		recode rd_controls (1 = 1)(0 2 3 4 5 = 0), gen(rd_controls_self)
			replace rd_controls = 0 if missing(rd_controls_self) // coded as 1 if you control yourself
	
	* firststage
		rename rd_radio_3months rd_radio_3months_dum
			replace rd_radio_3months = e_rd_radio_3months if missing(rd_radio_3months) // ne
			
		rename rd_radio_2wks rd_radio_2wks_freq
			replace rd_radio_2wks = e_rd_radio_2wks if missing(rd_radio_2wks) // ne
		recode rd_radio_2wks_freq (0 = 0 "never")(1 2 3 = 1 "ever"), gen(rd_radio_2wks_dum)
			lab var rd_radio_2wks_dum "(Dummy) Listened to radio in last two weeks?"
			
		rename rd_radio_hrs rd_radio_1day_hrs
			replace rd_radio_1day_hrs = e_rd_radio_hrs if missing(rd_radio_1day_hrs)
		
		gen rd_radio_1day_dum = 1 if rd_radio_1day_hrs > 0 & rd_radio_1day_hrs < 8
			replace rd_radio_1day_dum = 0 if rd_radio_1day_hrs == 0
			lab var rd_radio_1day_dum "(Dummy) Listened to radio yesterday?"
			
		clonevar radio_natleader = e_radio_natleader // ne
			replace radio_natleader = e_radio_natleader if missing(radio_natleader) // as1 + as2
			replace radio_natleader = cm3_radio_natleader if missing(radio_natleader) // cm

	* environmental knowledge
		clonevar enviro_ccknow_short = e_env_ccknow_mean_dum // as2
			replace enviro_ccknow_short = cm3_env_ccknow_mean_dum if missing(enviro_ccknow_short) // cm
		
		clonevar enviro_cause_human_short = e_env_cause_human
			replace enviro_cause_human_short = cm3_env_cause_human if missing(enviro_cause_human_short)
			replace enviro_cause_human_short = enviro_cause_human_short/2
		
		clonevar enviro_cause_intl = e_env_cause_intl
			replace enviro_cause_intl = cm3_env_cause_intl if missing(enviro_cause_intl)
			
		egen enviro_know_index = rowmean(enviro_ccknow_short enviro_cause_human_short enviro_cause_intl)

	* gender 
		rename e_ge_school ge_school
		
		rename e_ge_work ge_work
			recode cm3_ge_job (2=1)(1=0), gen(cm3_ge_work)
			replace ge_work = cm3_ge_work if missing(ge_work)

		rename e_ge_earning ge_earning
			recode cm3_ge_earn_2 (2=0)
			replace ge_earning = cm3_ge_earn_2 if missing(ge_earning)		
		
		rename e_ge_leadership ge_leadership
			replace ge_leadership = e_wpp_attitude2_dum if missing(ge_leadership)
			replace ge_leadership = cm3_ge_leaders_new if missing(ge_leadership)
			
		rename e_ge_business ge_business
			recode cm3_ge_business (2=0)
			replace ge_business = cm3_ge_business if missing(ge_business)
		
		drop e_ge_index
		egen ge_index = rowmean(ge_business ge_leadership ge_earning ge_work ge_school)

		
	* ipv
		clonevar ipv_reject_index = e_ipv_rej_disobey // ne
			replace ipv_reject_index = e_ipv_reject_gossip if missing(ipv_reject_index) // as2
			replace ipv_reject_index = cm3_ipv_reject_gossip if missing(ipv_reject_index) // cm
		tab ipv_reject_index sample, m

		rename e_ipv_norm_rej ipv_norm_rej
		tab ipv_norm_rej sample, m

		*rename ipv_report e_ipv_report
		egen ipv_report = rowmean(e_ipv_report e_ipv_report_index)
		tab ipv_report sample, m
		
		egen ipv_index = rowmean(ipv_reject_index ipv_norm_rej ipv_report)
	
	* wpp 
		rename e_wpp_behavior wpp_behavior
		replace wpp_behavior = cm3_wpp_behavior if missing(wpp_behavior) // cm
		tab wpp_behavior sample, m
		
		rename e_wpp_attitude_dum wpp_attitude_dum 
		tab wpp_attitude_dum sample, m
		
		rename e_wpp_norm_dum wpp_norm_dum
		tab wpp_norm_dum sample, m
		
		clonevar wpp_attitude2_dum = e_wpp_attitude2_dum 
			replace wpp_attitude2_dum = cm3_wpp_attitude2_dum if missing(wpp_attitude2_dum) // cm3
		tab wpp_attitude2_dum sample, m
		
		cap drop e_wpp_behavior_self_short 
		gen e_wpp_behavior_self_short = .
			replace e_wpp_behavior_self_short = 1 if e_wpp_behavior_self == 3 | e_wpp_behavior_self == 2
			replace e_wpp_behavior_self_short = 0 if e_wpp_behavior_self == 1 | e_wpp_behavior_self == 0

		drop e_wpp_behavior_adult
		egen e_wpp_behavior_adult = rowmean(e_wpp_behavior_wife e_wpp_behavior_self_short)
		
		foreach var in 	wpp_behavior_self wpp_behavior_wife wpp_behavior_adult  ///
						wpp_behavior_self_short  {
							
							clonevar `var' = e_`var'
							replace `var' = cm3_`var' if missing(`var')
							tab `var' sample, m
						}
						
		egen wpp_index = rowmean(wpp_behavior wpp_attitude_dum wpp_attitude2_dum wpp_behavior_adult)
		tab wpp_index sample, m
	
	* openness - neighbor 
		clonevar open_yesnbr_hiv = e_prej_yesnbr_aids // as1
			replace open_yesnbr_hiv = e_prej_yesneighbor_aids if missing(open_yesnbr_hiv) // ne
			replace open_yesnbr_hiv = e_prej_yesnbr_hiv if missing(open_yesnbr_hiv) //as2
			replace open_yesnbr_hiv = cm3_prej_yesnbr_hiv if missing(open_yesnbr_hiv) // cm
		tab open_yesnbr_hiv sample, m

		clonevar open_yesnbr_gay = e_prej_yesnbr_homo // as1
			replace open_yesnbr_gay = e_prej_yesneighbor_homo if missing(open_yesnbr_gay) // ne
		tab open_yesnbr_gay sample, m
		
		clonevar open_yesnbr_alcoholic = e_prej_yesnbr_alcoholic // as1
			replace open_yesnbr_alcoholic = e_prej_yesneighbor_alcoholic if missing(open_yesnbr_alcoholic) // ne
		tab open_yesnbr_alcoholic sample, m
		
		clonevar open_yesnbr_unmarried = e_prej_yesnbr_unmarried // as1 + as2	
			replace open_yesnbr_unmarried = e_prej_yesneighbor_unmarried if missing(open_yesnbr_unmarried) // ne
			replace open_yesnbr_unmarried = e_neighbor_unmarried if missing(open_yesnbr_unmarried) // as2
			replace open_yesnbr_unmarried = cm3_prej_yesnbr_unmarried if missing(open_yesnbr_unmarried) // cm3 
		tab open_yesnbr_unmarried sample, m
		
		clonevar open_yesnbr_albino = e_neighbor_albino // as2
			replace open_yesnbr_albino = cm3_prej_yesnbr_albino if missing(open_yesnbr_albino) // cm3
		tab open_yesnbr_albino sample, m
		
		egen open_yesnbr_index = rowmean(open_yesnbr_hiv open_yesnbr_gay open_yesnbr_alcoholic open_yesnbr_unmarried open_yesnbr_albino)
	
	* openness - kid marry 
		clonevar open_kidmarry_difftribe = e_prej_kidmarry_nottribe // ne
			replace open_kidmarry_difftribe = e_prej_kidmarry_nottribe if missing(open_kidmarry_difftribe) // as1 + as2
			replace open_kidmarry_difftribe = cm3_prej_kidmarry_nottribe if missing(open_kidmarry_difftribe) // cm
		tab open_kidmarry_difftribe sample, m
		
		clonevar open_kidmarry_diffrelig = e_prej_kidmarry_notrelig // ne
			replace open_kidmarry_diffrelig = e_prej_kidmarry_notrelig if missing(open_kidmarry_diffrelig) // as1 + as2
			replace open_kidmarry_diffrelig = cm3_prej_kidmarry_notrelig if missing(open_kidmarry_diffrelig) // cm
		tab open_kidmarry_diffrelig sample, m
		
		clonevar open_kidmarry_difftz = e_prej_kidmarry_nottz // ne
			replace open_kidmarry_difftz = e_prej_kidmarry_nottz if missing(open_kidmarry_difftz) // as1 + as2
			replace open_kidmarry_difftz = cm3_prej_kidmarry_nottz if missing(open_kidmarry_difftz) // cm
		tab open_kidmarry_difftz sample, m
	
		egen open_kidmarry_index = rowmean(open_kidmarry_difftribe open_kidmarry_diffrelig open_kidmarry_difftz)
	
	* thermometer
		gen open_thermo_notrelig = e_prej_thermo_muslims if b_resp_muslim != 1 // ne
			replace open_thermo_notrelig = e_prej_thermo_christians if b_resp_muslim == 1 & missing(open_thermo_notrelig) // ne + as1 
			*replace open_thermo_notrelig = e_prej_thermo_muslims if b_resp_muslim != 1 & missing(open_thermo_notrelig) // as1 
			*replace open_thermo_notrelig = e_prej_thermo_christians if b_resp_muslim == 1 & missing(open_thermo_notrelig) // as1 
		
		gen sb_sambaa = e_prej_thermo_sambaa if b_resp_tribe_sambaa != 1 
		gen sb_digo = e_prej_thermo_digo if b_resp_tribe_digo != 1 
		
		egen open_thermo_nottribe = rowmean(sb_sambaa sb_digo)

		egen open_thermo_index = rowmean(open_thermo_notrelig open_thermo_nottribe)
		
		replace open_thermo_nottribe = open_thermo_nottribe/100 
		replace open_thermo_notrelig = open_thermo_notrelig/100 
		replace open_thermo_index = open_thermo_index/100 
		
		egen open_index = rowmean(open_kidmarry_index open_yesnbr_index open_thermo_index)

	* tzovertribe 
		recode e_values_tzovertribe (1 2 = 1)(3 4 5 = 0), gen(neas_identity_tzovertribe_dum) // ne
		recode e_values_tzvstribe (1 2 = 1)(3 4 5 = 0), gen(e_identity_tzovertribe_dum) // as2
		recode cm3_values_tzvstribe (1 2 = 1)(3 4 5 = 0), gen(cm3_identity_tzovertribe_dum) // cm

		egen identity_tzovertribe_dum = rowmean(neas_identity_tzovertribe_dum e_identity_tzovertribe_dum cm3_identity_tzovertribe_dum)

	* religiosity 
		rename e_resp_religiosity identity_religiosity 
			*replace identity_religiosity = resp_religiosity if missing(identity_religiosity)
		
	* political participation (interest and behavior)
		*recode e_pknow_interest (1 = 3 "Very")(2 = 2 "Interested")(3 = 1 "Not very")(4 = 0 "Not at all"), gen(e_ppart_interest) // as2
		recode cm3_pknow_interest (1 = 3 "Very")(2 = 2 "Interested")(3 = 1 "Not very")(4 = 0 "Not at all"), gen(cm3_ppart_interest)
	egen ppart_interest = rowmean(e_ptixpart_interest e_ppart_interest cm3_ppart_interest)
	recode ppart_interest (3 = 1 "Very")(2 1 0 = 0 "Not very"), gen(ppart_interest_dum)

	gen ppart_collact = e_ptixpart_collact
	gen ppart_vote = e_ptixpart_vote
	gen ppart_villmeet = e_ptixpart_villmeet
	egen ppart_raiseissue = rowmean(e_ppart_raiseissue cm3_ptixpart_raiseissue)

	egen ppart_behavior_index = rowmean(ppart_collact ppart_vote ppart_villmeet ppart_raiseissue)
			
	* political knowledge 
		egen pknow_ports = rowmean(e_pknow_ports cm3_pknow_currentevent) 
		egen pknow_vp = rowmean(cm3_ptixknow_natl_vp e_ptixknow_natl_vp) 
		egen pknow_ruto = rowmean(cm3_ptixknow_fopo_ruto e_ptixknow_fopo_ruto)
		gen pknow_kenyatta = e_ptixknow_fopo_kenyatta
		gen pknow_justice = e_ptixknow_natl_justice
		gen pknow_pm = e_ptixknow_natl_pm
		gen pknow_em = e_ptixknow_em_aware 
		gen pknow_music = e_ptixknow_pop_music 
		gen pknow_sport = e_ptixknow_pop_sport 
		
		egen pknow_index = rowmean(pknow_vp pknow_ports pknow_ruto pknow_justice pknow_pm pknow_em pknow_kenyatta)

	* responsibility 
		recode e_ptixpref_resp (1 = 1)(2 3 4 = 0), gen(e_responsibility_vill)
		recode e_ptixpref_resp (2 3 = 1)(1 4 = 0), gen(e_responsibility_lga)
		recode e_ptixpref_resp (4 = 1)(1 2 3 = 0), gen(e_responsibility_natl)
		
		recode cm3_ptixpref_resp (1 = 1)(2 3 4 = 0), gen(cm3_responsibility_vill)
		recode cm3_ptixpref_resp (2 3 = 1)(1 4 = 0), gen(cm3_responsibility_lga)
		recode cm3_ptixpref_resp (4 = 1)(1 2 3 = 0), gen(cm3_responsibility_natl)

		recode e_ptixpref_responsibility (1 = 1)(2 3 4 = 0), gen(neas_responsibility_vill)
		recode e_ptixpref_responsibility(2 3 = 1)(1 4 = 0), gen(neas_responsibility_lga)
		recode e_ptixpref_responsibility (4 = 1)(1 2 3 = 0), gen(neas_responsibility_natl)
		
		egen presponsibility_vill = rowmean(e_responsibility_vill cm3_responsibility_vill neas_responsibility_vill)
		egen presponsibility_lga = rowmean(e_responsibility_lga cm3_responsibility_lga neas_responsibility_lga)
		egen presponsibility_natl = rowmean(e_responsibility_natl cm3_responsibility_natl neas_responsibility_natl)
		gen presponsibility_gov = presponsibility_lga + presponsibility_natl

	* ptrust 
		egen ptrust_lga = rowmean(e_ptixknow_trustloc cm3_ptixknow_trustloc)
		egen ptrust_natl = rowmean(e_ptixknow_trustnat cm3_ptixknow_trustnat)
		egen ptrust_relig = rowmean(e_ptixknow_trustrel cm3_ptixknow_trustrel)
		egen ptrust_radio = rowmean(e_ptixknow_trustradio cm3_ptixknow_trustradio)

	* crime
		rename e_ptixpref_rank_crime ptixpref_rank_crime
		gen crime_ppref = (ptixpref_rank_crime-1)/8
		*clonevar crime_vote = vote_crime 
		egen crime_local_long = rowmean(e_crime_local cm3_crime_local)
			gen crime_local = crime_local_long/3
		egen crime_natl = rowmean(e_crime_natl cm3_crime_natl)

		gen crime_bodarisky = e_gbv_boda_risky_short
		gen crime_travelrisky = e_gbv_travel_risky_short
		
		*replace crime_bodarisky = cm3_gbv_risky_boda_short if missing(crime_bodarisky)
		egen crime_risky = rowmean(crime_bodarisky crime_travelrisky)
		
		gen crime_nopartyalone = e_gbv_safe_party_self
		gen crime_walklongway = e_gbv_sfstreet_self_short
		
		egen crime_safebehavior_index = rowmean(crime_nopartyalone crime_walklongway)
		
		egen crime_index = rowmean(crime_ppref crime_local crime_natl crime_risky)

	* crime report (not panalysis)
		egen crime_gbv_report = rowmean(e_gbv_response_gov cm3_gbv_response_gov)
		egen crime_gbv_testify = rowmean(e_gbv_testify cm3_gbv_testify)
		egen crime_ipv_report = rowmean(ipv_report e_ipv_report_index)
		gen crime_em_report = e_em_report 
		egen crime_report_index = rowmean(crime_gbv_report crime_gbv_testify crime_ipv_report crime_em_report)
		
	* ccm 
		recode e_ppart_corruption (2 = 1)(1 = 0), gen(ccm_nocorruption)
		
		recode e_ppart_ccm_perform (2 = 1)(1 0 = 0), gen(ccm_goodperformance)
		
		gen ccm_thermo = e_thermo_ccm_num/100 
		egen ccm_samia_long = rowmean(e_thermo_samia_num cm3_thermo_samia_num)
			gen ccm_samia = ccm_samia_long/100
			
		egen ccm_index = rowmean(ccm_goodperformance ccm_thermo ccm_samia)

	* health know
		rename e_hivknow_* hivknow_*
		rename e_healthknow_* healthknow_*
		
		drop hivknow_arv_nospread
		egen hivknow_arv_nospread = rowmax(e_s_hiv_nospread_1 e_s_hiv_nospread_2) // ARVs and condoms
	
		drop hivknow_index 
		egen hivknow_index = rowmean(hivknow_arv_survive hivknow_arv_nospread hivknow_transmit)
		
		egen healthknow_index = rowmean(healthknow_notradmed healthknow_nowitchcraft healthknow_vaccines healthknow_vaccines_imp)
		
	* hiv disclosure 
		rename e_hivdisclose_* hivdisclose_* 
		
	* hiv stigma 
		rename e_hivstigma_* hivstigma_*

	* em / fm 
		rename e_em_* em_* 
		rename e_fm_* fm_* 
		rename e_ptixpref_rank_efm ptixpref_rank_efm
		replace ptixpref_rank_efm = (ptixpref_rank_efm-1)/8
		egen em_index = rowmean(fm_reject em_reject_index ptixpref_rank_efm em_norm_reject_dum em_record_shareany)
		
	* all gender
	
		egen gender_all = rowmean(em_index ge_index wpp_index)
	
	* values 
		rename e_values_* values_*

	* deal with missingness in covariates: replace -999/-888 to . and set any missingness
	* to village mean
		do "${user}/Documents/pfm_radiodistribution/02_indices/pfm_rd_indices_main.do"

		foreach var of global covars {
			* deal with missings 
			recode `var' (-999 -888 = .d)
			
			* replace
			qui bys id_village_uid : egen vill_`var' = mean(`var')
			qui replace `var' = vill_`var' if `var' == . | `var' == .d | `var' == .r | `var' == .o
			qui drop vill_*
			
			* some cm3 people (and villages) did not get baseline values collected, set to the average of their sample
			qui bys sample: egen sample_`var' = mean(`var')
				qui replace `var' = sample_`var' if missing(`var') & sample == "cm"
			
			tab `var', m
		}
stop
	* decide what to keep 	
		keep 	all community covars sample block ///
				${treat_vars} ${covars} ${comply} ${firststage} radio_stations_* radio_type_* ///
				${enviroknow} ///
				${gender} ${ipv} ${wpp} ///
				${open_nbr} ${open_marry} ${open_thermo} ///
				${identity} ///
				${ppart} ${pknow} ${presponsibility} ${ptrust} ///
				${crime} ${crime_report} ///
				${ccm} ${em}  ///
				${hivknow} ${healthknow} ///
				${hivdisclose} ${hivstigma} ///
				${values} gender_all ipv_index em_index treat
				
		
	
/* Save ________________________________________________________________________*/

	save "${user}\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\01 Data/pfm_rd_analysis.dta", replace
	
	
** do we want to merge in the other stuff
	
	
	
	
	
	
	
/* RI Prelim 

	tempfile rd_as rd_ne rd_as2 rd_cm 
	
	use "${data}/03_final_data/pfm_as_merged.dta", clear
		rename as_* * 
		keep if !missing(rd_treat)
		keep id_resp_uid rd_treat_* 
		gen sample = "as"
		save `rd_as', replace
		

	use "${data}/03_final_data/pfm_ne_merged.dta", clear
		rename ne_* *
		keep if !missing(rd_treat)
		keep id_resp_uid rd_treat_* 
		gen sample = "ne"
		save `rd_ne', replace
		
	use  "${data}/03_final_data/pfm_as2_merged.dta", clear
		rename as2_* *
		keep if !missing(rd_treat)
		keep id_resp_uid rd_treat_* 
		gen sample = "as2"
		save `rd_as2', replace	
	
	use  "${data}/03_final_data/pfm_cm_merged.dta", clear
		rename cm1_* b_*
		keep if !missing(rd_treat)
		keep id_resp_uid rd_treat_* 
		gen sample = "cm"
		save `rd_cm', replace		
	
	append using `rd_as', force 
	append using `rd_ne', force 
	append using `rd_as2', force
	
	save "X:/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_ri.dta", replace
*/
	

	
