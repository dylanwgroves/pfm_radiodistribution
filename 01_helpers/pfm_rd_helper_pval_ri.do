	
/* Calculate RI p-value */


merge 1:1 id_resp_uid using "${user}/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_ri.dta", gen(l_merge)
	keep if l_merge == 3
	keep if !missing(rd_treat_1)

	
if "$test" == "onesided" {

	/* one sided */
	local rip_count = 0
	forval j = 1 / $rerandcount {
	
		qui xi: reg $dv rd_treat_`j' ${cov_always}
			matrix RIP = r(table)
			local coef_ri = RIP[1,1]
			if ${coef} < `coef_ri' { 	  
					local rip_count = `rip_count' + 1	
			}
	}	
}


if "$test" == "twosided" {

	/* two sided */
	local rip_count = 0
	forval j = 1 / $rerandcount {
	
		qui xi: reg $dv rd_treat_`j' ${cov_always}
			matrix RIP = r(table)
			local coef_ri = RIP[1,1]
			
			if abs(${coef}) < abs(`coef_ri') { 	  
				local rip_count = `rip_count' + 1	
			}
	}
}
	
	
	drop rd_treat_* l_merge 
	global helper_ripval = `rip_count' / $rerandcount
		
	

	
use "${user}/Dropbox/Wellspring Tanzania Papers/Wellspring Tanzania - Radio Distribution/01 Data/pfm_rd_ri.dta", clear