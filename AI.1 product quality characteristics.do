*	AI.1 product quality characteristics.do**

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 


*ANTIMALARIAL DATASET (I.E. IN LONG FORMAT) SHOULD BE IDENTIFIED HERE, EXAMPLE:

use "${mngmtdata}/${country}_${year}_antimalarial_data", clear

*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:

include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"


********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************

*table label
	local tabname T_i

	
	*file name and sheet
	putexcel set "${tables}/AI.1 product quality characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	**tables loop and putexcel output	

		local row=3
		local col=2

	foreach x of varlist `amqual' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'
		
			putexcel A`row'=("`varlabelx'")
		
				qui: count if `x'==1 & `y'==1 & screened==1
					if r(N)==0 {
					count if `y'==1 & screened==1
					matrix ns=r(N)		
			

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabely'")
			
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
			estpost svy, subpop(if screened==1 & `y'==1): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)


			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabely'")

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
*/
*

**# 
********************************************************************************
********************************************************************************
*II. National level resutls by urban/ rural

********************************************************************************
********************************************************************************

local tabname T_ii

		
		
	*file name and sheet
	putexcel set "${tables}/AI.1 product quality characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `amqual' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label	`z'
			
			foreach y of varlist `outvars1' {
			local varlabely :  var label	`y'
		
				qui: count if `x'==1 & `y'==1 & `z'==1 & screened==1
					if r(N)==0 {
					count if `y'==1 & `z'==1 & screened==1
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
					
			estpost svy, subpop(if screened==1 & `z'==1 & `y'==1): tab `x', ci per nototal

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
*/


**# 
********************************************************************************
********************************************************************************
*III. Strata results
********************************************************************************
********************************************************************************

foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iii_`s'
	

	*file name and sheet
	putexcel set "${tables}/AI.1 product quality characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `amqual' {
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




********************************************************************************
********************************************************************************
*IV. Strata resutls by urban/ rural
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {


		*table label
		
local tabname T_iv_`s'		

		*file name and sheet
		putexcel set "${tables}/AI.1 product quality characteristics_$tabver", sheet("`tabname'") modify

		*labels	
		putexcel A1=("`tabname'")
		putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
		putexcel A3=("variable name")
		
		
		***tables output:

			local row=3
			local col=2

		foreach x of varlist `amqual' {
			local row=`row'+1
			local col=2	
			local varlabelx :  var label `x'
			
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'

				foreach y of varlist `outvars1' {
				local varlabely :  var label `y'
				
			
					qui: count if `x'==1 & `y'==1 & `z'==1  & `s'==1 & screened==1
						if r(N)==0 {
					qui: count if `y'==1 & `s'==1 & `z'==1 & screened==1
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
						
				estpost svy, subpop(if screened==1 & `z'==1 & `y'==1 & `s'==1 ): tab `x', ci per nototal

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

		
