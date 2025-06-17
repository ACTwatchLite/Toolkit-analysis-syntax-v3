

/*******************************************************************************
	ACTwatch LITE 
	Step 0.3   PREPARE PRODUCT LISTS
	
********************************************************************************/
/* Product lists were used to search through a list of known antimalarial and RDTs during data collection instead of manually entering all product information. These are in .csv format, but need to be converted to .dta to use in this analysis. This will be used to merge/ fix any errors amended during data collection and to determine which products are PQ. 

*NOTE IF THE PRODLISTDIR IN STEP 0.4 IS NOT SET CORRECTLY, THIS .DO WILL NOT RUN

*THIS ONLY NEEDS TO BE RUN ONCE

* This Stata script prepares product lists for antimalarials and rapid diagnostic tests (RDTs) by converting CSV files to .dta format, cleaning variable names, standardizing text to uppercase, and renaming ID variables (amcode for antimalarials and rdtcode for RDTs). It checks for duplicate IDs and counts observations before saving cleaned datasets to specified directories. The script ensures standardized and deduplicated master lists for further data validation or analysis.

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
	
	




********************************************************************************
*STEP 0.3 - PREPARE PRODUCT LISTS
*******************************************************************************	

*	ANTIMALARIALS 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*CONVERT CSV TO DTA	
		clear
	$$$	insheet using "${prodlistdir}/[insert directory of the antimalarial list in excel format here]"
		
	*CLEAN
		foreach var of varlist _all {
		rename `var' `var'_master // ### renames all variables with _master suffix 
		}
		strtu // ### converts all string variable contents to uppercase
		rename id_master amcode //  ### renames identification ID variable in the antimalarial dataset to amcode

		*check and fix duplicates in amcode 
		duplicates list amcode	
		
		count // number of observations in the dataset
		
	*SAVE
		save "${lists}/antimalarial_masterlist.dta", replace // ### save the antimalarial dataset here
			
			 
*	RDTs
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*CONVERT CSV TO DTA
		/* EXAMPLE:
		clear 
		insheet using "${prodlistdir}/rdt_masterlist.csv"
		*/ 
		
		clear 
	$$$	insheet using "" [insert directory of the RDT list in excel format here]
		
	*CLEAN
		foreach var of varlist _all {
			rename `var' `var'_master // ### renames all variables with _master suffix 
		}
		strtu // ### converts all string variable contents to uppercase
		rename id_master rdtcode //  ### renames identification ID variable in the antimalarial dataset to amcode

		*check and fix duplicates in rdtcode
		duplicates list rdtcode	
		
		count // number of observation
		
	*SAVE
		save "${lists}/rdt_masterlist.dta", replace // save tha RDT dataset here
		
		
		
		
		
		
		
		
		
			
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************


		
