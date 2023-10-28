/* _____________________________________________________________________________

	Project: Wellspring Tanzania, Pangani Community Survey 2023
	Author: beatrice montano, beatrice.montano@columbia.edu
	Date: 2023

	Purpose: SurveyCTO prep
________________________________________________________________________________*/

/* Packages needed _____________________________________________________________*/


/* Introduction ________________________________________________________________*/
	
	version 16
	clear all	
	clear matrix
	clear mata
	set more off
	set seed 1956

/* Users _______________________________________________________________________*/	
	
	foreach user in  	"X:/" ///
						"/Users/BeatriceMontano" ///
						"/Users/Bardia" {
					capture cd "`user'"
					if _rc == 0 macro def path `user'
				}
	local dir `c(pwd)'
	global user `dir'
	display "${user}"

	foreach user in "X:/Box/34 Community Media III (Wellspring and Columbia PO)" ///
					"X:/Box Sync" ///
					"X:/Box" ///
					"/Volumes/Secomba/BeatriceMontano/Boxcryptor/Box Sync" ///
					"/Volumes/Secomba/Bardia/Boxcryptor/Box" {
					capture cd "`user'"
					if _rc == 0 macro def path `user'
				}
	local dir `c(pwd)'
	global userboxcryptor `dir'
	display "${userboxcryptor}"	

	foreach user in  "" ///
					 "/Users/BeatriceMontano/Library/CloudStorage/GoogleDrive-bm2955@columbia.edu/.shortcut-targets-by-id/1R35XbDm2trc2CVs41kTg8zPMzGVl8tL2" {
					capture cd "`user'"
					if _rc == 0 macro def path `user'
				}
	local dir `c(pwd)'
	global usergoogledrive `dir'
	display "${usergoogledrive}"	
	
/* Paths _______________________________________________________________________*/	

	do "${userboxcryptor}/07_Questionnaires & Data/05_Community survey/03 Data Flow/2_dofiles/05_pangani/00_pfm2023_paths.do"
	
/* Sample _______________________________________________________________________*/	

	* Pangani Survey - 2nd wave [ 2 nov 2021 - 18 nov 2021 ] ___________________*/

		use "${userboxcryptor}/30_Community Media II (Wellspring)/07&08 Questionnaires & Data/01_Community Survey/05_data/02_survey/03 clean/panganifm_survey2_clean_dwg.dta", clear 

		/*
		keep 	key district_name id_village 		///
				resp_id resp_name resp_name_pull 	///
				startdate subvillage_name_pull  ///
				svy_coast svy_type village_name 				///
				village_name_pull ward_name ward_name_pull		///
				resp_gender resp_age s20q1b resp_married resp_hh_kids enum_gender resp_relationship ///
				cca_firewood bbctz_gocourt
		*/			
		sort startdate resp_id
		
		* clean identifiers
			
			* drop training surveys
			drop if startdate < td(01112021)
			
			* clean name
			replace resp_name 	= resp_name_pull 	if resp_name == "" & resp_name_pull != ""
			drop resp_name_pull
			
			* clean IDs
			replace resp_id 	= "N5_51_1_00"		if key == "uuid:f97b6b3b-e0ce-46de-9fa9-64fd646c1b95"
			replace resp_id 	= "N5_51_1_45"		if key == "uuid:1a42ddc2-cc45-480f-a120-f65699d1139c"
			replace resp_id 	= "N5_71_3_34"		if key == "uuid:746f19c9-2ac2-4f86-9a53-c569eea07237"
			replace resp_id 	= "N5_91_2_10"		if key == "uuid:f5ac73ae-dc07-4102-bb1d-608a20c511f6"
			replace resp_id 	= "N5_91_2_11"		if key == "uuid:da0faa38-d303-4022-861c-f0cb2215c4e9"
			replace resp_id 	= "N5_91_2_19"		if key == "uuid:c2768992-b1c0-4238-8274-49ce619a1e81"
			replace resp_id 	= "N5_91_2_29"		if key == "uuid:7b855e68-5218-4ace-8f5d-90b624dee3a3"
			replace resp_id 	= "R5_31_1_44"		if key == "uuid:339f49d8-438a-4d29-be3c-f34673f3352f"
			replace resp_id 	= "R5_1_37_65"		if key == "uuid:0826f58c-611e-4bea-a142-85cdcbab8e8c"
			replace resp_id 	= "R5_31_1_42"		if key == "uuid:5f919bce-ac81-44ec-b554-3f0188840d5a"
			replace resp_id 	= "R5_71_2_32" 		if key == "uuid:bc380343-0d9f-4c3b-8f62-cd14b01adb1f"	
			replace resp_id 	= "N5_51_1_1" 		if key == "uuid:35a1078c-7037-4af0-b554-05e458714e1f"	
			replace resp_id 	= "N5_51_1_11" 		if key == "uuid:c08ee005-b13f-4b99-8ecb-d5ad7f33e829"	
			replace resp_id 	= "N5_51_1_13" 		if key == "uuid:310a35bf-a746-446a-9aec-1c8376735704"	
			replace resp_id 	= "N5_51_1_14" 		if key == "uuid:5abedc8c-2ae4-4c3f-85c4-0ac8f2a642de"	
			replace resp_id 	= "N5_51_1_18" 		if key == "uuid:139aa7bc-4bbc-449d-adb2-5b31b297884f"	
			replace resp_id 	= "N5_51_1_19" 		if key == "uuid:9e42d35a-50a6-47ad-a49d-50b15ee41e19"	
			replace resp_id 	= "N5_51_1_2" 		if key == "uuid:58dff962-29f2-41c7-a2b7-be32cfd7e89f"	
			replace resp_id 	= "N5_51_1_20" 		if key == "uuid:7960b574-f4c0-4746-88ce-b270706a5ce8"	
			replace resp_id 	= "N5_51_1_28" 		if key == "uuid:82dad9aa-e41e-40a1-83e3-92b74a4aee0e"	
			replace resp_id 	= "N5_51_1_29" 		if key == "uuid:2990c784-bc86-41ec-a1a0-8c9f90ecc34e"	
			replace resp_id 	= "N5_51_1_3" 		if key == "uuid:b1af6ad3-7b96-4451-bc5e-04ce72b1fdd2"	
			replace resp_id 	= "N5_51_1_30" 		if key == "uuid:4e2c365c-9373-4b86-9e09-1714f42ba266"	
			replace resp_id 	= "N5_51_1_46" 		if key == "uuid:27e16ecb-cbdd-4ea4-a424-6e27eae06c12"	
			replace resp_id 	= "N5_51_1_47" 		if key == "uuid:a2bb8887-8cd2-4ffc-8544-dacfae6e98f2"	
			replace resp_id 	= "N5_51_1_51" 		if key == "uuid:da97099b-bdb1-4ec7-af35-19c7eaf0e146"	
			replace resp_id 	= "N5_51_1_52" 		if key == "uuid:2e2d247e-2dc7-4278-a27e-3556505f4c60"	
			replace resp_id 	= "N5_51_1_6" 		if key == "uuid:47f7f26a-8547-4576-9d84-824d1524f1b9"	
			replace resp_id 	= "N5_51_1_7" 		if key == "uuid:2a0d7600-75b0-41ee-ba3f-bb6008571c58"	
			replace resp_id 	= "N5_51_1_8" 		if key == "uuid:459973a8-6ae3-4503-8d2f-b041faebaf58"
			replace resp_id 	= "B5_51_1_33"		if key == "uuid:8bd9b2c0-85b1-46a1-b677-ff7487f03707"
			replace resp_id 	= "B5_51_1_34"		if key == "uuid:3075da25-4633-4ee2-8e02-183fab3781a7"
			replace resp_id 	= "B5_51_1_35"		if key == "uuid:40d6d4a7-8a4d-4bbc-ad00-e7f5dffb1165"
			replace resp_id 	= "B5_71_3_3"		if resp_id == "B71_5_3_3"
			replace resp_id 	= "B5_71_3_5"		if resp_id == "B71_5_3_5"
			replace resp_id 	= "B5_71_3_8"		if resp_id == "B71_5_3_8"
			replace resp_id 	= "N5_91_2_10"		if resp_id == "5_91_2_10"
			replace resp_id 	= "N5_91_2_11"		if resp_id == "5_91_2_11"
			
			* drop ward and subvillage as empty, and district as constant
			drop ward_name ward_name_pull subvillage_name_pull district_name
			
			* clean village
			replace village_name 	= "Boza"		if startdate == td(01112021)
			replace village_name 	= "Mkwaja"		if key == "uuid:a8d2961e-741f-4922-9f9b-f99d4ae26fe2"
			replace village_name 	= "Mkwaja"		if key == "uuid:fe3605e4-0687-43b4-87ad-a7475116f1cb"
			
			drop 	id_village
			gen 	id_village 		= ""
					replace id_village 		= "5_51_1"		if village_name == "Boza"
					replace id_village 		= "5_31_1"		if village_name == "Bweni"
					replace id_village 		= "5_51_2"		if village_name == "Choba"
					replace id_village 		= "5_91_2"		if village_name == "Kipumbwi"
					replace id_village 		= "5_91_1"		if village_name == "Kwakibuyu"
					replace id_village 		= "5_81_1"		if village_name == "Langoni"
					replace id_village 		= "5_61_2"		if village_name == "Masaraza"
					replace id_village 		= "5_131_2"		if village_name == "Mbulizaga"
					replace id_village 		= "5_101_3"		if village_name == "Mikinguni"
					replace id_village 		= "5_121_3"		if village_name == "Mkwaja"
					replace id_village 		= "5_111_2"		if village_name == "Mseko"
					replace id_village 		= "5_71_2"		if village_name == "Mzambarauni"
					replace id_village 		= "5_121_1"		if village_name == "Sange"
					replace id_village 		= "5_101_2"		if village_name == "Stahabu"
					replace id_village 		= "5_81_2"		if village_name == "Tungamaa"
					replace id_village 		= "5_71_3"		if village_name == "Ushongo"
			drop village_name_pull
			
			rename id_village 		id_village_code
			rename village_name 	id_village_name
		
			* clean coast/inland
			replace svy_coast = 2 if startdate == td(01112021)
			
			* clean gender for pilot
			replace resp_gender = enum_gender if startdate == td(01112021)
		
		* sample identifiers 
		  gen sample_21 = 1
				* identify which is the pilot sample [ pilot == 1 nov 2021 ]
				gen sample_21_pilot = 1 if (startdate <= td(01112021))
				
		*		
		tempfile file_2021
		save `file_2021'
	

	* Pangani Survey - 1st wave [ 4 nov 2021 - 14 nov 2021 ] ___________________*/
	
		use "${user}/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Uzikwasa/01_data/pangani_communitysurvey_2020.dta", clear
		/*
		keep 	key  	district_name ward_name	village_name	///
						resp_id resp_name startdate  		///
						resp_female resp_age resp_hh_kids resp_rltn_status svy_phone ///
						svy_followupok resp_religion
*						svy_district_c	svy_ward_c svy_vill_c ///
		*/
*		rename svy_district_c 	id_district_code
		rename district_name 	id_district_name
*		rename svy_ward_c 		id_ward_code
		rename ward_name 		id_ward_name
*		rename svy_vill_c 		id_village_code
		rename village_name 	id_village_name
		rename resp_rltn_status	resp_relationship

		* clean others needed for cases
		gen resp_gender = resp_female
			la de resp_gender 1 "Female" 0 "Male"
			la val resp_gender resp_gender
			drop resp_female

		sort startdate resp_id
		
		* sample identifiers
		gen sample_20 = 1
		
	/* Merge the two _____________________________________________________________*/
	
		merge 1:1 resp_id using `file_2021', gen(merge_2020) force
		sort resp_id 

	* clean IDs
	
		* codes 
			drop id_village_code

			gen idclean = resp_id
				replace idclean = subinstr(idclean, "B", "", .)
				replace idclean = subinstr(idclean, "R", "", .)
				replace idclean = subinstr(idclean, "N", "", .)

			split idclean , p(_)
			
	*		gen idclean22 = string(real(idclean2),"%03.0f")
	*		gen idclean33 = string(real(idclean3),"%02.0f")
	*		gen idclean44 = string(real(idclean4),"%03.0f")
			gen midthing = "_"

			gen		id_district_code 	= idclean1
			gen		id_ward_code 		= id_district_code 	+ midthing + idclean2	
			gen 	id_village_code 	= id_ward_code 		+ midthing + idclean3	
			
			/*gen 	letter = ""
				replace letter = "_B" if svy_type == 2
				replace letter = "_R" if svy_type == 3
				replace letter = "_N" if svy_type == 4
			
			gen 	resp_id_clean 			= id_village_code 	+ midthing + idclean4
			gen 	resp_id_clean_type 		= id_village_code 	+ midthing + idclean4 + letter
			
			drop letter 
			*/
			
			drop idclean* midthing
		
		* names
			carryforward id_district_name	, replace
			
			replace id_ward_code 		= "5_31"		if resp_id == "R5_1_23_44"
			replace id_village_code 	= "5_31_1"		if resp_id == "R5_1_23_44"
			replace resp_id			 	= "5_21_1_44_R"	if resp_id == "R5_1_23_44"
			replace id_ward_code 		= "5_31"		if resp_id == "R5_1_37_65"
			replace id_village_code 	= "5_31_1"		if resp_id == "R5_1_37_65"
			replace resp_id 			= "5_31_1_65_R"	if resp_id == "R5_1_37_65"
			
			replace id_ward_name		= "Ubangaa" 	if id_village_code == "5_111_2"
			replace id_ward_name		= "Mwera" 		if id_village_code == "5_71_2"
			replace id_ward_name		= "Mikunguni" 	if id_ward_code == "5_101"
			replace id_ward_name		= "Tungamaa" 	if id_village_code == "5_81_2"
			replace id_ward_name		= "Kipumbwi" 	if id_village_name == "Kwakibuyu"
			replace id_ward_name		= "Mkwaja" 		if id_ward_code == "5_121"
			replace id_ward_name		= "Mkalamo" 	if id_ward_code == "5_131"
			replace id_ward_name		= "Bweni" 		if id_ward_code == "5_31"
			replace id_ward_name		= "Bushiri" 	if id_ward_code == "5_61"
			replace id_ward_name		= "Kipumbwi" 	if id_ward_code == "5_91"
			
			replace id_village_name 	= "Sokoni" 		if id_village_code == "5_22_2"
			replace id_village_name 	= "Langoni" 	if id_village_code == "5_81_1"
			replace id_village_name 	= "Stahabu" 	if id_village_code == "5_101_2"
			replace id_village_name 	= "Masaraza" 	if id_village_code == "5_61_2"
		
			replace svy_coast = 2 		if id_village_name == "Stahabu"
			replace svy_coast = 2 		if id_village_name == "Mikinguni"
			replace svy_coast = 2 		if id_village_name == "Mseko"
			replace svy_coast = 2 		if id_village_name == "Masaraza"
			replace svy_coast = 2 		if id_village_name == "Mzambarauni"
			replace svy_coast = 2 		if id_village_name == "Langoni"
			replace svy_coast = 2 		if id_village_name == "Tungamaa"
			replace svy_coast = 2 		if id_village_name == "Kwakibuyu"
			
			replace svy_coast = 1 		if id_village_name == "Mkwaja"
			replace svy_coast = 1 		if id_village_name == "Mbulizaga"
			replace svy_coast = 1 		if id_village_name == "Bweni"
			
		tempfile file_2021_2020
		save `file_2021_2020'

	/* Merge radio distribution information ____________________________________*/

	use "${userboxcryptor}/30_Community Media II (Wellspring)/07&08 Questionnaires & Data/04 Midline/05_data/02_survey/02_imported/pfm4_radiodistribution.dta" , clear
	
		gen radio_sample = 1 
		
		replace id = "B5_71_3_3"	if key == "uuid:6c33577c-3c49-4449-a207-a601e901346c"
		replace id = "R5_31_1_44"	if key == "uuid:2d88a9a6-8584-4db7-b97c-fe954c1bb0cc"
		
		gen resp_id = id 
		
		keep if inlist(substr(resp_id, 1, 1),"5", "R", "B", "N")
		
		distinct resp_id 
		duplicates drop resp_id , force
		
		keep resp_id radio_sample radio_treat key 

		* clean code

		/*gen svy_type = .
			replace svy_type = 2 if inlist(substr(resp_id, 1, 1), "B")
			replace svy_type = 3 if inlist(substr(resp_id, 1, 1), "R")
			replace svy_type = 4 if inlist(substr(resp_id, 1, 1), "N")
		*/
		
		gen idclean = resp_id
				replace idclean = subinstr(idclean, "B", "", .)
				replace idclean = subinstr(idclean, "R", "", .)
				replace idclean = subinstr(idclean, "N", "", .)

			split idclean , p(_)
			
	*		gen idclean22 = string(real(idclean2),"%03.0f")
	*		gen idclean33 = string(real(idclean3),"%02.0f")
	*		gen idclean44 = string(real(idclean4),"%03.0f")
			gen midthing = "_"

			gen		id_district_code 	= idclean1
			gen		id_ward_code 		= id_district_code 	+ midthing + idclean2	
			gen 	id_village_code 	= id_ward_code 		+ midthing + idclean3	
			
			/*gen 	letter = ""
				replace letter = "_B" if svy_type == 2
				replace letter = "_R" if svy_type == 3
				replace letter = "_N" if svy_type == 4
			
			gen 	resp_id_clean 			= id_village_code 	+ midthing + idclean4
			gen 	resp_id_clean_type 		= id_village_code 	+ midthing + idclean4 + letter
			
			drop letter
			*/
			
			drop idclean*  midthing

		* merge radio info with the rest 

		merge 1:1 resp_id using `file_2021_2020', gen(merge_radio)
		save `file_2021_2020', replace
		sort resp_id 
		save "C:\Users\grovesd\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Uzikwasa\01_data\pfm_communitysurvey_20202021_cleaned.dta", replace
stop
	* determine priority of tracking ___________________________________________*/
		
		replace radio_sample = 0 if radio_sample == . 
		
		replace radio_treat = "Flashlight" 	if radio_treat == "0"
		replace radio_treat = "Radio" 		if radio_treat == "1"
		
		gen radio_treat_num = .
			replace radio_treat_num = 0 if radio_treat == "0"
			replace radio_treat_num = 1 if radio_treat == "1"
			la de 	radio_treat_num 0 "Flashligh" 1 "Radio"
			la val 	radio_treat_num radio_treat_num
		
		gen priority = ""
			replace priority = "(A) RD + 20 + 21" 	if merge_2020 == 3 & merge_radio == 3
			replace priority = "(B) RD + 21"		if merge_2020 == 2 & merge_radio == 3
			replace priority = "(C) 20 + 21"		if merge_2020 == 3 & (merge_radio == 1 | merge_radio == 2)
			replace priority = "(D) 21"				if merge_2020 == 2 & (merge_radio == 1 | merge_radio == 2)
			replace priority = "(E) 20"				if merge_2020 == 1
			
	* encouragement text treatment assignment __________________________________*/

	preserve
		
		import excel "${userboxcryptor}/30_Community Media II (Wellspring)/07&08 Questionnaires & Data/01_Community Survey/05_data/06_encouragement/encouragement.xlsx", sheet("selected") firstrow allstring clear
		
		gen resp_id 		= RespondentID 
		gen treat_bbtext 	= checksample
		
		keep treat_bbtext resp_id
		
			replace resp_id 	= "N5_71_3_34"		if resp_id == "5N_71_3_34"
			replace resp_id 	= "B5_71_3_3"		if resp_id == "B71_5_3_3"
			replace resp_id 	= "B5_71_3_5"		if resp_id == "B71_5_3_5"
			replace resp_id 	= "B5_71_3_8"		if resp_id == "B71_5_3_8"
			replace resp_id 	= "N5_91_2_29"		if resp_id == "N5_81_2_29"
		
		tempfile text
		save `text'
		
	restore 
	
	merge 1:1 resp_id using `text', gen(merge_text)
	drop if merge_text == 2
	// 1 obs
	sort resp_id 
			
			
	* cleanup and export _______________________________________________________*/
		
		gen kids_tracking = (resp_hh_kids > 0 )	
		rename s20q1b 		phone_21
		rename svy_phone 	phone_20
		
		order 	id_district_code 	id_district_name 	///
				id_ward_code 		id_ward_name 		///
				id_village_code 	id_village_name 	///
				svy_coast 								///
				resp_id				priority			///
				radio_sample		radio_treat			radio_treat_num treat_bbtext ///
				resp_name resp_gender resp_married resp_age kids_tracking phone_21 phone_20
		

		tempfile readytoworkwith
		save `readytoworkwith'

		

********************************************************************************

/* Save tracking sheets _________________________________________________________

********************************************************************************	
	
		* PILOT 
		
		preserve
			
			drop 	resp_relationship resp_hh_kids ///
					resp_hh_kids svy_followupok key startdate ///
					sample_20 svy_type sample_21 merge_2020 merge_radio enum_gender cca_firewood bbctz_gocourt ///
					resp_religion radio_treat_num treat_bbtext
			
			sort  	id_village_code priority resp_id 
			
			keep if sample_21_pilot == 1
			drop sample_21_pilot
			
			export excel using "${userboxcryptor}/07_Questionnaires & Data/04 Endline/03 Data Flow/4_data/1_preloads/pfm5_pangani2023_sample_villagers_pilot.xlsx", firstrow(variables)replace

		restore
		
		* SAMPLE
		
		preserve
			
			drop 	resp_relationship resp_hh_kids ///
					resp_hh_kids svy_followupok key startdate ///
					sample_20 svy_type sample_21 merge_2020 merge_radio enum_gender cca_firewood bbctz_gocourt ///
					resp_religion radio_treat_num treat_bbtext
			
			sort  	id_village_code priority resp_id 
			
			keep if sample_21_pilot != 1
			drop sample_21_pilot
			
			export excel using "${userboxcryptor}/07_Questionnaires & Data/04 Endline/03 Data Flow/4_data/1_preloads/pfm5_pangani2023_sample_villagers.xlsx", firstrow(variables)replace

		restore
*/
	
********************************************************************************

/* Save this basic sample mother info __________________________________________*/

********************************************************************************	

	preserve 
	
		drop 	resp_hh_kids svy_followupok key startdate phone* enum_gender ///
				resp_relationship cca_firewood bbctz_gocourt resp_religion kids_tracking resp_married resp_age
							
		save "${data_pangani}/pfm5_pangani2023_motherinfo", replace
	
	restore 
	
********************************************************************************

* Cases for SurveyCTO __________________________________________________________*/

********************************************************************************	
	
	drop 	resp_hh_kids svy_followupok key startdate phone* enum_gender ///
			merge_2020 sample_20  sample_21_pilot priority svy_coast svy_type resp_married ///
			kids_tracking merge_radio 
				
		replace id_village_code = "5_51_2" if resp_id == "N5_52_2_35"
				
	* Basic information to be checked
		
		gen name_pull 				= resp_name
		gen gender_pull 			= resp_gender

		gen gender_pull_txt = ""
			replace gender_pull_txt = "female" 	if gender_pull == 1
			replace gender_pull_txt = "male" 	if gender_pull == 0	
		
		gen	age_pull				= resp_age
		gen	village_pull			= id_village_name
		gen resp_relationship_pull  = resp_relationship
		gen	resp_relationship_pull_txt		= ""
			replace resp_relationship_pull_txt = "Married" 				if resp_relationship == 1
			replace resp_relationship_pull_txt = "Living as married" 	if resp_relationship == 2
			replace resp_relationship_pull_txt = "In a relationship" 	if resp_relationship == 3
			replace resp_relationship_pull_txt = "Divorced" 			if resp_relationship == 4
			replace resp_relationship_pull_txt = "Separated" 			if resp_relationship == 5
			replace resp_relationship_pull_txt = "Widowed" 				if resp_relationship == 6
			replace resp_relationship_pull_txt = "Single" 				if resp_relationship == 7
		gen resp_relationship_pull_txt_sw 	= ""
			replace resp_relationship_pull_txt_sw = "Nimeoa/nimeolewa" 		if resp_relationship == 1
			replace resp_relationship_pull_txt_sw = "Tunaishi kama wanandoa" 	if resp_relationship == 2
			replace resp_relationship_pull_txt_sw = "Niko kwenye mahusiano" 	if resp_relationship == 3
			replace resp_relationship_pull_txt_sw = "Mtalikiwa" 				if resp_relationship == 4
			replace resp_relationship_pull_txt_sw = "Tumetengana" 				if resp_relationship == 5
			replace resp_relationship_pull_txt_sw = "Mjane" 					if resp_relationship == 6
			replace resp_relationship_pull_txt_sw = "Sijaoa / sijaolewa" 		if resp_relationship == 7
	
		drop resp_name resp_gender resp_age id_village_name resp_relationship
		
		gen bbdriver = 1 if inlist(substr(resp_id, 1, 1), "B")
	
	* Environment and gender 
  
		* generate treatment var for information
		gen agr_treat 			= round(runiformint(0,2))
			la de agr_treat 0 "control" 1 "treated_v1" 2 "treated_v2"
			la val agr_treat agr_treat
		
	* Environment outcomes 
	
		* ENVIRO PI EXP
			gen cca_firewood_recoded = .
				replace cca_firewood_recoded = 1 if cca_firewood == 1
				replace cca_firewood_recoded = 0 if cca_firewood == 2
			* community, by village
			bys id_village_code:	egen pi_cut_comvil_tot_txt_pull = count(cca_firewood_recoded)
			bys id_village_code:	egen pi_cut_comvil_rej_txt_pull = total(cca_firewood_recoded)
			
		drop cca_firewood  cca_firewood_recoded

	* GBV - Boda Bora outcomes 
	
		* TESTIFY PI EXP
			gen bbctz_gocourt_recoded = .
				replace bbctz_gocourt_recoded = 1 if bbctz_gocourt == 1
				replace bbctz_gocourt_recoded = 0 if bbctz_gocourt == 2
			* community, by village
			bys id_village_code:	egen pi_crt_comvil_tot_txt_pull = count(bbctz_gocourt_recoded)
			bys id_village_code:	egen pi_crt_comvil_rej_txt_pull = total(bbctz_gocourt_recoded)
		
		drop bbctz_gocourt  bbctz_gocourt_recoded
		
		* add randomization to court_boda_sex_norm
		
			gen	end_court_boda_sex_norm		= round(runiformint(0,2))
				replace end_court_boda_sex_norm		= round(runiformint(3,4)) 		if end_court_boda_sex_norm == 2
				la de end_court_boda_sex_norm 		0 "others" 1 "other people like you" 3 "influential people" 4 "respected people"
				la val end_court_boda_sex_norm 		end_court_boda_sex_norm
		 
				gen	end_court_boda_sex_norm_txt	= ""
			replace end_court_boda_sex_norm_txt	= "OTHERS" 					if end_court_boda_sex_norm == 0
			replace	end_court_boda_sex_norm_txt	= "OTHER PEOPLE LIKE YO"   	if end_court_boda_sex_norm == 1
			replace	end_court_boda_sex_norm_txt	= "INFLUENTIAL PEOPLE"   	if end_court_boda_sex_norm == 3
			replace	end_court_boda_sex_norm_txt	= "RESPECTED PEOPLE"   		if end_court_boda_sex_norm == 4
		
				gen	end_court_boda_sex_norm_swa	= ""
			replace	end_court_boda_sex_norm_swa	= "WENGINE" 				if end_court_boda_sex_norm == 0
			replace	end_court_boda_sex_norm_swa	= "WATU WENGINE KAMA WEWE"  if end_court_boda_sex_norm == 1
			replace	end_court_boda_sex_norm_swa	= "WATU WENYE USHAWISHI"   	if end_court_boda_sex_norm == 3
			replace	end_court_boda_sex_norm_swa	= "WATU WANAO HEMSHIMIKA"   if end_court_boda_sex_norm == 4

	* Openness
	
		gen resp_religion_pull				= resp_religion
		
		gen resp_religion_txt_pull			= ""
			replace resp_religion_txt_pull	= "Christian" 	if resp_religion_pull == 2
			replace resp_religion_txt_pull	= "Muslim" 		if resp_religion_pull == 3
			
		gen resp_religion_txt_swa_pull		   = ""
			replace resp_religion_txt_swa_pull = "Mkristo" 	if resp_religion_pull == 2
			replace resp_religion_txt_swa_pull = "Muislamu" if resp_religion_pull == 3
	
		drop resp_religion

	* Elections conjoint
			
		/* GBV ______________________________________________________*/

		* randomize if you are asked about GBV for the first or second candidate within the same question (old: rand_order_1st_txt)
		gen rand_order_ele_gbv 		= round(runiformint(1,2))
			la de rand_order_ele_gbv	1	"first" 2	"second"
			la val rand_order_ele_gbv 	rand_order_ele_gbv
	
				gen rand_order_1st_txt = ""
			replace rand_order_1st_txt = "first" 	if rand_order_ele_gbv == 1
			replace rand_order_1st_txt = "second" 	if rand_order_ele_gbv == 2
	
		drop rand_order_ele_gbv
		
		* randomize the characteristics of the candidate: gender and religion
		gen rand_cand1 = round(runiformint(1,4))
			la de rand_cand1	1	"Mr. Salim" 2	"Mr. John" 3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
			la val rand_cand1 	rand_cand1
	
			gen rand_cand2_1 = round(runiformint(2,4)) 	if rand_cand1 == 1
			gen rand_cand2_2 = round(runiformint(81,83)) 	if rand_cand1 == 2
					recode rand_cand2_2 (81 = 1) (82 = 3) (83 = 4)
			gen rand_cand2_3 = round(runiformint(91,93)) 	if rand_cand1 == 3
					recode rand_cand2_3 (91 = 1) (92 = 2) (93 = 4)
			gen rand_cand2_4 = round(runiformint(1,3)) 	if rand_cand1 == 4

			gen rand_cand2 = .
				forvalues i = 1/4 {
				replace rand_cand2 = rand_cand2_`i' if rand_cand1 == `i'
				}
			
			drop rand_cand2_1 rand_cand2_2 rand_cand2_3 rand_cand2_4
			
			la de rand_cand2	1	"Mr. Salim" 2	"Mr. John"  3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
			la val rand_cand2 	rand_cand2

				* English version
					gen rand_cand1_txt 	= ""
				replace rand_cand1_txt	= "Mr. Salim" 		if rand_cand1 == 1
				replace rand_cand1_txt	= "Mr. John" 		if rand_cand1 == 2
				replace rand_cand1_txt	= "Mrs. Mwanaidi"	if rand_cand1 == 3
				replace rand_cand1_txt	= "Mrs. Rose"		if rand_cand1 == 4
			
					gen rand_extra1_txt = ""
				replace rand_extra1_txt	= "Muslim man" 		if rand_cand1 == 1
				replace rand_extra1_txt	= "Christian man" 	if rand_cand1 == 2
				replace rand_extra1_txt	= "Muslim woman"	if rand_cand1 == 3
				replace rand_extra1_txt	= "Christian woman"	if rand_cand1 == 4
		
					gen rand_cand2_txt 	= ""
				replace rand_cand2_txt	= "Mr. Salim" 		if rand_cand2 == 1
				replace rand_cand2_txt	= "Mr. John" 		if rand_cand2 == 2
				replace rand_cand2_txt	= "Mrs. Mwanaidi"	if rand_cand2 == 3
				replace rand_cand2_txt	= "Mrs. Rose"		if rand_cand2 == 4
			
					gen rand_extra2_txt = ""
				replace rand_extra2_txt	= "Muslim man" 		if rand_cand2 == 1
				replace rand_extra2_txt	= "Christian man" 	if rand_cand2 == 2
				replace rand_extra2_txt	= "Muslim woman"	if rand_cand2 == 3
				replace rand_extra2_txt	= "Christian woman"	if rand_cand2 == 4
				
				* Swahili version
					gen rand_cand1_txt_sw 	= ""
				replace rand_cand1_txt_sw	= "Mr. Salim" 		if rand_cand1 == 1
				replace rand_cand1_txt_sw	= "Mr. John" 		if rand_cand1 == 2
				replace rand_cand1_txt_sw	= "Mrs. Mwanaidi"	if rand_cand1 == 3
				replace rand_cand1_txt_sw	= "Mrs. Rose"		if rand_cand1 == 4
			
					gen rand_extra1_txt_sw = ""
				replace rand_extra1_txt_sw	= "Muislamu" 		if rand_cand1 == 1
				replace rand_extra1_txt_sw	= "Mkristo" 		if rand_cand1 == 2
				replace rand_extra1_txt_sw	= "Muislamu"		if rand_cand1 == 3
				replace rand_extra1_txt_sw	= "Mkristo"			if rand_cand1 == 4
			
					gen rand_cand2_txt_sw 	= ""
				replace rand_cand2_txt_sw	= "Mr. Salim" 		if rand_cand2 == 1
				replace rand_cand2_txt_sw	= "Mr. John" 		if rand_cand2 == 2
				replace rand_cand2_txt_sw	= "Mrs. Mwanaidi"	if rand_cand2 == 3
				replace rand_cand2_txt_sw	= "Mrs. Rose"		if rand_cand2 == 4
			
					gen rand_extra2_txt_sw = ""
				replace rand_extra2_txt_sw	= "Muislamu" 		if rand_cand2 == 1
				replace rand_extra2_txt_sw	= "Mkristo" 		if rand_cand2 == 2
				replace rand_extra2_txt_sw	= "Muislamu"		if rand_cand2 == 3
				replace rand_extra2_txt_sw	= "Mkristo"			if rand_cand2 == 4
		
		* randomize the opposing platform to GBV
		
			gen rand_platform_gbv = round(runiformint(1,2))
			
			gen rand_promise_1st_txt = ""
				replace rand_promise_1st_txt = ///
					"improve roads in the village. Their slogan is Make Our Roads Better" ///
											if rand_platform_gbv == 1
				replace rand_promise_1st_txt = ///
					"improve education in our village. Their Slogan is Better Schools for our Children" ///
											if rand_platform_gbv == 2
			
			gen rand_promise_1st_txt_sw = ""
				replace rand_promise_1st_txt_sw = ///
				"Kuboresha barabara kijijini. Kauli mbiu yake ni tutengeneze barabara bora" ///
												if rand_platform_gbv == 1
				replace rand_promise_1st_txt_sw = ///
				"Kuboresha elimu kijijini. Kauli mbiu yake ni shule bora kwa watoto wetu" ///
												if rand_platform_gbv == 2
		
			drop rand_platform_gbv
			
		/* ENV ______________________________________________________*/
		
		* randomize if you are asked about ENV for the first or second candidate within the same question (old: rand_order_2nd_txt)
		gen rand_order_ele_env 		= round(runiformint(1,2))
			la de rand_order_ele_env	1	"first" 2	"second"
			la val rand_order_ele_env 	rand_order_ele_env
	
				gen rand_order_2nd_txt = ""
			replace rand_order_2nd_txt = "first" 	if rand_order_ele_env == 1
			replace rand_order_2nd_txt = "second" 	if rand_order_ele_env == 2
			
		drop rand_order_ele_env
	
		* randomize the characteristics of the candidate: gender and religion
		gen rand_cand3 = round(runiformint(1,4))
			la de rand_cand3	1	"Mr. Salim" 2	"Mr. John" 3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
			la val rand_cand3 	rand_cand3
	
			gen rand_cand4_1 = round(runiformint(2,4)) 	if rand_cand3 == 1
			gen rand_cand4_2 = round(runiformint(81,83)) 	if rand_cand3 == 2
					recode rand_cand4_2 (81 = 1) (82 = 3) (83 = 4)
			gen rand_cand4_3 = round(runiformint(91,93)) 	if rand_cand3 == 3
					recode rand_cand4_3 (91 = 1) (92 = 2) (93 = 4)
			gen rand_cand4_4 = round(runiformint(1,3)) 	if rand_cand3 == 4

			gen rand_cand4 = .
				forvalues i = 1/4 {
				replace rand_cand4 = rand_cand4_`i' if rand_cand3 == `i'
				}

			drop rand_cand4_1 rand_cand4_2 rand_cand4_3 rand_cand4_4

			la de rand_cand4	1	"Mr. Salim" 2	"Mr. John"  3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
			la val rand_cand4 	rand_cand4

				* English version
					gen rand_cand3_txt 	= ""
				replace rand_cand3_txt	= "Mr. Salim" 		if rand_cand3 == 1
				replace rand_cand3_txt	= "Mr. John" 		if rand_cand3 == 2
				replace rand_cand3_txt	= "Mrs. Mwanaidi"	if rand_cand3 == 3
				replace rand_cand3_txt	= "Mrs. Rose"		if rand_cand3 == 4
			
					gen rand_extra3_txt = ""
				replace rand_extra3_txt	= "Muslim man" 		if rand_cand3 == 1
				replace rand_extra3_txt	= "Christian man" 	if rand_cand3 == 2
				replace rand_extra3_txt	= "Muslim woman"	if rand_cand3 == 3
				replace rand_extra3_txt	= "Christian woman"	if rand_cand3 == 4
		
					gen rand_cand4_txt 	= ""
				replace rand_cand4_txt	= "Mr. Salim" 		if rand_cand4 == 1
				replace rand_cand4_txt	= "Mr. John" 		if rand_cand4 == 2
				replace rand_cand4_txt	= "Mrs. Mwanaidi"	if rand_cand4 == 3
				replace rand_cand4_txt	= "Mrs. Rose"		if rand_cand4 == 4
			
					gen rand_extra4_txt = ""
				replace rand_extra4_txt	= "Muslim man" 		if rand_cand4 == 1
				replace rand_extra4_txt	= "Christian man" 	if rand_cand4 == 2
				replace rand_extra4_txt	= "Muslim woman"	if rand_cand4 == 3
				replace rand_extra4_txt	= "Christian woman"	if rand_cand4 == 4
				
				* Swahili version
					gen rand_cand3_txt_sw 	= ""
				replace rand_cand3_txt_sw	= "Bw. Salim" 		if rand_cand3 == 1
				replace rand_cand3_txt_sw	= "Bw. John" 		if rand_cand3 == 2
				replace rand_cand3_txt_sw	= "Bi. Mwanaidi"	if rand_cand3 == 3
				replace rand_cand3_txt_sw	= "Bi. Rose"		if rand_cand3 == 4
			
					gen rand_extra3_txt_sw	= ""
				replace rand_extra3_txt_sw	= "Muislamu" 		if rand_cand3 == 1
				replace rand_extra3_txt_sw	= "Mkristo" 		if rand_cand3 == 2
				replace rand_extra3_txt_sw	= "Muislamu"		if rand_cand3 == 3
				replace rand_extra3_txt_sw	= "Mkristo"			if rand_cand3 == 4
			
					gen rand_cand4_txt_sw 	= ""
				replace rand_cand4_txt_sw	= "Bw. Salim" 		if rand_cand4 == 1
				replace rand_cand4_txt_sw	= "Bw. John" 		if rand_cand4 == 2
				replace rand_cand4_txt_sw	= "Bi. Mwanaidi"	if rand_cand4 == 3
				replace rand_cand4_txt_sw	= "Bi. Rose"		if rand_cand4 == 4
			
					gen rand_extra4_txt_sw  = ""
				replace rand_extra4_txt_sw	= "Muislamu" 		if rand_cand4 == 1
				replace rand_extra4_txt_sw	= "Mkristo" 		if rand_cand4 == 2
				replace rand_extra4_txt_sw	= "Muislamu"		if rand_cand4 == 3
				replace rand_extra4_txt_sw	= "Mkristo"			if rand_cand4 == 4
				
		* randomize the opposing platform to ENV
		
			gen rand_platform_env = round(runiformint(1,2))
			
			gen rand_promise_2nd_txt = ""
				replace rand_promise_2nd_txt = ///
					"improve roads in the village. Their slogan is Make Our Roads Better" ///
											if rand_platform_env == 1
				replace rand_promise_2nd_txt = ///
					"improve education in our village. Their Slogan is Better Schools for our Children" ///
											if rand_platform_env == 2
			
			gen rand_promise_2nd_txt_sw = ""
				replace rand_promise_2nd_txt_sw = ///
				"Kuboresha barabara kijijini. Kauli mbiu yake ni tutengeneze barabara bora" ///
												if rand_platform_env == 1
				replace rand_promise_2nd_txt_sw = ///
				"Kuboresha elimu kijijini. Kauli mbiu yake ni shule bora kwa watoto wetu" ///
												if rand_platform_env == 2
			
			drop rand_platform_env

			
	* Treatments 
		
		gen rd_sample_pull 	= radio_sample
		gen treat_rd_pull 	= radio_treat if rd_sample_pull == 1
		
		gen encourag_treat_pull = treat_bbtext
		
		drop sample_21 radio_treat_num radio_sample radio_treat

		count
		// 810
		
		************************************************************************

		* Cases for potential replacements _____________________________________*/

		************************************************************************
		
		preserve		
		
			use `readytoworkwith' , clear
			
			drop 	resp_hh_kids svy_followupok key startdate phone* enum_gender ///
					merge_2020 sample_20  sample_21_pilot priority svy_coast svy_type resp_married ///
					kids_tracking merge_radio 
						
			replace id_village_code = "5_51_2" if resp_id == "N5_52_2_35"
			
			gen resp_id_replacements = "R" + resp_id 
			
			keep resp_id_replacements id_district_code id_district_name id_village_code id_village_name id_ward_code id_ward_name bbctz_gocourt cca_firewood
				
					* Basic information to be checked
						
						gen name_pull 				= ""

						gen gender_pull 			= .
						gen gender_pull_txt = ""
						
						gen	age_pull				= .
						
						gen	village_pull			= id_village_name
						
						gen resp_relationship_pull  = .
						gen	resp_relationship_pull_txt		= ""
						gen resp_relationship_pull_txt_sw 	= ""
					
						drop  id_village_name 
											
					* Environment and gender 
				  
						* generate treatment var for information
						gen agr_treat 			= round(runiformint(0,2))
							la de agr_treat 0 "control" 1 "treated_v1" 2 "treated_v2"
							la val agr_treat agr_treat
						
					* Environment outcomes 
					
						* ENVIRO PI EXP
							gen cca_firewood_recoded = .
								replace cca_firewood_recoded = 1 if cca_firewood == 1
								replace cca_firewood_recoded = 0 if cca_firewood == 2
							* community, by village
							bys id_village_code:	egen pi_cut_comvil_tot_txt_pull = count(cca_firewood_recoded)
							bys id_village_code:	egen pi_cut_comvil_rej_txt_pull = total(cca_firewood_recoded)
							
						drop cca_firewood  cca_firewood_recoded

					* GBV - Boda Bora outcomes 
					
						* TESTIFY PI EXP
							gen bbctz_gocourt_recoded = .
								replace bbctz_gocourt_recoded = 1 if bbctz_gocourt == 1
								replace bbctz_gocourt_recoded = 0 if bbctz_gocourt == 2
							* community, by village
							bys id_village_code:	egen pi_crt_comvil_tot_txt_pull = count(bbctz_gocourt_recoded)
							bys id_village_code:	egen pi_crt_comvil_rej_txt_pull = total(bbctz_gocourt_recoded)
						
						drop bbctz_gocourt  bbctz_gocourt_recoded
						
						* add randomization to court_boda_sex_norm
						
							gen	end_court_boda_sex_norm		= round(runiformint(0,2))
								replace end_court_boda_sex_norm		= round(runiformint(3,4)) 		if end_court_boda_sex_norm == 2
								la de end_court_boda_sex_norm 		0 "others" 1 "other people like you" 3 "influential people" 4 "respected people"
								la val end_court_boda_sex_norm 		end_court_boda_sex_norm
						 
								gen	end_court_boda_sex_norm_txt	= ""
							replace end_court_boda_sex_norm_txt	= "OTHERS" 					if end_court_boda_sex_norm == 0
							replace	end_court_boda_sex_norm_txt	= "OTHER PEOPLE LIKE YO"   	if end_court_boda_sex_norm == 1
							replace	end_court_boda_sex_norm_txt	= "INFLUENTIAL PEOPLE"   	if end_court_boda_sex_norm == 3
							replace	end_court_boda_sex_norm_txt	= "RESPECTED PEOPLE"   		if end_court_boda_sex_norm == 4
						
								gen	end_court_boda_sex_norm_swa	= ""
							replace	end_court_boda_sex_norm_swa	= "WENGINE" 				if end_court_boda_sex_norm == 0
							replace	end_court_boda_sex_norm_swa	= "WATU WENGINE KAMA WEWE"  if end_court_boda_sex_norm == 1
							replace	end_court_boda_sex_norm_swa	= "WATU WENYE USHAWISHI"   	if end_court_boda_sex_norm == 3
							replace	end_court_boda_sex_norm_swa	= "WATU WANAO HEMSHIMIKA"   if end_court_boda_sex_norm == 4

					* Openness
					
						gen resp_religion_pull				= .
						gen resp_religion_txt_pull			= ""
						gen resp_religion_txt_swa_pull		   = ""
					
					* Elections conjoint
							
						/* GBV ______________________________________________________*/

						* randomize if you are asked about GBV for the first or second candidate within the same question (old: rand_order_1st_txt)
						gen rand_order_ele_gbv 		= round(runiformint(1,2))
							la de rand_order_ele_gbv	1	"first" 2	"second"
							la val rand_order_ele_gbv 	rand_order_ele_gbv
					
								gen rand_order_1st_txt = ""
							replace rand_order_1st_txt = "first" 	if rand_order_ele_gbv == 1
							replace rand_order_1st_txt = "second" 	if rand_order_ele_gbv == 2
					
						drop rand_order_ele_gbv
						
						* randomize the characteristics of the candidate: gender and religion
						gen rand_cand1 = round(runiformint(1,4))
							la de rand_cand1	1	"Mr. Salim" 2	"Mr. John" 3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
							la val rand_cand1 	rand_cand1
					
							gen rand_cand2_1 = round(runiformint(2,4)) 	if rand_cand1 == 1
							gen rand_cand2_2 = round(runiformint(81,83)) 	if rand_cand1 == 2
									recode rand_cand2_2 (81 = 1) (82 = 3) (83 = 4)
							gen rand_cand2_3 = round(runiformint(91,93)) 	if rand_cand1 == 3
									recode rand_cand2_3 (91 = 1) (92 = 2) (93 = 4)
							gen rand_cand2_4 = round(runiformint(1,3)) 	if rand_cand1 == 4

							gen rand_cand2 = .
								forvalues i = 1/4 {
								replace rand_cand2 = rand_cand2_`i' if rand_cand1 == `i'
								}
							
							drop rand_cand2_1 rand_cand2_2 rand_cand2_3 rand_cand2_4
							
							la de rand_cand2	1	"Mr. Salim" 2	"Mr. John"  3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
							la val rand_cand2 	rand_cand2

								* English version
									gen rand_cand1_txt 	= ""
								replace rand_cand1_txt	= "Mr. Salim" 		if rand_cand1 == 1
								replace rand_cand1_txt	= "Mr. John" 		if rand_cand1 == 2
								replace rand_cand1_txt	= "Mrs. Mwanaidi"	if rand_cand1 == 3
								replace rand_cand1_txt	= "Mrs. Rose"		if rand_cand1 == 4
							
									gen rand_extra1_txt = ""
								replace rand_extra1_txt	= "Muslim man" 		if rand_cand1 == 1
								replace rand_extra1_txt	= "Christian man" 	if rand_cand1 == 2
								replace rand_extra1_txt	= "Muslim woman"	if rand_cand1 == 3
								replace rand_extra1_txt	= "Christian woman"	if rand_cand1 == 4
						
									gen rand_cand2_txt 	= ""
								replace rand_cand2_txt	= "Mr. Salim" 		if rand_cand2 == 1
								replace rand_cand2_txt	= "Mr. John" 		if rand_cand2 == 2
								replace rand_cand2_txt	= "Mrs. Mwanaidi"	if rand_cand2 == 3
								replace rand_cand2_txt	= "Mrs. Rose"		if rand_cand2 == 4
							
									gen rand_extra2_txt = ""
								replace rand_extra2_txt	= "Muslim man" 		if rand_cand2 == 1
								replace rand_extra2_txt	= "Christian man" 	if rand_cand2 == 2
								replace rand_extra2_txt	= "Muslim woman"	if rand_cand2 == 3
								replace rand_extra2_txt	= "Christian woman"	if rand_cand2 == 4
								
								* Swahili version
									gen rand_cand1_txt_sw 	= ""
								replace rand_cand1_txt_sw	= "Mr. Salim" 		if rand_cand1 == 1
								replace rand_cand1_txt_sw	= "Mr. John" 		if rand_cand1 == 2
								replace rand_cand1_txt_sw	= "Mrs. Mwanaidi"	if rand_cand1 == 3
								replace rand_cand1_txt_sw	= "Mrs. Rose"		if rand_cand1 == 4
							
									gen rand_extra1_txt_sw = ""
								replace rand_extra1_txt_sw	= "Muislamu" 		if rand_cand1 == 1
								replace rand_extra1_txt_sw	= "Mkristo" 		if rand_cand1 == 2
								replace rand_extra1_txt_sw	= "Muislamu"		if rand_cand1 == 3
								replace rand_extra1_txt_sw	= "Mkristo"			if rand_cand1 == 4
							
									gen rand_cand2_txt_sw 	= ""
								replace rand_cand2_txt_sw	= "Mr. Salim" 		if rand_cand2 == 1
								replace rand_cand2_txt_sw	= "Mr. John" 		if rand_cand2 == 2
								replace rand_cand2_txt_sw	= "Mrs. Mwanaidi"	if rand_cand2 == 3
								replace rand_cand2_txt_sw	= "Mrs. Rose"		if rand_cand2 == 4
							
									gen rand_extra2_txt_sw = ""
								replace rand_extra2_txt_sw	= "Muislamu" 		if rand_cand2 == 1
								replace rand_extra2_txt_sw	= "Mkristo" 		if rand_cand2 == 2
								replace rand_extra2_txt_sw	= "Muislamu"		if rand_cand2 == 3
								replace rand_extra2_txt_sw	= "Mkristo"			if rand_cand2 == 4
						
						* randomize the opposing platform to GBV
						
							gen rand_platform_gbv = round(runiformint(1,2))
							
							gen rand_promise_1st_txt = ""
								replace rand_promise_1st_txt = ///
									"improve roads in the village. Their slogan is Make Our Roads Better" ///
															if rand_platform_gbv == 1
								replace rand_promise_1st_txt = ///
									"improve education in our village. Their Slogan is Better Schools for our Children" ///
															if rand_platform_gbv == 2
							
							gen rand_promise_1st_txt_sw = ""
								replace rand_promise_1st_txt_sw = ///
								"Kuboresha barabara kijijini. Kauli mbiu yake ni tutengeneze barabara bora" ///
																if rand_platform_gbv == 1
								replace rand_promise_1st_txt_sw = ///
								"Kuboresha elimu kijijini. Kauli mbiu yake ni shule bora kwa watoto wetu" ///
																if rand_platform_gbv == 2
						
							drop rand_platform_gbv
							
						/* ENV ______________________________________________________*/
						
						* randomize if you are asked about ENV for the first or second candidate within the same question (old: rand_order_2nd_txt)
						gen rand_order_ele_env 		= round(runiformint(1,2))
							la de rand_order_ele_env	1	"first" 2	"second"
							la val rand_order_ele_env 	rand_order_ele_env
					
								gen rand_order_2nd_txt = ""
							replace rand_order_2nd_txt = "first" 	if rand_order_ele_env == 1
							replace rand_order_2nd_txt = "second" 	if rand_order_ele_env == 2
							
						drop rand_order_ele_env
					
						* randomize the characteristics of the candidate: gender and religion
						gen rand_cand3 = round(runiformint(1,4))
							la de rand_cand3	1	"Mr. Salim" 2	"Mr. John" 3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
							la val rand_cand3 	rand_cand3
					
							gen rand_cand4_1 = round(runiformint(2,4)) 	if rand_cand3 == 1
							gen rand_cand4_2 = round(runiformint(81,83)) 	if rand_cand3 == 2
									recode rand_cand4_2 (81 = 1) (82 = 3) (83 = 4)
							gen rand_cand4_3 = round(runiformint(91,93)) 	if rand_cand3 == 3
									recode rand_cand4_3 (91 = 1) (92 = 2) (93 = 4)
							gen rand_cand4_4 = round(runiformint(1,3)) 	if rand_cand3 == 4

							gen rand_cand4 = .
								forvalues i = 1/4 {
								replace rand_cand4 = rand_cand4_`i' if rand_cand3 == `i'
								}

							drop rand_cand4_1 rand_cand4_2 rand_cand4_3 rand_cand4_4

							la de rand_cand4	1	"Mr. Salim" 2	"Mr. John"  3	"Mrs. Mwanaidi" 4	"Mrs. Rose"
							la val rand_cand4 	rand_cand4

								* English version
									gen rand_cand3_txt 	= ""
								replace rand_cand3_txt	= "Mr. Salim" 		if rand_cand3 == 1
								replace rand_cand3_txt	= "Mr. John" 		if rand_cand3 == 2
								replace rand_cand3_txt	= "Mrs. Mwanaidi"	if rand_cand3 == 3
								replace rand_cand3_txt	= "Mrs. Rose"		if rand_cand3 == 4
							
									gen rand_extra3_txt = ""
								replace rand_extra3_txt	= "Muslim man" 		if rand_cand3 == 1
								replace rand_extra3_txt	= "Christian man" 	if rand_cand3 == 2
								replace rand_extra3_txt	= "Muslim woman"	if rand_cand3 == 3
								replace rand_extra3_txt	= "Christian woman"	if rand_cand3 == 4
						
									gen rand_cand4_txt 	= ""
								replace rand_cand4_txt	= "Mr. Salim" 		if rand_cand4 == 1
								replace rand_cand4_txt	= "Mr. John" 		if rand_cand4 == 2
								replace rand_cand4_txt	= "Mrs. Mwanaidi"	if rand_cand4 == 3
								replace rand_cand4_txt	= "Mrs. Rose"		if rand_cand4 == 4
							
									gen rand_extra4_txt = ""
								replace rand_extra4_txt	= "Muslim man" 		if rand_cand4 == 1
								replace rand_extra4_txt	= "Christian man" 	if rand_cand4 == 2
								replace rand_extra4_txt	= "Muslim woman"	if rand_cand4 == 3
								replace rand_extra4_txt	= "Christian woman"	if rand_cand4 == 4
								
								* Swahili version
									gen rand_cand3_txt_sw 	= ""
								replace rand_cand3_txt_sw	= "Bw. Salim" 		if rand_cand3 == 1
								replace rand_cand3_txt_sw	= "Bw. John" 		if rand_cand3 == 2
								replace rand_cand3_txt_sw	= "Bi. Mwanaidi"	if rand_cand3 == 3
								replace rand_cand3_txt_sw	= "Bi. Rose"		if rand_cand3 == 4
							
									gen rand_extra3_txt_sw	= ""
								replace rand_extra3_txt_sw	= "Muislamu" 		if rand_cand3 == 1
								replace rand_extra3_txt_sw	= "Mkristo" 		if rand_cand3 == 2
								replace rand_extra3_txt_sw	= "Muislamu"		if rand_cand3 == 3
								replace rand_extra3_txt_sw	= "Mkristo"			if rand_cand3 == 4
							
									gen rand_cand4_txt_sw 	= ""
								replace rand_cand4_txt_sw	= "Bw. Salim" 		if rand_cand4 == 1
								replace rand_cand4_txt_sw	= "Bw. John" 		if rand_cand4 == 2
								replace rand_cand4_txt_sw	= "Bi. Mwanaidi"	if rand_cand4 == 3
								replace rand_cand4_txt_sw	= "Bi. Rose"		if rand_cand4 == 4
							
									gen rand_extra4_txt_sw  = ""
								replace rand_extra4_txt_sw	= "Muislamu" 		if rand_cand4 == 1
								replace rand_extra4_txt_sw	= "Mkristo" 		if rand_cand4 == 2
								replace rand_extra4_txt_sw	= "Muislamu"		if rand_cand4 == 3
								replace rand_extra4_txt_sw	= "Mkristo"			if rand_cand4 == 4
								
						* randomize the opposing platform to ENV
						
							gen rand_platform_env = round(runiformint(1,2))
							
							gen rand_promise_2nd_txt = ""
								replace rand_promise_2nd_txt = ///
									"improve roads in the village. Their slogan is Make Our Roads Better" ///
															if rand_platform_env == 1
								replace rand_promise_2nd_txt = ///
									"improve education in our village. Their Slogan is Better Schools for our Children" ///
															if rand_platform_env == 2
							
							gen rand_promise_2nd_txt_sw = ""
								replace rand_promise_2nd_txt_sw = ///
								"Kuboresha barabara kijijini. Kauli mbiu yake ni tutengeneze barabara bora" ///
																if rand_platform_env == 1
								replace rand_promise_2nd_txt_sw = ///
								"Kuboresha elimu kijijini. Kauli mbiu yake ni shule bora kwa watoto wetu" ///
																if rand_platform_env == 2
							
							drop rand_platform_env

							
					* Treatments 
						
						gen rd_sample_pull 	= .
						gen treat_rd_pull 	= ""
						
						gen encourag_treat_pull = ""
								
			count 
			// 810
			tempfile replacementcases
			save `replacementcases'
			
			restore
			
		append using `replacementcases'
		replace resp_id = resp_id_replacements if resp_id_replacements != ""
		drop resp_id_replacements

		
		
********************************************************************************
* Save and export __________________________________________________________*/
********************************************************************************
			
		drop if village_pull == "Sokoni"
			
		save "${preloads}/pfm2023_preload.dta"	, replace

		export excel using "${preloads}/pfm2023_preload.xlsx" ,  replace firstrow(variables)
		export excel using "${usergoogledrive}/PanganiFM 5/pfm2023_preload.xlsx",  replace firstrow(variables)

		
********************************************************************************

/* Save this basic sample mother info INCLUDING REPLACEMENTS ___________________*/

********************************************************************************	

	preserve 
	
		drop 	resp_hh_kids svy_followupok key startdate phone* enum_gender ///
				resp_relationship cca_firewood bbctz_gocourt resp_religion kids_tracking resp_married resp_age
							
		save "${data_pangani}/pfm5_pangani2023_motherinfo", replace
	
	restore 
