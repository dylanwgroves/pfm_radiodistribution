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

	
/* Run Prelim File _____________________________________________________________*/

	*do "${code}/pfm_.master/00_setup/pfm_paths_master.do"
	do "${code}/pfm_radiodistribution/pfm_rd_prelim.do"


/* Load Data ___________________________________________________________________*/	

	use "${data_rd}/pfm_rd_analysis.dta", clear
	encode id_village_uid, gen(id_village_uid_c)
	
	reg ipv_norm_rej treat i.block_rd if sample == "ne"
	stop

/* Define Parameters ___________________________________________________*/

	#d ;
		
		/* set seed */
		set seed 			1957
							;
							
		/* rerandomization count */
		global rerandcount	500
							;
		
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
		local index_list	
							ppref
							/*
							takeup
							stations
							topics
							pint
							healthknow
							gender
							wpp
							ipv
							em
							prej_nbr
							prej_marry
							prej_thermo
							values
							ppart
							ppref
							pknow

							hivknow
							hivdisclose
							hivstigma
							*/
							;
	#d cr

	
/* Run Do File ______________________________________________________________*/

	do "${code}/pfm_radiodistribution/02_indices/pfm_rd_indices_${survey}.do"
	do "${code}/pfm_radiodistribution/02_indices/pfm_rd_labels.do"


/* Run for Each Index __________________________________________________________

foreach index of local index_list {

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
*/

	/* Define Matrix _______________________________________________________________*/
				
		/* Set Put Excel File Name */
		putexcel clear
		putexcel set "${rd_tables}/pfm_rd_analysis_${survey}.xlsx", sheet(`index', replace) modify
		
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
		qui putexcel X1 = ("lasso_ctls_replacement")
		qui putexcel Y1 = ("lasso_ctls_num_replacement")
		
	
	/* Summary Stats ___________________________________________________________*/

		/* Set locals */
		local var_list ${`index'}												// Variables
		local row = 2															// Row for exporting to matrix
		foreach dv of local var_list  {
		
		/* variable */
		global dv `dv'
		
		/* Variable name */
		qui ds `dv'
			global varname = "`r(varlist)'"  

		/* Variable label */
		global varlabel : var label `dv'
		
		/* Treatment mean */
		qui sum `dv' if treat == 0 
			global ctl_mean `r(mean)'
			global ctl_sd `r(sd)'

		/* Control mean */
		qui sum `dv' if treat == 1 
			global treat_mean `r(mean)'
			global treat_sd `r(sd)'
			
		/* Control village sd */
		preserve
		qui collapse (mean) `dv' treat, by(id_village_uid)
		qui sum `dv' if treat == 0
			global vill_sd : di %6.3f r(sd)
		restore

		/* Variable range */	
		qui sum `dv' 
			global min = r(min)
			global max = r(max)
			
			
	/* Basic Regression ________________________________________________________*/

		qui xi: reg `dv' treat ${cov_always}									// This is the core regression
			matrix table = r(table)
			
			/* Save values from regression */
			global coef = table[1,1]    	//beta
			global se 	= table[2,1]		//pval
			global t 	= table[3,1]		//pval
			global r2 	= `e(r2_a)' 		//r-squared
			global n 	= e(N) 				//N
			
			/* Calculate one-sided pvalue */
			global pval = 2*ttail(e(df_r),abs(${t})) 
			
			/* Calculate RI-pvalue */
			do "${code}/pfm_radiodistribution/01_helpers/pfm_rd_helper_ri.do"
			global ripval = ${helper_ripval}

		
	/* Lasso Regression  ___________________________________________________________*/

		qui lasso linear `dv' ${cov_lasso}										// set this up as a separate do file
			global lasso_ctls = e(allvars_sel)										
			global lasso_ctls_num = e(k_nonzero_sel)

	
		if ${lasso_ctls_num} != 0 {												// If lassovars selected	
			qui regress `dv' treat ${cov_always} ${lasso_ctls}
				matrix table = r(table)
			}
			
			else if ${lasso_ctls_num} == 0 {									// If no lassovars selected
				qui regress `dv' treat ${cov_always}
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
			
			/* Calculate one-sided pvalue */				
			global lasso_pval = 2*ttail(e(df_r),abs(${lasso_t})) 
			
			/* Calculate Lasso RI-pvalue */
			do "${code}/pfm_radiodistribution/01_helpers/pfm_rd_helper_ri_lasso.do"
			global lasso_ripval = ${helper_lasso_ripval}

			di "****************************************"
			di "*** Variable is `dv'"
			di "*** coef is `lasso_coef'"
			di "*** pval is `pval'"
			di "*** ripval is `lasso_rip_count' / `rerandcount'	"
			
		
	/* Export to Excel _________________________________________________________*/ 
		
		di "Variable is ${varname}, coefficient is ${coef}, pval is ${pval}, N = ${n}"
		di "LASSO: Variable is ${varname}, coefficient is ${lasso_coef}, pval is ${lasso_pval}, N = ${lasso_n}"
		di "LASSO vars were ${lasso_ctls}"

		qui putexcel A`row' = ("${varname}")
		qui putexcel B`row' = ("${varlabel}")
		qui putexcel C`row' = ("${coef}")
		qui putexcel D`row' = ("${se}")
		qui putexcel E`row' = ("${pval}")
		qui putexcel F`row' = ("${ripval}")
		qui putexcel G`row' = ("${r2}")
		qui putexcel H`row' = ("${n}")
		qui putexcel I`row' = ("${lasso_coef}")
		qui putexcel J`row' = ("${lasso_se}")
		qui putexcel K`row' = ("${lasso_pval}")
		qui putexcel L`row' = ("${lasso_ripval}")
		qui putexcel M`row' = ("${lasso_r2}")
		qui putexcel N`row' = ("${lasso_n}")
		qui putexcel O`row' = ("${lasso_ctls}")
		qui putexcel P`row' = ("${lasso_ctls_num}")
		qui putexcel Q`row' = ("${treat_mean}")
		qui putexcel R`row' = ("${treat_sd}")
		qui putexcel S`row' = ("${ctl_mean}")
		qui putexcel T`row' = ("${ctl_sd}")
		qui putexcel U`row' = ("${vill_sd}")
		qui putexcel V`row' = ("${min}")
		qui putexcel W`row' = ("${max}")
		qui putexcel X`row' = ("${lasso_ctls_replacement}")
		qui putexcel Y`row' = ("${lasso_ctls_num_replacement}")
		
		/* Update locals ___________________________________________________________*/
		
		local row = `row' + 1
		}
}



















