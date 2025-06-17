*2		Market Composition
*2.2	Distribution of outlet types among outlets with malaria blood-testing

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
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT  MARKET COMPOSITION RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE  FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS) IN
* 2.1 Distribution of outlet types among outlets stocking antimalarials.do - PLEASE REFER TO
* THAT DO FILE FOR FULL INFORMATION. 
*  ANY NEW CODE FOR THIS SET OF TABLES IS ANNOTATED WHERE APPROPRIATE

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 



**# 
********************************************************************************
********************************************************************************
*I. National level resutls
********************************************************************************
********************************************************************************

*table label
	local tabname T_i


	***************
	*FOOTNOTES

	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 // AMONG OUTLETS STOCKING ANY DIAGNOSTICS
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
	
	*file name and sheet
		putexcel set "${tables}/1.2_Market Composition among outlets with tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote1' ")


		
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_test==1
			
			estpost svy, subpop(if st_test==1 & booster==0): tab `x', ci per nototal

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

	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 & Ru1==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
		
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 & Ru2==1
	**count of outlets stored as footnote
	return list
	local footnote2 =r(N)


	*file name and sheet
		putexcel set "${tables}/1.2_Market Composition among outlets with tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Rural Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote1' ")
	putexcel C1= ("Urban Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote2' ")
		
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_test==1
		
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'
			
			estpost svy, subpop(if st_test==1 & booster==0): tab `x', ci per nototal

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

*/

**# 
********************************************************************************
********************************************************************************
*III. Strata resutls
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {

	
		*table label
		
local tabname T_iii_`s'	

	
	***************
	*FOOTNOTES	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 & `s'==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
	
	*file name and sheet
		putexcel set "${tables}/1.2_Market Composition among outlets with tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote: outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote1' ")


		
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_test==1
			
			estpost svy, subpop(if st_test==1 & booster==0 & `s'==1): tab `x', ci per nototal

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

	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 & `s'==1 & Ru1==1
	**count of outlets stored as footnote
	return list
	local footnote1 =r(N)
	
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & st_test==1 & `s'==1 & Ru2==1
	**count of outlets stored as footnote
	return list
	local footnote2 =r(N)
		
	*file name and sheet
	putexcel set "${tables}/1.2_Market Composition among outlets with tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote: Rural outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote1'")
	putexcel D1= ("`s' Footnote: Urban outlets that met screening criteria for a full interview but did not complete the interview with any diagnostics in stock = `footnote2'")

		
	**tables loop and putexcel output	

		local row=3
		local col=2

	

		foreach x of varlist `outvars3' {
		local varlabelx :  var label `x'
		
		recode `x'(.=0) if st_test==1
		
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'
			
			estpost svy, subpop(if st_test==1 & booster==0 & `s'==1 & `z'==1): tab `x', ci per nototal

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


**end

