

/* Calculate Lasso RI p-value */
merge 1:1 id_resp_uid using "${user}/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_ri.dta", gen(l_merge)
	keep if l_merge == 3
	keep if !missing(rd_treat_1)

	
/* one-sided */
if "$test" == "onesided" {

									
	local lasso_rip_count = 0
	forval k = 1/$rerandcount {
		
		if ${lasso_ctls_num} != 0 {											// If lassovars selected						
			qui regress $dv rd_treat_`k' ${cov_always} ${lasso_ctls}
				matrix LASSO_RIP = r(table)
			}
			
			else if ${lasso_ctls_num} == 0 {							// If lassovars not selected
				qui regress $dv rd_treat_`k' ${cov_always}
					matrix LASSO_RIP = r(table)
			}	
			
			local lasso_coef_ri = LASSO_RIP[1,1]
				
			if ${lasso_coef} < `lasso_coef_ri' { 	  
					local lasso_rip_count = `lasso_rip_count' + 1	
			}
	di "`k'"
	}
}


/* two-sided */

if "$test" == "twosided" {

									
	local lasso_rip_count = 0
	forval k = 1/$rerandcount {
		
		if ${lasso_ctls_num} != 0 {											// If lassovars selected						
			qui regress $dv rd_treat_`k' ${cov_always} ${lasso_ctls}
				matrix LASSO_RIP = r(table)
			}
			
			else if ${lasso_ctls_num} == 0 {							// If lassovars not selected
				qui regress $dv rd_treat_`k' ${cov_always}
					matrix LASSO_RIP = r(table)
			}	
			
			local lasso_coef_ri = LASSO_RIP[1,1]
							
			if abs(${lasso_coef}) < abs(`lasso_coef_ri') { 	  
						local lasso_rip_count = `lasso_rip_count' + 1	
			}
	di "`k'"		
	}
}

	drop rd_treat_* l_merge
	global helper_lasso_ripval = `lasso_rip_count' / $rerandcount
	
