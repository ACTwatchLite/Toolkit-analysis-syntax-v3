*	2		Availability
*	2.2		Availability of antimalarials among all antimaaltial stocking outlets


/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level results - i.e. across the whole greogrpahic reach for which the study was designed to be representative.
	II. National level results disaggregated by urban/ rural - i.e. if your study is stratified by urban/rural, the II results show that disaggregation
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
	IV. Results by strata dissagregated by urban/ rural - i.e. other geographical stratification (eg. region/ state) and urban/rural
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
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR II TO IV IS
* ANNOTATED WHERE APPROPRIATE

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

	*Footnote A: Number of anyAM outltes, for each outlet type
	count if pnp==1 & anyAM==1   // COUNTS THE NUMBER OF OUTLET TYPE PNP (PRIVATE NOT FOR PROFIT) THAT WERE SCREENED IN THE STUDY
	local footnote1 =r(N) // SAVES THE RESULT AS A LOCAL MACRO
	
	count if pfp==1 & anyAM==1  
	local footnote2 =r(N)
	
	count if pop==1 & anyAM==1  
	local footnote3 =r(N)

	count if drs==1 & anyAM==1 
	local footnote4 =r(N)
	
	count if inf==1 & anyAM==1 
	local footnote5 =r(N)
	
	count if lab==1 & anyAM==1 
	local footnote6 =r(N)
	
	count if wls==1 & anyAM==1
	local footnote7 =r(N)

	*Footnote B: outlets that met screening criteria for a full interview but did not complete the interview (were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 // COUNTS THE TOTAL OUTLETS THAT DID NOT COMPLETE THE INTERVIEW
	local footnote8 =r(N) // SAVES THE RESULT AS A LOCAL MACRO

	
	*file name and sheet
	*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 
	putexcel set "${tables}/2.2_Availability of antimalarials in antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	*ADDING LABELS AND INFORMATION TO BE WRITTEN TO THE EXCEL FILE
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	*WRITING THE RESULTS OF THE COUNTS FOR FOOTNOTES INTO THE EXCEL FILE HERE. ENSURE THE OUTLET TYPES MATCH THE ONES IDENITIFIED ABOVE.
	putexcel C1= ("`s' Footnote - N anyAM outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")

	*THE NEXT SECTION ANALYSES THE WEIGHTED DATA AT OUTLET LEVEL AND WRITES THE RESULTS TO THE EXCEL OUTPUT FILE.
	* IT SHOULD NOT REQUIRE ANY MODIFICATIONS. 
	
	*TABLES ANALYSIS AND OUTPUT:

	*note that providing the variables and datasets have been correctly set up, no changes should be made to the below syntax:
	
	*this code loops over each type of product (x) and outlet (y), and prints results to excel, calculating and saving weighted point estimate, lower and upper confidence interval, and N for each product-outlet
	*combination. Products are listed in the excel on rows, outlets on columns. 
	
	
		local row=3 									// the macro identifying the starting row in excel for the analysis
		local col=2 									//  the macro identifying the starting column in excel for the analysis

	foreach x of varlist `covars' {  					// the local covars is the list of covariates for the analysis (i.e. product types, etc), identified in the local_definitions.doh file. This loops the code over each covariate x
		local row=`row'+1 								// adds 1  to the current value for row
		local col=2										// ensures that each loop starts on column 2 in excel
		local varlabelx :  var label `x' 				// creates a macro for variable labels for x (x is the list of covariates, defined above)
		

			foreach y of varlist `outvars1' {  			// this loops the code over each outlet type, defined by the local macro outvars1 which can be found in the local_definitions.doh file.
			local varlabely :  var label `y' 			// creates a macro for variable labels for y (y is the list of outlets, defined above)
			
		
*this block of code [from qui: count... to else {...] identifies where there are no results to display, i.e. where for x product in y outlet, there are zero cases. 
* the excel output where there are zero cases is "0" for the point estimate, "." for the upper and lower confidence intervals, and the number of outlets of type y. 

				qui: count if `x'==1 & `y'==1 & anyAM==1 //this set of 4 lines of code identifies where 
					if r(N)==0 {
					count if `y'==1 & anyAM==1 
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
		
*the code from else {  onwards runs where there is more than 0 outlets of type y with x product available

		
		else {
					
			estpost svy, subpop(if anyAM==1 & `y'==1): tab `x', ci per nototal // this line of code is the analysis of availabilty of x product in y outlet (among all anyAM outlets), weighted using estpost and subpop

			matrix b=e(b)  // the matrix command allows us to save the results of the analysis (in the line above starting with [estpost...], so they can be copied into excel by putexcel
			matrix lb=e(lb)
			matrix ub=e(ub)
			matrix ns=e(N_sub)

			putexcel A`row'=("`varlabelx'") // adding x variable labels to the excel file's first column
*adding results to excel systematically is complicated for columns as they use the alphabet rather than numbers (the rows have numbers, and it is easy to add 1 to a row and move down the spreadhseet)
*the [mata st_local... ] line of code allows us to convert between numbers and alphabet, by treating the alphabet as a base 26 number, so that we can tell putexcel to "add 1 to the column"
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'") // here we are adding the y variable label to the location where the results for that outlet will be put in excel i.e. [column],row2
			
			mata: st_local("alphacol", numtobase26((`col'))) 
			putexcel `alphacol'`row'=(b[1,2]) // the point estimate for the analysis will be put in excel [column][row].
			local col=`col'+1 //adds 1 to the column tally

		if (b[1,2])==100 {  // if 100% of outet y has product x, then :
			
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(100) // put 100 for the lower confidence interval in the column+1-row in excel
			local col=`col'+1 // add 1 to the column tally

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(100) // then put 100 for the upper confidence interval in the column+1-row in excel
			local col=`col'+1 // add 1 to the column tally

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1]) // then put the N in the in the column+1 again-row in excel
			local col=`col'+1
		}	
		else { // if less than 100% of outlet type y has product type x, then:
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(lb[1,2]) // put  the lower confidence interval in the column+1-row in excel
			local col=`col'+1 // add 1 to the column tally

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ub[1,2]) // put  the upper confidence interval in the column+1-row in excel
			local col=`col'+1 // add 1 to the column tally

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(ns[1,1])  // then put the N in the in the column+1 again-row in excel
			local col=`col'+1 // add 1 to the column tally
		}	
	}
}
}

*END OF NATIONAL RESULTS*


********************************************************************************
********************************************************************************
*II. RURAL URBAN
********************************************************************************
********************************************************************************

											// the only difference between the table I above and II here (rural/urban) is the addition of an extra foreach command loop for rural/urban (i.e. foreach z of varlist `rural' ... ) 


		*table label
		
local tabname T_ii	

		***************
		*FOOTNOTES
*RURAL FOOTNOTES
		*Footnote: Number of anyAM outltes, for each outlet type
		count if pnp==1 & anyAM==1 & Ru1==1 
		local footnote1 =r(N)
		
		count if pfp==1 & anyAM==1  & Ru1==1
		local footnote2 =r(N)
		
		count if pop==1 & anyAM==1  & Ru1==1
		local footnote3 =r(N)

		count if drs==1 & anyAM==1  & Ru1==1
		local footnote4 =r(N)
		
		count if inf==1 & anyAM==1 & Ru1==1
		local footnote5 =r(N)
		
		count if lab==1 & anyAM==1 & Ru1==1 
		local footnote6 =r(N)
		
		count if wls==1 & anyAM==1 & Ru1==1
		local footnote7 =r(N)

		*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
		*(were not interviewered or completed a partial interview).
		count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 &  Ru1==1
		***store the count to include in footnote
			local footnote8 =r(N)

*URBAN FOOTNOTES

		*Footnote: Number of anyAM outltes, for each outlet type
		count if pnp==1 & anyAM==1 & Ru2==1 
		local footnote9 =r(N)
		
		count if pfp==1 & anyAM==1  & Ru2==1
		local footnote10 =r(N)
		
		count if pop==1 & anyAM==1  & Ru2==1
		local footnote11 =r(N)

		count if drs==1 & anyAM==1  & Ru2==1
		local footnote12 =r(N)
		
		count if inf==1 & anyAM==1 & Ru2==1
		local footnote13 =r(N)
		
		count if lab==1 & anyAM==1 & Ru2==1 
		local footnote14 =r(N)
		
		count if wls==1 & anyAM==1 & Ru2==1
		local footnote15 =r(N)

		*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
		*(were not interviewered or completed a partial interview).
		count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 &  Ru2==1
		local footnote16 =r(N)
			
			
		*file name and sheet
		putexcel set "${tables}/2.2_Availability of antimalarials in antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

		*labels	
		putexcel A1=("`tabname'")
		putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
		putexcel A3=("variable name")
		
		*footnotes into excel file
		putexcel C1= ("Rural Footnote - N anyAM outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")
		putexcel D1= ("Urban Footnote - N anyAM outlets: Private not for profit=`footnote9'; private not for profit=`footnote10'; pharmacy=`footnote11'; PPMV=`footnote12'; informal=`footnote13'; labs = `footnote14'; wholesalers= `footnote15'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote16' ")
	
		***tables output:

			local row=3
			local col=2

		foreach x of varlist `covars' {
			local row=`row'+1
			local col=2	
			local varlabelx :  var label `x'
			
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'

				foreach y of varlist `outvars1' {
				local varlabely :  var label `y'
				
			
					qui: count if `x'==1 & `y'==1 & `z'==1 & anyAM==1	
						if r(N)==0 {
					qui: count if `y'==1 &  `z'==1 & anyAM==1
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
						
				estpost svy, subpop(if anyAM==1 & `z'==1 & `y'==1): tab `x', ci per nototal

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




**# 
********************************************************************************
********************************************************************************
*III. STRATUM RESULTS
********************************************************************************
********************************************************************************

										// the only difference in this table is that the whole analysis loops over each stratum to create a separate tab in the final excel output (i.e. foreach s of varlist abia kano lagos...)
*$$$

foreach s of varlist `stratumlist' {


*table label
	
	local tabname T_iii_`s'
	
	

	***************
	*FOOTNOTES

	*Footnote: Number of anyAM outltes, for each outlet type
	count if pnp==1 & anyAM==1  & `s'==1 
	local footnote1 =r(N)
	
	count if pfp==1 & anyAM==1  & `s'==1 
	local footnote2 =r(N)
	
	count if pop==1 & anyAM==1  & `s'==1 
	local footnote3 =r(N)

	count if drs==1 & anyAM==1  & `s'==1  
	local footnote4 =r(N)
	
	count if inf==1 & anyAM==1  & `s'==1 
	local footnote5 =r(N)
	
	count if lab==1 & anyAM==1  & `s'==1 
	local footnote6 =r(N)
	
	count if wls==1 & anyAM==1 & `s'==1  
	local footnote7 =r(N)

	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & `s'==1 
	***store the count to include in footnote?
		local footnote8 =r(N)

	*file name and sheet
	putexcel set "${tables}/2.2_Availability of antimalarials in antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
	putexcel A3=("variable name")
	
	*footnotes into excel file
	putexcel C1= ("`s' Footnote - N anyAM outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")

	
	***tables output:

		local row=3
		local col=2

	foreach x of varlist `covars' {
		local row=`row'+1
		local col=2	
		local varlabelx :  var label `x'
		

			foreach y of varlist `outvars1' {
			local varlabely :  var label `y'
			
		
				qui: count if `x'==1 & `y'==1 & `s'==1 & anyAM==1 
					if r(N)==0 {
					count if `y'==1 & `s'==1 & anyAM==1 
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
					
			estpost svy, subpop(if anyAM==1 & `s'==1 & `y'==1): tab `x', ci per nototal

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
										// the only difference in this table is that the whole analysis loops over each stratum to create a separate tab in the final excel output (i.e. foreach s of varlist abia kano lagos...)
										// and also includes the rural/urban loop (as in table II)

*$$$
foreach s of varlist `stratumlist' {

		*table label
		
local tabname T_iv_`s'		

		***************
		*FOOTNOTES

		*Footnote: Number of anyAM outltes, for each outlet type
		count if pnp==1 & anyAM==1 & `s'==1 & Ru1==1
		local footnote1 =r(N)
		
		count if pfp==1 & anyAM==1  & `s'==1 & Ru1==1
		local footnote2 =r(N)
		
		count if pop==1 & anyAM==1  & `s'==1 & Ru1==1
		local footnote3 =r(N)

		count if drs==1 & anyAM==1  & `s'==1 & Ru1==1
		local footnote4 =r(N)
		
		count if inf==1 & anyAM==1 & `s'==1 & Ru1==1
		local footnote5 =r(N)
		
		count if lab==1 & anyAM==1 & `s'==1 & Ru1==1
		local footnote6 =r(N)
		
		count if wls==1 & anyAM==1  & `s'==1 & Ru1==1
		local footnote7 =r(N)

		*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
		*(were not interviewered or completed a partial interview).
		count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & `s'==1 & Ru1==1
		***store the count to include in footnote
			local footnote8 =r(N)

		***************
		*FOOTNOTES

		*Footnote: Number of anyAM outltes, for each outlet type
		count if pnp==1 & anyAM==1 & `s'==1 & Ru2==1
		local footnote9 =r(N)
		
		count if pfp==1 & anyAM==1  & `s'==1 & Ru2==1
		local footnote10 =r(N)
		
		count if pop==1 & anyAM==1  & `s'==1 & Ru2==1
		local footnote11 =r(N)

		count if drs==1 & anyAM==1  & `s'==1 & Ru2==1
		local footnote12 =r(N)
		
		count if inf==1 & anyAM==1 & `s'==1 & Ru2==1
		local footnote13 =r(N)
		
		count if lab==1 & anyAM==1 & `s'==1 & Ru2==1
		local footnote14 =r(N)
		
		count if wls==1 & anyAM==1  & `s'==1 & Ru2==1
		local footnote15 =r(N)

		*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
		*(were not interviewered or completed a partial interview).
		count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & anyAM==1 & `s'==1 & Ru2==1
		***store the count to include in footnote
			local footnote16 =r(N)	
			
					
		*file name and sheet
		putexcel set "${tables}/2.2_Availability of antimalarials in antimalarial-stocking outlets_$tabver", sheet("`tabname'") modify

		*labels	
		putexcel A1=("`tabname'")
		putexcel B3=("Point estimate") C3=("Lower CI") D3=("Upper CI") E3=("N")
		putexcel A3=("variable name")
		
		*footnotes into excel file:
		putexcel C1= ("Rural `s' Footnote - N anyAM outlets: Private not for profit=`footnote1'; private not for profit=`footnote2'; pharmacy=`footnote3'; PPMV=`footnote4'; informal=`footnote5'; labs = `footnote6'; wholesalers= `footnote7'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote8' ")
		putexcel D1= ("Urban `s' Footnote - N anyAM outlets: Private not for profit=`footnote9'; private not for profit=`footnote10'; pharmacy=`footnote11'; PPMV=`footnote12'; informal=`footnote13'; labs = `footnote14'; wholesalers= `footnote15'. Outlets that met screening criteria for a full interview but did not complete the interview (were not interviewed or completed a partial interview) = `footnote16' ")

		
		***tables output:

			local row=3
			local col=2

		foreach x of varlist `covars' {
			local row=`row'+1
			local col=2	
			local varlabelx :  var label `x'
			
			foreach z of varlist `rural' {
			local varlabelz :  var label `z'

				foreach y of varlist `outvars1' {
				local varlabely :  var label `y'
				
			
					qui: count if `x'==1 & `y'==1 & `z'==1  & `s'==1 & anyAM==1	
						if r(N)==0 {
					qui: count if `y'==1 & `s'==1 & `z'==1 & anyAM==1
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
						
				estpost svy, subpop(if anyAM==1 & `z'==1 & `y'==1 & `s'==1 ): tab `x', ci per nototal

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
