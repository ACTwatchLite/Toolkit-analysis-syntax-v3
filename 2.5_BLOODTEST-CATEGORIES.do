

/*******************************************************************************
	ACTwatch LITE 
	Step 2.5 Generate blood testing category variables 
	
********************************************************************************/
/*
This .do file generates binary variables for the top three RDT manufacturers plus "other" and "unknown". 
These variables are used to disaggregate results by manufacturer in diagnostic availability and market composition tables.
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
**# 2.5 Generate blood testing category variables 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


	$$$ Identify top 3 manufacturers.

		tab rdtmanu if productype==3 , sort	
	
	*$$$ insert results and update syntax for top 3 
		
 

	
	*$$$ Generate variables for the top 3 manufacturers.

		/* EXAMPLE:
		gen rdtmanu_1=1 if regexm(rdtmanu,"PREMIER MEDICAL CORPORATION")
		lab var rdtmanu_1 "RDT manufacturer: PREMIER MEDICAL CORPORATION"

		gen rdtmanu_2=1 if regexm(rdtmanu,"ADVY CHEMICAL")
		lab var rdtmanu_2 "RDT manufacturer: ADVY CHEMICAL"

		gen rdtmanu_3=1 if regexm(rdtmanu,"ARKRAY HEALTHCARE")
		lab var rdtmanu_3 "RDT manufacturer: ARKRAY HEALTHCARE"


		*Identify and generate variable for other manufacturers.
 
		gen rdtmanu_other=1 if rdtmanu_1!=1 & rdtmanu_2!=1 & rdtmanu_3!=1 & productype==3 & rdtmanu!=""
		lab var rdtmanu_other "RDT manufacturer: other"

		*Generate variable for unknown manufacturers.
		gen rdtmanu_dk=1 if rdtmanu=="" & productype==3
		lab var rdtmanu_dk "RDT manufacturer: don't know"

		*/ 
		

		gen rdtmanu_1=1 if regexm(rdtmanu,"ADD TOP MANUFACTURE NAME HERE")
		lab var rdtmanu_1 "RDT manufacturer: XXXX"

		gen rdtmanu_2=1 if regexm(rdtmanu,"XXXX")
		lab var rdtmanu_2 "RDT manufacturer: XXXX"

		gen rdtmanu_3=1 if regexm(rdtmanu,"XXXX")
		lab var rdtmanu_3 "RDT manufacturer: XXXXE"


		*Identify and generate variable for other manufacturers.
 
		gen rdtmanu_other=1 if rdtmanu_1!=1 & rdtmanu_2!=1 & rdtmanu_3!=1 & productype==3 & rdtmanu!=""
		lab var rdtmanu_other "RDT manufacturer: other"

		*Generate variable for unknown manufacturers.
		gen rdtmanu_dk=1 if rdtmanu=="" & productype==3
		lab var rdtmanu_dk "RDT manufacturer: don't know"

	
	

	
	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
