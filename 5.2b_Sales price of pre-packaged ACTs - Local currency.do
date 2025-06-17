*	3		Price
*	3.2		Purchase price of pre-packaged ACTs **in local currency and USD**

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 


*PRICE OF PRODUCTS IS MEASURED AT THE PRODUCT LEVEL. 
*PRODUCT DATASET (I.E. IN LONG FORMAT) SHOULD BE IDENTIFIED HERE, EXAMPLE:
use "${mngmtdata}/${country}_${year}_full_data", clear


*
*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:

include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"


*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT PRICE RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE OF THIS TYPE IN 3.1a Purchase price of antimalarial AETDs in USD.do
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR I TO IV IN THIS FILE IS
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


*IN USD 


*NAME THE LOCAL MACRO FOR THIS ANALYSIS AND SUB-GROUP (SHOULD MATCH INDICATOR TABLE)
*table label
	local tabname T_i	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta packagePrice if qaal_1==1 & packagePrice==., m
			return list
				local footnote1 =r(N)
		ta packagePrice if qaal_2==1 & packagePrice==., m
		return list
				local footnote2 =r(N)
		ta packagePrice if qaal_3==1 & packagePrice==., m
		return list
				local footnote3 =r(N)
		ta packagePrice if qaal_4==1 & packagePrice==., m
		return list
				local footnote4 =r(N)	
		ta packagePrice if nqaal_1==1 & packagePrice==., m
		return list
				local footnote5 =r(N)
		ta packagePrice if nqaal_2==1 & packagePrice==., m
		return list
				local footnote6 =r(N)
		ta packagePrice if nqaal_3==1 & packagePrice==., m
		return list
				local footnote7 =r(N)
		ta packagePrice if nqaal_4==1 & packagePrice==., m
		return list
				local footnote8 =r(N)
	
	
	*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 
	*file name and sheet
	putexcel set "${tables}/5.2b_Sales price of pre-pack ACTs to customer local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	*WRITING THE RESULTS OF THE COUNTS FOR FOOTNOTES INTO THE EXCEL FILE HERE. ENSURE THE OUTLET TYPES MATCH THE ONES IDENITIFIED ABOVE.	
	putexcel C1= ("Footnote: products with missing price data for the following: QA AL pack size 1:`footnote1'; QA AL pack size 2:`footnote2'; QA AL pack size 3:`footnote3'; QA AL pack size 4:`footnote4'; non-QA AL pack size 1:`footnote5'; non-QA AL pack size 2:`footnote6'; non-QA AL pack size 3:`footnote7'; non-QA AL pack size 4:`footnote8' ")

	
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `pp_cov' {				// pack price variables, defined in local_definitions.doh
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile packagePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & packagePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 & a3==1 & packagePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}
	

	
	
**# 
********************************************************************************
********************************************************************************
*II. National level resutls by urban/ rural
********************************************************************************
********************************************************************************

*table label
	local tabname T_ii	

	
	**********
	*FOOTNOTES
*RURAL
	*missing prices for: 	
		ta packagePrice if qaal_1==1 & packagePrice==. & Ru1==1
			return list
				local footnote1 =r(N)
		ta packagePrice if qaal_2==1 & packagePrice==. & Ru1==1
		return list
				local footnote2 =r(N)
		ta packagePrice if qaal_3==1 & packagePrice==. & Ru1==1
		return list
				local footnote3 =r(N)
		ta packagePrice if qaal_4==1 & packagePrice==. & Ru1==1
		return list
				local footnote4 =r(N)	
		ta packagePrice if nqaal_1==1 & packagePrice==. & Ru1==1
		return list
				local footnote5 =r(N)
		ta packagePrice if nqaal_2==1 & packagePrice==. & Ru1==1
		return list
				local footnote6 =r(N)
		ta packagePrice if nqaal_3==1 & packagePrice==. & Ru1==1
		return list
				local footnote7 =r(N)
		ta packagePrice if nqaal_4==1 & packagePrice==. & Ru1==1
		return list
				local footnote8 =r(N)
*URBAN
*missing prices for: 	
		ta packagePrice if qaal_1==1 & packagePrice==. & Ru2==1
			return list
				local footnote9 =r(N)
		ta packagePrice if qaal_2==1 & packagePrice==. & Ru2==1
		return list
				local footnote10 =r(N)
		ta packagePrice if qaal_3==1 & packagePrice==. & Ru2==1
		return list
				local footnote11 =r(N)
		ta packagePrice if qaal_4==1 & packagePrice==. & Ru2==1
		return list
				local footnote12 =r(N)	
		ta packagePrice if nqaal_1==1 & packagePrice==. & Ru2==1
		return list
				local footnote13 =r(N)
		ta packagePrice if nqaal_2==1 & packagePrice==. & Ru2==1
		return list
				local footnote14 =r(N)
		ta packagePrice if nqaal_3==1 & packagePrice==. & Ru2==1
		return list
				local footnote15 =r(N)
		ta packagePrice if nqaal_4==1 & packagePrice==. & Ru2==1
		return list
				local footnote15 =r(N)
				
	
	*file name and sheet
	putexcel set "${tables}/5.2b_Sales price of pre-pack ACTs to customer local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote: products with missing price data for the following: QA AL pack size 1:`footnote1'; QA AL pack size 2:`footnote2'; QA AL pack size 3:`footnote3'; QA AL pack size 4:`footnote4'; non-QA AL pack size 1:`footnote5'; non-QA AL pack size 2:`footnote6'; non-QA AL pack size 3:`footnote7'; non-QA AL pack size 4:`footnote8'")

	putexcel D1= ("Urban Footnote: products with missing price data for the following: QA AL pack size 1:`footnote9'; QA AL pack size 2:`footnote10'; QA AL pack size 3:`footnote11'; QA AL pack size 4:`footnote12'; non-QA AL pack size 1:`footnote13'; non-QA AL pack size 2:`footnote14'; non-QA AL pack size 3:`footnote15'; non-QA AL pack size 4:`footnote16'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pp_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'

		_pctile packagePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1 & packagePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 & a3==1 & packagePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


}

	
**# 
********************************************************************************
********************************************************************************
*III. Strata resutls
********************************************************************************
********************************************************************************

foreach s of varlist `stratumlist' {


		*table label
		
local tabname T_iii_`s'		

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta packagePrice if qaal_1==1 & `s'==1 & packagePrice==., m
			return list
				local footnote1 =r(N)
		ta packagePrice if qaal_2==1 & `s'==1 & packagePrice==., m
		return list
				local footnote2 =r(N)
		ta packagePrice if qaal_3==1 & `s'==1 & packagePrice==., m
		return list
				local footnote3 =r(N)
		ta packagePrice if qaal_4==1 & `s'==1 & packagePrice==., m
		return list
				local footnote4 =r(N)	
		ta packagePrice if nqaal_1==1 & `s'==1 & packagePrice==., m
		return list
				local footnote5 =r(N)
		ta packagePrice if nqaal_2==1 & `s'==1 & packagePrice==., m
		return list
				local footnote6 =r(N)
		ta packagePrice if nqaal_3==1 & `s'==1 & packagePrice==., m
		return list
				local footnote7 =r(N)
		ta packagePrice if nqaal_4==1 & `s'==1 & packagePrice==., m
		return list
				local footnote8 =r(N)
		
	
	*file name and sheet
	putexcel set "${tables}/5.2b_Sales price of pre-pack ACTs to customer local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")

	
	putexcel C1= ("`s' Footnote: products with missing price data for the following: QA AL pack size 1:`footnote1'; QA AL pack size 2:`footnote2'; QA AL pack size 3:`footnote3'; QA AL pack size 4:`footnote4'; non-QA AL pack size 1:`footnote5'; non-QA AL pack size 2:`footnote6'; non-QA AL pack size 3:`footnote7'; non-QA AL pack size 4:`footnote8' ")


	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pp_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'
	
		_pctile packagePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & packagePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 &`s'==1 & countprod==1 & packagePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}
}
**# 
********************************************************************************
********************************************************************************
*IV. Strata resutls by urban/ rural
********************************************************************************
********************************************************************************	
	
	
foreach s of varlist `stratumlist' {

		*table label
		
local tabname T_iv_`s'	

	*FOOTNOTES
*RURAL
	*missing prices for: 	
		ta packagePrice if qaal_1==1 & packagePrice==. & Ru1==1 & `s'==1
			return list
				local footnote1 =r(N)
		ta packagePrice if qaal_2==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote2 =r(N)
		ta packagePrice if qaal_3==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote3 =r(N)
		ta packagePrice if qaal_4==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote4 =r(N)	
		ta packagePrice if nqaal_1==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote5 =r(N)
		ta packagePrice if nqaal_2==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote6 =r(N)
		ta packagePrice if nqaal_3==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote7 =r(N)
		ta packagePrice if nqaal_4==1 & packagePrice==. & Ru1==1 & `s'==1
		return list
				local footnote8 =r(N)
*URBAN
*missing prices for: 	
		ta packagePrice if qaal_1==1 & packagePrice==. & Ru2==1 & `s'==1
			return list
				local footnote9 =r(N)
		ta packagePrice if qaal_2==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote10 =r(N)
		ta packagePrice if qaal_3==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote11 =r(N)
		ta packagePrice if qaal_4==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote12 =r(N)	
		ta packagePrice if nqaal_1==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote13 =r(N)
		ta packagePrice if nqaal_2==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote14 =r(N)
		ta packagePrice if nqaal_3==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote15 =r(N)
		ta packagePrice if nqaal_4==1 & packagePrice==. & Ru2==1 & `s'==1
		return list
				local footnote15 =r(N)
				

	
	*file name and sheet
	putexcel set "${tables}/5.2b_Sales price of pre-pack ACTs to customer local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote: products with missing price data for the following: QA AL pack size 1:`footnote1'; QA AL pack size 2:`footnote2'; QA AL pack size 3:`footnote3'; QA AL pack size 4:`footnote4'; non-QA AL pack size 1:`footnote5'; non-QA AL pack size 2:`footnote6'; non-QA AL pack size 3:`footnote7'; non-QA AL pack size 4:`footnote8'")

	putexcel D1= ("Urban `s' Footnote: products with missing price data for the following: QA AL pack size 1:`footnote9'; QA AL pack size 2:`footnote10'; QA AL pack size 3:`footnote11'; QA AL pack size 4:`footnote12'; non-QA AL pack size 1:`footnote13'; non-QA AL pack size 2:`footnote14'; non-QA AL pack size 3:`footnote15'; non-QA AL pack size 4:`footnote16'")



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `pp_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'

		_pctile packagePrice [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1 &`s'==1 & packagePrice!=., p(25, 50, 75)

			
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
			
			count if `y'==1 & `x'==1 & `z'==1  &`s'==1 & countprod==1 & packagePrice!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
			}	
		}
	}
}
	
	
	*ends*
