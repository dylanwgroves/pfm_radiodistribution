

/* Basics ______________________________________________________________________

	Project: Wellspring Tanzania, Radio Distribution Globals
	Purpose: Analysis - Set Globals
	Author: dylan groves, dylanwgroves@gmail.com
	Date: 2020/12/23
________________________________________________________________________________*/


/* Define Globals and globals ___________________________________________________*/

	#d ;
			
		global cov_always	i.id_village_uid_c ;
		
		global covars 		b_resp_female b_resp_age b_resp_muslim b_resp_religiousschool  b_resp_religiosity ///
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
							b_asset_tv b_asset_cell ///
							b_ipv_reject b_fm_reject b_ge_earning
							;
							
		global comply		rd_receive 
							rd_stillhave 
							rd_stillhave_show 
							rd_working 
							rd_controls_self ;
		
		global firststage 	rd_radio_2wks_freq 
							rd_radio_2wks_dum 
							rd_radio_3months 
							rd_radio_1day_hrs 
							rd_radio_1day_dum 
							radio_natleader ;
				
		global stations		/* Stations */
							radio_stations_voa 
							radio_stations_tbc 
							radio_stations_efm 
							radio_stations_pfm 
							radio_stations_clouds 
							radio_stations_rmaria 
							radio_stations_rone 
							radio_stations_huruma 
							radio_stations_mwambao 
							radio_stations_wasafi 
							radio_stations_nuru 
							radio_stations_uhuru 
							radio_stations_bbc 
							radio_stations_tk 
							radio_stations_imani 
							radio_stations_freeafrica 
							radio_stations_abood  
							radio_stations_kiss 
							;
							
		global topics		/* Topics */
							radio_type_music 
							radio_type_sports 
							radio_type_news 
							radio_type_rltnship 
							radio_type_social 
							radio_type_relig
							;
							
		global enviroknow	/* Enviro Know */
							enviro_know_index
							enviro_ccknow_short
							enviro_cause_human
							enviro_cause_intl
							;
							
		global gender		/* Gender Equality */
							ge_index 
							ge_business 
							ge_leadership 
							ge_earning 
							ge_work 
							ge_school
							;
							
		global ipv 			ipv_reject_index
							ipv_norm_rej
							ipv_report
							;

							
		global wpp 			wpp_index
							wpp_attitude2_dum
							wpp_attitude_dum 
							wpp_behavior 
							wpp_behavior_self_short
							wpp_behavior_wife
							wpp_behavior_adult
							;
							
		global open_nbr		open_yesnbr_index
							open_yesnbr_hiv 
							open_yesnbr_gay 
							open_yesnbr_alcoholic 
							open_yesnbr_unmarried 
							open_yesnbr_albino
							;
							
		global open_marry 	open_kidmarry_index 
							open_kidmarry_difftribe 
							open_kidmarry_diffrelig 
							open_kidmarry_difftz
							;
							
		global open_thermo 	open_index
							open_thermo_index 
							open_thermo_notrelig
							open_thermo_nottribe
							;
							
		global identity		identity_tzovertribe_dum
							;
							
		global ppart		/* Political Interest */
							ppart_interest 
							ppart_collact
							ppart_villmeet
							ppart_vote
							ppart_raiseissue
							;
							
		global pknow		/* Political knowledge*/
							pknow_index
							pknow_ports
							pknow_vp 
							pknow_ruto
							pknow_kenyatta
							pknow_justice 
							pknow_pm 
							pknow_em 
							pknow_music 
							pknow_sport
							;
							
		global presponsibility		/* Political preferences */
								presponsibility_vill
								presponsibility_gov
								presponsibility_lga
								presponsibility_natl
								;
								
		global ptrust		ptrust_lga 
							ptrust_natl 
							ptrust_relig 
							ptrust_radio 
							;
						
							
		global crime		/* Crime */
							crime_index 
							crime_ppref
							crime_vote
							crime_local
							crime_natl
							crime_risky
							crime_bodarisky
							crime_travelrisky
							crime_nopartyalone
							crime_walklongway
							crime_safebehavior_index
							;

							
		global crime_report crime_report_index
							crime_gbv_report
							crime_gbv_testify
							crime_ipv_report 
							crime_em_report
							;
							
		global ccm			ccm_index
							ccm_nocorruption
							ccm_goodperformance 
							ccm_thermo
							ccm_samia
							;

		global em 			
							fm_reject
							fm_reject_long
							em_reject_index
							em_reject_all
							em_reject_religion_dum 
							em_reject_noschool_dum 
							em_reject_pregnant_dum 
							em_reject_money_dum 
							em_reject_needhus_dum
							em_norm_reject_dum
							em_record_reject 
							em_record_name
							em_record_sharepfm
							em_record_shareptix
							em_record_shareany
							em_record_shareany_name
							em_record_shareptix_name 
							em_record_sharepfm_name
							ptixpref_rank_efm
							;
							

							
		global values	 	/* Values */
							values_tzovertribe_dum
							resp_religiosity
							values_questionauthority
							values_conformity
							values_urbangood 
							;

							
		global healthknow 	healthknow_index 
							hivknow_index 
							healthknow_notradmed 
							healthknow_nowitchcraft 
							healthknow_vaccines 
							healthknow_vaccines_imp 
							;
							
		global hivknow		hivknow_index 
							hivknow_arv_survive 
							hivknow_arv_nospread 
							hivknow_transmit 
							;
							
		global hivdisclose	hivdisclose_index 
							hivdisclose_fam 
							hivdisclose_friend 
							hivdisclose_cowork 
							hivdisclose_nosecret 
							;
							
		global hivstigma 	hivstigma_index 
							hivstigma_notfired 
							hivstigma_yesbus 
							hivstigma_notfired_norm 
							;
							



		#d cr