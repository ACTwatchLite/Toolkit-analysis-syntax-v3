*AI.4 supplier characteristics

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level results - i.e. across the whole greogrpahic reach for which the study was designed to be representative.
	II. National level results disaggregated by urban/ rural - i.e. if your study is stratified by urban/rural, the II results show that disaggregation
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
	IV. Results by strata dissagregated by urban/ rural - i.e. other geographical stratification (eg. region/ state) and urban/rural
*/

*Comment out any tables that are not relevant to this implementation using /* */ 

*SUPPLIER CHARACTERISTICS IS MEASURED AT THE OUTLET LEVEL. 
*OUTLET DATASET SHOULD BE IDENTIFIED HERE, 
*EXAMPLE: 
use "${mngmtdata}/${country}_${year}_outlet_data", clear

*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file

*EXAMPLE: 
include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"

*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT AVAILABILTY RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR II TO IV IS
* ANNOTATED WHERE APPROPRIATE

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 





********************************************************************************
********************************************************************************
*OVERALL RESULTS FOR SUPPLY CHAIN DIAGRAM 
***************************************************
********************************************************************************



********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************



*table label
	
	local tabname T_i
	
	
	***************
	*FOOTNOTES

	*Footnote: outlets eligible forthe full study but who did not provide any supplier information: 
	count if eligible==1 & sa1==.
	***store the count to include in footnote
		local footnote1 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.4 supplier characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Footnote - N eligible outlets missing data for supplier characteristics = `footnote1' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `suppvar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1  & screened==1 & sa1!=.
					if r(N)==0 {
					count if `y'==1 & screened==1 & sa1!=.
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
					
			estpost svy, subpop(if screened==1   & `y'==1 & sa1!=.): tab `x', ci per nototal

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




********************************************************************************
********************************************************************************
*I. Rural/urban results
********************************************************************************
********************************************************************************

*table label
	
	local tabname T_ii
	
	***************
	*FOOTNOTES

	*Footnote: outlets eligible forthe full study but who did not provide any supplier information: 
	*RURAL
	count if eligible==1 & sa1==. & Ru1==1
	***store the count to include in footnote?
	local footnote1 =r(N)
	
	*URBAN
	count if eligible==1 & sa1==. & Ru2==1
	***store the count to include in footnote?
	local footnote2 =r(N)
	
	
	
	*file name and sheet
	putexcel set "${tables}/AI.4 supplier characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Rural Footnote - N eligible outlets missing data for supplier characteristics = `footnote1' ")
	putexcel D1= ("Urban Footnote - N eligible outlets missing data for supplier characteristics = `footnote2' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `suppvar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
			local varlabelz :  var label `z'

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `z'==1 & screened==1 & sa1!=.
					if r(N)==0 {
					count if `y'==1  & `z'==1 & screened==1 & sa1!=.
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
					
			estpost svy, subpop(if screened==1  & `z'==1  & `y'==1 & sa1!=.): tab `x', ci per nototal

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

										// the only difference in this table is that the whole analysis loops over each stratum to create a separate tab in the final excel output (i.e. foreach s of varlist abia kano lagos...)


*table label
 
foreach s of varlist `stratumlist' {

	local tabname T_iii_`s'
	
	
	***************
	*FOOTNOTES

	*Footnote: outlets eligible forthe full study but who did not provide any supplier information: 
	count if eligible==1 & sa1==. & `s'==1
	***store the count to include in footnote?
		local footnote1 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.4 supplier characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote - N eligible outlets missing data for supplier characteristics = `footnote1' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `suppvar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & screened==1 & sa1!=.
					if r(N)==0 {
					count if `y'==1 & screened==1 & `s'==1 & sa1!=.
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
					
			estpost svy, subpop(if screened==1 & `y'==1 & `s'==1 & sa1!=.): tab `x', ci per nototal

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
*IV. Strata results by urban/ rural
********************************************************************************
********************************************************************************
										// the only difference in this table is that the whole analysis loops over each stratum to create a separate tab in the final excel output (i.e. foreach s of varlist abia kano lagos...)
										// and also includes the rural/urban loop (as in table II)

foreach s of varlist `stratumlist' {
*table label
	
	local tabname T_iv_`s'
	
	***************
	*FOOTNOTES

	*Footnote: outlets eligible forthe full study but who did not provide any supplier information: 
	*RURAL
	count if eligible==1 & sa1==. & Ru1==1 & `s'==1
	***store the count to include in footnote
	local footnote1 =r(N)
	
	*URBAN
	count if eligible==1 & sa1==. & Ru2==1 & `s'==1
	***store the count to include in footnote
	local footnote2 =r(N)
	
	
	
	*file name and sheet
	putexcel set "${tables}/AI.4 supplier characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Rural `s' Footnote - N eligible outlets missing data for supplier characteristics = `footnote1' ")
	putexcel D1= ("Urban `s' Footnote - N eligible outlets missing data for supplier characteristics = `footnote2' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `suppvar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
			local varlabelz :  var label `z'

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `z'==1 & screened==1 & sa1!=. & `s'==1
					if r(N)==0 {
					count if `y'==1  & `z'==1 & screened==1 & sa1!=. & `s'==1
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
					
			estpost svy, subpop(if screened==1  & `z'==1  & `y'==1 & sa1!=. & `s'==1): tab `x', ci per nototal

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


*ends





