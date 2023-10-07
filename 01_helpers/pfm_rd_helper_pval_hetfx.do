
* Main Test 

if "$test" == "onesided" {

	/* Calculate one-side pvalue */
	if $coef > 0 {
		global helper_pval = ttail(${df},abs(${t})) 
	}
	else if $coef < 0 {
		global helper_pval = 1-ttail(${df},abs(${t}))
	}

}
	
if "$test" == "twosided" {

	/* Calculate two-side pvalue */
	global helper_pval = 2*ttail(${df},abs(${t})) 

}

* Covariate Test

if "${c_test}" == "onesided" {

	/* Calculate one-side pvalue */
	if ${c_coef} > 0 {
		global c_helper_pval = ttail(${df},abs(${c_t})) 
	}
	else if ${c_coef} < 0 {
		global c_helper_pval = 1-ttail(${df},abs(${c_t}))
	}

}
	
if "${c_test}" == "twosided" {

	/* Calculate two-side pvalue */
	global c_helper_pval = 2*ttail(${df},abs(${c_t})) 

}


* Interaction Test

if "${x_test}" == "onesided" {

	/* Calculate one-side pvalue */
	if ${x_coef} > 0 {
		global x_helper_pval = ttail(${df},abs(${x_t})) 
	}
	else if ${x_coef} < 0 {
		global x_helper_pval = 1-ttail(${df},abs(${x_t}))
	}

}
	
if "${x_test}" == "twosided" {

	/* Calculate two-side pvalue */
	global x_helper_pval = 2*ttail(${df},abs(${x_t})) 

}


* Margins Test

if "${test}" == "onesided" {

	/* Calculate one-side pvalue */
	if ${m_coef} > 0 {
		global m_helper_pval = ttail(${df},abs(${m_t})) 
	}
	else if ${m_coef} < 0 {
		global m_helper_pval = 1-ttail(${df},abs(${m_t}))
	}

}
	
if "${x_test}" == "twosided" {

	/* Calculate two-side pvalue */
	global m_helper_pval = 2*ttail(${df},abs(${m_t})) 

}

