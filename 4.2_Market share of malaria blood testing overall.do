
/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level results - i.e. across the whole greogrpahic reach for which the study was designed to be representative.
	II. National level results disaggregated by urban/ rural - i.e. if your study is stratified by urban/rural, the II results show that disaggregation
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
	IV. Results by strata dissagregated by urban/ rural - i.e. other geographical stratification (eg. region/ state) and urban/rural
*/

*Comment out any tables that are not relevant to this implementaiton using /* */ 

*VOLUMES OF PRODUCTS IS FOR INDIVIDUAL PRODUCTS AND THEREFORE THE PRODUCT LEVEL
* DATASET SHOULD BE IDENTIFIED HERE:


clear

use "${mngmtdata}/${country}_${year}_rdt_micro_data", clear


*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file

include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"

	

	**CONFIRM THE MARKET SHARE WEIGHTS ARE BEING USED FOR THIS ANALYSIS
	
	***Market share weights	
	svyset c4 [pweight=wt_marketShare], strata(strata) fpc(fpc)
	svydes
	
*Droping outlets missing outlet type.
	drop if outcat2==. 


	
	
	
*###
* PLEASE NOTE THAT IN THIS FILE, THE ANALYSIS TO OUTPUT AVAILABILTY RESULTS IS 
* REPEATED FOR EACH OF I TO IV ABOVE. 
* WE HAVE ONLY FULLY ANNOTATED THE FIRST SET OF CODE (FOR NATIONAL LEVEL RESULTS),
* AS THE SAME COMMENTS APPLY TO SUBSEQUENT CODE. ANY NEW CODE FOR tables ii - iv IS
* ANNOTATED WHERE NECCESSARY

* THE PUTEXCEL COMMAND/ STATA PACKAGE IS THE TOOL USED TO OUTPUT THE RESULTS FOR MOST ANALYSIS 



	
**# 
********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************
	
	

**# 
********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************
	
	


		*table label
		
local tabname T_i		


	**FOOTNOTES
	*ENSURE THAT EACH OUTLET TYPE IN THE SURVEY IS INCLUDED BELOW AND SAVED AS A SEPARATE LOCAL FOOTNOTE MACRO 

		sum volume if booster==0  // COUNTS THE OVERALL VOLUME OF ANTIMALARIALS SOLD IN ALL OUTLETS
		local footnote1 =r(N) // STORES THAT RESULT IN A LOCAL MACRO
		
		sum volume if booster==0 & pnp==1  // COUNTS THE OVERALL VOLUME OF ANTIMALARIALS SOLD IN OUTLET TYPE "NOT FOR PROFIT"
		local footnote2 =r(N) // STORES THAT RESULT IN A LOCAL MACRO
	
		sum volume if booster==0 & pfp==1 
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1 
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1 
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1 
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1 
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1 
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=. 
		local footnote9 =r(N) // STORES THAT RESULT IN A LOCAL MACRO

	*file name and sheet
		*USING PUTEXCEL COMMAND, LOCATE AND NAME THE EXCEL FILE FOR THE RESULTS OF THIS ANALYSIS (NOTE THAT THIS COMMAND SHOULD BE IDENTICAL FOR ALL ANALYSIS IN THIS DO FILE) 
	putexcel set "${tables}/4.2_Market share of tests_$tabver", sheet("`tabname'") modify

	*labels	
	*ADDING LABELS AND INFORMAITON TO BE WRITTEN TO THE EXCEL FILE
	putexcel A1=("`tabname'")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
	
	*WRITES THE FOOTNOTES TO THE EXCEL FILE
	putexcel B1= ("'Footnote: Volume data were available for the following total number of diagnostic products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	
	

	*THE NEXT SECTION ANALYSES THE WEIGHTED DATA AND WRITES THE RESULTS TO THE EXCEL OUTPUT FILE.
	* IT SHOULD NOT REQUIRE ANY MODIFICATIONS. 
	* SEE 1.1 AVAILABLITY OF ANTIMALARIALS AMONG ALL SCREENED OUTLETS FOR MORE COMPLETE NOTES ON ANALYSIS LOOPS; WE JUST NOTE DIFFERENCES IN THIS FILE
	
	*TABLES ANALYSIS AND OUTPUT:

	*note that providing the variables and datasets have been correctly set up, no changes should be made to the below syntax:
	
	*this code loops over each type of product (x) and outlet (y), and prints results to excel, calculating and saving weighted VOLUME ESTIMATES, lower and upper confidence interval, and N for each product-outlet
	*combination. Products are listed in the excel on rows, outlets on columns. 
	
		local row=3
		local col=2
		

		foreach x of varlist `dvol_cov' {				// specifies the list of products for which the total volume will be calculated
		recode `x' (0 = .) 								// ensures that zero volume products are coded to missing for this analysis
		
		local row=`row'+1
		local col=2	
		
		local varlabelx :  var label `x'

		foreach y of varlist `outvars4' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1 & volume!=.
					if r(N)==0 {
						
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
			putexcel `alphacol'`row'=("0" )
			local col=`col'+1			
						
						
						}
		
			else {	
				
		
		svy: total volume if `y'==1 , over(`x')		// weighted estimate of within-outlet y total volume of x product sold/distributed
					mat list e(b)							// subsequent matrix commands pull results to be tabluated
						mat volume=get(_b)
					
					
					mat list e(V)
						matrix b=e(b)
						scalar tot=b[1,1]
						mat variance=e(V)
						scalar variance=variance[1,1]
						scalar bound= sqrt(variance)*invttail(e(df_r),0.5*(1-c(level)/100)) // calculates ocnfidence interval based on point estimate and variance
							
			local varlabel :  var label	`x'

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1]) 			// point estimate for volume of x product in y outlet inserted in excel spreadsheet
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			
			if (volume[1,1] - bound)<0 {					// inserts 0 in results for lower bound <0 from above calculation 
			putexcel `alphacol'`row'=("0.0")
			local col=`col'+1
			}
			else {
		
			putexcel `alphacol'`row'=(volume[1,1] - bound) // includes lower bound in excel output
			local col=`col'+1
				}
			mata: st_local("alphacol", numtobase26((`col'))) 
			putexcel `alphacol'`row'=(volume[1,1] + bound) // includes upper bound in excel output
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(e(N))					// includes N products in excel outpout
			local col=`col'+1
		}	
	}
}

*ends

	

	
**# 
********************************************************************************
********************************************************************************
*I. National level results by rural / urban
********************************************************************************
********************************************************************************
***** updated for each table:
	local tabname T_ii

	**FOOTNOTES
		
		*rural
		sum volume if booster==0 & Ru1==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1 & Ru1==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1 & Ru1==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1 & Ru1==1
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1 & Ru1==1
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1 & Ru1==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1 & Ru1==1
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1 & Ru1==1
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.  & Ru1==1
		local footnote9 =r(N)

		
		*urban
		sum volume if booster==0  & Ru2==1
		local footnote10 =r(N)
		
		sum volume if booster==0 & pnp==1 & Ru2==1
		local footnote11 =r(N)
	
		sum volume if booster==0 & pfp==1 & Ru2==1
		local footnote12 =r(N)
	
		sum volume if booster==0 & pop==1 & Ru2==1
		local footnote13 =r(N)
		
		sum volume if booster==0 & drs==1 & Ru2==1
		local footnote14 =r(N)
	
		sum volume if booster==0 & inf==1 & Ru2==1
		local footnote15 =r(N)
		
		sum volume if booster==0 & lab==1 & Ru2==1
		local footnote16 =r(N)
			
		sum volume if booster==0 & wls==1 & Ru2==1
		local footnote17 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=. & Ru2==1
		local footnote18 =r(N)
		
		
	*file name and sheet
	putexcel set "${tables}/4.2_Market share of tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel B1= ("Rural Footnote: Volume data were available for the following total number of diagnostic products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	putexcel C1= ("Urban Footnote: Volume data were available for the following total number of diagnostic products=`footnote10';  by outlet type: Private not for profit=`footnote11'; private not for profit=`footnote12'; pharmacy=`footnote13'; PPMV=`footnote14'; informal=`footnote15'; labs = `footnote16'; wholesalers= `footnote17';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote18'" )

	
	**tables loop and putexcel output	

		local row=3
		local col=2
		

		foreach x of varlist `dvol_cov' {
		recode `x' (0 = .) 
		
		local row=`row'+1
		local col=2	
		
		local varlabelx :  var label `x'

		foreach z of varlist `rural' {				// note includion of rural/urban loop (z) here; local macro rural is defined in the local_definitions.doh file
		local varlabelz :  var label	`z'
			
		
		foreach y of varlist `outvars4' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1 & `z'==1 & volume!=.
					if r(N)==0 {
						
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
			putexcel `alphacol'`row'=("0" )
			local col=`col'+1			
						
						
						}
		
			else {	
				
		
		svy: total volume if `y'==1 & `z'==1 , over(`x')
					mat list e(b)
						mat volume=get(_b)
					
					
					mat list e(V)
						matrix b=e(b)
						scalar tot=b[1,1]
						mat variance=e(V)
						scalar variance=variance[1,1]
						scalar bound= sqrt(variance)*invttail(e(df_r),0.5*(1-c(level)/100))
							
			local varlabel :  var label	`x'

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			
			if (volume[1,1] - bound)<0 {
			putexcel `alphacol'`row'=("0.0")
			local col=`col'+1
			}
			else {
		
			putexcel `alphacol'`row'=(volume[1,1] - bound)
			local col=`col'+1
				}
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1] + bound)
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(e(N))
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

foreach s of varlist `stratumlist' {				//note the additional loop for strata here, producing a new tab in the final excel for each stratum
	
		
		*table label
		
local tabname T_iii_`s'		



	**FOOTNOTES
	
		sum volume if booster==0  & `s'==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1  & `s'==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1  & `s'==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1  & `s'==1
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1  & `s'==1
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1  & `s'==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1  & `s'==1
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1  & `s'==1
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & `s'==1
		local footnote9 =r(N)

	*file name and sheet
	putexcel set "${tables}/4.2_Market share of tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel B1= ("`s' Footnote: Volume data were available for the following total number of diagnostic products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	
	**tables loop and putexcel output	

		local row=3
		local col=2
		

		foreach x of varlist `dvol_cov' {
		recode `x' (0 = .) 
		
		local row=`row'+1
		local col=2	
		
		local varlabelx :  var label `x'

		foreach y of varlist `outvars4' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1  & `s'==1 &  volume!=.
					if r(N)==0 {
						
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
			putexcel `alphacol'`row'=("0" )
			local col=`col'+1			
						
						
						}
		
			else {	
				
		
		svy: total volume if `y'==1 & `s'==1, over(`x')
					mat list e(b)
						mat volume=get(_b)
					
					
					mat list e(V)
						matrix b=e(b)
						scalar tot=b[1,1]
						mat variance=e(V)
						scalar variance=variance[1,1]
						scalar bound= sqrt(variance)*invttail(e(df_r),0.5*(1-c(level)/100))
							
			local varlabel :  var label	`x'

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			
			if (volume[1,1] - bound)<0 {
			putexcel `alphacol'`row'=("0.0")
			local col=`col'+1
			}
			else {
		
			putexcel `alphacol'`row'=(volume[1,1] - bound)
			local col=`col'+1
				}
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1] + bound)
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(e(N))
			local col=`col'+1
		}	
	}
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



	**FOOTNOTES
		
		*rural
		sum volume if booster==0 & Ru1==1 & `s'==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1 & Ru1==1 & `s'==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1 & Ru1==1 & `s'==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1 & Ru1==1 & `s'==1
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1 & Ru1==1 & `s'==1
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1 & Ru1==1 & `s'==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1 & Ru1==1 & `s'==1
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1 & Ru1==1 & `s'==1
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.  & Ru1==1 & `s'==1
		local footnote9 =r(N)

		
		*urban
		sum volume if booster==0  & Ru2==1 & `s'==1
		local footnote10 =r(N)
		
		sum volume if booster==0 & pnp==1 & Ru2==1 & `s'==1
		local footnote11 =r(N)
	
		sum volume if booster==0 & pfp==1 & Ru2==1 & `s'==1
		local footnote12 =r(N)
	
		sum volume if booster==0 & pop==1 & Ru2==1 & `s'==1
		local footnote13 =r(N)
		
		sum volume if booster==0 & drs==1 & Ru2==1 & `s'==1
		local footnote14 =r(N)
	
		sum volume if booster==0 & inf==1 & Ru2==1 & `s'==1
		local footnote15 =r(N)
		
		sum volume if booster==0 & lab==1 & Ru2==1 & `s'==1
		local footnote16 =r(N)
			
		sum volume if booster==0 & wls==1 & Ru2==1 & `s'==1
		local footnote17 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=. & Ru2==1 & `s'==1
		local footnote18 =r(N)
		
		
	*file name and sheet
	putexcel set "${tables}/4.2_Market share of tests_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel B1= ("Rural `s' Footnote: Volume data were available for the following total number of diagnostic products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	putexcel C1= ("Urban `s' Footnote: Volume data were available for the following total number of diagnostic products=`footnote10';  by outlet type: Private not for profit=`footnote11'; private not for profit=`footnote12'; pharmacy=`footnote13'; PPMV=`footnote14'; informal=`footnote15'; labs = `footnote16'; wholesalers= `footnote17';   The number of diagnostic products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote18'" )

	
	**tables loop and putexcel output	

		local row=3
		local col=2
		

		foreach x of varlist `dvol_cov' {
		recode `x' (0 = .) 
		
		local row=`row'+1
		local col=2	
		
		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label	`z'
			
		
		foreach y of varlist `outvars4' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1  & `z'==1  & `s'==1 & volume!=.
					if r(N)==0 {
						
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
			putexcel `alphacol'`row'=("0" )
			local col=`col'+1			
						
						
						}
		
			else {	
				
		
		svy: total volume if `y'==1 & `z'==1  & `s'==1, over(`x')
					mat list e(b)
						mat volume=get(_b)
					
					
					mat list e(V)
						matrix b=e(b)
						scalar tot=b[1,1]
						mat variance=e(V)
						scalar variance=variance[1,1]
						scalar bound= sqrt(variance)*invttail(e(df_r),0.5*(1-c(level)/100))
							
			local varlabel :  var label	`x'

			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")
			
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1])
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			
			if (volume[1,1] - bound)<0 {
			putexcel `alphacol'`row'=("0.0")
			local col=`col'+1
			}
			else {
		
			putexcel `alphacol'`row'=(volume[1,1] - bound)
			local col=`col'+1
				}
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(volume[1,1] + bound)
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(e(N))
			local col=`col'+1
				}
			}	
		}
	}
}



	**ends
