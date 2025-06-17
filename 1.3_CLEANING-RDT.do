
/*******************************************************************************
	ACTwatch LITE 
	DATA PREPARATION & CLEANING SYNTAX 
	FOR SUPPLIER DATA	
	
********************************************************************************/
/*This syntax imports, prepares, and cleans audit data for RDTs

This syntax produces a dataset in long format, with one rdt product 
per row (with repeated outlet data for outlets with more than 1 rdt product)

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
1.3.1 - $$$ DATA PREPARATION*
1.3.2 - $$$ DATA CLEANING**
1.3.3 - GENERATE QARDT 

*manual input is only required for the raw .csv data file name in the preparation syntax and for checking duplicates/ known errors
**manual input is required for checking and cleaning each variable in the audit dataset. The syntax below can be used to structure this cleaning process, but additional code, checks, outputs, etc. should be well documented as changes are made. 

THE RESULTS OF THIS SYNTAX = 
A cleaned dataset of all RDTs audited at study outlets which will be referenced in the data management syntax

*/

  
  
  
*** SECTION A OF THE MASTERFLIE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	

* RUN STEP 1.1 TO CLEAN OUTLET LEVEL DATA BEFORE MERGING TO THIS DATASET
 


clear 
********************************************************************************
**#  1.3.1	DATA PREPARATION                        											*
********************************************************************************
/*The data preparation syntax should import raw datasets and 
	ensures the variables and values are labelled so that the data is easier 
	to work with. See guideline document for a more detailed 
	description and instructions for specific preparation steps. 
*/  


*1.3.1.1: IMPORT DATASETS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* import data from primary .csv file for RDT audits
	/* EXAMPLE:
	insheet using "${datadir}/raw/AwL-${country}-${year}-final-consent_group-section6-rdtAudit.csv", names clear
	*/
	$$$ insheet using "${datadir}/raw/[RDT AUDIT DATA FILENAME]", names clear
			
	count // $$$ record count


	
*1.3.1.2: LABEL VARIABLES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*run .do file for variable labels for this dataset. 
	do "${cleandir}/variable-lables/varlbl_syntax_rdtaudit.do"



*1.3.1.3: PREPARE FIELD TYPES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*STRINGS 
		*define strings 
		local text_fields1 "" [insert variables to modify] 
		
		/* EXAMPLE:
		local text_fields1 "rdtbrand_search parasite_search anti_search dtmanu_search r1 r3_lbl r2_lbl r4 rdtbrand r5code_other r19"
		*/
		
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
				
				**To make cleaning easier, we remove accents from letters below. 
			*more lines can be added for other accents not included here
				ds, has(type string)
				foreach v in `r(varlist)' { 
					replace `v'=subinstr(`v',"é","E",.)
					replace `v'=subinstr(`v',"È","E",.)
					replace `v'=subinstr(`v',"è","E",.)
					replace `v'=subinstr(`v',"É","E",.)
					replace `v'=subinstr(`v',"à","A",.)
					replace `v'=subinstr(`v',"À","A",.)
					replace `v'=subinstr(`v',"ç","C",.)
					replace `v'=subinstr(`v',"Ç","C",.)
					replace `v'=subinstr(`v',"Ñ","N",.)
					replace `v'=subinstr(`v',"ñ","N",.)
				}
	
				
			*trim and convert string to uppercase **USING STRTU PROGRAM**
				strtu
				
	

*1.3.1.4: COMBINE SEARCHED AND MANUAL ENTERED PRODUCT INFO FOR PARASITE, ANTIGEN AND MANUFACTURER
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  	
  *parasite 
	gen parasite=parasite_search, after(rdtbrand) 
	replace parasite=r3_lbl if fillmethod==2
	tab parasite, m
	drop r3 r3_lbl parasite_search

   *antigen 
	gen antigen=anti_search, after(parasite) 
	replace antigen=r2_lbl if fillmethod==2
	tab antigen
	drop r2 r2_lbl anti_search

	*manufacture
	gen rdtmanu=rdtmanu_search, after(antigen) 
	replace rdtmanu=r4 if fillmethod==2
	tab rdtmanu
	drop r4 rdtmanu_search
	
	
	
*1.3.1.5: CHECK AND CORRECT DUPLICATES
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

	duplicates list key // the final RDT audit dataset should contain no duplicte unique IDs (key)
						// however, errors may occur during upload from tablets to the server
						// by fieldworkers, leading to duplicate records. Fix these here.
	
	*$$$ drop duplicates found, if any

	
*1.3.1.6: CORRECT KNOWN ERRORS HIGHLIGHTED DURING DATA COLLECTION
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

*	$$$ address any other errors noted during data collection or in the comments 	
	
	
	
	
	
*1.3.1.7: MERGE OUTLET-LEVEL DATA
// THIS STEP ENSURES SOME OUTLET LEVEL VARIABLES ARE MERGED INTO THE RDT PRODUCT DATASET
// AND ALLOWS FOR CONFIRMATION THAT ALL RDTS ARE LINKED TO AN OUTLET
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

	rename key rdtauditkey
	rename parent_key key
	
	merge m:1 key using ///
    "data/cleaning/AwL_${country}_${year}-allforms_clean.dta", ///
    keepusing (formtype outletid consented s5b s6 rdt_stock d7 status setofrdtaudit)
     	
		*$$$ check outlets with no RDTs. This is ok if outlets are not eligible or didnt have RDTs
			drop if _merge==2 & consented!=1
			drop if _merge==2 & rdt_stock!=1 
			drop if _merge==2 & d7!=1
		
		*Drop outlets without RDTs (once confirmed above)
			drop if _merge == 2
			
			ta _merge 
		*$$$ Check any products that dont match to outlet record; there should be no products of theis type. 
		*investigate any cases found. 
			br if _merge==1
				
			list setof* if _merge==1
		/* INSERT RESULTS:

			*/
		
			drop _merge


	
*SAVE PREPARED DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
save "${datadir}/cleaning/AwL_${country}_${year}-rdtaudit_prepared.dta", replace


	
		
**# 
*******************************************************************************/
*	1.3.2	MALARIA BLOOD TESTING DATA CLEANING
*******************************************************************************/
* Open prepared dataset if not already in use
	*clear 	
	*use "${datadir}/cleaning/AwL_${country}_${year}-rdtaudit_prepared.dta", clear
	count //

	
* CHECK AND CLEAN EACH VARIABLE	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	$$$ REVIEW AND CLEAN EACH VARIABLE IN THE RDT DATASET BELOW 
	NOTE: STRING INPUTS (NAME, LOCATION, ETC REQUIRE MANUAL CLEANING)


**************** 1.3.2.1:  CHECK REPORTED COMPLETENESS 
	tab rdtaudit_complete, m 
		/* INSERT RESULTS:
		*/
		
		$$$ check incomplete audits and edit accordingly 
 

  
**************** 1.3.2.2: CHECK COMMENTS (NOTE THIS SHOULD ALSO HAVE BEEN DONE DURING QC) 
/*Any rdt comments that require cleaning of rdt-level variables should be flagged and cleaned in the respective cleaning step. Best practice is to also double check outlet-level end of interview comments as well */	
	
	replace r19="" if r19=="NONE" | r19=="NO" | r19=="NOTHING." | r19=="NO COMMENT(S)" | r19=="NO COMMENT" | r19=="NOTHING"
	
	*check comments and make any edits accordingly 
	br if r19!=""
		/* INSERT RESULTS:
		*/
		
  
  
**************** 1.3.2.3: FILLMETHOD (i.e was this product added by searching the database or manually entered
	tab fillmethod
		/* INSERT RESULTS:
		*/
		

**************** 1.3.2.4: RDT CODE 
*this should not require any edits, unless the database was modified during the datacollection period. 

	ta rdtcode if fillmethod==1, m
	
	*check for searched products missing rdtcode, edit accordingly
	br if rdtcode=="" & fillmethod==1
 	
	

**************** 1.3.2.5: MANUFACTURER NAME & COUNTRY 

*COUNTRY OF MANUFACTURER - OTHER SPECIFY
  /*Recode other-specify country of manufacturer responses to valid types. Use
    the value labels to recode other-specify countries to the correct values.
    This step is required for both search and manual fill RDTs. */
	
	rename r5code_other rdtCountry_other
	rename r5code rdtCountry
	
	
tab rdtCountry_other if rdtCountry_other == 996 | rdtCountry_other == 998
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
*$$$ recode all other countries 
	/* EXAMPLE:
	recode rdtCountry_other (996=1) if regexm(rdtCountry_other,"SHANDON") | regexm(rdtCountry_other,"SHANGDONG") // China
	replace rdtCountry=10 if rdtCountry_other=="REPUBLIC OF KOREA"
	lab def rdtCountry_other 901 "MALAYSIA", add 
 	recode rdtCountry_other (996=901) if rdtCountry_other=="MALAYSIA"
*/


*$$$once all other countries recoded, this variable can be dropped
*drop rdtCountry_other
	

*MANUFACTURER
  /*Harmonize the manu variable retaining the original manu variable
    in case it needs to be referenced in during subsequent cleaning steps. This
    is only required for manual fill RDTs. If upon review, some of the
    manufacturer names are actually in the search database then harmonize the
    manufacturer name to the exact string in the search database.*/
	
	rename rdtmanu manu_original
		label variable manu_original "manufacturer - original"
		order manu_original, last
	gen rdtmanu=manu_original, before (rdtCountry)
		label variable rdtmanu "manufacturer - cleaned"	
	
	*apply basic string cleaning 
		replace rdtmanu=upper(rdtmanu)	
		replace rdtmanu=subinstr(rdtmanu,"é","E",.)
		replace rdtmanu=subinstr(rdtmanu,"É","E",.)
		replace rdtmanu=subinstr(rdtmanu,"	"," ",.)
		replace rdtmanu=subinstr(rdtmanu,"  "," ",.)
		replace rdtmanu=subinstr(rdtmanu,"  "," ",.)
		replace rdtmanu=subinstr(rdtmanu,".","",.)
		replace rdtmanu=subinstr(rdtmanu,",","",.)
		replace rdtmanu=subinstr(rdtmanu,"LIMITED","LTD",.)
		replace rdtmanu=subinstr(rdtmanu,"PRIVATE","PVT",.)
		replace rdtmanu=subinstr(rdtmanu,"ê", "E",.)	
		*/
	
	

	ta rdtmanu	
		/* INSERT RESULTS:

		*/
				
				
		/*Check for typos, variations in naming convention that can be matched/ cleaned up, etc. 
		*Try to (1) match manually entered manufactures to those in the database where possible 
		*or (2) use the same nomenclature for new manufactures*/
	
	/*USE YOUR PREFERRED STRING CLEANING APPROACH, EXAMPLE:
	
	replace rdtmanu="SD BIOLINE" if regexm(rdtmanu,"S.D.BIOL"
	replace rdtmanu="ARTRON LABORATORIES INC." if rdtmanu=="ARTON" | rdtmanu=="ARTRON" | rdtmanu=="ARTRON LABORATORY" | rdtmanu=="ATRON LABORATORIES INC"
	...
	
	*/
	
	
	
* MANUFACTURER /BRAND NAME- CONSISTENCY
  /*Check consistency between brand name and manufacturer. This step is only
    required for manual fill RDTs. */
	
	bysort rdtbrand: tab rdtmanu if fillmethod==2
		/* INSERT RESULTS:
		*/
	
	*$$$ Although some brands may have more than one manufacturer, sense check and edit as needed so that there is consistency within brand names.	
			
	
*COUNTRY - harmonize with manufacture

	bysort rdtmanu: tab rdtCountry	
		/* INSERT RESULTS:
		*/
		
	*$$$ Although some manufactures have more than one country of operation, sense check and edit as needed so that there is consistency between manufacture and country.	
	
		
			
**************** 1.3.2.6: BRAND NAME 
  /*Harmonize the brand variable retaining the original brand variable
    in case it needs to be referenced in during subsequent cleaning steps. This
    is only required for manual fill RDTs.*/

	rename rdtbrand brand_original
		label variable brand_original "brand - NOT CLEAN"
		order brand_original, last
	gen rdtbrand=brand_original, after(rdtcode)
		label variable rdtbrand "brand - clean"	
	
	
	*apply basic string cleaning 
		replace rdtbrand=upper(rdtbrand)	
		replace rdtbrand=subinstr(rdtbrand,"é","E",.)
		replace rdtbrand=subinstr(rdtbrand,"É","E",.)
		replace rdtbrand=subinstr(rdtbrand,"	"," ",.)
		replace rdtbrand=subinstr(rdtbrand,"  "," ",.)
		replace rdtbrand=subinstr(rdtbrand,"  "," ",.)
		replace rdtbrand=subinstr(rdtbrand,".","",.)
		replace rdtbrand=subinstr(rdtbrand,",","",.)
		replace rdtbrand=subinstr(rdtbrand,"LIMITED","LTD",.)
		replace rdtbrand=subinstr(rdtbrand,"PRIVATE","PVT",.)
		replace rdtbrand=subinstr(rdtbrand,"ê", "E",.)	
		*/	


		ta rdtbrand	
			/* INSERT RESULTS:

			*/
				
	*$$$ Continue running through brand names to clean as needed.
		/*Check for typos, variations in naming convention that can be matched/ cleaned up, etc. 
		*Try to (1) match manually entered manufactures to those in the database where possible 
		*or (2) use the same nomenclature for new manufactures*/
	
	
	
*BRAND NAME / MANUFACTURER - CONSISTENCY
  /*Check consistency between brand name and manufacturer. This step is only
    required for manual fill antimalarials. */
	
	bysort rdtmanu: tab rdtbrand if fillmethod==2	
	*$$$ Although some brands may have more than one manufacture, sense check and edit as needed so that there is consistency within brand names. It may help to search products online!
	/* INSERT RESULTS:
	
		*/
		
	
	

**************** 1.3.2.7: PARASITE & ANTIGEN
  /*Check that parasite and antigen information are complete and consistant */
	
	*$$$fix missing info (not indicated) where possible
	*$$$check consistancy within brand
	
	ta parasite antigen	
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed 
		
	bysort rdtbrand: tab parasite antigen if fillmethod==2
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check, clean as needed using product photos where available
		/*
		EXAMPLE: 
		list pic_front pic_ais rdtauditkey parasite antigen rdtbrand
		*/
		
		
		
**************** 1.3.2.8: SELF-ADMINISTER - PROPORTION
  /*Check the completeness of responses for RDTs which are for self-admin */
	tab self, m
		/* INSERT RESULTS:
		*/
	bysort brand: tab self, m
		*$$$ sense check, clean as needed based on product photos
	
**************** 1.3.2.9: AMOUNT SOLD/DISTRIBUTED - RANGE
  /*Check the range of amount sold/distributed for RDTs. This step is required
    for both search and manual fill RDTs.
	Outliers will be confirmed in data management syntax. */	
	
	tab r13, m
	replace r13=-9888 if r13==9998
	replace r13=-9777 if r13==9997
	sum r13 if r13>0
	br if r13==.
	*review comments for missing values
	list r19 if r13==. | r13<0
	
		/* INSERT RESULTS:
		*/
		
	
**************** 1.3.2.10: STOCK OUT - PROPORTION
  /*Check the proportion / range of stock out */

	tab r14, m 
		/* INSERT RESULTS:
		*/

	*review comments for missing
	list r19 if r14==. 

**************** 1.3.2.11: RETAIL PRICE

*RETAIL IN-OUTLET PRICE - RANGE
	/*Check range for outlet test retail price for adults and children. This step
    is required for both search and manual fill RDTs. */
	
	*do you test in this outlet?
		tab r15a, m
		/* INSERT RESULTS:
		*/
	
	*review comments for missing
		list r19 if r15a==. | r15a<0

		
		
		*adult price 
			tab r15b if r15a==1, m
			sum r15b if !inlist(r15b,-9777, -9888), d
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r15b==. | r15b<0

		
		*child price 
			tab r15c if r15a==1, m
			sum r15c if !inlist(r15c,-9777, -9888), d
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r15c==. | r15c<0
 		
	
*RETAIL TAKE-AWAY PRICE - RANGE
	 /*Check range for take-away test retail price for adults and children. This
    step is required for both search and manual fill RDTs. */
	
	*do you sell rdts for take away?
			tab r16a, m
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r16a==. | r16a <0
 				
		*adult price 
				tab r16b if r16a==1, m
				sum r16b if !inlist(r16b,-9777, -9888), d
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r16b==.	| r16b <0	
		
		*child price
				tab r16c if r16a==1, m
				sum r16c if !inlist(r16c,-9777, -9888), d
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r16c==. | | r16c <0
		
**************** 1.3.2.12: WHOLESALE PRICE
*WHOLESALE NUMBER - RANGE
	tab r17n, m
	tab r17n if !inlist(r17n,-9777, -9888), m
		/* INSERT RESULTS:
		*/
		
	*review comments for missing
		list r19 if r17n==. | | r17n <0
 		
		
*WHOLESALE PRICE - RANGE
	/*Check range for wholesale price. It is required to determine the price per
    test as respondents were asked about the number of tests purchased and the
    total price for all tests purchased. RDTs with a wholesale number or price
    of don't know (code 998) should be removed from this check. This step is
    required for both search and manual fill RDTs. */ 
		
	tab r17p, m
		/* INSERT RESULTS:
		*/
		
		*$$$ sense check and review comments, clean as needed 
				
		*ws price per test (i.e. price paid for total amount divided by total amount purchased)
		gen r17p_test = r17p / r17n if !inlist(r17p,-9777, -9888) & ///
		!inlist(r17n,99995,99997,99998), after(r17p)
		lab var r17p_test "wholesale: last purchase price per test"
		tab r17p_test, m
		/* INSERT RESULTS:
		*/
		
		
		


   
****************  1.3.2.13: RETAIL AND WHOLESALE PRICE - OUTLIERS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*Check for retail and wholesale price outliers. 
  This step is required for
    both search and manual fill RDTs. */
	
		sum r15b if !inlist(r15b,-9777, -9888), d
		sum r15c if !inlist(r15c,-9777, -9888), d
		sum r16b if !inlist(r16b,-9777, -9888), d
		sum r16b if !inlist(r16c,-9777, -9888), d
		sum r17p_test, d
		
		/* INSERT RESULTS:
		*/
		
*document any suspicious values, including possible miscodes (eg. 999 for missing) and/or negative values

		
		
		

		
		
**# 
*******************************************************************************/
*	1.3.3	GENERATE QARDT VARIABLE
*******************************************************************************/

**** SYNTAX FOR PREPARING THE RDT MASTERLIST DTA MUST BE RUN BEFORE THIS SECTION (SETUP 0.5) ****

**************** 1.3.3.1: GENERATE THE QARDT VARIABLE
/*Generate the QARDT variable. The QARDT variable is coded based on brand
	name, manufacturer name, country of manufacturer, antigen and parasite
	species. 
	 */
	 		gen qardt=0
			lab var qardt "Is this a quality-assured RDT?"
			lab val qardt yesno
	 
 
****************1.3.3.2: RECODE SERACHED PRODUCTS USING QA COLUMN IN RDT DATABASE
* MERGE QA RDT database with the RDT datasets
	
			merge m:1 rdtcode using ///
			"${datadir}/lists/rdt-masterlist.dta", ///
			keepusing (rdtcode natapp_master qardt_master)
			
			*drop RDTs appearing in the masterlist that were not found in the field:
			drop if _merge==2
			
			tab rdtbrand qardt, m 
			lab var qardt "WHO PQ RDT"			
		
		**note, manually entered RDTs that match a product in the database should be assigned the
		*corresponding rdtcode. Following cleaning, manually entered products that match DB-searched products 
		*should be checked, and assinged an rdt code:
		
		bysort rdtmanu rdtbrand parasite: ta rdtcode fillmethod,m
		
				/* INSERT RESULTS:
		*/
		
		/*
		*based on these results, locate any specific products that require an RDT code, EXAMPLE:
		replace rdtcode="A130_NGA" if rdtcode=="" & rdtmanu=="DR MEYER" & rdtbrand=="SUPERTEST" & parasite=="2"
		*/
		
	
**************** 1.3.3.3: RDT TRUE - GENERATE
 /*Generate a variable that indicates if the RDT audited was deemed valid. This
	step is required for both search and manual fill RDTs. */

			gen rdt_true = 0
			recode rdt_true (0 = 1) if rdtbrand != "94" & rdtbrand != ""
			lab var rdt_true "RDT audited is true RDT?"
			ta rdt_true,m
			gen productype=3 if rdt_true==1	
			
	
	

	

			
*SAVE CLEAN DATASET
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
save "${datadir}/cleaning/AwL_${country}_${year}-rdtaudit_clean.dta", replace	

	count // insert number of observations here


	
	

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
