
*	AI.2 outlet characteristics.do

*Comment out any tables that are not relevant to this implementaiton. 

/*This .do file produces 2 tables and outputs them to an excel workbook: 
	I. National level results - i.e. across the whole greogrpahic reach for which the study was designed to be representative.
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
*/

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 

*OUTLET CHARACTERISTICS ARE MEASURED AT OUTLET LEVEL AND SHOULD USE THE OUTLET DAATSET, 
*FOR EXAMPLE:
use "${mngmtdata}/${country}_${year}_outlet_data", clear


*CONFIRM THE CORRECT SURVEY SETTINGS ARE IN PLACE FOR THIS FILE:		 
		 
	 svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc) 
	 svydes

*Droping outlets missing outlet type.
	drop if outcat2==. 

	
*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"



**********

* Generate essential variables for the outlet description analysis: 
gen char2_a=1 if inrange(char2,2020,2024) & char2!=.
lab var char2_a "Outlet established in last 5 years (since 2020)"
recode char2_a (.=0) if char2!=.

recode reg6 (1=1) (else=0)
lab var reg6 "Had a gov't inspection in past year"

gen resale_cust=0
recode resale_cust (0=1) if p32_3==1 | p32_4==1 | p32_5==1
lab var resale_cust "Outlet sells to other outlets/ for resale"


* Recode missing values by zero
recode p32_1 p32_3 p32_4 p32_2 p32_5 (98 . =0)
 


********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************


*table label
	
	local tabname T_i
	
	

	***************
	*FOOTNOTES

	
	*file name and sheet
	putexcel set "${tables}/AI.2 outlet characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 &  screened==1 
					if r(N)==0 {
					count if `y'==1 & screened==1 
					matrix ns=r(N)
						
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=("0")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1			
						
						
						}
		
		else {
					
			estpost svy, subpop(if screened==1  & `y'==1): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(b[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1
		}	
	}
}

/*



********************************************************************************
********************************************************************************
*I. Rural/urban level results
********************************************************************************
********************************************************************************

*table label
	
	local tabname T_ii
	
	
	*file name and sheet
	putexcel set "${tables}/AI.2 outlet characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `z'==1 & screened==1 
					if r(N)==0 {
					count if `y'==1 & `z'==1  &  screened==1 
					matrix ns=r(N)
						
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=("0")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1			
						
						
						}
		
		else {
					
			estpost svy, subpop(if screened==1  & `y'==1 & `z'==1 ): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(b[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1
				}	
			}
		}
	}



**# 
********************************************************************************
********************************************************************************
*III. STRATUM RESULTS
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iii_`s'
	
	
	*file name and sheet
	putexcel set "${tables}/AI.2 outlet characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & screened==1 
					if r(N)==0 {
					count if `y'==1 & `s'==1 & screened==1 
					matrix ns=r(N)
						
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=("0")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1			
						
						
						}
		
		else {
					
			estpost svy, subpop(if screened==1  & `s'==1 & `y'==1): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(b[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1
			}	
		}
	}
}





*# 
********************************************************************************
********************************************************************************
*III. STRATUM/ Rural-Urban RESULTS
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iv_`s'
	
	
	*file name and sheet
	putexcel set "${tables}/AI.2 outlet characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & `z'==1 & screened==1 
					if r(N)==0 {
					count if `y'==1 & `s'==1 & `z'==1  &  screened==1 
					matrix ns=r(N)
						
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=("0")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(".")
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1			
						
						
						}
		
		else {
					
			estpost svy, subpop(if screened==1  & `s'==1 & `y'==1 & `z'==1 ): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(b[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])
			local col=`col'+1
				}	
			}
		}
	}
}
