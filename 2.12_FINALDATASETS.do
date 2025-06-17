

/*******************************************************************************
	ACTwatch LITE 
	Step 2.12 Finalize and save datasets for results generation 
	
********************************************************************************/
/*
This .do file prepares and saves the final cleaned datasets for analysis. It compresses the full product dataset, merges in supplier data, and generates survey-ready datasets at both the full product level and the outlet level. It also creates an RDT-only subset for specific analyses.
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
**# 2.12 SAVE DATA
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear



********************************************************************************
********************************************************************************
*SAVE FULL, OUTLET AND RDT DATA SETS


*******************
*SAVE FULL DATA SET
	*Compress and save data set
	qui: compress
	drop _merge
	
	save "${mngmtdata}/${country}_${year}_full_data", replace
	
* MERGE IN SUPPLIER DATASET

	use "${datadir}/cleaning/AwL_${country}_${year}-suppliers_clean.dta", clear
	
	drop key
	rename parent_key key
	duplicates report key
	
	merge m:m key using "${mngmtdata}/${country}_${year}_full_data"
	
	drop if _merge==1
	drop _merge
	
	save "${mngmtdata}/${country}_${year}_full_data", replace


***************************
*SAVE OUTLET-LEVEL DATA SET
	*Reopen full data set
	
	use "${mngmtdata}/${country}_${year}_full_data", clear
	
	*Keep 1 observation from each outlet
	keep if nOut==1

	*Survey set data set FOR ALL OUTLETS (I.E. NOT MARKET SHARE)
	svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc)
	svydes

	*Compress and save data set
	save "${mngmtdata}/${country}_${year}_outlet_data", replace


***************************
*SAVE RDT DATA SET
	*Reopen full data set
	
	use "${mngmtdata}/${country}_${year}_full_data", clear

	*Keep only RDT and micro products
	keep if productype==3
	recode qardt (.=0) 

	*Survey set data set FOR MARKET SHARE
	svyset c4 [pweight=wt_marketShare], strata(strata) fpc(fpc)
	svydes

	*Compress and save data set
	qui: compress
	
	save "${mngmtdata}/${country}_${year}_rdt_data", replace
	clear


*Close log file
cap log close



	*************************
	*************************
	******	END 		*****
	*************************
	*************************
