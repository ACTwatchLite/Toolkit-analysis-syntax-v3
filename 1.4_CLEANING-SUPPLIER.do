/*
******************************************************************************
	ACTwatch LITE 
	DATA PREPARATION & CLEANING SYNTAX 
	FOR SUPPLIER DATA	
	
********************************************************************************
This syntax imports, prepares, and cleans supplier repeat group data for antimalarials and RDTs

This syntax produces a dataset in long format, with one supplier 
per row (with repeated outlet data for outlets reporting more than 1 supplier)


 The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  

 	THERE ARE MANUAL STEPS WITHIN *EACH* DO FILE FLAGGED WITH "$$$"
	REVIEW THESE AND MANAGE/CLEAN DATA ACCORDINGLY. 
	ONCE ALL $$$ ARE ADDRESSED IN ALL .DO FILES, THIS MASTERFILE CAN BE USED TO
	RUN DATA PREP, CLEANING, AND MANAGEMENT THEN PRODUCE OUTPUT TABLES.
	
STEPS: 
1.4.1 - $$$ DATA PREPARATION*
1.4.2 - $$$ DATA CLEANING**
1.4.3 - [OPTIONAL] EXPORT LIST OF SUPPLIERS FOR DATA COLLECTION FIELD TEAMS

*manual input is only required for the raw .csv data file name in the preparation 
syntax and for checking duplicates/ known errors
**manual input is required for checking and cleaning each variable in the supplier 
dataset. The syntax below can be used to structure this cleaning process, but 
additional code, checks, outputs, etc. should be well documented as changes are made. 


THE RESULTS OF THIS SYNTAX = 
A single, clean list of reported RDT and antimalarial suppliers that can be
 shared throughout data collection with field teams to guide additional  
 interviews at these supplier/ wholesale level outlets.

*/

  

  
*** SECTION A OF THE MASTERFLIE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	

* RUN STEP 1.1 TO CLEAN OUTLET LEVEL DATA BEFORE MERGING TO THIS DATASET
 


********************************************************************************
**#  1.4.1 DATA PREPARATION                        											*
********************************************************************************

**# 1.4.1.1: IMPORT DATASETS
*this step combines (appends) data on antimalarial and RDT suppliers (which are saved as 
*separate csv files by the ODK form). 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*prepare RDT suppliers for append
		* import data from primary .csv file
				clear 
			/* EXAMPLE:
			clear 
			insheet using "${datadir}/raw/AwL-${country}-${year}-final-consent_group-section6-rdt_supp1.csv", names clear
			*/
			
			$$$ insheet using "${datadir}/raw/[RDT SUPPLIER DATA FILENAME]", names clear
			

		*rename RDT supplier variables
			rename rdtsupp1 supp1
			rename rdtsupp2 supp2
			rename rdtsupp3 supp3
			rename rdtsupp4 supp4
			rename rdtsupp5 supp5
			rename rdtsupp6 supp6
			rename rdtsupp7 supp7	
					
		*create source variable 
			gen source=0
				
		* save data from primary .dta file					
		save "${datadir}/raw/AwL_${country}_${year}-suppliers_rdt.dta", replace		
		
	*prepare antimalarial suppliers for append
		* import data from primary .csv file
			/* EXAMPLE:
			insheet using "${datadir}/raw/AwL-NGA-2024-final-consent_group-section7-section7a-am_suppliers.csv", names clear
			*/	
			
			$$$ insheet using "${datadir}/raw/[AM SUPPLIER DATA FILENAME]", names clear

			
		*rename antimalarial supplier variables
			rename amsupp1 supp1
			rename amsupp2 supp2
			rename amsupp3 supp3
			rename amsupp4 supp4
			rename amsupp5 supp5
			rename amsupp6 supp6
			rename amsupp7 supp7
				
		*create source variable 
			gen source=1 
				
		* save data from primary .dta file					
		save "${datadir}/raw/AwL_${country}_${year}-suppliers_am.dta", replace		

**# 1.4.1.2:APPEND SUPPLIER DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*append am and rdt suppliers datasets
	append using "${datadir}/raw/AwL_${country}_${year}-suppliers_rdt.dta", force
			
	  
**# 1.4.1.3: LABEL VARIABLES
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	cap label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"
	cap label variable supp1 "Supplier name:"
	cap label variable supp2 "Type of supplier?"
	cap label variable supp3 "Other type of supplier?"
	cap label variable supp4 "What state is the supplier located in?"
	cap label variable supp5 "City / town of supplier."
	cap label variable supp6 "Physical address or description of business location."
	cap label variable supp7 "Contact information (if available)"
	cap label variable source "supplier type/ source dataset"	
	
	cap label define supp2 ///
		1 "International manufacturer" 2 "Local manufacturer" ///
		3 "Importer" 4 "Distributor" 5 "Pharmacy wholesale" 7 "PPMV / chemist" ///
		11 "Public sector supply chain" 12 "Other informal outlet" ///
		96 "Other private outlet/seller" 97 "Refuse to answer" 98 "Don't know"
		label values supp2 supp2

	*define the supp4 (supplier location) var labels:
	
	/* EXAMPLE: 
	label define supp4 ///
		1 "Lagos" 2 "Kano" 3 "Abia" 96 "Other" -9998 "Don't know" -9777 "Refused"
		label values supp4 supp4
*/


	label define source ///
		0 "Reported RDT supplier" 1 "Reported antimalarial supplier" 
		label values source source

		
		
		
	* label variables
	*$$$ replace variable labels with your specific form choices! 
	
	cap label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"
	label variable supp1 "Supplier name:"
	label variable supp3 "Other type of supplier"
	label variable supp5 "Supplier location - City / town"
	label variable supp6 "Supplier address"
	label variable supp7 "Supplier contact"

	label variable supp2 "Type of supplier?"
		label define supp2 1 "International manufacturer" 2 "Local manufacturer" ///
			3 "Importer" 4 "Distributor" 5 "Pharmacy wholesale" 7 "PPMV / chemist" ///
			11 "Public sector supply chain" 12 "Other informal outlet" ///
			96 "Other private outlet/seller" 97 "Refuse to answer" 98 "Don't know"
		label values supp2 supp2
	

	label variable supp99 "Type of commodities purchased"
		label define supp99 1 "Antimalarials" 2 "RDTs" 3 "Both"
		label values supp99 supp99

	label variable supp4 "Supplier location- state"
		label define supp4 1 "STATE 1" 2 "STATE 2" 3 "STATE 3" ///
			96 "Other" -9998 "Don't know" -9777 "Refused"
		label values supp4 supp4
	
	


		
		

	  
**# 1.4.1.4: PREPARE FIELD TYPES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*STRINGS 
		*define strings 
			local text_fields1 "supp1 supp3 supp5 supp6 supp7"
		* ensure that text fields are always imported as strings (with "" for missing values)
		* (note that we treat "calculate" fields as text; you can destring later if you wish)
				tempvar ismissingvar
				quietly: gen `ismissingvar'=.
				forvalues i = 1/100 {
					if "`text_fields`i''" ~= "" {
						foreach svarlist in `text_fields`i'' {
							cap unab svarlist : `svarlist'
							if _rc==0 {
								foreach stringvar in `svarlist' {
									quietly: replace `ismissingvar'=.
									quietly: cap replace `ismissingvar'=1 if `stringvar'==.
									cap tostring `stringvar', format(%100.0g) replace
									cap replace `stringvar'="" if `ismissingvar'==1
								}
							}
						}
					}
				}
				quietly: drop `ismissingvar'
				
			*trim and convert string to uppercase **USING STRTU PROGRAM**
				strtu
				
	*DATES		n/a
	*INTEGER	n/a
	*DECIMAL	n/a


**# 1.4.1.5: CHECK AND CORRECT DUPLICATES 
*duplicate unique ID's may occur during uploading data from tablets to the server. 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  			
	duplicates list key
	
	*$$$ drop duplicates found if any
	/* EXAMPLE: 
	duplicates drop key
	*/
	
	

	
**# 1.4.1.6: CORRECT KNOWN ERRORS HIGHLIGHTED DURING DATA COLLECTION
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

$$$ address any other errors noted during data collection or in the comments 	
	
	
		
	
	
**# 1.4.1.7: MERGE OUTLET-LEVEL DATA	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	rename key supplierkey
	rename parent_key key
	merge m:1 key using ///
	"${datadir}/cleaning/AwL_${country}_${year}-outlet_prepared.dta", ///
	keepusing (key date formtype auditlevel c1a c2 c3 c4 c7 outletid sa1 sa1a st1 st1a)
		/* INSERT RESULTS:

		*/
	  
$$$ check for errors with merge; check suppliers without outlet record
	
	*drop outlets without suppliers 
	drop if _merge == 2
	
	drop _merge
				 
  
**# 1.4.1.8: SAVE PREPARED DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	save "${datadir}/cleaning/AwL_${country}_${year}-suppliers_prepared.dta", replace




	
********************************************************************************
**#  1.4.2 DATA CLEANING                                                           *
********************************************************************************
* Open prepared dataset if not already in use
	*clear 	
	*use "${datadir}/cleaning/AwL_${country}_${year}-suppliers_prepared.dta", clear
	count //


**# 1.4.2.1: CHECK AND CLEAN EACH VARIABLE	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
$$$ REVIEW AND CLEAN EACH VARIABLE IN THE SUPPLIER DATASET BELOW 
	NOTE: STRING INPUTS (NAME, LOCATION, ETC REQUIRE MANUAL CLEANING)
*/

**************** SOURCE (source)
*CHECK SOURCE

	tab source, m
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed 

**************** SUPPLIER NAME (supp1)
*CLEAN NAMES

	rename supp1 supp1_orig
	gen supp1=supp1_orig, before (supp2)
	label variable supp1 "Supplier name"
	
	*general cleaning 
		replace supp1=upper(supp1)	
		replace supp1=subinstr(supp1,"é","E",.)
		replace supp1=subinstr(supp1,"É","E",.)
		replace supp1=subinstr(supp1,"	"," ",.)
		replace supp1=subinstr(supp1,"  "," ",.)
		replace supp1=subinstr(supp1,"SARL","",.)
		replace supp1=subinstr(supp1,"COMPAGNIE"," CO",.)
		replace supp1=subinstr(supp1,"COMPANY"," CO",.)
		replace supp1=subinstr(supp1,"PHARMACEUTIQUE"," PHARMA",.)
		replace supp1=subinstr(supp1,"PHARMACEUTICAL"," PHARMA",.)
		replace supp1=subinstr(supp1,"PHARMAS"," PHARMA",.)
		replace supp1="REFUSED" if supp1=="97"
		replace supp1="DONT KNOW" if supp1=="98"
		ta supp1, sort
			
	tab supp1, m
		/* INSERT RESULTS:

		*/
					
$$$ manualy review and clean names - sense check supplier names for typos, variations in naming convention that can be matched/ cleaned up, etc. 
	
	
**************** SUPPLIER TYPE (supp2 & supp3) Check missing values and inconsistency
*CLEAN SUPPLIER TYPE
	tab supp2, m
	ta supp2 if source ==1, sort
	ta supp2 if source ==0, sort
	tab supp3, sort
		/* INSERT RESULTS:
		*/
		
$$$ sense check supplier type by checking names eg if pharmacy is in the name but type is missing, recode
		

**************** SUPPLIER LOCATION (supp4 - supp6) Checking inconsistency, missing values, review adress (city, town) 
*CLEAN SUPPLIER LOCATION
	tab supp4, m
	tab supp5 supp4, m
	
	ta supp5 if supp4==96
	tab supp6, sort	
	
	replace supp6="." if supp6=="-9888" | supp6=="-9777" | supp6=="9888"
		/* INSERT RESULTS:
		*/
		
$$$ sense check location and clean typos etc, check by name if helpful



**************** SUPPLIER CONTACT INFORMATION (supp7)
*$$$ note: these data do not need to be cleaned/ made consistent as
		*they are not needed for analysis. However, they may be required for 
		*field teams to locate suppliers to include in the study (step 1.4.3 below)
	
	tab supp7, sort
	replace supp7="." if supp7=="-9888" | supp7=="-9777" | supp7=="9888"
		/* INSERT RESULTS:
		*/
		
		
	
	
	
**# 1.4.2.2: SAVE CLEAN DATASET	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
save "${datadir}/cleaning/AwL_${country}_${year}-suppliers_clean.dta", replace
		

			

********************************************************************************
**# 1.4.3 [OPTIONAL] EXPORT SUPPLIER LIST FOR FIELD TEAM
********************************************************************************
/* 

	FOR SOME ACTWATCH LITE STUDIES, SUPPLIER INFORMATION REPORTED FROM RETAIL 
	LEVEL OUTLETS WILL BE USED TO INFORM FIELD TEAMS ON WHERE TO GO TO CAPTURE 
	\ADDITIONAL DATA FROM HIGHER LEVELS OF THE SUPPLY CHAIN DURING DATA 
	COLLECTION. IF THAT IS THE STUDY DESIGN FOR THIS IMPLEMENTATION, THIS SYNTAX
	CAN BE USED TO EXPORT A LIST OF REPORTED SUPPLIERS. 
	ADDITIONAL MANUAL CLEANING IS LIKELY REQUIRED 


*/ 

 
*clear				
*use "${datadir}/cleaning/AwL_${country}_${year}-suppliers_clean.dta", replace


*DROP SUPPLIERS REPORTED MULTIPLE TIMES:
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*note if you are interested in calculating the number of times a given supplier is reported, this syntax should be commented out.
			sort supp1 supp2 supp4 supp5 supp6 supp7
			quietly by  supp1 supp2 supp4 supp5 supp6 supp7 ///
			:  gen dup1= cond(_N==1,0,_n)
			tab dup1
			*br if dup1>=1
				/* INSERT RESULTS:
				*/
			
	$$$ review and adress or drop duplicates found if any
				
			drop if dup1>1
			drop dup1
			
		*same name, type, town
			sort  supp1 supp2 supp4 supp5 supp6 supp7
			quietly by  supp1 supp2 supp4 supp5 :  gen dup2= cond(_N==1,0,_n)
			*$$$ review dups 
			tab dup2
			/* INSERT RESULTS:
			*/
			
	$$$ review and adress or drop duplicates found if any
				
			drop if dup2>1
			drop dup2


* RENAME VARIABLES FOR CLARITY	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	rename supp1 supplier_name
	rename supp2 supplier_type
	rename supp4 supplier_state
	rename supp5 supplier_town
	rename supp6 supplier_address
	rename supp7 supplier_contact
	
	

*DROP NON ESSENTIAL VARS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	cap drop key supplierkey setofam_suppliers setofrdt_supp1 dup formtype c1a outletid sa1 sa1a st1 st1a supp1_orig reported_by_* auditlevel
	drop supp3 //this should be recoded and empty by now	
	
		
			
*EXPORT EXCEL FILE FOR SUPPLIER LIST TO SUPPORT FIELDWORK AS NEEDED
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
export excel using "${datadir}/lists/supplier-list.xlsx", firstrow(variables)  replace




	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
		
