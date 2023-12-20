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
	set maxvar 30000

	
/* Run Prelim File _____________________________________________________________*/

	*do "${code}/pfm_.master/00_setup/pfm_paths_master.do"
	*do "${code}/pfm_radiodistribution/pfm_rd_prelim.do"


/* Load Data ___________________________________________________________________*/	

	use "X:\Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis.dta", clear
	

/* Define Parameters ___________________________________________________*/

	#d ;
		
		/* set seed */
		set seed 			1956
							;
							
		/* rerandomization count */
		global rerandcount	1
							;
		
		
		/* sample */
		global sample		all
							;
							/* 
							all
							as 
							ne
							*/
		/* survey */
		global survey 		main
							;
							/*
							main
							partner
							friend
							kid
							*/
				
		global interact		b_resp_muslim
							;
							
		/* Indices */			
		global index_list	comply 
							firststage
							stations
							topics
							enviroknow
							gender
							wpp
							ipv
							open_nbr
							open_marry
							open_thermo
							identity
							ppart
							pknow 
							presponsibility
							ptrust
							crime
							crime_report 
							ccm
							/*
							covars
							comply 
							firststage
							stations
							topics
							enviroknow
							gender
							wpp
							ipv
							open_nbr
							open_marry
							open_thermo
							identity
							ppart
							pknow 
							presponsibility
							ptrust
							crime
							crime_report 
							ccm
							

							healthknow
							enviroknow 
							em
							*/
							;
	#d cr

	
/* Run Do File ______________________________________________________________*/

	do "X:\Documents/pfm_radiodistribution/02_indices/pfm_rd_indices_${survey}.do"
	*do "X:\Documents/pfm_radiodistribution/02_indices/pfm_rd_labels.do"
	do "X:\Documents/pfm_radiodistribution/02_indices/pfm_rd_twosided.do"



/* Keep Target Data ____________________________________________________________*/

	keep if ${sample} == "yes" 
	
	
/* Set treatment variable ______________________________________________________*/

	clonevar treat = t_rd
	
	
/* Create Interaction Term _____________________________________________________*/

	gen covar = ${interact}
	gen interact = treat*covar
	drop if mod(covar,1) > 0
	
/* Run for Each Index __________________________________________________________*/

foreach index of global index_list {

	/* Drop Macros */
	macro drop lasso_ctls 
	macro drop lasso_ctls_num 
	macro drop lasso_ctls_int
	
	macro drop lasso_ctls_replacement
	macro drop lasso_ctls_num_replacement 
	macro drop lasso_ctls_int_replace
	
	macro drop helper_pval
	macro drop helper_ripval
	macro drop helper_lasso_ripval
	
	macro drop test
	
	/* Define Matrix _______________________________________________________________*/
				
		/* Set Put Excel File Name */
		putexcel clear
		putexcel set "X:\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\03 Tables and Figures/pfm_rd_analysis_${interact}.xlsx", sheet(`index', replace) modify

		qui putexcel A1 = ("variable")
		qui putexcel B1 = ("variablelabel")

		qui putexcel C1 = ("coef")
		qui putexcel D1 = ("se")
		qui putexcel E1 = ("pval")
		qui putexcel F1 = ("ripval")

		qui putexcel G1 = ("m_coef")
		qui putexcel H1 = ("m_se")
		qui putexcel I1 = ("m_pval")
		qui putexcel J1 = ("m_ripval")

		qui putexcel K1 = ("x_coef")
		qui putexcel L1 = ("x_se")
		qui putexcel M1 = ("x_pval")
		qui putexcel N1 = ("x_ripval")

		qui putexcel O1 = ("c_coef")
		qui putexcel P1 = ("c_se")
		qui putexcel Q1 = ("c_pval")
		qui putexcel R1 = ("c_ripval")

		qui putexcel S1 = ("r2")
		qui putexcel T1 = ("n")

		qui putexcel AA1 = ("treat_mean")
		qui putexcel AB1 = ("treat_sd")
		qui putexcel AC1 = ("ctl_mean")
		qui putexcel AD1 = ("ctl_sd")
		qui putexcel AE1 = ("vill_sd")

		qui putexcel AF1 = ("c_treat_mean")
		qui putexcel AG1 = ("c_treat_sd")
		qui putexcel AH1 = ("c_ctl_mean")
		qui putexcel AI1 = ("c_ctl_sd")
		qui putexcel AJ1 = ("c_vill_sd")

		qui putexcel AK1 = ("")
		qui putexcel AL1 = ("")
		qui putexcel AM1 = ("")
		qui putexcel AN1 = ("")
		qui putexcel AO1 = ("")

		qui putexcel AP1 = ("min")
		qui putexcel AQ1 = ("max")

		qui putexcel AR1 = ("")
		qui putexcel AS1 = ("")

		qui putexcel AT1 = ("sd")
		qui putexcel AU1 = ("constant")

		qui putexcel AV1 = ("test")
		qui putexcel AW1 = ("c_test")
		qui putexcel AX1 = ("x_test")

		qui putexcel AY1 = ("rerandcount")
		qui putexcel AZ1 = ("date")
		qui putexcel BA1 = ("time")

	
	/* Summary Stats ___________________________________________________________*/

		/* Set locals */
		local var_list ${`index'}												// Variables
		local row = 2															// Row for exporting to matrix
		
	/* Run for each variable */
	foreach dv of local var_list  {
		
		/* variable */
		global dv `dv'
		global covar `interact'
		
		/* set one or two-sided tests */
		
			/* set treat test */
			if strpos("$twosided", "${dv}") { 
				global test twosided
			} 
				else {
					global test onesided
				}

			/* set covar test */
			if strpos("${twosided_covar}", "${covar}") { 
				global c_test twosided
			} 
				else {
					global c_test onesided
				}
				
			/* set covar test */
			if strpos("${onesided_interact}", "${covar}") { 
				global x_test onesided
			} 
				else {
					global x_test twosided
				}

		/* Variable name */
		qui ds `dv'
			global variable = "`r(varlist)'"  

		/* Variable label */
		global variablelabel : var label $dv
		
		/* dependendent variable means */
			* treatment = 0
			qui sum $dv if treat == 0 
				global ctl_mean `r(mean)'
				global ctl_sd `r(sd)'

			* treatment = 0
			qui sum $dv if covar == 1 
				global treat_mean `r(mean)'
				global treat_sd `r(sd)'
		
			* covar = 1
			qui sum $dv if covar == 0 
				global c_ctl_mean `r(mean)'
				global c_ctl_sd `r(sd)'

			* covar = 0
			qui sum $dv if covar == 1 
				global c_treat_mean `r(mean)'
				global c_treat_sd `r(sd)'
			
		/* sd */
			* individual-level
			sum ${dv} if treat == 0
				global sd :  di %6.3f r(sd)
		
			* village-level
			preserve
			qui collapse (mean) ${dv} treat, by(id_village_uid)
			qui sum ${dv} if treat == 0
				global vill_sd : di %6.3f r(sd)
			restore

		/* dv range */
		qui sum ${dv}
			global min = r(min)
			global max = r(max)

		
	/* Basic Regression ________________________________________________________*/

		xi: reg ${dv} treat##covar													// This is the core regression
			matrix table = r(table)
			matrix list table 

			/* Save values from regression */
			global coef 	= table[1,2]    	//beta
			global se 		= table[2,2]		//pval
			global t 		= table[3,2]		//tstat
			
			global c_coef 	= table[1,4]    	//beta
			global c_se 	= table[2,4]		//pval
			global c_t 		= table[3,4]		//tstat
			
			global x_coef 	= table[1,8]    	//beta
			global x_se 	= table[2,8]		//pval
			global x_t 		= table[3,8]		//tstat
			
			global constant	= table[1,9] 		//r-squared			
			global r2 		= `e(r2_a)' 		//r-squared
			global n 		= e(N) 				//N
			global df 		= e(df_r)
			
		margins, dydx(treat) at(covar=1)
			matrix table = r(table)
			
			global m_coef 	= table[1,2]    	//beta
			global m_se 	= table[2,2]		//pval
			global m_t 		= table[3,2]		//tstat

			/* Calculate pvalue */
			do "X:\Documents\pfm_radiodistribution\01_helpers\pfm_rd_helper_pval_hetfx.do"
			global pval 	= ${helper_pval}
			global c_pval 	= ${c_helper_pval}
			global x_pval 	= ${x_helper_pval}
			global m_pval 	= ${m_helper_pval}
			
			/* Calculate RI-pvalue 			
			do "X:\Documents\spotlights_leaders\02_code/01_helpers/leaders_helper_pval_ri.do"
			global ripval = ${helper_ripval}
			*/
	
	/* Export to Excel _________________________________________________________*/ 
		
		*di "Variable is ${varname}, coefficient is ${coef}, pval is ${pval} / ripval is ${ripval}, N = ${n}"
		*di "LASSO: Variable is ${varname}, coefficient is ${lasso_coef}, lasso pval is ${lasso_pval} / lasso ripval is ${lasso_ripval}, N = ${lasso_n}"
		*di "LASSO vars were ${lasso_ctls}"

		qui putexcel A`row' = ("${variable}")
		cap qui putexcel B`row' = ("${variablelabel}")

		qui putexcel C`row' = ("${coef}")
		qui putexcel D`row' = ("${se}")
		qui putexcel E`row' = ("${pval}")
		cap qui putexcel F`row' = ("${ripval}")

		qui putexcel G`row' = ("${c_coef}")
		qui putexcel H`row' = ("${c_se}")
		qui putexcel I`row' = ("${c_pval}")
		cap qui putexcel J`row' = ("${c_ripval}")

		qui putexcel K`row' = ("${x_coef}")
		qui putexcel L`row' = ("${x_se}")
		qui putexcel M`row' = ("${x_pval}")
		cap qui putexcel N`row' = ("${x_ripval}")

		qui putexcel O`row' = ("${m_coef}")
		qui putexcel P`row' = ("${m_se}")
		qui putexcel Q`row' = ("${m_pval}")
		cap qui putexcel R`row' = ("${m_ripval}")

		qui putexcel S`row' = ("${r2}")
		qui putexcel T`row' = ("${n}")

		qui putexcel AA`row' = ("${treat_mean}")
		qui putexcel AB`row' = ("${treat_sd}")
		qui putexcel AC`row' = ("${ctl_mean}")
		qui putexcel AD`row' = ("${ctl_sd}")
		qui putexcel AE`row' = ("${vill_sd}")

		qui putexcel AF`row' = ("${c_treat_mean}")
		qui putexcel AG`row' = ("${c_treat_sd}")
		qui putexcel AH`row' = ("${c_ctl_mean}")
		qui putexcel AI`row' = ("${c_ctl_sd}")
		qui putexcel AJ`row' = ("${c_vill_sd}")

		qui putexcel AK`row' = ("")
		qui putexcel AL`row' = ("")
		qui putexcel AM`row' = ("")
		qui putexcel AN`row' = ("")
		qui putexcel AO`row' = ("")

		qui putexcel AP`row' = ("${min}")
		qui putexcel AQ`row' = ("${max}")

		qui putexcel AR`row' = ("")
		qui putexcel AS`row' = ("")

		qui putexcel AT`row' = ("${sd}")
		qui putexcel AU`row' = ("${constant}")

		qui putexcel AV`row' = ("${test}")
		qui putexcel AW`row' = ("${c_test}")
		qui putexcel AX`row' = ("${x_test}")

		qui putexcel AY`row' = ("${rerandcount}")
		
		/* Update locals ___________________________________________________________*/
		
		local row = `row' + 1
		}
		
}











