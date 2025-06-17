*1./1		Market Composition
*1.1	Distribution of outlet types among outlets stocking antimalarials

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 
clear

*MARKET COMPOSITION IS MEASURED AT THE OUTLET LEVEL. 
*OUTLET DATASET SHOULD BE IDENTIFIED HERE, 
*EXAMPLE:
use "${mngmtdata}/${country}_${year}_outlet_data", clear



*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"



	*nb. market share weights for this table
	svydes
	svyset c4 [pweight=wt_marketShare], strata(strata) fpc(fpc)
	

*Drop if outlet category information is missing.
	drop if outcat2==.

*ensuring that the % market composition is only among the outlet types for which
*this is being calcuated (i.e. outvars3 in local_definitions.doh):	
 gen temp_tot=0
	foreach v of varlist `outvars3' { 
		recode temp_tot (0=1) if `v'==1
	}
drop if temp_tot==0	
drop temp_tot

	
*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT MARKET COMPOSITION RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR II TO IV IS
* ANNOTATED WHERE APPROPRIATE

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 



**# 
********************************************************************************
********************************************************************************
*I. National level resutls
********************************************************************************
********************************************************************************

*NAME THE LOCAL MACRO FOR THIS ANALYSIS AND SUB-GROUP (SHOULD MATCH INDICATOR TABLE)
*table label
	local tabname T_i


	***************
	*FOOTNOTES

	***************
	*FOOTNOTES - FOR TABLES AND FIGURES
	
	*ENSURE THAT EACH OUTLET TYPE IN THE SURVEY IS INCLUDED BELOW AND SAVED AS A SEPARATE LOCAL FOOTNOTE MACRO 

	*Footnote A: Number of outlets with any AM in stock that did not complete the interview: 
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1 
	
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
	*file name and sheet
		putexcel set "${tables}/1.1_Market Composition among antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= (" Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock  = `footnote1' ")


		
	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist `outvars3' {   // OUTLET VARIABLES FOR MARKET COMPOSITION, IE. NO TOTALS AND NO WHOLESALE, JUST ACTUAL OUTLET TYPES

		local varlabelx :  var label `x' 
		
		recode `x'(.=0) if st_anyAM==1  //ensures that %s are calculated correctly by setting outlet types to either 1 or 0 values 
			
			estpost svy, subpop(if st_anyAM==1 & booster==0): tab `x', ci per nototal  // calculates the % of all outlets with AM in stock that are of each outlet type

			matrix b=e(b) // the matrix command allows us to save the results of the analysis (in the line above starting with [estpost...], so they can be copied into excel by putexcel
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			mata: st_local("alphacol", numtobase26((`col')))			// Adding results to excel systematically is complicated for columns as they use the alphabet rather than numbers (the rows have numbers, and it is easy to add 1 to a row and move down the spreadsheet)
																		//the [mata st_local... ] line of code allows us to convert between numbers and alphabet, by treating the alphabet as a base 26 number, so that we can tell putexcel to "add 1 to the column"
			putexcel `alphacol'1=("`varlabelx'")						// here we are adding the x variable label to the location where the results for that outlet will be put in excel i.e. [column],row2

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(b[1,2])							// the point estimate for the analysis will be put in excel [column][row].
			local col=`col'+1											//adds 1 to the column tally

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2])							// adds lower CI bound to excel in [col][row] location defined by the alphacol and row local macros
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2]) 							// adds upper CI bound to excel in [col][row] location defined by the alphacol and row local macros
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])							// adds N to excel in [col][row] location defined by the alphacol and row local macros
			local col=`col'+1
		}	
	



**# 
********************************************************************************
********************************************************************************
*II. National level resutls by urban/ rural
********************************************************************************
********************************************************************************

*table label
	local tabname T_ii	
	
	
	***************
	*FOOTNOTES

	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1  & Ru1==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1  & Ru2==1
	**count of outlets stored as footnote
	return list
	local footnote2 =r(N)

	************
	
	*file name and sheet
	putexcel set "${tables}/1.1_Market Composition among antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Rural Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock = `footnote1' ")
	putexcel D1= ("Urban Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock = `footnote2' ")

		
	**tables loop and putexcel output	

		local row=3
		local col=2

		foreach x of varlist `outvars3' { 	
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_anyAM==1
			foreach z of varlist `rural' {					// includes a loop over rural and urban
			local varlabelz :  var label `z'				// identifies the labels for rural and urban
			
			estpost svy, subpop(if st_anyAM==1 & booster==0): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelx'")
			putexcel `alphacol'2=("`varlabelz'")			// adds the rural/ urban label [col] row2 in the excel 
			
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



**# 
********************************************************************************
********************************************************************************
*III. Strata resutls
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {			// loops the whole analysis over the strata listed here

		*table label
		
local tabname T_iii_`s'		

	
	***************
	*FOOTNOTES
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1 & `s'==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	

	*file name and sheet
	putexcel set "${tables}/1.1_Market Composition among antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock = `footnote1' ")
	
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {	
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_anyAM==1

			
			estpost svy, subpop(if `s'==1 & st_anyAM==1 & booster==0): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelx'")
			
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


**# 
********************************************************************************
********************************************************************************
*IV. Strata results by urban/ rural
********************************************************************************
********************************************************************************



foreach s of varlist `stratumlist' {


		*table label
		
local tabname T_iv_`s'		

	
	***************
	*FOOTNOTES

	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1 & `s'==1 & Ru1==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)

	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_anyAM==1 & `s'==1 & Ru2==1
	**count of outlets stored as footnote
	return list
	local footnote2 =r(N)

	************
	*DENOMINATOR

	*Denominator: all outlets screened
	
	
*Drop if outlet category information is missing.
	drop if outcat2==.

 gen temp_tot=0

 foreach v of varlist `outvars3' {
  recode temp_tot (0=1) if `v'==1
  }
  
  
drop if temp_tot==0	
drop temp_tot

	
	*file name and sheet
		putexcel set "${tables}/1.1_Market Composition among antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote: Rural outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock = `footnote1' ")
	putexcel D1= ("`s' Footnote: Urban outlets that met screening criteria for a full interview but did not complete the interview with any AM in stock = `footnote2' ")

		
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_anyAM==1
		
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'
			
			estpost svy, subpop(if st_anyAM==1 & booster==0 & `s'==1 & `z'==1): tab `x', ci per nototal

			matrix b=e(b)
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)


			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelx'")
			putexcel `alphacol'2=("`varlabelz'")
			
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
