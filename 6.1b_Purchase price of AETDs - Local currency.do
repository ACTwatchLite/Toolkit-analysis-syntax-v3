*	3		Price
*	3.1		Purchase price of antimalarial AETDs **in local currency**

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 

clear

use "${mngmtdata}/${country}_${year}_full_data", clear

***this command ensures that the local macros for outlets, strata and products are available in this do file
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"


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

*Subset to tablet formulations ONLY
	/*!!!This table only includes tablet formulations. Before proceeding it is very important that all variables are restricted to the type of formulation
		 that the variable is intended to represent (e.g. tablet, syrup, suspension).*/
		keep if a3==1 

		
**ENSURE THAT ALL OUTLETS INCLUDED IN THSI ANALYSIS ARE CODED AS EITHER 1 OR 0 FOR THIS ANALYSIS (I.E. NO MISSING VALUES)		
foreach v of varlist `outvars1' {
 recode `v' (.=0) if countprod==1 
 }

	
		 
**# 
********************************************************************************
********************************************************************************
*I. National level resutls
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

*table label
	
	local tabname T_i	
	
	
	*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 
	*file name and sheet
	putexcel set "${tables}/6.1_Purchase price of AETDs from suppliers_$tabver", sheet("`tabname'") modify

	*ADDING LABELS AND INFORMAITON TO BE WRITTEN TO THE EXCEL FILE
	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1
	return list
	local footnote1 =r(N) // SAVES THAT RESULT TO A LOCAL MACRO CALLED FOOTNOTE1


	count if anyAM==1 & suppriceperaetd==. 
	return list
	local footnote2 =r(N) // SAVES THAT RESULT TO A LOCAL MACRO CALLED FOOTNOTE2
	
	
	putexcel C1= ("Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist `pri_cov' { 			// the local pri_cov is the list of covariates for the price analysis (i.e. product types, etc), identified in the local_definitions.doh file. This loops the code over each covariate x
		local row=`row'+1 							// adds 1  to the current value for row
		local col=2	 								// ensures that each loop starts on column 2 in excel

		local varlabelx :  var label `x'			 // creates a macro for variable labels for x (x is the list of covariates, defined above)

		
		foreach y of varlist `outvars1' { 			// this loops the code over each outlet type, defined by the local macro outvars1 which can be found in the local_definitions.doh file.
		local varlabely :  var label `y' 			// creates a macro for variable labels for y (y is the list of outlets, defined above)
		
	
		_pctile suppriceperaetd [pw=wt_allOutlet] if `y'==1 & `x'==1 & suppriceperaetd!=., p(25, 50, 75)
													// the above line of code is the analysis of the weighted 25th, 50th and 75th percentiles for price of x product in y outlet among non-missing price values, ou
			
			putexcel A`row'=("`varlabelx'")
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabely'")
													// here we are adding the y variable label to the location where the results for that outlet will be put in excel i.e. [column],row2

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2)) 		// r(r2) is what Stata stores the 50th percentile as, and this result is then put into the excel in the location indicated by the local macros alphacol and row
			local col=`col'+1 						// this adds one to the column number so that the next result is put into the next column
			

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1)) 		// r(r1) is the 25th percentile
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3)) 		// r(r3) is the 75th percentile
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & a3==1 & suppriceperaetd!=.
													// this line counts the N product x with non-missing price data in outlet type y

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))			 // r(N) is the N products
			local col=`col'+1
		}	
	}

	
	
**# 
********************************************************************************
********************************************************************************
*I. Rural/Urban level resutls
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

*table label
	local tabname T_ii	
	
	
	*file name and sheet // Change table according to rural/urban level
	putexcel set "${tables}/6.1_Purchase price of AETDs from suppliers_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & Ru1==1 
	return list
	local footnote1 =r(N)


	count if anyAM==1 & suppriceperaetd==. & Ru1==1 
	return list
	local footnote2 =r(N)
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & Ru2==1 
	return list
	local footnote3 =r(N)


	count if anyAM==1 & suppriceperaetd==. & Ru2==1 
	return list
	local footnote4 =r(N)
	
	
	putexcel C1= ("Rural Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")

	putexcel D1= ("Urban Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote3'; N Antimalarial products audited but missing price information = `footnote4'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pri_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile suppriceperaetd [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1 & suppriceperaetd!=., p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & a3==1 & suppriceperaetd!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


}
	
	
	
**# 
********************************************************************************
********************************************************************************
*III. State level resutls
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

foreach s of varlist `stratumlist' {


		*table label
		
local tabname T_iii_`s'		

	
	*file name and sheet
	putexcel set "${tables}/6.1_Purchase price of AETDs from suppliers_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 &`s'==1
	return list
	local footnote1 =r(N)


	count if anyAM==1 & suppriceperaetd==. 
	return list
	local footnote2 =r(N)
	
	
	putexcel C1= ("`s' Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pri_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'
		
		_pctile suppriceperaetd [pw=wt_allOutlet] if `y'==1 & `x'==1  & `s'==1 &  suppriceperaetd!=., p(25, 50, 75)
			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & `s'==1 & countprod==1 & suppriceperaetd!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}
}
	
	
	
	
	
**# 
********************************************************************************
********************************************************************************
*I. Rural/Urban & State level resutls
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

// the only difference in this table is that the whole analysis loops over each stratum to create a separate tab in the final excel output (i.e. foreach s of varlist abia kano lagos...)
// and also includes the rural/urban loop (as in table II)

foreach s of varlist `stratumlist' {

		*table label
		
local tabname T_iv_`s'
 

	
	*file name and sheet
	putexcel set "${tables}/6.1_Purchase price of AETDs from suppliers_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & `s'==1 & Ru1==1
	return list
	local footnote1 =r(N)


	count if anyAM==1 & suppriceperaetd==. & Ru1==1
	return list
	local footnote2 =r(N)
	
		***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & `s'==1 & Ru2==1
	return list
	local footnote3 =r(N)


	count if anyAM==1 & suppriceperaetd==. & Ru2==1
	return list
	local footnote4 =r(N)

	
	
	putexcel C1= ("Rural `s' Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")
	
	putexcel D1= ("Urban `s' Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote3'; N Antimalarial products audited but missing price information = `footnote4'")



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pri_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile suppriceperaetd [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1  & `s'==1 & suppriceperaetd!=., p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1  & `s'==1 & countprod==1 & suppriceperaetd!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
				}	
			}
		}
	}
	
*ends*
