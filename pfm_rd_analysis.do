/* Basics ______________________________________________________________________

Project: Wellspring Tanzania, Radio Distribution
Purpose: Analysis
Author: dylan groves, dylanwgroves@gmail.com
Date: 2020/12/23
________________________________________________________________________________*/


/* Introduction ________________________________________________________________*/
	
	clear all	
	clear matrix
	clear mata
	set more off
	global c_date = c(current_date)
	set seed 1956

	
/* Run Prelim File _____________________________________________________________

	*do "${user}/Documents/pfm_.master/00_setup/pfm_paths_master.do"
	do "${code}/../pfm_radiodistribution/pfm_rd_prelim.do"
*/
	
/* Load Data ___________________________________________________________________*/	

	use "${data_rd}/pfm_rd_analysis.dta", clear

	
/* Define Globals and Locals ___________________________________________________*/
	#d ;
		
		/* Sandbox */															// Set if you just want to see the immediate results without export
		local sandbox		1
							;
							
		/* Partner */
		local partner 		1
							;
		
		
		/* Rerandomization count */
		local rerandcount	500
							;
			
			
		/* Set seed */
		set seed 			1956
							;
							
			
		/* Indices */		
		local index_list	hivknow
		
							;
		local pint			/* Political Interest */
							ptixpart_interest
							radio_locleader 
							radio_natleader 
							;
		local healthknow 	/* Health Knowledge */
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
							fm_partner
							;
		local em 			em_reject_index
							em_reject_religion_dum 
							em_reject_noschool_dum 
							em_reject_pregnant_dum 
							em_reject_money_dum 
							em_record_reject
							em_record_shareany
							em_report
							em_norm_reject_dum
							;
		local prej_nbr		/* Prejudice */
							prej_yesnbr_index 
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
							wpp_partner
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
							hivdisclose_secret 
							;
		local hivstigma 	hivstigma_index 
							hivstigma_fired 
							hivstigma_bus 
							hivstigma_fired_norm 
							;
		/* Covariates */	
		global cov_always	i.block_rd
							;					
		/* Lasso Covariates */
		local cov_lasso		
							;
		/* Statitistics of interest */
		local stats_list 	coefficient											//1
							se													//2
							ripval												//3
							pval												//4
							controls_num										//5
							r2													//6
							N 													//7
							basic_coefficient									
							basic_se
							basic_ripval
							basic_pval											//11
							basic_r2
							basic_N
							ctl_mean
							ctl_sd
							treat_mean											//16
							treat_sd										
							min		
							max
							;
	#d cr


/* Sandbox _____________________________________________________________________*/

if `sandbox' > 0 {



	estimates clear

	foreach index of local index_list {

		foreach var of local `index' {
			xi : regress prej_thermo_sambaa treat ${cov_always}
			estimates store sb_`var'
		}
		
	}
	
	estimates table sb_*, keep(treat) b(%7.4f) se(%7.4f)  p(%7.4f) stats(N r2_a) varw(20) model(20)

stop

}
stop


/* Run for Each Index __________________________________________________________*/

foreach index of local index_list {

	/* Adjust for Partner Survey ___________________________________________________*/

		if `partner' > 0 {														// Need to change variable titles if partner survey
			local dv_p
			foreach var of local `index' {
				local dv_p `dv_p' p_`var'
				}
			local newindex `dv_p'
			local var_list `newindex'
		}
		
	/* Define Matrix _______________________________________________________________

		This section prepares an empty matrix to hold results
	*/
		if `partner' < 1 {
			local var_list ``index''
		}
	
	local varnames ""   
	local varlabs ""   
	local mat_length `: word count `var_list'' 
	local mat_width `: word count `stats_list'' 
	mat R =  J(`mat_length', `mat_width', .)

	
	/* Export Regression ___________________________________________________________*/

	local i = 1

	foreach dv of local var_list  {

		/* Variable Name */
		qui ds `dv'
			local varname = "`r(varlist)'"  
			*local varlab: var label `var'  										// Could capture variable label in future	
			local varnames `varnames' `varname'   
			*local varlabs `varlabs' `varlab' 

			
	/* Lasso Regression  ___________________________________________________________*/

		qui lasso linear `dv' ${cov_lasso}											// Select best preidctors of outcome, store variables and number of variables
			local lassovars = e(allvars_sel)										
			local lassovars_num  = e(k_nonzero_sel)

		if `lassovars_num' != 0 {													// If lassovars selected	
			qui regress `dv' treat ${cov_always} `lassovars'
				matrix table = r(table)
			}
			else if "`lassovars_num'" == "0" {												// If no lassovars selected
				qui regress `dv' treat ${cov_always}
					matrix table = r(table)
			}	
			
			/* Save Coefficient */
			local lasso_coef = table[1,1]
				
			/* Save beta on treatment, standard error, r-squared, and N */
			mat R[`i',1] = table[1,1]    											//beta
			mat R[`i',2] = table[2,1]   											//se
			local pval = table[4,1]													//p-val
				if `lasso_coef' > 0 {										
					if `pval' > 0 {
						local pval = `pval'/2										// Divide by two for one-sided test
					}
				}
			mat R[`i',5]= `lassovars_num'											//Lassovars Number	
			mat R[`i',6]= `e(r2_a)' 												//r-squared
			mat R[`i',7]= e(N)   													//N 
				
			/* Calculate Lasso RI p-value */										// Move to program (and is it faster to do the export to excel strategy from midline?)
			local lasso_rip_count = 0
			forval k = 1/`rerandcount' {
				if `lassovars_num' != 0 {											// If lassovars selected						
					qui regress `dv' treat_`k' ${cov_always} `lassovars'
						matrix RIP = r(table)
					}
					else if "`lassovars_num'" == "0" {										// If lassovars not selected
						qui regress `dv' treat_`k' ${cov_always}
							matrix RIP = r(table)
					}	
					local lasso_coef_ri = RIP[1,1]
						if `lasso_coef' > 0 {										// One-sided if estimate is positive (as predicted)
							if `lasso_coef' < `lasso_coef_ri' { 	  
								local lasso_rip_count = `lasso_rip_count' + 1	
							}
						}
						if `lasso_coef' < 0 {										// Two-sided if estimate is zero or negative (WE NEED TO CHANGE THIS FOR OUR TWO SIDED)
							if abs(`lasso_coef') < abs(`lasso_coef_ri') { 	  
								local lasso_rip_count = `lasso_rip_count' + 1	
							}
						}
			}
			mat R[`i',3] = `lasso_rip_count' / `rerandcount'	
			mat R[`i',4] = `pval'	
			
			di "****************************************"
			di "*** Variable is `dv'"
			di "*** coef is `lasso_coef'"
			di "*** pval is `pval'"
			di "*** ripval is `lasso_rip_count' / `rerandcount'	"
			
	/* Basic Regression  ___________________________________________________________*/	

		/* Run basic regression */
		qui xi: regress `dv' treat ${cov_always}								// This is the core regression
			
			/* Save Coefficient */
			matrix table = r(table)
			local coef = table[1,1]
			
			/* Save beta on treatment, se, R, N, control mean, (save space for ri p-val!) */
			mat R[`i',8]= table[1,1]    											//beta
			mat R[`i',9]= table[2,1]   												//se
			local basic_pval = table[4,1]   										//p-val
				if `coef' > 0 {
					local basic_pval = `basic_pval'/2
				}
			mat R[`i',12]= `e(r2_a)' 		//r-squared
			mat R[`i',13]= e(N) 			//N
			
			/* Calculate RI p-value 		*/
			local rip_count = 0
			forval j = 1 / `rerandcount' {
				qui xi: reg `dv' treat_`j' ${cov_always}
					matrix RIP = r(table)
					local coef_ri = RIP[1,1]
					if `coef' > 0 {
						if `coef' < `coef_ri' { 	  
							local rip_count = `rip_count' + 1	
						}
					}
					if `coef' < 0 {
						if abs(`coef') < abs(`coef_ri') { 	  
							local rip_count = `rip_count' + 1	
						}
					}
			}
			mat R[`i',10] = `rip_count' / `rerandcount'	
			mat R[`i',11] = `basic_pval'
			di "*** Basic coef is `coef'"
			di "*** Basic pval is `basic_pval'"
			di "*** Basic ripval is `rip_count' / `rerandcount'	"
			di "****************************************"


	/* Gather Summary Statistics ___________________________________________________*/
		
		/* Treat/Control Mean */
		qui sum `dv' if treat == 0 
			local control_mean `r(mean)'
			local control_sd `r(sd)'
		qui sum `dv' if treat == 1 
			local treat_mean `r(mean)'
			local treat_sd `r(sd)'

		/* Variable Range */
		qui sum `dv' 
			local min = r(min)
			local max = r(max)
					
		/* Village SD */
			preserve
			qui sum `dv' if treat == 0
			local sd `r(sd)'
			restore
		
		/* Save variable summaries */
			mat R[`i',14]= `treat_mean'    											// treat mean
			mat R[`i',15]= `treat_sd'    											// treat sd		
			mat R[`i',16]= `control_mean'    										// control mean
			mat R[`i',17]= `control_sd'    											// control mean
			mat R[`i',18]= `min'  													// min
			mat R[`i',19]= `max'  													// max

		/* Reset Locals */
			capture macro drop pval
			capture macro drop basic_pval
			capture macro drop lassovars_num
			
	local i = `i' + 1 
	}

		
	/* Export Matrix _______________________________________________________________*/ 
		
		preserve
		/* Row Names */
		mat rownames R = `varnames'  

		/* Transfer matrix to using dataset */
		clear
		svmat R, names(name)

		/* Create a variable for each outcome */
		gen outcome = "" 
		order outcome, before(name1)
		local i = 1 
		foreach var in `var_list' { 
			replace outcome="`var'" if _n==`i' 
			local ++i
		}

		/* Label regression statistics variables */
		local i 1 
		foreach col in `stats_list' { 
			cap confirm variable name`i' 
			if _rc==0 {
				rename name`i' `col'
				local ++i
			} 
		}  
		
		
		/* Export */
		if `partner' > 0 {
			save "${data_rd}/`index'_partner", replace
			export excel using "${rd_tables}/pfm_rd_rawresults_partner", sheet(`index') sheetreplace firstrow(variables)
		}
		if `partner' < 1 {
			save "${data_rd}/`index'", replace
			export excel using "${rd_tables}/pfm_rd_rawresults", sheet(`index') sheetreplace firstrow(variables)
		}
		restore
}



















