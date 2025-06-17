
/*******************************************************************************
	ACTwatch LITE 
	DATA PREPARATION & CLEANING SYNTAX 
	FOR OUTLET LEVEL DATA	
	
********************************************************************************/
/*This syntax imports, prepares, and cleans data captured for each outlet visited during the study, as well as screening and provider interview data for outlets where this was conducted 
*/
  
/*The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  
*/
  
 /*
 	THERE ARE MANUAL STEPS WITHIN *EACH* DO FILE FLAGGED WITH "$$$"
	REVIEW THESE AND MANAGE/CLEAN DATA ACCORDINGLY. 
	ONCE ALL $$$ ARE ADDRESSED IN ALL .DO FILES, THIS MASTERFILE CAN BE USED TO RUN DATA PREP, CLEANING, AND MANAGEMENT THEN PRODUCE OUTPUT TABLES.
	
STEPS: 
1.1.1 - $$$ DATA PREPARATION*
1.1.2 - $$$ DATA CLEANING**

*manual input is only required for the raw .csv data file name in the preparation syntax and for checking duplicates/ known errors
**manual input is required for checking and cleaning each variable in the dataset. The syntax below can be used to structure this cleaning process, but additional code, checks, outputs, etc. should be well documented as changes are made. 

THE RESULTS OF THIS SYNTAX = 
A cleaned dataset for each outlet with outlet info, screening, and provider interview data

*/




*** SECTION A OF THE MASTERFLIE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	
	
	
*A subset of variables from this dataset will be merged to audit and supplier data so this syntax should be run first 




********************************************************************************
**#  1.1.1 DATA PREPARATION                        											
********************************************************************************

clear 

*1.1.1.1: IMPORT DATASETS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* import data from primary .csv file	
	/* EXAMPLE:
	insheet using "${datadir}/raw/AwL-NGA-2024-final.csv", names clear
	*/
	$$$ insheet using "${datadir}/raw/[OUTLET MAIN DATASET FILENAME]", names clear
			
	count // number of observations


save "${datadir}/cleaning/AwL_${country}_${year}-outlet.dta", replace

	
	
*1.1.1.2: LABEL VARIABLES  [insert directory to run label variable do-file]
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*run .do file for variable labels for this dataset. 
	do "${cleandir}/variable-lables/varlbl_syntax_outlet.do"

	
	
*1.1.1.3: PREP FIELD TYPES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*list string variables from ODK - these can be copied from software .do files
	local text_fields1 "" [insert variables to modify here]
	local text_fields2 "" [insert variables to modify here]
	local text_fields3 "" [insert variables to modify here]
	local text_fields4 "" [insert variables to modify here]

	*list date variables from ODK - these can be copied from SurveyCTO .do files
local date_fields1 "" [insert variables to modify here]

	*list date/time variables from ODK - these can be copied from SurveyCTO .do files
local datetime_fields1 "" [insert variables to modify here]


	*NOTES
	* drop note fields (since they don't contain any real data in the current tool design)

	*DATE/TIME
		* format date and date/time fields
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvarlist in `datetime_fields`i'' {
					cap unab dtvarlist : `dtvarlist'
					if _rc==0 {
						foreach dtvar in `dtvarlist' {
							tempvar tempdtvar
							rename `dtvar' `tempdtvar'
							gen double `dtvar'=.
							cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
							* automatically try without seconds, just in case
							cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
							format %tc `dtvar'
							drop `tempdtvar'
						}
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvarlist in `date_fields`i'' {
					cap unab dtvarlist : `dtvarlist'
					if _rc==0 {
						foreach dtvar in `dtvarlist' {
							tempvar tempdtvar
							rename `dtvar' `tempdtvar'
							gen double `dtvar'=.
							cap replace `dtvar'=date(`tempdtvar',"MDY",2025)
							format %td `dtvar'
							drop `tempdtvar'
						}
					}
				}
			}
		}
	
	
	
	*STRINGS 
	
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
	
	
	
	
	
*1.1.1.4: CHECK AND CORRECT DUPLICATES
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
	*Consolidate unique ID into "key" variable
		replace key=instanceid if key==""
		drop instanceid
			
	* Check duplicates duplicates in key variable 
		duplicates list key
		/* INSERT RESULTS:
		*/	
		
	$$$ If duplicates exist, investigate and resolve below	
		*example code for dropping: drop if key == "" // 1 dropped	
		
	* Check duplicates duplicates in outletID
		duplicates list outletid 
		/* INSERT RESULTS:
		*/	
		
	$$$ If duplicates exist, investigate and resolve below	
			*example code for dropping: drop if outletid == "" // 1 dropped	
	
	


								
				
	
*1.1.1.5: CHECK LINKS 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*each outlet may have up to 4 linked datasets: antimalarial audits, rdt audits, antimalarial suppliers, and rdt suppliers. Check that each outlet has the keys to link to the datasets relevant to that outlet (e.g. if the outlet has rdts, there should be an rdtaudit link)	

**************** CHECK LINK TO ANTIMALARIAL AUDITS 
	*Check completeness 
		ta amaudit_complete
		ta amaudit_complete if setofamaudit==""
	
	*Check missing
			gen hasamaudit=1
			replace hasamaudit=0 if setofamaudit==""
			replace hasamaudit=9888 if setofamaudit=="" & (eligible==0 | consented!=1)  //not eligible
			replace hasamaudit=9888 if setofamaudit=="" & am_stockcurrent==0 // reported not stocking am
			replace hasamaudit=9888 if setofamaudit=="" & n1==0 // actually not stocking am
			ta hasamaudit, m
			/* INSERT RESULTS:
			*/
			$$$ address any outlet records that should have an antimalarial audit but does not 
		
	
**************** CHECK LINK TO RDT AUDITS 
	*Check completeness 
		ta rdtaudit_complete
		ta rdtaudit_complete if setofrdtaudit==""
				
	*Check missing
			gen hasrdtaudit=1
			replace hasrdtaudit=0 if setofrdtaudit==""
			replace hasrdtaudit=9888 if setofrdtaudit=="" & (eligible==0 | consented!=1)  //not eligible
			replace hasrdtaudit=9888 if setofrdtaudit=="" & rdt_stock==0 // reported not stocking rdt
			replace hasrdtaudit=9888 if setofrdtaudit=="" & d7==0 // actually not stocking rdt
			ta hasrdtaudit, m
			/* INSERT RESULTS:
			*/
			$$$ address any outlet records that should have an rdt audit but does not 
	
**************** CHECK LINK TO SUPPLIER	
	*Check missing	
		generate hasamsuppliers=0 
		recode hasamsuppliers 0=1 if setofam_suppliers!=""
		recode hasamsuppliers 0=9888 if consented==0 | sa1a!=1
		ta hasrdtaudit, m
		/* INSERT RESULTS:
		*/
		$$$ address any outlet records that should have suppliers reported but does not 
		
		
		
		
*1.1.1.6: CORRECT KNOWN ERRORS HIGHLIGHTED DURING DATA COLLECTION
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

	$$$ address any other errors noted during data collection or in the comments 	
	
	/* EXAMPLE:
	numlabel c4, add
		ta c4
		recode c4 (102016=102012)
		list key if regexm(outletid,"102016")
	*/	
	
	
		

*1.1.1.7: DROP VARIABLES NOT REQUIRED FOR ANALYSIS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
	/*All variables that are not required for cleaning and analysis should be
    dropped. Modify the following list according to the ODK output variables
    generated. We recommend a conservative approach if in doubt. i.e. do not drop
	any variables that may be needed for analysis; only drop calc or group fields and/or 
	other variables that are a product of the data collection software */
	
	cap drop  deviceid subscriberid simid phonenumber device_info instancename randomnum outletnum  // [ADD ANY ADDITIONAL VARIABLES TO DROP HERE] 
	
	
			



*1.1.1.8: SAVE PREPARED DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
save "${datadir}/cleaning/AwL_${country}_${year}-outlet_prepared.dta", replace

	*show codebook and notes
	*codebook
	*notes list
	
	/*
	### Note each record in the prepared dataset represents one form submitted and 
	each record does not represent a outlet visited i.e. some outlets have more 
	than one form (supplementary forms)
	
	the variable key and outletid_orig uniquely identify forms 
	the variable outletid uniquely identifies outlets 
	
	both are needed for merging data to the repeat group datasets (am and rdt 
	audits and suppliers datasets)
	
	*/ 
	
	
	
	
	
	
	
	
	
	
**# 
*******************************************************************************/
*	1.1.2	OUTLET DATA CLEANING
*******************************************************************************/
/*
In this step, each variable in the dataset is reviewed, checked, and cleaned. 


For outlet data, it is recommneded that the following are completed ***during fieldwork*** as part of quality control activities 
	- checking metadata, reading and responding to comments (SEE METADATA SECTION BELOW)
	- cleaning the final interview status varible 
	- ensuring audits are available when outlets have products (i.e. checking links with syntax above)
	- conducting progress check by date, team, enumerator, etc. 
		--> A dashboard or automated report may be useful for this but is not currently available as part of the ACTwatch toolkit. 
			Examples of QC conducted during ACTwatch Lite pilot studies is available upon request.
*/



* Open prepared dataset if not already in use
	*clear 	
	*use "${datadir}/cleaning/AwL_${country}_${year}-outlet_prepared.dta", replace
	count //

	
	
	
*CHECK AND CLEAN EACH VARIABLE	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	$$$ REVIEW AND CLEAN EACH VARIABLE IN THE OUTLET DATASET BELOW 
	NOTE: STRING INPUTS (NAME, LOCATION, ETC REQUIRE MANUAL CLEANING)


	
	
**# 	
****************1.1.2.1:  INTERVIEWER COMMENTS 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*Review interview comments. Any interview comments that require cleaning of
    outlet-level variables should be flagged and cleaned in the respective
    cleaning step. */
	
	*END OF QUESTIONNAIRE COMMENTS	
		*conduct basic string cleaning 	
		replace end3=upper(end3)
		replace end3="." if end3=="" | end3=="NONE" | end3=="NO COMMENT" | end3=="NO COMMENTS" ///
		| end3=="NO" | end3=="9998"  | end3=="NA"  | end3=="N/A"  | end3=="N.A" | end3=="NONE." | end3=="NOTHING" ///
		| end3=="NOTHING." | end3=="SUCCESSFUL..."  | end3=="SUCCESSFUL.." | end3=="SUCESSFUL" ///
		| end3=="SUCESSFUL INTERVIEW" | end3=="NOT APPLICABLE" | end3=="SUCCESSFUL" ///
		| end3=="SUCCESSFUL INTERVIEW" | end3=="SATISFACTORY"
		list status end3 if end3!="."
		
		
		list end3 if end3!="."
		
		$$$ clean records as needed based on comments	

	*BUSINESS PRACTICE COMMENTS	
		*conduct basic string cleaning 	
		replace p_cmts=upper(p_cmts)
		replace p_cmts="." if p_cmts=="" | p_cmts=="NONE" | p_cmts=="NO COMMENT" | p_cmts=="NO COMMENTS" ///
		| p_cmts=="NO" | p_cmts=="9998"  | p_cmts=="NA"  | p_cmts=="N/A"  | p_cmts=="N.A" | p_cmts=="NONE." ///
		| p_cmts=="NOTHING" | p_cmts=="GOOD" ///
		| p_cmts=="NOTHING." | p_cmts=="SUCCESSFUL..."  | p_cmts=="SUCCESSFUL.." | p_cmts=="SUCESSFUL" ///
		| p_cmts=="SUCESSFUL INTERVIEW" | p_cmts=="NOT APPLICABLE" | p_cmts=="SUCCESSFUL" ///
		| p_cmts=="SUCCESSFUL INTERVIEW" | p_cmts=="SATISFACTORY" | p_cmts=="NO COMMENT(S)"
		
		list p_cmts if p_cmts!="."
		
		$$$ clean records as needed based on comments	


		

	

**# 
**************** 1.1.2.2: METADATA			                       
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* THESE ARE QUICK CHECKS FOR DATA QUALITY ASSURANCE 
	NOTE IT IS RECOMMENDED THAT THE FOLLOWING ARE CHECKED THROUGHOUT DATA COLLECTION, AS WELL AS AFTER IN POST-ANALYSIS.
*/
	
**************** DATE RANGE	
	tab date 
	twoway histogram date, discrete gap(15) by(team)
		/* INSERT RESULTS:
		*/
		
	$$$ ANY OUT OF RANGE DATES SHOULD BE INVESTIGATED. 
		CONFIRM ANY PILOT DATA HAS BEEN REMOVED FROM THE MAIN DATASET. 
		Document any reasons for out of date records that are kept above. 
	
	
	
**************** DURATION OF INTERVIEW
	destring duration, replace
	gen duration_min= duration/60
	sum duration_min
		/* INSERT RESULTS:
		*/
	
	$$$ ANY SUSPICIOUS CASES SHOULD BE INVESTIGATED e.g. if average time to complete less then 30 minutes should be double-checked 

	
	* Check form with shorted and longest duration 
	sum duration_min, detail 
	list outletid date starttime endtime formtype duration_min c6 eligible if duration_min <=1 | duration_min >=180
	bysort formtype: sum duration_min if consented==1, detail
	bysort c7_r: sum duration_min if consented==1, detail
	mean duration_min if formtype==1 & consented==1, over(c7_r)

	
 
		
		
		
**# 
****************  SECTION-BY-SECTION VARIABLE CLEANING	                       
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~			
/* The following syntax is organized by section of the toolkit quantitative questionnaire. Each variable should be checked and cleaned. 

If sections of the form where removed for this implementation, the syntax can be commented out or removed for those sections. 
If sections were added, additional syntax should be written to check these variables. 

*/
		

	


********************************************************************************
**# CENSUS AND SCREENING MODULE
*	1.1.2.3: SECTION 1: CENSUS INFORMATION			                       *  
********************************************************************************

**************** TEAM
	tab team
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed 

**************** DATA COLLECTOR 
	bysort team: ta c1a, sort
	ta c1a formtype
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed 
	
	$$$ after data collection is complete, drop data collector names
	*drop c1a c1b

**************** LOCATION DATA 
	tab c2 //region
	tab c3 //district
	tab c4 //Aire de sante
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed 
	

**************** GPS - DUPLICATES [IF GPS COLLECTED]
*CHECK GPS VALUES FOR REPEAT VISITS TO THE SAME OUTLET
  /*Review observations with identical GPS values. Drop outlets that are
    determined to be duplicates. */

	duplicates tag gpslatitude gpslongitude, gen (dup_gps)
	replace dup_gps=. if hasgps==0 //informal outlets with no gps
	tab dup_gps, m	
	tab c7_r dup_gps
	*br outletid formtype c4 - c7 c6 c5 c1a date gpslatitude gpslongitude if gpslongitude!=. & dup_gps> 0  & dup_gps!=.
	
		/* INSERT RESULTS:
		*/
		
	$$$ review and remove any duplicate records. Note GPS points may overlap when outlets are very near e.g. within the same marketplace  
	
	drop dup_gps


	
**************** OUTLET TYPE	
/*the questionnaire captures retail and wholesale outlet type in seperate variables. 
	These are combined or calculated in the form in variable c7 so the seperate vars should be dropped. */
		drop c7_r c7_ws
			
	*next, ensure c7 is correctly labeled
		
		$$$ update example labels below based on your form: 
		
		/* EXAMPLE: 
		label define c7 1 "Clinic/ hospital" 3 "Laboratory" 11 "CP" 20 "Chemist/ PPMV" 	//
						22 "Retail/other shop" 25 "Street vendor" 26 "At home" 30 "Importer" 
						31 "Manufacturer" 32 "Distributor"  96 "Other"
		label values c7 c7 
		*/
		
	*check outlet type and recode outlet type other specify responses to predefined values
		ta c7, m 
			/* INSERT RESULTS:
			*/
			
			*$$$ sense check, clean as needed 
			
				
		*br eligible consented c1a outletid c4 - c7 c7_other if c7 == 96
			/* INSERT RESULTS:
			*/
			
			$$$ recode other specified 
			*e.g. replace c7=20 if c7_other=="PPMV WHOLESALER" 
			
			
**************** OUTLET NAME 
	$$$ outlet names may be cleaned for for obvious errors. 
		*/ Check that duplicated names are reasonable (e.g. chain outlets), check outlet names are consistant with type (e.g. if there is 'pharmacy' in the name the outlet type should likely also be pharmacy). If there are suspiciously similar outlet names of the same type in the same cluster then investigate and potentially drop duplicates. This variable is not used in the analysis so manual cleaning is not required unless specified*/ 
			
	$$$ Remove outlet name from final or published datasets
			

			
			
			
			
			
			
********************************************************************************
**# CENSUS AND SCREENING MODULE
	*1.1.2.4: SECTION 2: SCREENING AND ELIGIBILITY                               
********************************************************************************  
/*Checks variables related to screening, eligibility, and consent then recodes 
the visit or interview status using ACTwatch values/ categories
*/

**************** SCREENING	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
*Are you able to screen this outlet/ business for participation in the study? 
	ta canscreen, m
			/* INSERT RESULTS:
			*/
				
			*$$$ sense check, clean as needed 
	
*Why are you not able to screen this outlet/business for eligibility in the study?

	*Specify other reason:
		list cantscreen_other if cantscreen==96
		
		$$$ recode other specified 
	
	*reasons outlets were not screened 
		ta cantscreen if canscreen==0, m
			/* INSERT RESULTS:
			*/
				
			*$$$ sense check, clean as needed 

*INCLUSION CRITERIA:
	*Do you have any antimalarial medicine in stock today?
			ta s3 if canscreen==0, m
			
			ta am_stockcurrent, m //this is a calculated variable from the form and should match s3
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 
				
	*Have you stocked AMs in the last 3 months?
			ta s4 if canscreen==0, m	
			
			ta am_stockpast, m //this is a calculated variable from the form and should match s4
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 			

	*Are RDTs available here today?
			ta s5b if canscreen==0, m
			
			ta rdt_stock //this is a calculated variable from the form and should match s5b
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 	

	*Have you stocked any RDTs in the last 3 months?
			ta s6 if canscreen==0, m
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 				
			
	*Is malaria microscopy screening available here today?
			ta s5a if canscreen==0, m
				
			ta micro_stockcurrent//this is a calculated variable from the form and should match s5a
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 	
		
	*any testing calculate variable 
	
			ta testing_stock //this is a calculated variable and should = outlets with RDT and/or microscopy 
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 	

			
**************** ELIGIBILITY & CONSENT
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*outlets are eligible if (1) they were screened and 
	*(2) if they have an antimalarial or blood test availble now or reportedly stock them in the last 3 months
	*if this study used a different eligibility criteria, edit here.

	*For screened outlets: 
		bysort canscreen: ta eligible, m 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

		
	*For eligible outlets: 
	*Did you obtain the consent of the participant?

		ta consented if eligible==1
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
			
		*if not consenting: 
			*Specify other reason:
			list c10_other if c10==96
			
			$$$ recode other specified 
		
			*Check reasons: 
			ta c10_other if consented==97
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 			
		
	*check calculate variables summarizing eligibility for study components 	
			ta no_prov_int, m //outlet is NOT eligible or consenting for provider interview
			ta prov_int, m //outlet is eligible, consented, and outlet type are applicable for provider interview 
			ta do_audit, m //outlet is eligible, consented, and outlet type are applicable for audit
		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	

*********** SELLS WHOLESALE/ FOR RE-SALE
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Does this [outlet or business] sell antimalarials or RDT to other outlets that re-sell the products?

	ta retws1, m //this is only for retail outlets that report selling to other outlets
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
	
	ta retws, m // this variable includes all outlets that resell
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
	*check dont knows 
	ta retws_confirmdk
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		

	ta c7 retws, row
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
	
*CREATE FINALINTSTAUS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	
/*This variable will summarize the status of the interview conducted at each outlet. 
*It will combine information from Section 2 on screening, eligibility, and consent with the progress and completeness of the rest of the interview and audits
*/ 

*********** CREATE NEW STATUS VARIABLE AND RECODE
	gen c9_new = c9 
		order c9 c9_new, after(consented)
	
		lab def finalvals ///
			1 "Completed form" ///
			2 "Outlet does not meet screening criteria" ///
			104 "Not screened: Respondent not available/Time not convenient" ///
			106 "Not screened: Outlet closed permanently" ///
			107 "Not screened: Other" ///
			108 "Not screened: Refused" ///
			204 "Not interviewed: Respondent not available/Time not convenient" ///
			208 "Not interviewed: Refused/ did not consent" ///
			303 "Partial interview: Interview interrupted" ///
			304 "Partial interview: Respondent not available/time not convenient" ///
			307 "Partial interview: Other" ///
			308 "Partial interview: Refused to continue" ///
			309 "Partial interview: AM audit incomplete" ///
			310 "Partial interview: RDT audit incomplete" 
		lab val c9_new finalvals	
	
	ta c9_new, m
	
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		

*$$$ the codes used in the odk form need to be recoded to match the categories used for the analysis (the label definitions above. The following syntax recodes these and fixes any miscategorizations based on other variables e.g. checkpoints and audit compoletness 
	

	*not screened 
	recode c9_new .=100 if canscreen==0 
			*recode based on reason for not screening
			recode c9_new 100=106 if cantscreen == 1 // Outlet closed permanently
			recode c9_new 100=108 if cantscreen == 2 // Refused
			recode c9_new 100=104 if cantscreen == 3 | cantscreen == 4 | cantscreen == 5 | cantscreen == 6	
							// Outlet closed/ provider not available after 3 visits
			recode c9_new 100=107 if cantscreen == 96	// Other
	
	*not eligible
	recode c9_new .=2 if eligible==0 
	
	*not consenting 
	recode c9_new .=208 if consented!=1
	
	
	*respondent not available 
	recode c9_new 99=304
	
	*respondent refused to continue 
	recode c9_new 97=308
	
		

*$$$ if there are still c9_new=96 (other) these need to be recoded here
		*br if c9_new=96
			
		$$$ check comments, checkpoints, audit completeness, etc to recode other
	
	*check cleaning is complete: 
	ta c9, m 
	ta c9_new, m
	
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed  --- no records should have a missing status at this point	
		
	

*********** INTERVIEW STARTED 		
	*generate variable to distigiush which outlets completed any outlet level interview
	  gen outletint=0
		recode outletint 0=1 if prov_int==1 & consented==1 
		lab variable outletint"outlet level interview started"
		lab values outletint yesno
		order outletint, after(c9)
	/*outlet-level questions will be "missing" if outletint==0; this 
	may be helpful to explain missing data in all subsequent outlet level variables.*/


*check status variable 
ta c9_new outletint
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	

*********** INTERVIEW INTERUPTED - CHECKPOINTS
	
	/*Checkpoints were added after each questionnaire section asking 
	if the interviwer was able to continue. These will be used to determine if the 
	interview was interrupted*/ 

		gen outletint_interupted=0 
			recode outletint_interupted 0=1 if checkpoint1==. | checkpoint2==. | ///
			checkpoint3==. | checkpoint4==. | checkpoint5==. | checkpoint6==. ///
			| checkpoint7==. | checkpoint_supp==. | checkpoint_am==. | checkpoint_rdt==. 
			recode outletint_interupted 1=0 if outletint==0
		replace status=2 if outletint_interupted==1
		
			
		ta c9_new outletint_interupted, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
		
		*recode status variable 


*********** AUDITS COMPLETE
 *Incomplete antimalarial audit 
	 ta c9_new amaudit_complete, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
		*reasons for incomplete audit 
		br amaudit_incomplete if amaudit_incomplete!="" 
		
		$$$ recode reasons for incomplete audit and double check that FinIntStat is recoded to reflect this.
		
		
		*recode status variable
		
		
*Incomplete rdt audit	
	ta c9_new rdtaudit_complete, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
		*reasons for incomplete audit 
		br rdtaudit_incomplete if rdtaudit_incomplete!="" 
		
		*$$$ recode reasons for incomplete audit and double check that FinIntStat is recoded to reflect this.
		
	
		*recode status variable
		
		
		
	
***********  Generate FinalIntStatus
	gen finalIntStat=c9_new
	lab val finalIntStat finalvals
	ta  finalIntStat formtype, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

/*$$$ Note before the am and rdt audit, outlets are asked again if they 
*have ams and rdts. This is checked for consistancy with screening in section 3 
below, as well as with audit completeness. The variable finalIntStat is edited 
if any discrepancies are found. */
	  
	
			
			
	
			
				
********************************************************************************
**# 1.1.2.5: PROVIDER MODULE

/*
For the provider module, the default setting for these sections is that these questions are only asked at: 
- outlets that have consented to participate 
- outlets that are NOT informal 
If your survey uses a different eligibility critiera, the syntax "prov_int=1 and $inf!=1" should be updated

Similarly, if sections are added or removed, the numbering of checkpoints in your survey may be differnt. Check and edit these as required.
*/		

********************************************************************************  


****************1.1.2.5.1: Section 1: Outlet characteristics                                

*Approximately when is this outlet usually open? check missing values
	ta p0 if (prov_int=1 & inf!=1) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
			
	list p0_other, sort
		/* INSERT RESULTS:
		*/
			
		$$$ recode as needed

	
* Do you know what year this outlet/ business was established? check missing values 
	ta char2 if (prov_int=1 & inf!=1) & !inlist(char2,-9777, -9888) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		
*How many people work here? check missing values
	ta char4 if (prov_int=1 & inf!=1) & !inlist(char4,-9777, -9888) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		
		
*Does this outlet have the correct license/ registration to sell medicines here?
	/*1	YES - the repondent REPORTS having this licence
	2	YES - the repondent REPORTS and you have OBSERVED the licence
	0	NO - the respondent reports NOT having the licence
	97	Respondent refused to answer
	98	Respondent does not know
	99	NOT APPLICABLE- this outlet type does not require this MoH agreement
	
	These values and labels will vary based on country context. Cross check and edit syntax accordingly
	*/
	
	bysort c7: ta reg1 if (prov_int=1 & inf!=1) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		
		
*Has this establishment received a government inspection in the last year
	bysort c7: ta reg2 if (prov_int=1 & inf!=1) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 

	*When was the last visit?
		bysort c7: ta reg2a if reg2=1 , m
			/* INSERT RESULTS:
			*/
				
			*$$$ sense check, clean as needed 




		
		
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

**************** 	Section 2: Staff characteristics                              

* Do you or anyone in this outlet/ business have any of the following health-related qualifications? Check missing values
	ta p8 if (prov_int=1 and inf!=1 and checkpoint1=11)  , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		
		*$$$ you may want to add a variable for ANY qualification or for specific qualificaitons based on country policy/ context e.g. outlets with a pharmacy technician
		
	*clean other specified 
	list p8_other, sort 
	
		$$$ recode as needed
			
			
*Has any staff working at this outlet/ business received malaria-related training in the last 2 years? Checking missing values?
	ta char9 if (prov_int=1 and inf!=1 and checkpoint1=1)  , m
	/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		
	*generate variable for ANY malaria training			
	gen char9_any=char9_1, after(char9_98)
		recode char9_any 0=1 if char9_2==1 | char9_3==1
				
	*clean other specified 
	list char9_other, sort
	
		$$$ recode as needed
		
		
			

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

**************** 1.1.2.5.3:	Section 3: Quality control and compliance                                

*ANTIMALARIAL STORAGE
	*Check variables 
		*Are antimalarials stored in a dry area? 
			ta am_storage_1 if d7==1 , m
		*Are antimalarials protected from direct sunlight?
			ta am_storage_2 if d7==1 , m
		*Are antimalarials kept on the floor?
			ta am_storage_3 if d7==1 , m
			
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 
		
	*Generate summary variable to indicate outlets with acceptable storage
		gen am_storgae_OK=0
		recode am_storgae_OK 0=1 if (am_storage_1==1 & am_storage_2==1 & am_storage_3==0)
		ta am_storgae_OK if supp!=1 & n1==1, m
		
	
	
*RDT STORAGE
	*Check variables 
			ta rdt_storage_1 if d7==1 , m
			ta rdt_storage_2 if d7==1 , m
			ta rdt_storage_3 if d7==1 , m
			
				/* INSERT RESULTS:
				*/
					
				*$$$ sense check, clean as needed 
		
	*Generate summary variable to indicate outlets with acceptable storage
			gen rdt_storgae_OK=0
			recode rdt_storgae_OK 0=1 if rdt_storage_1==1 & rdt_storage_2==1 & rdt_storage_3==0
			ta rdt_storgae_OK if d7==1, m
		

*MICROSCOPY EQUIPMENT
*disposable gloves
	ta d1 if (supp!=1 & testing_stock==1 & do_audit==1 & checkpoint5==1) , m
		/* INSERT RESULTS:
		*/
				
		*$$$ sense check, clean as needed 
		
*sharps container
	ta d2 if (supp!=1 & testing_stock==1 & do_audit==1 & checkpoint5==1) , m
		/* INSERT RESULTS:
		*/
					
		*$$$ sense check, clean as needed 



		
		
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

**************** 1.1.2.5.4:	Section 4: Respondent malaria knowledge                                


* Please name one first-line drug <b>recommended by the government</b> to treat uncomplicated malaria. (i.e. what is the most effective drug to treat uncomplicated malaria)? Check missing values
	list p16_name_oth, sort
	
		$$$ clean and recode as needed
	
	bysort p16_form: ta p16_name if (prov_int=1 and inf!=1 and checkpoint3=1)  
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 

*Have you ever seen or heard of a malaria rapid diagnostic test (RDT)? Missing values
	bysort c7: ta p21 if (prov_int=1 and inf!=1 and checkpoint3=1 )  , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 			
	

*While working at this outlet/ business, have you ever tested a client for malaria using an RDT? Checking missing values
	bysort c7: ta p22 if (prov_int=1 and inf!=1 and checkpoint3=1) & p21==1  , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
	
	
*Is a prescription or positive malaria test result required to purchase an antimalarial at this outlet?
	bysort c7: ta p25 if (prov_int=1 and inf!=1 and checkpoint3=1)  , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
		

*Would you recommend that a patient/client take an antimalarial drug if the rapid diagnostic test is negative for malaria?
	bysort c7: ta p23 if (prov_int=1 and inf!=1 and checkpoint3=1 ) & p21==1  , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 
				
	
*Under what circumstances would you recommend that a patient/client take an antimalarial drug after a negative RDT test for malaria? Check missing values
/*
1	When they have signs/symptoms of malaria
2	When they ask for antimalarial treatment
3	When they are children
4	When they are adults
5	When they are pregnant women
6	When I don't trust the test
7	When I know the patient/client
8	RDT tests are not done at this outlet
9	Does not prescribe only sells 
10	As preventive treatment
96	Other

Note these responses may have been edited for this study. Cross check and update accordingly.
*/

	list p24_other, sort 
	
		$$$ clean and recode as needed
		
	ta p24 if (prov_int=1 and inf!=1 and checkpoint3=1 ) , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 		
			
		


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

**************** 1.1.2.5.5:	Section 5: Outlet tech/ digital access & use                             

*In the past 30 days, did this outlet/ business have...
	ta dig0 if (prov_int=1 and inf!=1 and checkpoint4=1), m			//water	
	ta dig1 if (prov_int=1 and inf!=1 and checkpoint4=1), m				//electricity
	ta dig2 if (prov_int=1 and inf!=1 and checkpoint4=1), m				//any phone
	ta dig2c if (prov_int=1 and inf!=1 and checkpoint4=1) & dig2!=0, m 	//mobile connection
	ta dig3 if (prov_int=1 and inf!=1 and checkpoint4=1), m				//wifi
	ta dig5 if (prov_int=1 and inf!=1 and checkpoint4=1), m				//tablet or computer
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 				
			
		* phone types
		ta dig2b if dig2!=0, m
		
		*wifi type
		ta dig4 if dig3!=0, m
		
		*tab/ computer type
		ta dig5b if & dig5!=0, m
		
			
*Select which of the following applications/ services you have used on this phone in the last 30 days:
	/* 	3	Mobile money
		1	SMS
		2	WhatsApp / Other messaging applications
		4	Call */ 
		
		ta dig2d if (prov_int=1 and inf!=1 and checkpoint4=1) & dig2!=0, m 	//apps used 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 				
			
				
*For each of the following business activities, identify if you currently use digital technology, would like to digitize, or are not interested in digitizing the activity. 
		ta dig7_1 if (prov_int=1 and inf!=1 and checkpoint4=1), m	//Gestion des ventes au détail aux clients
		ta dig7_2 if (prov_int=1 and inf!=1 and checkpoint4=1), m	//Gestion des stocks 
		ta dig7_3 if (prov_int=1 and inf!=1 and checkpoint4=1), m	//Passer des commandes auprès des fourisseurs
		ta dig7_4 if (prov_int=1 and inf!=1 and checkpoint4=1), m	//Payer les fournisseurs
		ta dig7_5 if (prov_int=1 and inf!=1 and checkpoint4=1), m	// HR
		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 			
		  

		*other activities 
		ta dig7b if (prov_int=1 and inf!=1 and checkpoint4=1), m
		
		list dig7bi, sort 
		
			$$$ review and recode others as needed
		
		


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

**************** 1.1.2.5.6:	Section 6: Outlet participation in monitoring                                
  
* Do you report malaria case data each month?
	ta data1 c7 if (prov_int=1 and inf!=1 and checkpoint5=1), m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 			
		  
* What forms and tools do you use to <b>report</b> malaria-related data to higher levels of the health system?
		*Other forms and tools used to report data:
		list data2b, sort 
		
			$$$ review and recode others as needed

		*Check form type variables 
		/*1	Directly to government
		2	Directly in to DHIS2 platform
		3	To specific project/ NGO
		96	Other
		98	Don't know
		
		Form types should be updated based on country context. Cross check values and edit syntax accordingly
		*/ 
		
			/* EXAMPLE:
			ta data2 c7 if (prov_int=1 and inf!=1 and checkpoint5=1) & data1==1, m  
			ta data2_1 c7 if (prov_int=1 and inf!=1 and checkpoint5=1) & data1==1, m  
			ta data2_2 c7 if (prov_int=1 and inf!=1 and checkpoint5=11) & data1==1, m  
			ta data2_3 c7 if (prov_int=1 and inf!=1 and checkpoint5=1) & data1==1, m  
			ta data2_96 c7 if (prov_int=1 and inf!=1 and checkpoint5=1) & data1==1, m  
			ta data2_98 c7 if (prov_int=1 and inf!=1 and checkpoint5=1) & data1==1, m 
			*/

		
	

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		

****************  1.1.2.5.7: Section 7: Business practices                                

**************** CUSTOMERS

*Does this outlet/ business sell antimalarials/RDTs online?
	ta retonline if (prov_int==1 & inf!=1 & checkpoint6==1), m		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 		
		
*How many retail customers did you sell antimalarials/RDTs to in the last 7 days?
	ta p30 if (prov_int==1 & inf!=1 & checkpoint6==1), m		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

		
***Check consistency and missing values for following quesions
	*How many retail customers did you sell antimalarials to in the last 7 days?
	*How many wholesale customers did you sell antimalarials to in the last 7 days?	
	*Customer types: Which of the following types of clients or businesses do you sell antimalarials or mRDTs to?
	*Can you estimate the proportion of antimalarials you sell to each customer type in the last year?

	*Ensuring that if just one customer type, that has 100% of the sales
	*Checking that %s add to 100 if more than one customer type:

				/* EXAMPLE:
				egen p32_1_count=anycount(p32_1 p32_2 p32_3 p32_4 p32_5 p32_6), values(1)
				ta p32_1_count
				egen p34b_sumcheck = rowtotal(p34b_1 p34b_2 p34b_3 p34b_4 p34b_5 p34b_6 ) if p32_1_count>0
				ta p34b_sumcheck
				*/
		
		
		
*How many wholesale customers did you sell antimalarials/RDTss to in the last 7 days?
	ta p31 if (prov_int==1 & inf!=1 & checkpoint6==1 & retws==1), m		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

*Which of the following types of clients or businesses do you sell antimalarials or mRDTs to?
		ta p32 if (prov_int==1 & inf!=1 & checkpoint6==1 & retws==1), m	
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed. it may make sense to tab each type e.g. ta p32_3 if (prov_int==1 & inf!=1 & checkpoint6==1 & retws==1), m	to check the proporiton of outlets that resell who sell to terminal wholesalers  

		*Other customer types
		list p32b if p32_6==1, sort 
		
			$$$ review and recode other customer types as needed

*Can you estimate the proportion of antimalarials/RDTs you sell to each customer type in the last year?
	ta p34 if (prov_int==1 & inf!=1 & checkpoint6==1 & retws==1), m		
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	


*Types of TERMINAL WHOLESALERS
	ta l1_1 if p32_3==1 , m
			/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
*Types of INTERMEDIATE WHOLESALERS 
	ta l1_1 if p32_3==1 , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	
*Where are your customers located?  i.e where do they come from to buy your products?
	ta ind_0 if (prov_int==1 & inf!=1 & checkpoint6==1), m	
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
		
*How do you distribute your antimalarial products?
	ta l1_3 if (prov_int==1 & inf!=1 & checkpoint6==1), m			
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

		*Other distrbution methods 
		list l1_3b if l1_3 ==96, sort 
		
			$$$ review and recode other customer types as needed

			
	
**************** SUPPLIERS 
*How many different suppliers have you purchased antimalarials from <b>in the last 3 months?
	ta sa1 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m

*Types of suppliers 
	ta sa2_1 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	Importer
	ta sa2_2 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	International manufacturer
	ta sa2_3 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	Local manufacturer
	ta sa2_4 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	Distributor
	ta sa2_5 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	pharmacy
	ta sa2_6 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	public sector supply chain
	ta sa2_7 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	other private outlet/shop
	ta sa2_8 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1), m //	other
	
	*other: 
	ta sa2b if sa2_8==1


*PROPORITONS 
	ta sa3 if sa1!=. & sa1>1 & inf!=1, m	

	*proportion by type
	
				
					ta sa3b_1 if sa3==1 & sa2_1==1, m //	Importer
					ta sa3b_2 if sa3==1 & sa2_2==1, m //	International manufacturer
					ta sa3b_3 if sa3==1 & sa2_3==1, m //	Local manufacturer
					ta sa3b_4 if sa3==1 & sa2_4==1, m //	Distributor
					ta sa3b_5 if sa3==1 & sa2_5==1, m //	pharmacy
					ta sa3b_6 if sa3==1 & sa2_6==1, m //	public sector supply chain
					ta sa3b_7 if sa3==1 & sa2_7==1, m  //	other private outlet/shop
					ta sa3b_8 if sa3==1 & sa2_8==1, m  //	other
			

		/* INSERT RESULTS:
		*/
			
		$$$ sense check, clean as needed 		


				
				
**************** PROCUREMENT, PAYMENT, AND STABILITY

* How do you most often receive your antimalarials and/ or RDTs from supplier(s)?
	ta sa4 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m
	
	tab sa4, gen(sa4_) 
	
*What are the common methods of payment to your suppliers for antimalarials and/or RDTs?
	ta sa5 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m
					
	list outletid sa5_other if sa5_other!=""
	
		$$$ !!! review and recode as needed 
				 
*Do you buy antimalarial drugs on credit from any supplier? Check missing values					
	ta sa6 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m
				
*What are the most common credit terms, in terms of number of days to settle payment? Check missing values
	ta sa7 if sa6==1, m

*What brand of antimalarial do you sell to Individual clients or use most often at this facilty/outlet?
	list sa11
	
		$$$ !!! review and recode as needed 
					
*In the last 12 m, did you ever have to use another supplier for because your regular supplier did not have it in stock?
	ta sa12 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m

*In the last 12 m, how has the price to purchase x changed?
	ta sa13 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m 

*In your opinion, what is the main reason for price changes over the last 12m ?
	ta sa14 if sa13==2 | sa13==3 | sa13==4, m
					
	list sa14_other if sa14==96 
		
		$$$ !!! review and recode as needed

*Have prices been less stable, about the same, or more stable than in the past two years?"
	ta sa15 if (prov_int==1 & checkpoint6==1) & (am_stockcurrent==1 | am_stockpast==1) & inf!=1, m  
			
		/* INSERT RESULTS:
		*/
			
		$$$ sense check, clean as needed 					
				

**************** WHOLESALE BUSINESS PRACTICES
*Do you import antimalarials? 
	ta ws1 if (retws==1 & prov_int==1 & inf!=1), m

*Where do you import antimalarials from (include company names and countries where possible). 
	list ws1b if ws1==1, sort 
	
*In the past 3 months, have you given credit to wholesale customers who purchased antimalarials? 
	ta ws12 if (retws==1 & prov_int==1 & inf!=1), m
	
*What are the most common terms of your credit in days? 
	ta ws13 if ws12==1	
					
				
		/* INSERT RESULTS:
		*/
			
		$$$ sense check, clean as needed 	
	
**************** BUSSINES NETWORK
*Does the owner of this business own any other stores or businesses that sell antimalarials or RDTs? 
	ta ws5a if (retws==1 & prov_int==1 & inf!=1), m
	
*What types of other stores or businesses does the owner own that sell antimalarials or RDTs? 
	ta ws5b if ws5a==1 , m
	
		/* INSERT RESULTS:
		*/
			
		$$$ sense check, clean as needed 					
	






*************************
*END OF PROVIDER MODULE *
*************************




********************************************************************************
**# 1.1.2.6: ANTIMALARIAL AUDIT MODULE  - outlet level variables 

*Note most of the antimalarial data is captured in the "repeat group" of the form and stored in a separate dataset (antimalarial audit dataset). Those variables will be cleaned separate (step 1.2)   
                   
********************************************************************************  
*ANTIMALARIAL PRESENCE 	
*Confirm the presence of at least one antimalarial at this outlet
	ta n1 if am_stockcurrent==1 & do_audit==1, m 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

*Please confirm the provider doesn't have any products physically available, or indicate here why there is a discrepancy in responses e.g. the provider doesn't want to show them, etc.</b>
	*Other reasons
	list n2_other, sort 
		
		$$$ review and recode others as needed	
		
	ta n2 if n1==0, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

	
*AUDIT COMPLETENESS 
	ta amaudit_complete, m
	ta amaudit_incomplete if amaudit_complete!=0, m 
	
		/* INSERT RESULTS:
		*/
			
		$$$ Check missing values and recode reasons for incomplete audit
			Double check that FinIntStat is recoded to reflect this 	

	
*STOCK OUTS
*Are there any antimalarials that are out of stock today, but that you have had in stock for the last 3 months? 
	ta a16 if am_stockcurrent==1 | am_stockpast==1 , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	


*Which of the following types of antimalarials have been OUT OF STOCK in the <b>last 3 months</b>? 
*Specify other antimalarial(s) you had out of stock in the last 3 months: 
	
	list a17_other, sort 
		
		$$$ review and recode others as needed	

	ta a17 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
			
	
/***The rest of this section of the questionnaire is contained within a repeat group. 
This data is exported in to the supplier dataset and cleaned in step 1.2***/			


********************************************************************************
**# 1.1.2.7: BLOOD TESTING AUDIT MODULE 

*Note most of the RDT data is captured in the "repeat group" of the form and stored in a seperate dataset (rdt audit dataset). Those variables will be cleaned seperatly (step 1.3)   
                         
********************************************************************************  

*RDT PRESENCE 	
*Confirm the presence of at least one RDT at this outlet:
	ta d7 if testing_stock==1 & do_audit==1, m 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

*Please confirm the provider doesn't have any products physically available, or indicate here why there is a discrepancy in responses e.g. the provider doesn't want to show them, etc.</b>
	*Other reasons
	list d8_other, sort 
		
		$$$ review and recode others as needed	
		
	ta d8 if d7==0, m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	

	
*AUDIT COMPLETENESS 
	ta rdtAudit_complete, m
	ta rdtAudit_incomplete if rdtAudit_complete!=0, m 
	
		/* INSERT RESULTS:
		*/
			
		$$$ Check missing values and recode reasons for incomplete audit
			Double check that FinIntStat is recoded to reflect this 	


*STOCK OUTS
*Are there any RDTs that are sold out today, but that you have had in stock for the last 3 months?
	ta d16 if testing_stock=1 & do_audit=1 , m
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	


*Which types of RDTs that are sold out today, have you had in stock for the last 3 months? 
	ta d16_type
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
			
	
*MICROSCOPY DETAILS
			
*Is malaria microscopy screening available here today?
	bysort micro_stockcurrent: ta d3 if testing_stock=1 & do_audit=1 , m
	
	ta d3b if d3=0 , m
		/* INSERT RESULTS:
		*/
			
		$$$ Check results to confirm coding for microscopy availability is consistent. Recode as needed
		
		
*How many people were tested for malaria at this facility/outlet using microscopy in the <b>past 7 days</b>?
	ta d4 if d3==1 , m
	recode d4 9998=-9888
	sum d4 if !inlist(d4,-9777, -9888), detail
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	
*What is the total cost for a microscopy test for <b>an adult</b>? 
	ta d5 if d3==1 , m
	recode d5 9998=-9888
	sum d5 if !inlist(d5,-9777, -9888), detail
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	
*What is the total cost for a microscopy test for a <b>child under 5 years of age</b>?
	ta d6 if d3==1 , m
	recode d6 9998=-9888
	sum d6 if !inlist(d6,-9777, -9888), detail
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	
		
/***The rest of this section of the questionnaire is contained within a repeat group. 
This data is exported in to the supplier dataset and cleaned in step 1.3***/	


	
		

********************************************************************************
**# 1.1.2.8: SUPPLIER DETAILS MODULE  
*Note most of the supplier data is captured in the "repeat group" of the form and stored in a seperate dataset (supplier dataset). Those variables will be cleaned seperatly (step 1.4)                        
********************************************************************************  
*Thinking again about your main suppliers for malaria commodities, are you able to share specific details about your main suppliers such as name and location?  
	ta sa1a if prov_int==1  & inf!=1 & sa1>=1, m 
		/* INSERT RESULTS:
		*/
			
		*$$$ sense check, clean as needed 	
	
/***The rest of this section of the questionnaire is contained within a repeat group. 
This data is exported in to the supplier dataset and cleaned in step 1.4***/
	




*** NOTE THE INTERVIEW RESULTS MODULE IS CLEANED IN ELIGIBILITY AND CONSENT ***                    




* 1.1.2.9: SAVE CLEAN DATASET
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
save "${datadir}/cleaning/AwL_${country}_${year}-outlet_clean.dta", replace
				*/
	count //number of observations

	*show codebook and notes
	*codebook
	*notes list


	
		
	*************************
	*************************
	******	END 		*****
	*************************
	*************************


	
