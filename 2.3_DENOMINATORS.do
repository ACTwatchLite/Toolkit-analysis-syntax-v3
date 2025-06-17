

/*******************************************************************************
	ACTwatch LITE 
	Step 2.3 GENERATE DENOMINATOR VARIABLES	
	
********************************************************************************/
/*
This .do file generates key binary variables that define the analysis denominators used throughout the results tables. These variables categorize outlets based on eligibility, screening status, and interview completion, allowing analysts to consistently calculate proportions and disaggregate results by relevant groups.
*/



/*The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  
*/
  
 
 /*
 	NOTE 
	*EACH* STEP FLAGGED WITH "$$$" HAS SECTIONS WHERE MANUAL INPUTS OR EDITS ARE REQUIRED. 	
	REVIEW LINES OF SYNTAX MARKED WITH "$$$". MANAGE/CLEAN DATA ACCORDINGLY. 
	
*/


*** SECTION A OF THE MASTERFLIE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	
	


******************************************************************************* 
**# 2.3 GENERATE DENOMINATOR VARIABLES	
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear

	
	/* ### The following variables are required to set the denominator when running tables. 
	### The syntax should not require modification.
	$$$ Read through the syntax "02_management/binary_vars/denominators_syntax.do" to check for any edits required
	$$$ Then run
*/
	

* ### The following variables are required to set the denominator when running tables. 
* ### The syntax should not require modification.
	
	lab def finalvals ///
		1 "Completed interview" ///
		2 "Outlet does not meet screening criteria" ///
		104 "Not screened: Respondent not available/Time not convenient" ///
		106 "Not screened: Outlet closed permanently" ///
		107 "Not screened: Other" ///
		108 "Not screened: Refused" ///
		204 "Not interviewed: Respondent not available/Time not convenient" ///
		208 "Not interviewed: Refused" ///
		303 "Partial interview: Interview interrupted" ///
		304 "Partial interview: Respondent not available/time not convenient" ///
		307 "Partial interview: Other" ///
		308 "Partial interview: Refused to continue" ///
		309 "Partial interview: AM audit incomplete" ///
		310 "Partial interview: RDT audit incomplete" ///
		400 "Informal outlet sheet used"
		
	lab val finalIntStat finalvals
	ta finalIntStat if nOut==1,m
	ta finalIntStat,m nol	


**# CHECK ELIGIBILITY 
			cap drop eligible_new
			gen eligible_new =.
				recode eligible_new (.=1) if am_stockcurrent==1
				recode eligible_new (.=2) if am_stockcurrent==0 & am_stockpast==1
				recode eligible_new (.=3) if am_stockcurrent==0 & (rdt_stock==1 | micro_stockcurrent==1)
				lab def eliglbl 1 "has AM in stock" 2 "had AM in stock in previous 3 months but not today" ///
				3 "has or had in prev 3m RDT or microscopy in stock, no AM in stock", modify
				lab val eligible_new eliglbl
			ta eligible_new,m

			ta finalInt eligible_new  if nOut==1, m 

			cap drop eligible 
			rename eligible_new eligible
				lab var eligible "NEW eligible recode"
				lab val eligible eliglbl
			order eligible, after(consented)	

			
**# GENERATE BINARY VARIABLES

***screened - outlets that were screened
		gen screened=1 if !inlist(finalIntStat,103,104,105,106,107,108) & finalIntStat!=.
			lab variable screened "Screened"
			tab finalIntStat screened if nOut==1, m	
		
***interviewed - outlets that started a full interview 
		gen interviewed=1 if inlist(finalIntStat,1,303,304,305,307,308, 309,310, 400)
			replace interviewed=. if missing(screened)
			lab var interviewed "Interviewed"
			tab finalIntStat interviewed if nOut==1, m	
			tab interviewed if nOut==1, m	

***enum - outlets that were enumerated	
		gen enum=1 if !missing(finalIntStat) //& nOut==1
			lab var enum "Enumerated Outlet"
			tab enum if nOut==1, m	

***denomEligible - outlets that were eligible (AM-stocking, recent AM-stockist, testing/diagnosis only)
		gen denomEligible=.
			recode denomEligible (.=1) if eligible!=. & interviewed==1
			lab var denomEligible "Eligible: current/recent AM stockist & testing only"
			tab denomEligible if nOut==1, m	

***denomAMcurrent - outlets that stocked antimalarials at the time of the interview (AM-stocking)
		gen denomAMcurrent=.
			recode denomAMcurrent (.=1) if eligible==1 & interviewed==1
			lab var denomAMcurrent "Eligible: current AM"
			tab denomAMcurrent if nOut==1, m	

***denomAMrecent - outlets that stocked antimalarials within the last 3 months (recent AM-stockist)
		gen denomAMrecent=.
			recode denomAMrecent (.=1) if eligible==2 & interviewed==1
			lab var denomAMrecent "Eligible: recent AM" 
			tab denomAMrecent if nOut==1, m		

*denomDX - outlets that provide testing only (testing/diagnosis only)
		gen denomDX=.
			recode denomDX (.=1) if eligible==3 & interviewed==1 
			lab var denomDX "Eligible: blood testing only"	
			tab denomDX if nOut==1, m	

*Sc El ElNIn InAmStock InAmRec InDx - denominator dummy varibles
*!!!The following indicators have been generated specifically for the detailed sample description table (Table X2).
		gen Sc=screened
			lab var Sc "Screened"
		gen El=1 if inrange(eligible,1,3) & interviewed==1
			lab var El "Eligible, interviewed"
		gen ElNIn=1 if inrange(eligible,1,3) & interviewed!=1
			lab var ElNIn "Eligible, not interviewed" 
		gen InAmStock=1 if interviewed==1 & eligible==1
			lab var InAmStock "Interviewed, stocking antimalarials"
		gen InAmRec=1 if interviewed==1 & (eligible==1 | eligible==2)
			lab var InAmRec "Interviewed, currently or recently stocking antimalarials"
		gen InDx=1 if interviewed==1 & eligible==3
			lab var InDx "Interviewed, stocking diagnostics"	

	
save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

		
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
