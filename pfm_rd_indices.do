/* Basics ______________________________________________________________________

Project: Wellspring Tanzania, Radio Distribution Globals
Purpose: Analysis - Set Globals
Author: dylan groves, dylanwgroves@gmail.com
Date: 2020/12/23
________________________________________________________________________________*/


/* Define Globals and Locals ___________________________________________________*/
	#d ;
		
		global takeup		/* Takeup 
							rd_receive
							rd_stillhave
							*/
							radio_ever
							radio_listen
							radio_listen_hrs
							;	
		global pint			/* Political Interest */
							ptixpart_interest
							radio_locleader 
							radio_natleader 
							;
		global healthknow 	/* Health Knowledge */
							resp_ppe
							healthknow_notradmed 
							healthknow_nowitchcraft 
							healthknow_vaccines 
							healthknow_vaccines_imp 
							;
		local gender		/* Gender Equality */
							ge_index 
							ge_work 
							ge_leadership 
							ge_business 
							ge_school
							;
		local ipv 			ipv_rej_disobey 
							ipv_norm_rej 
							ipv_report
							;
		local fm 			fm_reject
							fm_reject_long
							/*fm_partner*/
							;
		local em 			em_reject_index
							em_reject_religion_dum 
							em_reject_noschool_dum 
							em_reject_pregnant_dum 
							em_reject_money_dum 
							em_record_reject
							em_record_shareany
							/*
							em_report
							em_norm_reject_dum
							*/
							;
		local prej_nbr		/* Prejudice */
							/*prej_yesnbr_index*/
							prej_yesnbr_aids 
							prej_yesnbr_homo 
							prej_yesnbr_alcoholic 
							prej_yesnbr_unmarried 
							;
		local prej_marry 	prej_kidmarry_index
							prej_kidmarry_nottribe 
							prej_kidmarry_notrelig 
							prej_kidmarry_nottz
							prej_kidmarry_notrural 
							;
		local prej_thermo 	prej_thermo_city 
							prej_thermo_chinese 
							prej_thermo_kenyan 
							prej_thermo_out_rel 
							prej_thermo_out_eth
							;
		local values	 	/* Values */
							values_tzortribe_dum
							values_urbangood 
							resp_urbanvisit
							resp_religiosity
							;
		local ppref	   		/* Political Preferences */
							values_dontquestion
							ptixknow_trustnat 
							ptixknow_trustloc
							ptixknow_trustrel
							ptixpref_local_approve
							ptixpref_respnat
							ptixpref_resploc
							ptixpref_respcom
							;
		local ppart 		/* Political Participation */
							ptixpart_villmeet
							ptixpart_collact
							ptixpart_vote
							;
		local wpp 			wpp_attitude_dum 
							wpp_norm_dum 
							wpp_behavior 
							/*wpp_partner*/
							;
		local hivknow		hivknow_index 
							hivknow_arv_survive 
							hivknow_arv_nospread 
							hivknow_transmit 
							;
		local hivdisclose	hivdisclose_index 
							hivdisclose_fam 
							hivdisclose_friend 
							hivdisclose_cowork 
							hivdisclose_nosecret 
							;
		local hivstigma 	hivstigma_index 
							hivstigma_notfired 
							hivstigma_yesbus 
							hivstigma_notfired_norm 
							;
		/* Covariates */	
		global cov_always	i.id_village_uid_c									// For partner
							/*i.block_rd*/
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
							b_resp_hhh 
							b_resp_numkid
							;
							
		/* Lasso Covariates - Partner */
		global cov_lasso_partner	
							p_resp_age 
							p_resp_female 
							p_resp_muslim
							b_resp_religiosity
							b_values_likechange 
							b_values_techgood 
							b_values_respectauthority 
							b_values_trustelders
							b_fm_reject
							b_ge_raisekids 
							b_ge_earning 
							b_ge_leadership 
							b_ge_noprefboy 
							b_media_tv_any 
							b_media_news_never 
							b_media_news_daily 
							b_radio_any 
							b_resp_lang_swahili 
							b_resp_literate 	
							b_resp_standard7 
							b_resp_nevervisitcity 
							b_resp_married 
							b_resp_hhh 
							b_resp_numkid
							b_fm_reject
							;
	#d cr
