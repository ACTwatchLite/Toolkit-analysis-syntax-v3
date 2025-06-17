
/*******************************************************************************
	ACTwatch Lite 
	Step 2.13 Sensitivity Analysis
	
********************************************************************************/
/*
This step performs a market share sensitivity analysis to identify and handle 
potential volume outliers in both antimalarial and diagnostic data. It applies 
two outlier definitions—one from the Independent Evaluation (IE) and a more 
conservative version—and compares their impact using automated tables. 

THIS DATA SHOULD BE USED FOR MARKET SHARE
*/



/*The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  
*/
  
 
 /*
 	NOTE 
	*EACH* STEP FLAGGED WITH "$$$" HAS SECTIONS WHERE MANUAL INPUTS OR EDITS 
	ARE REQUIRED. 	
	
	REVIEW LINES OF SYNTAX MARKED WITH "$$$". MANAGE/CLEAN DATA ACCORDINGLY. 
	
*/


*** SECTION A OF THE MASTERFILE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	

**# 
********************************************************************************
*ANTIMALARIAL MARKET SHARE SENSITIVITY ANALYSIS


/* !!!Volume outliers have the potential to drastically influence market share results. The market share sensitive analysis is a tool that is used to identify volume 
	 outliers and to decide on how to deal with them. Two versions of the market share analysis will be performed and the results will be compared using
	 automatically formatted tables. 
		1.	Identify outliers using the IE volume outlier definition and set outliers to missing.
		2.	Identify outliers using more conservative outlier definition and set outliers to missing.
	
	Refer to the guidelines for detailed instructions on how to perform the market share sensitivity analysis. 
*/
	
	
**********************************************
*CREATE DATA SET DEFINING VOLUME OUTLIERS FROM THE ACTWATCH 1.0 INDEPENDENT EVALUATION

		
*Reopen full data set
use "${mngmtdata}/${country}_${year}_full_data", clear

*Apply survey settings FOR MARKET SHARE
svyset c4 [pweight=wt_marketShare], strata(strata) fpc(fpc)
svydes


*Keep only antimalarials not used for prophylaxis
keep if inlist(productype,1,2)
drop if drugcat1==4


*Recode volume outliers to missing based on IE volume outlier definitions.

*Private-not-for-profit health facilities
list gname a3 volume if volume>1000 & volume!=. & pnp==1 & booster==0 
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>1000 & volume!=. & pnp==1 & booster==0

*Private-for-profit health facilities
list gname a3 volume if volume>1000 & volume!=. & pfp==1 & booster==0 
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>1000 & volume!=. & pfp==1 & booster==0

*Pharmacies
list gname a3 volume if volume>500 & volume!=. & (pop==1 | ppm==1) & booster==0 
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>500 & volume!=. & (pop==1 | ppm==1) & booster==0


*Drug stores
list gname1 a3 volume if volume>500 & volume!=. & drs==1 & booster1==0
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>500 & volume!=. & drs==1 & booster1==0


*General retailers
list gname a3 volume if volume>200 & volume!=. & ger==1 & booster==0
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>200 & volume!=. & ger==1 & booster==0

*informal overall
list gname a3 volume if volume>200 & volume!=. & inf==1 & booster==0
/* ADD RESULTS HERE: 

*/
replace volume=. if volume>200 & volume!=. & inf==1 & booster==0


*Save IE volume outlier definition sensitivity analysis data set.
*!!!This dataset will be used for all three versions of the sensitivity analysis.

save "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_IE.dta", replace


********************************************************************************
*MARKET SHARE ANALYSIS -  IE VOLUME OUTLIER DEFINITIONS, OUTLIERS SET TO MISSING

use "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_IE.dta", clear		

local tabname Vol_sensitivity1
	
	*file name and sheet
	putexcel set "${sensdir}/IE_outlier_table", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
			
		**volume covariates
		ds ///
			 anyAM /// total
			 AL ASAQ APPQ DHAPPQ ARPPQ otherACT /// ACTs
			 QN CQ SP SPAQ nonartoth /// non-art oral
			 oartmono /// mono oral
			 recAS injAS injAR injAE  // severe
		local vol_cov = r(varlist)	
			
	* OUTLET VARIABLES FOR MARKET SHARE (IE. OUTLET VARIABLES WITHOUT WHOLESALE, BUT WITH TOT FIRST)
		ds ///
			tot pnp pfp pop ppm lab inf 
		local outvars = r(varlist)

		
****	THE FOLLOWING SECTION OF ANALYSIS CODE SHOULD NOT REQUIRE MODIFICATION:
		
		
		
	**tables loop and putexcel output	

	local row=3
	local col=2
		
	foreach x of varlist `vol_cov' {
	recode `x' (0 = .) 
		
		local row=`row'+1
	local col=2	
		
		local varlabelx :  var label `x'

		foreach y of varlist `outvars' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1  &  volume!=.
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
				
		
		svy: total volume if `y'==1, over(`x')
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

***

*****************************************************************************
*MARKET SHARE ANALYSIS - CONSERVATIVE OUTLIER DEFINITIONS, OUTLIERS SET TO MISSING


*Reopen base sensitivity analysis data set.
use "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_IE.dta", replace


*Investigate additional outliers (>100 AETD).
/* !!!All volumes with outliers >100 AETD should be investigated regardless of outlet type. Mark volumes as 'plausible' if the volume, although unlikely, could have been
 	 sold/distributed, or 'improbable' if the volume sold/distributed is highly unlikely. The country context, outlet type, generic name, formulation and the number of
	 packages/tablets sold should all be considered when deciding if a case is plausible or improbable.*/

	 ** ppmvs
list gname a3 volume if volume>100 & volume!=. & ppm==1 & booster==0
/* ADD RESULTS HERE: 

*/

sort outcat2 volume	 
list outcat2 c7 gname a3 volume if volume>100 & volume!=. & wls!=1, noheader noobs clean
list amauditkey c7 volume gname if volume>100 & volume!=. & wls!=1, noheader noobs clean
*!!!Copy and paste the stata output into the do file. Mark each case as plausible or improbable.
*plausible/ improbable definitions will depend on local context. The analyst should discuss each case
*with the study lead and team to confirm
*

/* ADD RESULTS HERE: 

*/
 
 **SET VOLUME TO MISSING FOR IMPLAUSIBLE
 
 /* EXAMPLE: 
replace volume=. if amauditkey=="UUID:7AF5D5D2-9DC5-46C0-97D5-91F508147A4B/CONSENT_GROUP-SECTION5-AMAUDIT[7]" | amauditkey=="UUID:56844049-D061-433A-8C35-A4C547803A94/CONSENT_GROUP-SECTION5-AMAUDIT[11]" | ///
 amauditkey=="UUID:27577FCE-76AB-4A2A-A126-A51B01A6C65F/CONSENT_GROUP-SECTION5-AMAUDIT[6]" | amauditkey=="UUID:390B1E79-E6AD-4180-B7F7-19FC0A8FBA16/CONSENT_GROUP-SECTION5-AMAUDIT[2]" | ///
 amauditkey=="UUID:21BCC690-287D-431C-ABC7-4E36B4A519D7/CONSENT_GROUP-SECTION5-AMAUDIT[3]" | amauditkey=="UUID:5DABA042-7992-4061-A118-7A09F2AB28CD/CONSENT_GROUP-SECTION5-AMAUDIT[4]" 
*/


*Save conservative volume outlier selection criteria set to missing sensitivity analysis data set.
save "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_conservative.dta", replace


*table label
		
local tabname Vol_sensitivity2	


	*file name and sheet
	putexcel set "${sensdir}/IE_outlier_table", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type")
	putexcel B3=("Volume") C3=("Lower bound") D3=("Upper bound") E3=("N")
	putexcel A3=("variable name")
	
	
	* OUTLET VARIABLES FOR MARKET SHARE (IE. OUTLET VARIABLES WITHOUT WHOLESALE, BUT WITH TOT FIRST)
			ds ///
tot pnp pfp pop ppm lab inf 
			local outvars = r(varlist)
			
			
		**volume covariates
		ds ///
 anyAM /// total
 AL ASAQ APPQ DHAPPQ ARPPQ otherACT /// ACTs
 QN CQ SP SPAQ nonartoth /// non-art oral
 oartmono /// mono oral
 recAS injAS injAR injAE  // severe
			local vol_cov = r(varlist)	

			
****	THE FOLLOWING SECTION OF ANALYSIS CODE SHOULD NOT REQUIRE MODIFICATION:


	**tables loop and putexcel output	

		local row=3
		local col=2
		

		foreach x of varlist `vol_cov' {
		recode `x' (0 = .) 
		
		local row=`row'+1
		local col=2	
		
		local varlabelx :  var label `x'

		foreach y of varlist `outvars' {
				local varlabely :  var label `y'
				
		
			qui: count if `x'==1 & `y'==1  &  volume!=.
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
				
		
		svy: total volume if `y'==1, over(`x')
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

***



$$$ review the outputted tables comparing the sets of results (including % differences) 
based on the review, decide which definition of outliers to use, and document here:

***********




********************************************************************************
*SAVE ANTIMALARIAL DATASET


$$$ Reopen selected antimalarial sensitivity analysis dataset based on review of sensitivity analysis results

*use "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_IE.dta", clear
*use "${mngmtdata}/${country}_${year}AM_market_share_sensitivity_analysis_conservative.dta", clear


*Compress and save data set

qui: compress

save "${mngmtdata}/${country}_${year}_antimalarial_data", replace

clear


********************************************************************************
*DIAGNOSTIC MARKET SHARE SENSITIVITY ANALYSIS
	
	*NO ACTWATCH LITE PILOTS TO DATE HAVE FOUND SIGNIFICANT PRIVATE SECTOR DIAGNOSTIC VOLUMES OR OUTLIERS, AND 
	*THEREFORE THIS SECTION IS TRUNCATED.
	
/* !!!Volume outliers have the potential to drastically influence market share 
	results. The market share sensitive analysis is a tool that is used to 
	identify volume outliers and to decide on how to deal with them. 
	For diagnostics, we use just the independent evaluation definitions of outliers for 
	market share analysis:
		1.	Identify outliers using the IE volume outlier definition and set outliers to missing.
	 
	IN CASES WHERE LARGE DIAGNOSTIC VOLUMES AND POTENTIAL OUTLIERS ARE IDENTIFIED
	YOU MAY WISH TO CONSIDER USING A COMPARATIVE APPROACH LIKE THE ONE USED FOR 
	ANTIMALARIALS ABOVE.
*/
	

**********************************************
*CREATE DATASET USING IE VOLUME OUTLIERS

		
*Reopen full data set

use "${mngmtdata}/${country}_${year}_full_data", clear


*Apply survey settings
	svyset c4 [pweight=wt_marketShare], strata(strata) fpc(fpc)
	svydes
	

*Keep 1 observation for each outlet stocking malaria microscopy (st_micro=1).
	keep if nOut==1
	keep if vf_micro==1
	tab d4, m
	recode rdt_true rdtmanu_1 rdtmanu_2 rdtmanu_3 rdtmanu_other rdtmanu_dk st_rdt st_qardt st_rdtmanu_1 st_rdtmanu_2 st_rdtmanu_3 st_rdtmanu_other st_rdtmanu_dk vd_rdt vf_rdt (1=0) 

*Keep variables required for market share calculations.
*keep outletid booster wt_marketShare wt_allOutlet strata c3 c4 fpc d4 outcat2 pnp pfp pop  ger itv for inf prt tot finalIntStat St*


*Generate a new variable to differentiate between microscopy and RDT products (test_type).
	gen test_type=1
	label define test_type 1"Microscopy" 2"RDT"
	label values test_type test_type                                               
	tab test_type, m


*Append RDT dataset to create a long dataset with one diagnostic per line 
*(i.e. long with respect to either micro or RDT)

append using "${mngmtdata}/${country}_${year}_rdt_data"


*Recode test_type to 2 for all cases of RDT products.
tab test_type, m
recode test_type (.=2)
tab test_type

recode rdt_true qardt (1 . = 0) if test_type==1

*Generate volume variable.
drop volume
gen volume=d4 if test_type==1
	replace volume=r13 if test_type==2
tab volume, m


*Generate additional dummy variables required for market share analysis.

*Flag for all diagnostic products.
gen total=1
lab var total "any diagnostic (micro/rdt)"

*Flag for all microscopy products.
gen microscopy=1 if test_type==1
lab var microscopy "any microscopy"

*Flag for all RDT products.
gen rdt=1 if test_type==2
lab var rdt "any rdts"

					
*Set volume variable system codes (e.g. don't know, user-missing, etc) to missing.
*!!!There should be as many recode lines as there are system codes.
recode volume (99998=.)
recode volume (998=.)
recode volume (99=.)


***Recode volume outliers to missing based on IE volume outlier definitions.

*Private-not-for-profit health facilities
list outcat2 brand manu volume if volume>1000 & volume!=. & pnp==1 & booster==0
/*!!!Copy and paste the stata output into the do file


*/
replace volume=. if volume>1000 & volume!=. & pnp==1 & booster==0

*Private-for-profit health facilities
list outcat2 brand manu volume  if volume>1000 & volume!=. & pfp==1 & booster==0
/*!!!Copy and paste the stata output into the do file


*/replace volume=. if volume>1000 & volume!=. & pfp==1 & booster==0

*Pharmacies
list outcat2 brand manu volume  if volume>500 & volume!=. & (pop==1 | ppm==1) & booster==0
/*!!!Copy and paste the stata output into the do file


*/replace volume=. if volume>500 & volume!=. & (pop==1 | ppm==1) & booster==0

*General retailers
list outcat2 brand manu volume  if volume>200 & volume!=. & ger==1 & booster==0
/*!!!Copy and paste the stata output into the do file


*/replace volume=. if volume>200 & volume!=. & ger==1 & booster==0

*Itinerant vendors
list outcat2 brand manu volume  if volume>200 & volume!=. & inf==1 & booster==0
/*!!!Copy and paste the stata output into the do file


*/replace volume=. if volume>200 & volume!=. & inf==1 & booster==0

*******************************************************************************

*Save IE volume outlier definition sensitivity analysis data set.
*!!!This dataset will be used for both versions of the sensitivity analysis.

save "${mngmtdata}/${country}_${year}_DIAG market share sensitivity analysis IE.dta", replace



*********************************************************************************

*SAVE RDT/MICROSCOPY DATASET

*Reopen diagnostic sensitivity analysis base dataset.

use  "${mngmtdata}/${country}_${year}_DIAG market share sensitivity analysis IE.dta", clear


*Compress and save data set
qui: compress
save "${mngmtdata}/${country}_${year}_rdt_micro_data", replace
clear



cap log close


	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
