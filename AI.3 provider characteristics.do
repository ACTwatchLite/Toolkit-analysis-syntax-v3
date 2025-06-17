

*	AI.3 provider characteristics

*Comment out any tables that are not relevant to this implementaiton. 


*OUTLET DATASET (I.E. IN LONG FORMAT) SHOULD BE IDENTIFIED HERE, EXAMPLE:

use "${mngmtdata}/${country}_${year}_outlet_data", clear


*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT PRICE RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR II TO IV IS
* ANNOTATED WHERE APPROPRIATE

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 

*CONFIRM THE CORRECT SURVEY SETTINGS ARE IN PLACE FOR THIS FILE:		 
		 
	 svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc) 
	 svydes

*Droping outlets missing outlet type.
	drop if outcat2==. 


***this command ensures that the local macros for outlets, strata and products are available in this do file
include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"


********************************************************************************
********************************************************************************
* Overview results
********************************************************************************
********************************************************************************

***unlike for other standard tables, we will identify the covariates in this 
*do file, not in the local_definitions.doh file


lab var treatNegTestNev  "Would treat a negative test for malaria: Never"
lab var treatNegTestSome "Would treat a negative test for malaria: Sometimes"
lab var treatNegTestAll "Would treat a negative test for malaria: Always"
lab var p21 "Have you ever seen or heard of a malaria rapid diagnostic test (RDT)?"
lab var p22 "While working at this outlet, have you ever tested a client for malaria?"
lab var treatNegTest_1 "When they have signs/symptoms of malaria"


*Description of provider characteristics** 
ds ///
effectiveAM /// knowledge
p21 p22 /// RDT use
treatNegTestNev treatNegTestSome treatNegTestAll treatNegTest_1 treatNegTest_2 treatNegTest_3 /// treat negative test results

local outchar = r(varlist)

tab1 `outchar'
 
 
********************************************************************************
********************************************************************************
* National level
********************************************************************************
********************************************************************************



*table label
	
	local tabname T_iii_`s'
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if  screened==1  & `s'==1 & char4_1==. 
	local footnote1 =r(N)
	
	count if  screened==1  & `s'==1 & healthqual==. 
	local footnote2 =r(N)
	
	count if  screened==1  & `s'==1 & effectiveAM==. 
	local footnote3 =r(N)

	count if  screened==1  & `s'==1 & p21==. 
	local footnote4 =r(N)
	
	count if  screened==1  & `s'==1 & treatNegTestNev==. 
	local footnote5 =r(N)
	
	

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1 
	***store the count to include in footnote?
		local footnote6 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.3 provider characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote - N screened outlets in `s' State missing data for: number of staff at outlet = `footnote1'; health qualifications=`footnote2'; malaria knowledge indicators=`footnote3'; RDT usage=`footnote4'; testing behaviors=`footnote5' ")
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars5' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1  & screened==1 
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
					
			estpost svy, subpop(if screened==1 & `y'==1): tab `x', ci per nototal

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
*  rural/urban level
********************************************************************************
********************************************************************************

 

*table label
	
	local tabname T_ii
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if  screened==1   & char4_1==. 
	local footnote1 =r(N)
	
	count if  screened==1 & healthqual==. 
	local footnote2 =r(N)
	
	count if  screened==1  & effectiveAM==. 
	local footnote3 =r(N)

	count if  screened==1  & p21==. 
	local footnote4 =r(N)
	
	count if  screened==1  & treatNegTestNev==. 
	local footnote5 =r(N)
	
	

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1 
	***store the count to include in footnote?
		local footnote6 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.3 provider characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote - N screened outlets in `s' State missing data for: number of staff at outlet = `footnote1'; health qualifications=`footnote2'; malaria knowledge indicators=`footnote3'; RDT usage=`footnote4'; testing behaviors=`footnote5' ")
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars5' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 &  `z'==1 & screened==1 
					if r(N)==0 {
					count if `y'==1 & screened==1  & `z'==1 
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


 
 
********************************************************************************
********************************************************************************
* Stratum level
********************************************************************************
********************************************************************************

 
foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iii_`s'
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if  screened==1   & char4_1==. 
	local footnote1 =r(N)
	
	count if  screened==1 & healthqual==. 
	local footnote2 =r(N)
	
	count if  screened==1  & effectiveAM==. 
	local footnote3 =r(N)

	count if  screened==1  & p21==. 
	local footnote4 =r(N)
	
	count if  screened==1  & treatNegTestNev==. 
	local footnote5 =r(N)
	
	

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1 
	***store the count to include in footnote?
		local footnote6 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.3 provider characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote - N screened outlets in `s' State missing data for: number of staff at outlet = `footnote1'; health qualifications=`footnote2'; malaria knowledge indicators=`footnote3'; RDT usage=`footnote4'; testing behaviors=`footnote5' ")
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars5' {
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



**

********************************************************************************
********************************************************************************
* Stratum rural/urban level
********************************************************************************
********************************************************************************

 
foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iv_`s'
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if  screened==1   & char4_1==. 
	local footnote1 =r(N)
	
	count if  screened==1 & healthqual==. 
	local footnote2 =r(N)
	
	count if  screened==1  & effectiveAM==. 
	local footnote3 =r(N)

	count if  screened==1  & p21==. 
	local footnote4 =r(N)
	
	count if  screened==1  & treatNegTestNev==. 
	local footnote5 =r(N)
	
	

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1 
	***store the count to include in footnote?
		local footnote6 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/AI.3 provider characteristics_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote - N screened outlets in `s' State missing data for: number of staff at outlet = `footnote1'; health qualifications=`footnote2'; malaria knowledge indicators=`footnote3'; RDT usage=`footnote4'; testing behaviors=`footnote5' ")
	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `outchar' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars5' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & `z'==1 & screened==1 
					if r(N)==0 {
					count if `y'==1 & `s'==1 & screened==1  & `z'==1 
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
