
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
	set maxvar 30000
	set seed 1956

/* Locations ___________________________________________________________________*/

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
	
/* Run Prelim File _____________________________________________________________*/

	*do "${code}/pfm_.master/00_setup/pfm_paths_master.do"
	*do "${code}/pfm_radiodistribution/pfm_rd_prelim.do"


/* Load Data ___________________________________________________________________*/	

	use "${user}\Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis.dta", clear
	

/* Define Parameters ___________________________________________________*/

	#d ;
		
		/* set seed */
		set seed 			1956
							;
							
		/* rerandomization count */
		global rerandcount	800
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
					
		/* Indices */			
		global index_list	
							ccm
							/*
							covars
							comply 
							firststage
							stations
							topics
							gender
							wpp
							ipv
							em
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
							enviroknow 
							hivknow
							healthknow
							hivdisclose
							hivstigma						
							*/
							;
	#d cr

	
/* Run Do File ______________________________________________________________*/

	do "${user}\Documents/pfm_radiodistribution/02_indices/pfm_rd_indices_main.do"
	*do "X:\Documents/pfm_radiodistribution/02_indices/pfm_rd_labels.do"
	do "${user}\Documents/pfm_radiodistribution/02_indices/pfm_rd_twosided.do"
	
	
/* Set treatment variable ______________________________________________________*/

	clonevar treat = t_rd


/* Standardize and replace covars ______________________________________________*/

	foreach var of global covars {	
		
		egen std_`var' = std(`var')
		replace `var' = std_`var'
		drop std_*
		
		*replace `var' = 0 if missing(`var')
		
		
		*tab `var', m
		
		/* other options is to remove those variables
		count if missing(`var')
		if r(N) == _N drop `var'
		*/
	}
	
	/*
	ds b_*
	local vars `r(varlist)'
	global covars `vars'
	*/
	
/* Keep Target Data ____________________________________________________________*/

	keep if ${sample} == "yes" 

/* Save file ___________________________________________________________________*/


	save "${user}\Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis_prepped.dta", replace


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
		putexcel set "${user}\Dropbox\Wellspring Tanzania Papers\Wellspring Tanzania - Radio Distribution\03 Tables and Figures/pfm_rd_analysis_${survey}_${sample}.xlsx", sheet(`index', replace) modify
		
		qui putexcel A1 = ("variable")
		qui putexcel B1 = ("variablelabel")
		qui putexcel C1 = ("coef")
		qui putexcel D1 = ("se")
		qui putexcel E1 = ("pval")
		qui putexcel F1 = ("ripval")
		qui putexcel G1 = ("r2")
		qui putexcel H1 = ("N")
		qui putexcel I1 = ("lasso_coef")
		qui putexcel J1 = ("lasso_se")
		qui putexcel K1 = ("lasso_pval")
		qui putexcel L1 = ("lasso_ripval")
		qui putexcel M1 = ("lasso_r2")
		qui putexcel N1 = ("lasso_N")
		qui putexcel O1 = ("lasso_ctls")
		qui putexcel P1 = ("lasso_ctls_num")
		qui putexcel Q1 = ("treat_mean")
		qui putexcel R1 = ("treat_sd")
		qui putexcel S1 = ("ctl_mean")
		qui putexcel T1 = ("ctl_sd")
		qui putexcel U1 = ("vill_sd")
		qui putexcel V1 = ("min")
		qui putexcel W1 = ("max")
		qui putexcel X1 = ("")
		qui putexcel Y1 = ("rerandcount")
		qui putexcel Z1 = ("test")
		qui putexcel AA1 = ("date")

	
	/* Summary Stats ___________________________________________________________*/

		/* Set locals */
		global var_list ${`index'}												// Variables
		local row = 2															// Row for exporting to matrix
		
		
		/* Run through locals */
		foreach dv of global var_list  {
			
			use "${user}\Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis_prepped.dta", clear
		
		/* variable */
		global dv `dv'
		
		di "********************************************************************"
		di "THE VARIABLE IS `dv'"
		di "********************************************************************"
				
		/* set test */
		if strpos("$twosided", "`dv'") { 
			global test twosided
		} 
			else {
				global test onesided
			}
		
		/* Variable name */
		qui ds ${dv}
			global varname = "`r(varlist)'"  

		/* Variable label */
		global varlabel : var label ${dv}
		
		/* Treatment mean */
		sum ${dv} if treat == 0 
			global ctl_mean `r(mean)'
			global ctl_sd `r(sd)'

		/* Control mean */
		sum ${dv} if treat == 1 
			global treat_mean `r(mean)'
			global treat_sd `r(sd)'
			
		/* Control village sd */
		preserve
		qui collapse (mean) ${dv} treat, by(id_village_uid)
		sum ${dv} if treat == 0
			global vill_sd : di %6.3f r(sd)
		restore

		/* Variable range */	
		sum ${dv} 
			global min = r(min)
			global max = r(max)
			
			
	/* Basic Regression ________________________________________________________*/

		reg ${dv} treat ${cov_always} 												// This is the core regression ${cov_always}

			matrix table = r(table)
			
			/* Save values from regression */
			global coef = table[1,1]    	//beta
			global se 	= table[2,1]		//pval
			global t 	= table[3,1]		//pval
			global r2 	= `e(r2_a)' 		//r-squared
			global n 	= e(N) 				//N
			global df 	= e(df_r)
			
			/* Calculate pvalue */
			do "${user}/Documents/pfm_radiodistribution/01_helpers/pfm_rd_helper_pval.do"
			global pval = ${helper_pval}
			
			/* Calculate RI-pvalue */
			do "${user}/Documents/pfm_radiodistribution/01_helpers/pfm_rd_helper_pval_ri.do"
			global ripval = ${helper_ripval}
	  
	/* Lasso Regression  _______________________________________________________*/
	
		use "${user}\Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_analysis_prepped.dta", clear
	
		qui lasso linear ${dv} ${covars}										// set this up as a separate do file
			global lasso_ctls = e(allvars_sel)										
			global lasso_ctls_num = e(k_nonzero_sel)

	
		if ${lasso_ctls_num} != 0 {												// If lassovars selected	
			regress ${dv} treat ${lasso_ctls} ${cov_always}

				matrix table = r(table)
			}
			
			else if ${lasso_ctls_num} == 0 {									// If no lassovars selected
				qui regress ${dv} treat ${cov_always}
					matrix table = r(table)	
			}	
		
			/* Save Coefficient */
			local lasso_coef = table[1,1]
				
			/* Save values from regression */
			global lasso_coef 	= table[1,1]    	//beta
			global lasso_se 	= table[2,1]		//pval
			global lasso_t 		= table[3,1]		//pval
			global lasso_r2 	= `e(r2_a)' 		//r-squared
			global lasso_n 		= e(N) 				//N			
			global lasso_df 	= e(df_r)

			/* Calculate one-sided pvalue */				
			do "${user}/Documents/pfm_radiodistribution/01_helpers/pfm_rd_helper_pval_lasso.do"
			global lasso_pval = ${helper_lasso_pval}
			
			/* Calculate Lasso RI-pvalue */
			do "${user}/Documents/pfm_radiodistribution/01_helpers/pfm_rd_helper_pval_ri_lasso.do"
			global lasso_ripval = ${helper_lasso_ripval}
	
		** Capture time
		global date = c(current_date)
		
	/* Export to Excel _________________________________________________________*/ 
		
		di "Variable is ${varname}, coefficient is ${coef}, pval is ${pval} / ripval is ${ripval}, N = ${n}"
		di "LASSO: Variable is ${varname}, coefficient is ${lasso_coef}, lasso pval is ${lasso_pval} / lasso ripval is ${lasso_ripval}, N = ${lasso_n}"
		di "LASSO vars were ${lasso_ctls}"

		cap qui putexcel A`row' = ("${varname}")
		cap qui putexcel B`row' = ("${varlabel}")
		cap qui putexcel C`row' = ("${coef}")
		cap qui putexcel D`row' = ("${se}")
		cap qui putexcel E`row' = ("${pval}")
		cap qui putexcel F`row' = ("${ripval}")
		cap qui putexcel G`row' = ("${r2}")
		cap qui putexcel H`row' = ("${n}")
		
		cap qui putexcel I`row' = ("${lasso_coef}")
		cap qui putexcel J`row' = ("${lasso_se}")
		cap qui putexcel K`row' = ("${lasso_pval}")
		cap qui putexcel L`row' = ("${lasso_ripval}")
		cap qui putexcel M`row' = ("${lasso_r2}")
		cap qui putexcel N`row' = ("${lasso_n}")
		cap qui putexcel O`row' = ("${lasso_ctls}")
		cap qui putexcel P`row' = ("${lasso_ctls_num}")


		cap qui putexcel Q`row' = ("${treat_mean}")
		cap qui putexcel R`row' = ("${treat_sd}")
		cap qui putexcel S`row' = ("${ctl_mean}")
		cap qui putexcel T`row' = ("${ctl_sd}")
		cap qui putexcel U`row' = ("${vill_sd}")
		cap qui putexcel V`row' = ("${min}")
		cap qui putexcel W`row' = ("${max}")
		cap qui putexcel X`row' = ("${}")
		cap qui putexcel Y`row' = ("${rerandcount}")
		cap qui putexcel Z`row' = ("${test}")
		cap qui putexcel AA`row' = ("${date}")
		

		
		/* Update locals ___________________________________________________________*/
		
		local row = `row' + 1
		}
}

