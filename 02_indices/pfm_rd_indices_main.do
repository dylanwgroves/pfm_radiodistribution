

/* Basics ______________________________________________________________________

	Project: Wellspring Tanzania, Radio Distribution Globals
	Purpose: Analysis - Set Globals
	Author: dylan groves, dylanwgroves@gmail.com
	Date: 2020/12/23
________________________________________________________________________________*/


/* Define Globals and globals ___________________________________________________*/

	#d ;
		global sb 			resp_religiosity
							;
		global takeup		/* Takeup */
							rd_receive
							rd_stillhave
							radio_ever
							radio_listen_twoweek
							radio_listen_hrperday
							radio_listen_hrs
							;
							
		global stations		/* Stations */
							radio_stations_uhurudar
							radio_stations_tk
							radio_stations_uhuru
							radio_stations_huruma
							radio_stations_rone 
							radio_stations_pfm 
							radio_stations_tbc 
							radio_stations_voa 
							;
							
		global topics		/* Topics */
							radio_type_music 
							radio_type_sports 
							radio_type_news 
							radio_type_rltnship 
							radio_type_social 
							radio_type_relig
							;
							
		global pint			/* Political Interest */
							ptixpart_interest
							radio_locleader 
							radio_natleader 
							;
							
		global ppref		/* Political preferences */
							ptixpref_resp_natgov
							ptixpref_resp_gov
							ptixpref_resp_locgov
							ptixpref_resp_vill
							ptixpref_local_approve	
							ptixknow_trustloc 
							ptixknow_trustnat 
							ptixknow_trustrel
							ptixpref_rank_crime 
							ptixpref_rank_efm 
							ptixpref_rank_justice 
							ptixpref_rank_ag 
							ptixpref_rank_edu 
							ptixpref_rank_electric 
							ptixpref_rank_sanit 
							ptixpref_rank_roads 
							ptixpref_rank_health
							;
							
		global pknow		/* Political preferences */
							ptixknow_natl_pm 
							ptixknow_natl_justice 
							ptixknow_fopo_kenyatta 
							ptixknow_em_aware 
							ptixknow_pop_music 
							ptixknow_pop_sport
							;
							
		global ppart 		/* Political Participation */
							ptixpart_villmeet
							ptixpart_collact
							ptixpart_vote
							;
							
		global healthknow 	healthknow_index 
							hivknow_index 
							healthknow_notradmed 
							healthknow_nowitchcraft 
							healthknow_vaccines 
							healthknow_vaccines_imp 
							;
							
		global gender		/* Gender Equality */
							ge_index 
							ge_work 
							ge_leadership 
							ge_business 
							ge_school
							;
							
		global ipv 			ipv_rej_disobey 
							ipv_rej_hithard 
							ipv_rej_persists
							ipv_norm_rej 
							ipv_report
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
							
		global prej_nbr		/* Prejudice */
							prej_yesnbr_index
							prej_yesnbr_aids 
							prej_yesnbr_homo 
							prej_yesnbr_alcoholic 
							prej_yesnbr_unmarried 
							;
							
		global prej_marry 	prej_kidmarry_index
							prej_kidmarry_nottribe 
							prej_kidmarry_notrelig 
							prej_kidmarry_nottz
							prej_kidmarry_notrural 
							;
							
		global prej_thermo 	prej_thermo_index
							prej_thermo_chinese 
							prej_thermo_kenyan 
							prej_thermo_out_rel 
							prej_thermo_out_eth
							;
							
		global values	 	/* Values */
							values_tzovertribe_dum
							resp_religiosity
							values_questionauthority
							values_conformity
							values_urbangood 
							;
							
		global wpp 			wpp_attitude_dum 
							wpp_norm_dum 
							wpp_behavior 
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
		/* Covariates */	
		global cov_always	i.block_rd
							;					

		
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