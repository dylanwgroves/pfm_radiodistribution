
/* Calculate RI p-value */

if "$test" == "onesided" {

	/* one sided */
	local rip_count = 0
	forval j = 1 / $rerandcount {
	
		qui xi: reg $dv treat_`j' ${cov_always}
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
	
		qui xi: reg $dv treat_`j' ${cov_always}
			matrix RIP = r(table)
			local coef_ri = RIP[1,1]
			
			if abs(${coef}) < abs(`coef_ri') { 	  
				local rip_count = `rip_count' + 1	
			}
	}
}

	global helper_ripval = `rip_count' / $rerandcount
		
	