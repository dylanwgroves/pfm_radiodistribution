

/* Calculate Lasso RI p-value */
									
	local lasso_rip_count = 0
	forval k = 1/${rerandcount} {
		if ${lasso_ctls} != 0 {											// If lassovars selected						
			qui regress `dv' treat_`k' ${cov_always} ${lasso_ctls}
				matrix LASSO_RIP = r(table)
			}
			else if "`lassovars_num'" == "0" {							// If lassovars not selected
				qui regress `dv' treat_`k' ${cov_always}
					matrix RIP = r(table)
			}	
			local lasso_coef_ri = LASSO_RIP[1,1]
				if ${lasso_coef} > 0 {									// One-sided if estimate is positive
					if ${lasso_coef} < `lasso_coef_ri' { 	  
						local lasso_rip_count = `lasso_rip_count' + 1	
					}
				}
				if `lasso_coef' < 0 {									
					if abs(`lasso_coef') < abs(`lasso_coef_ri') { 	  
						local lasso_rip_count = `lasso_rip_count' + 1	
					}
				}
	}