*	3		Price
*	3.3 	Purchase price of malaria blood testing **in local currency and USD**

*Comment out any tables that are not relevant to this implementation. 

clear


*PRICE OF PRODUCTS IS MEASURED AT THE PRODUCT LEVEL. 
*PRODUCT DATASET (I.E. IN LONG FORMAT) SHOULD BE IDENTIFIED HERE, EXAMPLE:	
use "${mngmtdata}/${country}_${year}_rdt_micro_data", clear


	 svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc) 
	 svydes
	
*Droping outlets missing outlet type.
	drop if outcat2==. 
	
***this command ensures that the local macros for outlets, strata and products are available in this do file
**NOTE THIS IS A DIFFERENT LOCAL DEFINITIONS FILE SPECIFIC TO DIAGNOSTICS
include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"


*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT PRICE RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR II TO IV IS
* ANNOTATED WHERE APPROPRIATE

**NOTE THIS DO FILE DIFFERS FROM OTHER PRICE DO FILES IN THAT IT OUTPUTS A SEPARATE EXCEL
*TAB FOR EACH PRODUCT TYPE
*THIS IS BECAUSE EACH DIAGNOSTIC PRODUCT MAY HAVE MORE THAN ONE PRICE VALUE (I.E.
* TAKE AWAY OR USE IN OUTLET, ADULT VS CHILD COST, ETC. 


* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 

*CONFIRM THE CORRECT SURVEY SETTINGS ARE IN PLACE FOR THIS FILE:		 
	 svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc) 
	 svydes

*Droping outlets missing outlet type.
	drop if outcat2==. 


**ENSURE THAT ALL OUTLETS INCLUDED IN THIS ANALYSIS ARE CODED AS EITHER 1 OR 0 FOR THIS ANALYSIS (I.E. NO MISSING VALUES)		
foreach v of varlist `outvars1' {
 recode `v' (.=0) if countprod==1 
 }

 

**# 
********************************************************************************
********************************************************************************
*I. National level resutls
********************************************************************************
********************************************************************************

*ADULT MICROSCOPY
*table label
	local tabname T_i_mic_ad	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==., m
			return list
				local footnote1 =r(N)
	 
	
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote: products with missing price data for adult microscopy:`footnote1'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pptestAdultTotal [pw=wt_allOutlet] if `y'==1 & `x'==1 & pptestAdultTotal!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult microscopy")

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
			
			count if `y'==1 & `x'==1 & pptestAdultTotal!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****CHILD MICROSCOPY
*table label
	local tabname T_i_mic_ch	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta uspptestChildTotalDC if microscopy==1 & uspptestChildTotalDC==., m
			return list
				local footnote1 =r(N)
		

	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote: products with missing price data for child microscopy:`footnote1'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile uspptestChildTotalDC [pw=wt_allOutlet] if `y'==1 & `x'==1 & uspptestChildTotalDC!=., p(25, 50, 75)

			
			putexcel A`row'=("Child Microscopy")

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
			
			count if `y'==1 & `x'==1 & uspptestChildTotalDC!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


	
	
*ADULT RDT in outlet  
*table label
	local tabname T_i_rdt_in	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultOutlet if rdt_true==1 & pprdtAdultOutlet==., m
			return list
				local footnote1 =r(N)
		

	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote: products with missing price data for adult RDT within outlet:`footnote1'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultOutlet [pw=wt_allOutlet] if `y'==1 & `x'==1 & pprdtAdultOutlet!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT in outlet")

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
			
			count if `y'==1 & `x'==1 & pprdtAdultOutlet!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****ADULT RDT TAKE AWAY
*table label
	local tabname T_i_rdt_ta	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultAway if rdt_true==1 & pprdtAdultAway==., m
			return list
				local footnote1 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote: products with missing price data for adult RDT take away:`footnote1'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultAway [pw=wt_allOutlet] if `y'==1 & `x'==1 & pprdtAdultAway!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT take away")

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
			
			count if `y'==1 & `x'==1 & pprdtAdultAway!=.

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

*ADULT MICROSCOPY
*table label
	local tabname T_i_mic_ad	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==. & Ru1==1, m
			return list
				local footnote1 =r(N)
				
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==. & Ru2==1, m
			return list
				local footnote2 =r(N)

	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote: products with missing price data for adult microscopy:`footnote1'")
	putexcel D1= ("Urban Footnote: products with missing price data for adult microscopy:`footnote2'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pptestAdultTotal [pw=wt_allOutlet] if `y'==1 & `x'==1 & pptestAdultTotal!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult microscopy")

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
			
			count if `y'==1 & `x'==1 & pptestAdultTotal!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****CHILD MICROSCOPY
*table label
	local tabname T_i_mic_ch	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta uspptestChildTotalDC if microscopy==1 & uspptestChildTotalDC==. & Ru1==1, m
			return list
				local footnote1 =r(N)
				
		ta uspptestChildTotalDC if microscopy==1 & uspptestChildTotalDC==. & Ru2==1, m
			return list
				local footnote1 =r(N)
		

	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote: products with missing price data for child microscopy:`footnote1'")
	putexcel D1= ("Urban Footnote: products with missing price data for child microscopy:`footnote1'")

	**tables loop and putexcel output	

		local row=3
		local col=2


		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile uspptestChildTotalDC [pw=wt_allOutlet] if `y'==1 & `x'==1 & uspptestChildTotalDC!=., p(25, 50, 75)

			
			putexcel A`row'=("Child Microscopy")

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
			
			count if `y'==1 & `x'==1 & uspptestChildTotalDC!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


	
	
*ADULT RDT in outlet  
*table label
	local tabname T_i_rdt_in	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultOutlet if rdt_true==1 & pprdtAdultOutlet==. & Ru1==1, m
			return list
				local footnote1 =r(N)
		
		ta pprdtAdultOutlet if rdt_true==1 & pprdtAdultOutlet==. & Ru2==1, m
			return list
				local footnote2 =r(N)
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote: products with missing price data for adult RDT within outlet:`footnote1'")
	putexcel D1= ("Rural Footnote: products with missing price data for adult RDT within outlet:`footnote2'")

	**tables loop and putexcel output	

		local row=3
		local col=2
	

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultOutlet [pw=wt_allOutlet] if `y'==1 & `x'==1 & pprdtAdultOutlet!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT in outlet")

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
			
			count if `y'==1 & `x'==1 & pprdtAdultOutlet!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****ADULT RDT TAKE AWAY
*table label
	local tabname T_i_rdt_ta	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultAway if rdt_true==1 & pprdtAdultAway==. & Ru1==1, m
			return list
				local footnote1 =r(N)

		ta pprdtAdultAway if rdt_true==1 & pprdtAdultAway==. & Ru2==1, m
			return list
				local footnote2 =r(N)

	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote: products with missing price data for adult RDT take away:`footnote1'")
	putexcel D1= ("Urban Footnote: products with missing price data for adult RDT take away:`footnote2'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultAway [pw=wt_allOutlet] if `y'==1 & `x'==1 & pprdtAdultAway!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT take away")

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
			
			count if `y'==1 & `x'==1 & pprdtAdultAway!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


**# 
********************************************************************************
********************************************************************************
*III. Strata resutls
********************************************************************************
********************************************************************************

foreach s of varlist `stratumlist' {
	
*ADULT MICROSCOPY
*table label
	local tabname T_iii_mic_ad_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==. & `s'==1, m
			return list
				local footnote1 =r(N)		
	
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote: products with missing price data for adult microscopy:`footnote1'")


	**tables loop and putexcel output	

		local row=3
		local col=2


		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pptestAdultTotal [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pptestAdultTotal!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult microscopy")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pptestAdultTotal!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****CHILD MICROSCOPY
*table label
	local tabname T_iii_mic_ch_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta uspptestChildTotalDC if microscopy==1 & `s'==1 & uspptestChildTotalDC==., m
			return list
				local footnote1 =r(N)
		

	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote: products with missing price data for child microscopy:`footnote1'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile uspptestChildTotalDC [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & uspptestChildTotalDC!=., p(25, 50, 75)

			
			putexcel A`row'=("Child Microscopy")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & uspptestChildTotalDC!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


	
	
*ADULT RDT in outlet  
*table label
	local tabname T_iii_rdt_in_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultOutlet if rdt_true==1 & `s'==1 & pprdtAdultOutlet==., m
			return list
				local footnote1 =r(N)
		

	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote: products with missing price data for adult RDT within outlet:`footnote1'")

	**tables loop and putexcel output	

		local row=3
		local col=2


		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultOutlet [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pprdtAdultOutlet!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT in outlet")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pprdtAdultOutlet!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
****ADULT RDT TAKE AWAY
*table label
	local tabname T_iii_rdt_ta_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultAway if rdt_true==1 & `s'==1 & pprdtAdultAway==., m
			return list
				local footnote1 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote: products with missing price data for adult RDT take away:`footnote1'")
	
	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultAway [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pprdtAdultAway!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT take away")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pprdtAdultAway!=.

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


		
*ADULT MICROSCOPY
*table label
	local tabname T_iii_mic_ad_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==. & `s'==1 & Ru1==1, m
			return list
				local footnote1 =r(N)
		
		ta pptestAdultTotal if microscopy==1 & pptestAdultTotal==. & `s'==1 & Ru2==1, m
			return list
				local footnote2 =r(N)
				
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote: products with missing price data for adult microscopy:`footnote1'")
	putexcel D1= ("Urban `s' Footnote: products with missing price data for adult microscopy:`footnote2'")


	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pptestAdultTotal [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pptestAdultTotal!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult microscopy")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pptestAdultTotal!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
****CHILD MICROSCOPY
*table label
	local tabname T_iii_mic_ch_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta uspptestChildTotalDC if microscopy==1 & `s'==1 & uspptestChildTotalDC==. & Ru1==1, m
			return list
				local footnote1 =r(N)
				
		ta uspptestChildTotalDC if microscopy==1 & `s'==1 & uspptestChildTotalDC==. & Ru2==1, m
			return list
				local footnote2 =r(N)
		

	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote: products with missing price data for child microscopy:`footnote1'")
	putexcel D1= ("Rural `s' Footnote: products with missing price data for child microscopy:`footnote2'")

	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist microscopy {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile uspptestChildTotalDC [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & uspptestChildTotalDC!=., p(25, 50, 75)

			
			putexcel A`row'=("Child Microscopy")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & uspptestChildTotalDC!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


	
	
*ADULT RDT in outlet  
*table label
	local tabname T_iii_rdt_in_`s'	

	
	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultOutlet if rdt_true==1 & `s'==1 & pprdtAdultOutlet==. & Ru1==1, m
			return list
				local footnote1 =r(N)
		
		ta pprdtAdultOutlet if rdt_true==1 & `s'==1 & pprdtAdultOutlet==. & Ru2==1, m
			return list
				local footnote2 =r(N)
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote: products with missing price data for adult RDT within outlet:`footnote1'")
	putexcel D1= ("Urban `s' Footnote: products with missing price data for adult RDT within outlet:`footnote2'")


	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultOutlet [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pprdtAdultOutlet!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT in outlet")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pprdtAdultOutlet!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

	
	
	
****ADULT RDT TAKE AWAY
*table label
	local tabname T_iii_rdt_ta_`s'	

	**********
	*FOOTNOTES

	*missing prices for: 	
		ta pprdtAdultAway if rdt_true==1 & `s'==1 & pprdtAdultAway==. & Ru1==1, m
			return list
				local footnote1 =r(N)
		
		ta pprdtAdultAway if rdt_true==1 & `s'==1 & pprdtAdultAway==. & Ru2==1, m
			return list
				local footnote2 =r(N)
	
	*file name and sheet
	putexcel set "${tables}/5.3b_Sales price of tests to customers-local currency_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Median price") C2=("Lower quartile") D2=("Upper quartile") E2=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote: products with missing price data for adult RDT take away:`footnote1'")
	putexcel D1= ("Urban `s' Footnote: products with missing price data for adult RDT take away:`footnote2'")

	
	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist rdt_true {
		local row=`row'+1
		local col=2	
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile pprdtAdultAway [pw=wt_allOutlet] if `y'==1 & `x'==1 & `s'==1 & pprdtAdultAway!=., p(25, 50, 75)

			
			putexcel A`row'=("Adult RDT take away")

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
			
			count if `y'==1 & `x'==1 & `s'==1 & pprdtAdultAway!=.

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}

} 



	**ends	
	



