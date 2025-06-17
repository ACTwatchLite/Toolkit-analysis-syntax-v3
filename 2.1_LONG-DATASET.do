
/*******************************************************************************
	ACTwatch LITE 
	Step 2.1 APPEND PRODUCT DATASETS AND APPEND OUTLET DATA TO CREATE A SINGLE ANALYTIC DATASET
	
********************************************************************************/
/*
This section appends the cleaned antimalarial and RDT product audit datasets into a single long-format dataset and merges them with the outlet dataset to create one unified analytic file. A variable is generated to classify product types (e.g., TSG, non-TSG, diagnostics, stockouts), and checks are included to confirm that all product records are correctly linked to an outlet. After verifying merge results and recoding missing values, the final cleaned dataset is saved for use in downstream analysis.
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
**# 2.1	CREATE SINGLE DATASET
********************************************************************************	
clear
use "${cleandir}/AwL_${country}_${year}-amaudit_clean.dta", clear

*create a variable to identify product types
	gen productype=.
		lab def prodtypelbl 1 "TSG" 2 "NT" 3 "Diagnostics" 4 "Stock-out" // tsg=tablet, suppository, granule; NT=other antimalarial types
		lab val  productype prodtypelbl
		
		recode productype (.=1) if inlist(a3,1,2,3) //TSG 
		recode productype (.=2) if inlist(a3,4,5,6,7,8) //non-TSG

	ta productype,m
	
*Append product datasets (antimalarial & RDT)
	append using "${cleandir}/AwL_${country}_${year}-rdtaudit_clean.dta" 

	recode productype .=3 if setofrdtaudit!=""
	
	ta productype, m

	cap drop _merge

	save "${mngmtdata}/${country}_${year}_amrdt_long_cleaned_temp.dta", replace
	

***Merge ALL outlet level variables to appended product dataset
* note select variables have been merged to product datasets for cleaning in 1 CLEANINGS .do files. This step merges all outlet level variables

	use "${cleandir}/AwL_${country}_${year}-outlet_clean.dta", clear 
	cap drop _merge
	
	merge 1:m key using "${mngmtdata}/${country}_${year}_amrdt_long_cleaned_temp.dta"
	
	ta _merge productype, m
	
/* $$$ add merge results here: 

   
*/

*ALL PRODUCTS (AM/RDT) SHOULD MATCH TO AN OUTLET
*NOT ALL OUTLETS MUST MATCH TO PRODUCTS (THEY MAY HAVE BEEN SCREENED OUT, 
*OR BE STOCKED OUT, FOR EXAMPLE)
	
	$$$ CHECK MERGE
			*$$$ Check outlet records with no antimalarials/diagnostics. Note that not all outlets will necessarily have AM / diag. audits, but confirm the list
			br if _merge==1	
			list key outletid if _merge==1
			list key setofamaudit if _merge==1		
/*
			confirm list is correct; review cleaning syntax for errors
			*/
			
			*$$$ All antimalarial (am) audit forms should be linked to an outlet form. Check am audit records that dont match to an outlet here:
			br if _merge==2
			ta productype if _merge==2
			list key setofamaudit if _merge==2

/*
			confirm list is correct; review cleaning syntax for errors
			*/
		
		*Once merge is checked and running correctly: 
		drop _merge
		
****RECODE SYSTEM MISSING VALUES CREATED DURING CLEANING
			ds, has(type numeric)
			local numvars `r(varlist)'
			foreach v of varlist `numvars' {
			mvdecode `v', mv (-998 -988 -977 -99 -97 -98 -97 -9998 -9777 -9888)
			}			
			
	
***Ensuring that stockouts are valid in the productype variable in the long data

	ta productype,m
	/*
	$$$ add results and adress any missing values


*/	
	recode productype (.=3) if d3==1 | d7==1 // diagnostics
	recode productype(.=4) if  (a16==1 | d16==1) // stocked out

		
**Save dataset
save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long.dta", replace	
	
	
	
	
	
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
