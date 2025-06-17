*	1		Availability
*	1.3		Availability of malaria blood testing among all screened outlets


/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural
*/

*Comment out any tables that are not relevant to this implementaiton using /* */ 

*AVAILABILITY OF PRODUCTS IS MEASURED AT THE OUTLET LEVEL. 
*OUTLET DATASET SHOULD BE IDENTIFIED HERE, 
*EXAMPLE:
use "${mngmtdata}/${country}_${year}_outlet_data", clear


*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file
*EXAMPLE:
include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"


*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT AVAILABILTY RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* SEE 1.1 Availability of antimalarials among all screened outlets.do FOR FULLY ANNOTATED CODE
* ANY NEW CODE FOR THIS SET OF ANALYSIS IS ANNOTATED WHERE APPROPRIATE

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

*ENSURE THAT EACH OUTLET TYPE IN THE SURVEY IS INCLUDED BELOW AND SAVED AS A SEPARATE LOCAL FOOTNOTE MACRO 

	*Footnote A: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1 // COUNTS THE NUMBER OF OUTLET TYPE PNP (PRIVATE NOT FOR PROFIT) THAT WERE SCREENED IN THE STUDY
	local footnote1 =r(N) // SAVES THE RESULT AS A LOCAL MACRO
	
	count if pfp==1 & screened==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1
	local footnote3 =r(N)

	count if drs==1 & screened==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1
	local footnote7 =r(N)

	*Footnote B: outlets that met screening criteria for a full interview but did not complete the interview (were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 // COUNTS THE TOTAL OUTLETS THAT DID NOT COMPLETE THE INTERVIEW
	local footnote8 =r(N)

	*ADDING LABELS AND INFORMATION TO BE WRITTEN TO THE EXCEL FILE
	*file name and sheet	
	putexcel set "${tables}/2.3_Availability of tests in all screened outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")

	putexcel C1= ("Footnote - N screened outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")

	
	**tables loop and putexcel output	

		local row=3
		local col=2

	foreach x of varlist `testvars' { 				// testvars macro - variables for analysis defined in the local_definitions.doh file
		local row=`row'+1
		local col=2	

		local varlabelx :  var label	`x'

		foreach y of varlist `outvars1' {
		local varlabely :  var label	`y'

		
				qui: count if `x'==1 & `y'==1 & screened==1
					if r(N)==0 {
					count if `y'==1 & screened==1
					matrix ns=r(N)
						
			putexcel A`row'=("`varlabelx'")

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
		
		
	

********************************************************************************
********************************************************************************
*III. NATIONAL RESULTS BY RURAL-URBAN	
********************************************************************************
********************************************************************************

	table label
	local tabname T_ii

	***************
	*FOOTNOTES

	*RURAL FOOTNOTES
	
	*Footnote: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1 & Ru1==1 
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1 & Ru1==1 
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & Ru1==1 
	local footnote3 =r(N)

	count if drs==1 & screened==1 & Ru1==1 
	local footnote4 =r(N)
	
	count if inf==1 & screened==1 & Ru1==1 
	local footnote5 =r(N)
	
	count if lab==1 & screened==1 & Ru1==1 
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & Ru1==1 
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & Ru1==1 
	local footnote8 =r(N)
	
	*URBAN FOOTNOTES

		*Footnote: Number of screened outltes, for each outlet type
		count if pnp==1 & screened==1 & Ru2==1 
		local footnote9 =r(N)
		
		count if pfp==1 & screened==1  & Ru2==1
		local footnote10 =r(N)
		
		count if pop==1 & screened==1  & Ru2==1
		local footnote11 =r(N)

		count if drs==1 & screened==1  & Ru2==1
		local footnote12 =r(N)
		
		count if inf==1 & screened==1 & Ru2==1
		local footnote13 =r(N)
		
		count if lab==1 & screened==1 & Ru2==1 
		local footnote14 =r(N)
		
		count if wls==1 & screened==1 & Ru2==1
		local footnote15 =r(N)

		*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
		*(were not interviewered or completed a partial interview).
		count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 &  Ru2==1
		local footnote16 =r(N)


	*file name and sheet
	putexcel set "${tables}/2.3_Availability of tests in all screened outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Footnote - N screened outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")
	putexcel D1= ("Footnote - N screened outlets: Private not for profit=`footnote9'; private not for profit=`footnote10'; pharmacy=`footnote11'; PPMV=`footnote12'; informal=`footnote13'; labs = `footnote14'; wholesalers= `footnote15'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote16' ")

	
	**tables loop and putexcel output	

		local row=3
		local col=2

	foreach x of varlist `testvars' {
		local row=`row'+1
		local col=2	
	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
		
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
			
			estpost svy, subpop(if screened==1 & `y'==1 & `z'==1): tab `x', ci per nototal

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
*III. Strata resutls
********************************************************************************
********************************************************************************

*table label
	

foreach s of varlist `stratumlist' {


		
		local tabname T_iii_`s'


	***************
	*FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1 & `s'==1
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1  & `s'==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1  & `s'==1
	local footnote3 =r(N)

	count if drs==1 & screened==1 & `s'==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1  & `s'==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1  & `s'==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1 & `s'==1
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1 & `s'==1
	local footnote8 =r(N)

	*file name and sheet
	putexcel set "${tables}/2.3_Availability of tests in all screened outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B2=("Point estimate") C2=("Lower CI") D2=("Upper CI") E2=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("`s' Footnote - N screened outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")

	
	**tables loop and putexcel output	

		local row=3
		local col=2

	foreach x of varlist `testvars' {
		local row=`row'+1
		local col=2	
	
		local varlabelx :  var label `x'
		
			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'

		
				qui: count if `x'==1 & `y'==1 & `s'==1 & screened==1
					if r(N)==0 {
					qui: count if `y'==1 & `s'==1 & screened==1
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
			
			estpost svy, subpop(if screened==1 & `y'==1 & `s'==1): tab `x', ci per nototal

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
				
				if (b[1,2])==100 {
			
				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(100)
				local col=`col'+1

				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(100)
				local col=`col'+1

				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(ns[1,1])
				local col=`col'+1
			}	
			else {
				
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
		

	
	
	


********************************************************************************
********************************************************************************
*IV. Strata resutls by urban/ rural
********************************************************************************
********************************************************************************


	

foreach s of varlist `stratumlist' {


*table label
	local tabname T_iv_`s'
	

***************
	*FOOTNOTES

	*RURAL FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1 & `s'==1 & Ru1==1
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1  & `s'==1 & Ru1==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & `s'==1 & Ru1==1
	local footnote3 =r(N)

	count if drs==1 & screened==1  & `s'==1 & Ru1==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1  & `s'==1 & Ru1==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1  & `s'==1 & Ru1==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1  & `s'==1 & Ru1==1
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1  & `s'==1 & Ru1==1
	local footnote8 =r(N)
	
	*URBAN FOOTNOTES

	*Footnote: Number of screened outltes, for each outlet type
	count if pnp==1 & screened==1 & `s'==1 & Ru2==1
	local footnote1 =r(N)
	
	count if pfp==1 & screened==1  & `s'==1 & Ru2==1
	local footnote2 =r(N)
	
	count if pop==1 & screened==1 & `s'==1 & Ru2==1
	local footnote3 =r(N)

	count if drs==1 & screened==1  & `s'==1 & Ru2==1
	local footnote4 =r(N)
	
	count if inf==1 & screened==1  & `s'==1 & Ru2==1
	local footnote5 =r(N)
	
	count if lab==1 & screened==1  & `s'==1 & Ru2==1
	local footnote6 =r(N)
	
	count if wls==1 & screened==1  & `s'==1 & Ru2==1
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & screened==1  & `s'==1 & Ru2==1
	local footnote8 =r(N)

	*file name and sheet
	putexcel set "${tables}/2.3_Availability of tests in all screened outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
		*footnotes into excel file:
		putexcel C1= ("RURAL `s' Footnote - N screened outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")
		putexcel D1= ("URBAN `s' Footnote - N screened outlets: Private not for profit=`footnote9'; private not for profit=`footnote10'; pharmacy=`footnote11'; PPMV=`footnote12'; informal=`footnote13'; labs = `footnote14'; wholesalers= `footnote15'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote16' ")
	
	**tables loop and putexcel output	

		local row=3
		local col=2

	foreach x of varlist `testvars' {
		local row=`row'+1
		local col=2	
	
		local varlabelx :  var label `x'
		
		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'

		
				qui: count if `x'==1 & `y'==1 & `z'==1  & `s'==1 & screened==1
					if r(N)==0 {
					qui: count if `y'==1 & `z'==1  & `s'==1 & screened==1
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
			
			estpost svy, subpop(if screened==1 & `y'==1 & `z'==1 & `s'==1): tab `x', ci per nototal

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
				
				if (b[1,2])==100 {
			
				
				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(100)
				local col=`col'+1

				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(100)
				local col=`col'+1

				mata: st_local("alphacol", numtobase26((`col')))
				putexcel `alphacol'`row'=(ns[1,1])
				local col=`col'+1
			}	
			else {
				
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
		
	}
	
	
	

	
