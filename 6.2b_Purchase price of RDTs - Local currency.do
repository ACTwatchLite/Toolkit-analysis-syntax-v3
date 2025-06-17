*	3		Price
*	3.1		Purchase price of antimalarial AETDs **in local currency and USD**

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 

clear

*PRICE OF PRODUCTS IS MEASURED AT THE PRODUCT LEVEL. 
*PRODUCT DATASET (I.E. IN LONG FORMAT) SHOULD BE IDENTIFIED HERE, EXAMPLE:
use "${mngmtdata}/${country}_${year}_full_data", clear


*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"

include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"


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

	
**ensuring RDTs included
	cap drop countprod
	gen countprod=1 if anyAM==1
	recode countprod (.=1) if rdt_true==1


**ENSURE THAT ALL OUTLETS INCLUDED IN THIS ANALYSIS ARE CODED AS EITHER 1 OR 0 FOR THIS ANALYSIS (I.E. NO MISSING VALUES)		
foreach v of varlist `outvars1' {
 recode `v' (.=0) if countprod==1 
 }

	

**# 
********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

*table label
	
	local tabname T_i	
	

	*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 	
	*file name and sheet
	putexcel set "${tables}/6.2_Purchase price of RDTs from suppliers_$tabver", sheet("`tabname'") modify

	
	*ADDING LABELS AND INFORMAITON TO BE WRITTEN TO THE EXCEL FILE
	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 // COUNTS THE NUMBER OF OUTLETS THAT DID NOT COMPLETE A FULL INTERVIEW
	return list
	local footnote1 =r(N) // SAVES THAT RESULT TO A LOCAL MACRO CALLED FOOTNOTE1


	count if anyAM==1 & unitRdtWholePrice==. // COUNTS THE N PRODUCTS MISSING PRICE DATA
	return list
	local footnote2 =r(N) // SAVES THAT RESULT TO A LOCAL MACRO CALLED FOOTNOTE2
	
	
	*WRITING THE RESULTS OF THE COUNTS FOR FOOTNOTES INTO THE EXCEL FILE HERE. ENSURE THE OUTLET TYPES MATCH THE ONES IDENITIFIED ABOVE.
	putexcel C1= ("Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")



	* THE NEXT SECTION ANALYSES THE WEIGHTED DATA AT PRODUCT LEVEL AND WRITES THE RESULTS TO THE EXCEL OUTPUT FILE.
	* IT SHOULD NOT REQUIRE ANY MODIFICATIONS. 
	
	*TABLES ANALYSIS AND OUTPUT:

	*note that providing the variables and datasets have been correctly set up, no changes should be made to the below syntax:
	
	*this code loops over each type of product (x) and outlet (y), and prints results to excel, calculating and saving weighted median (p50 - 50th percentile), interquartile range (p25 and p75), and N for each product-outlet
	*combination. Products are listed in the excel on rows, outlets in columns. 
	
	* See detail on comments in the 3.1 a do-file
	
		local row=3
		local col=2

		

		foreach x of varlist `rdtvars' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile unitRdtWholePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & unitRdtWholePrice!=., p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & a3==1 & unitRdtWholePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
	
**# 
********************************************************************************
********************************************************************************
*I. Rura/Urban level resutls
********************************************************************************
********************************************************************************

*IN LOCAL CURRENCY

*table label
	local tabname T_ii	

	*file name and sheet
	putexcel set "${tables}/6.2_Purchase price of RDTs from suppliers_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & Ru1==1 
	return list
	local footnote1 =r(N)


	count if anyAM==1 & unitRdtWholePrice==.  & Ru1==1 
	return list
	local footnote2 =r(N)
	

	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & Ru2==1 
	return list
	local footnote3 =r(N)


	count if anyAM==1 & unitRdtWholePrice==.  & Ru2==1 
	return list
	local footnote4 =r(N)

	
	
	putexcel C1= ("Rural Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N Antimalarial products audited but missing price information = `footnote2'")

	putexcel D1= ("Urban Footnote: Prices are per AETD of tablet formulations only. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote3'; N Antimalarial products audited but missing price information = `footnote4'")

	

	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `rdtvars' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'
		

		_pctile unitRdtWholePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1 & unitRdtWholePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 & a3==1 & unitRdtWholePrice!=.

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
	putexcel set "${tables}/6.2_Purchase price of RDTs from suppliers_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Median price") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	***store the count to include in footnote?
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & eligible==1 &`s'==1
	return list
	local footnote1 =r(N)


	count if rdt_true==1 & unitRdtWholePrice==. 
	return list
	local footnote2 =r(N)
	
	
	putexcel C1= ("`s' Footnote: Prices are per RDT. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N RDT products audited but missing price information = `footnote2'")



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `rdtvars' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'
		
		_pctile unitRdtWholePrice [pw=wt_allOutlet] if `y'==1 & `x'==1  & `s'==1 &  unitRdtWholePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 & `s'==1 & countprod==1 & unitRdtWholePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


}
	
	
	
	
	
********************************************************************************
********************************************************************************
*I. Rural/Urban & State level resutls
********************************************************************************
********************************************************************************

*IN USD 

foreach s of varlist `stratumlist' {

		*table label
		
local tabname T_iv_`s'
 

	
	*file name and sheet
	putexcel set "${tables}/6.2_Purchase price of RDTs from suppliers_$tabver", sheet("`tabname'") modify

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

	
	putexcel C1= ("Rural `s' Footnote: Prices are per RDT. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote1'; N RDT products audited but missing price information = `footnote2'")

	putexcel D1= ("Urban `s' Footnote: Prices are per RDT. N outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote3'; N RDT products audited but missing price information = `footnote4'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `rdtvars' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile unitRdtWholePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1  & `s'==1 & unitRdtWholePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1  & `s'==1 & countprod==1 & unitRdtWholePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
				}	
			}
		}
	}
	
*ends*
