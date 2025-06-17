*	7		Stockouts


/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural		
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural	
*/

*Comment out any tables that are not relevant to this implementaiton using /* */ 

*STOCKOUTS OF PRODUCTS IS MEASURED AT THE OUTLET LEVEL AND USES THE SAME APPROACH AS 1.1 AVAILABLILTY


*OUTLET DATASET SHOULD BE IDENTIFIED HERE:
use "${mngmtdata}/${country}_${year}_outlet_data", clear

*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"


*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT STOCKOUT RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* NOTE THAT THIS ANALYSIS FILE IS BASED ON 1.1 Availability of antimalarials among all screened outlets.do
* AND FULLER ANNOTATION MAY BE FOUND IN THAT FILE. 
* WE HAVE ONLY  ANNOTATED ANY NEW CODE FOR TABLES I TO IV WHERE THIS DIFFERS FROM 
* OTHER FILES

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 



********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************

*NAME THE LOCAL MACRO FOR THIS ANALYSIS AND SUB-GROUP (SHOULD MATCH INDICATOR TABLE)

*table label
	
	local tabname T_i
	
	
***************
	*FOOTNOTES - FOR TABLES AND FIGURES
	
	*ENSURE THAT EACH OUTLET TYPE IN THE SURVEY IS INCLUDED BELOW AND SAVED AS A SEPARATE LOCAL FOOTNOTE MACRO 

	*Footnote A: Number of screened outlets not missing stockout data (a16), for each outlet type

	
	count if pnp==1 & screened==1 & a16!=. // COUNTS THE NUMBER OF OUTLET TYPE PNP (PRIVATE NOT FOR PROFIT) THAT WERE SCREENED AND NOT MISSING STOCKOUT DATA IN THE STUDY
	local footnote1 =r(N)  // SAVES THE RESULT AS A LOCAL MACRO
	
	count if pfp==1 & screened==1 & a16!=.
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & a16!=.
	local footnote3 =r(N)

	count if drs==1 & screened==1 & a16!=.
	local footnote4 =r(N)
	
	count if inf==1 & screened==1 & a16!=.
	local footnote5 =r(N)
	
	count if lab==1 & screened==1 & a16!=.
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & a16!=.
	local footnote7 =r(N)

	*Footnote B: outlets that met screening criteria for a full interview but did not complete the interview (were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & a16!=.
	***store the count to include in footnote
		local footnote8 =r(N)
	
	*Footnote C: TOTAL N outlets that were screened and are missing stockout data
		count if screened==1  & a16==.
		local footnote9 =r(N)

	*file name and sheet
	*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 
	putexcel set "${tables}/7.1&2_Stock outs of antimalarials and RDTs_$tabver", sheet("`tabname'") modify

	
	*ADDING LABELS AND INFORMATION TO BE WRITTEN TO THE EXCEL FILE
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	*WRITING THE RESULTS OF THE COUNTS FOR FOOTNOTES INTO THE EXCEL FILE HERE. ENSURE THE OUTLET TYPES MATCH THE ONES IDENITIFIED ABOVE.
	putexcel C1= ("Footnote - N screened outlets with stockout data: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote8'; screened outlets with no AM stockout data = `footnote9' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `oosvars' {				// local macro for out of stock variables, defined in the local_definitions.doh file
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & screened==1  & a16!=.		// analysis among all screened outlets with stockout data available
					if r(N)==0 {
					count if `y'==1 & screened==1 & a16!=.
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
					
			estpost svy, subpop(if screened==1 & a16!=. & `y'==1): tab `x', ci per nototal

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




**# 
********************************************************************************
********************************************************************************
*II. National level results by urban/ rural
*
********************************************************************************
********************************************************************************

*table label
	
	local tabname T_ii
	
	

	***************
	*FOOTNOTES
***RURAL
	*Footnote: Number of screened outlets, for each outlet type
	count if pnp==1 & screened==1 & a16!=. & Ru1==1
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1 & a16!=. & Ru1==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & a16!=. & Ru1==1
	local footnote3 =r(N)

	count if drs==1 & screened==1 & a16!=. & Ru1==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1 & a16!=. & Ru1==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1 & a16!=. & Ru1==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & a16!=. & Ru1==1
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & a16!=. & Ru1==1
	***store the count to include in footnote?
		local footnote8 =r(N)
		
		count if screened==1 & a16==. & Ru1==1
	***store the count to include in footnote
		local footnote9 =r(N)


***URBAN
	*Footnote: Number of screened outlets, for each outlet type
	count if pnp==1 & screened==1 & a16!=. & Ru2==1
	local footnote10 =r(N)
	
	count if pfp==1 & screened==1 & a16!=. & Ru2==1
	local footnote11 =r(N)
	
	count if pop==1 & screened==1 & a16!=. & Ru2==1
	local footnote12 =r(N)

	count if drs==1 & screened==1 & a16!=. & Ru2==1
	local footnote13 =r(N)
	
	count if inf==1 & screened==1 & a16!=. & Ru2==1
	local footnote14 =r(N)
	
	count if lab==1 & screened==1 & a16!=. & Ru2==1
	local footnote15 =r(N)
	
	count if wls==1 & screened==1 & a16!=. & Ru2==1
	local footnote16 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & a16!=. & Ru2==1
	***store the count to include in footnote?
		local footnote17 =r(N)
		
		count if screened==1 & a16==. & Ru2==1
	***store the count to include in footnote
		local footnote18 =r(N)
	
		
	*file name and sheet
	putexcel set "${tables}/7.1&2_Stock outs of antimalarials and RDTs_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural Footnote - N screened outlets with stockout data: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote8'; screened outlets with no AM stockout data = `footnote9' ")
	putexcel D1= ("Urban Footnote - N screened outlets with stockout data: Private not for profit=`footnote10'; private not for profit=`footnote11'; pharmacy=`footnote12'; PPMV=`footnote13'; informal=`footnote14'; labs = `footnote15'; wholesalers= `footnote16'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote17'; screened outlets with no AM stockout data = `footnote18' ")
	
		***tables output:

			local row=3
			local col=2

		foreach x of varlist `oosvars' {
			local row=`row'+1
			local col=2	
			local varlabelx :  var label `x'
			
			foreach z of varlist `rural' {				//note rural/urban macro included here
			local varlabelz :  var label `z'

				foreach y of varlist `outvars1' {
				local varlabely :  var label `y'
				
			
					qui: count if `x'==1 & `y'==1 & `z'==1  & `s'==1 & screened==1 & a16!=.
						if r(N)==0 {
					qui: count if `y'==1 & `s'==1 & `z'==1 & screened==1 & a16!=.
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
						
				estpost svy, subpop(if screened==1 & a16!=. & `z'==1 & `y'==1 & `s'==1 ): tab `x', ci per nototal

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
*III. Strata results
********************************************************************************
********************************************************************************



foreach s of varlist `stratumlist' {			// loops over the strata defined in local_definitions.doh


*table label
	
	local tabname T_iii_`s'
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1  & `s'==1 & a16!=.
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1  & `s'==1 & a16!=.
	local footnote2 =r(N)
	
	count if pop==1 & screened==1  & `s'==1 & a16!=.
	local footnote3 =r(N)

	count if drs==1 & screened==1  & `s'==1 & a16!=.
	local footnote4 =r(N)
	
	count if inf==1 & screened==1  & `s'==1 & a16!=.
	local footnote5 =r(N)
	
	count if lab==1 & screened==1  & `s'==1 & a16!=.
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & `s'==1 & a16!=.
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1  & a16!=.
	***store the count to include in footnote?
		local footnote8 =r(N)
		
		count if screened==1 & `s'==1  & a16==.
	***store the count to include in footnote?
		local footnote9 =r(N)

	*file name and sheet
	putexcel set "${tables}/7.1&2_Stock outs of antimalarials and RDTs_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("`s' Footnote - N screened outlets with stock-out data: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote8'; screened outlets with no AM stockout data = `footnote9' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `oosvars' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & screened==1  & a16!=.
					if r(N)==0 {
					count if `y'==1 & `s'==1 & screened==1 & a16!=.
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
					
			estpost svy, subpop(if screened==1 & a16!=. & `s'==1 & `y'==1): tab `x', ci per nototal

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


*
********************************************************************************
********************************************************************************
*IV. Strata resutls by urban/ rural
********************************************************************************
********************************************************************************



foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iv_`s'
	
	*FOOTNOTES
***RURAL
	*Footnote: Number of screened outlets, for each outlet type
	count if pnp==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote3 =r(N)

	count if drs==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & a16!=. & Ru1==1 & `s'==1
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & a16!=. & Ru1==1  & `s'==1
	***store the count to include in footnote?
		local footnote8 =r(N)
		
		count if screened==1 & a16==. & Ru1==1  & `s'==1
	***store the count to include in footnote
		local footnote9 =r(N)


***URBAN
	*Footnote: Number of screened outlets, for each outlet type
	count if pnp==1 & screened==1 & a16!=. & Ru2==1  & `s'==1
	local footnote10 =r(N)
	
	count if pfp==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote11 =r(N)
	
	count if pop==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote12 =r(N)

	count if drs==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote13 =r(N)
	
	count if inf==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote14 =r(N)
	
	count if lab==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote15 =r(N)
	
	count if wls==1 & screened==1 & a16!=. & Ru2==1 & `s'==1
	local footnote16 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & a16!=. & Ru2==1 & `s'==1
	***store the count to include in footnote?
		local footnote17 =r(N)
		
		count if screened==1 & a16==. & Ru2==1 & `s'==1
	***store the count to include in footnote
		local footnote18 =r(N)
	
		
	*file name and sheet
	putexcel set "${tables}/7.1&2_Stock outs of antimalarials and RDTs_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Rural `s' Footnote - N screened outlets with stockout data: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote8'; screened outlets with no AM stockout data = `footnote9' ")
	putexcel D1= ("Urban `s' Footnote - N screened outlets with stockout data: Private not for profit=`footnote10'; private not for profit=`footnote11'; pharmacy=`footnote12'; PPMV=`footnote13'; informal=`footnote14'; labs = `footnote15'; wholesalers= `footnote16'. Outlets that met screening criteria for a full interview but did not complete the interview and have stockout data = `footnote17'; screened outlets with no AM stockout data = `footnote18' ")
	

		***tables output:

			local row=3
			local col=2

		foreach x of varlist `oosvars' {
			local row=`row'+1
			local col=2	
			local varlabelx :  var label `x'
			
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'

				foreach y of varlist `outvars1' {
				local varlabely :  var label `y'
				
			
					qui: count if `x'==1 & `y'==1 & `z'==1  & `s'==1 & screened==1 & a16!=.
						if r(N)==0 {
					qui: count if `y'==1 & `s'==1 & `z'==1 & screened==1 & a16!=.
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
						
				estpost svy, subpop(if screened==1 & a16!=. & `z'==1 & `y'==1 & `s'==1 ): tab `x', ci per nototal

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

		
