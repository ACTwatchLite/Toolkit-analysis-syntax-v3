
/*******************************************************************************
	ACTwatch LITE 
	DATA PREPARATION & CLEANING SYNTAX 
	FOR ANTIMALARIAL AUDIT DATA
	
********************************************************************************/
/*
This syntax imports, prepares, and cleans audit data for antimalarials 

This syntax produces a dataset in long format, with one antimalarial product 
per row (with repeated outlet data for outlets with more than 1 antimalarial product)

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
1.2.1 - $$$ DATA PREPARATION*
1.2.2 - $$$ DATA CLEANING**
1.2.3 - GENERATE QAACT AND NATAPP 

*manual input is only required for the raw .csv data file name in the preparation syntax and for checking duplicates/ known errors
**manual input is required for checking and cleaning each variable in the audit dataset. The syntax below can be used to structure this cleaning process, but additional code, checks, outputs, etc. should be well documented as changes are made. 

THE RESULTS OF THIS SYNTAX = 
A cleaned dataset of all antimalarials audited at study outlets which will be referenced in the data management syntax

*/

  
  
*** SECTION A OF THE MASTERFLIE SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		
	

* RUN STEP 1.1 TO CLEAN OUTLET LEVEL DATA BEFORE MERGING TO THIS DATASET
 


clear 
********************************************************************************
**#  1.2.1	DATA PREPARATION                        											*
********************************************************************************
/*The data preparation syntax should import raw datasets and 
	ensures the variables and values are labelled so that the data is easier 
	to work with. See the data preparation guidelines for a more detailed 
	description and instructions for specific preparation steps. 
*/  



* 1.2.1.1: IMPORT DATASETS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* import data from primary .csv file	
	/* EXAMPLE:
	insheet using "${datadir}/raw/AwL-NGA-2024-final-consent_group-section5-amAudit.csv" 
	 */
	
	$$$ insheet using "${datadir}/raw/[AM AUDIT DATA FILENAME]", names clear
			
	count // $$$ record count



* 1.2.1.2: LABEL VARIABLES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*run .do file for variable labels for this dataset. 
	do "${cleandir}/variable-lables/varlbl_syntax_amaudit.do"
	
	
	
*1.2.1.3: PREPARE FIELD TYPES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	*list string variables from ODK - these can be copied from software .do files
	
	*$$$ local text_fields1 " [insert here variables to modify] "
	
	 /* EXAMPLE:
		local text_fields1 "tsgsearchtext tab_amcode tab_ambrand_search tab_brand_search tab_a3_search tab_a3_lbl_search tab_ai1_search tab_ai1_lbl_search tab_ai1_mg_search tab_ai1_ml_search tab_ai1_strength_search"
	*/
	
		/* ensure that text fields are always imported as strings 
		(with "" for missing values)
		Note "calculate" fields treated as text; you can remove above or 
		destring later if you wish*/ 
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
	

	
	
* 1.2.1.4: DROP TABLET AND NON-TABLET VALUES WHERE THESE HAVE ALREADY BEEN COMBINED INTO A SINGLE VARIABLE BY ODK FORM
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
*The ODK form captures information from tablet and non-tablet antimalarials separately. The form then auto-combines variables so the separate tab/ ntab are not needed and can be dropped here. 
	*$$$ edit or add if variable names have changed, been added or removed.

drop tab_amcode tab_ambrand_search tab_brand_search tab_a3_search tab_a3_lbl_search tab_ai1_search tab_ai1_lbl_search tab_ai1_mg_search tab_ai1_ml_search tab_ai1_strength_search tab_ai2_search tab_ai2_lbl_search tab_ai2_mg_search tab_ai2_ml_search tab_ai2_strength_search tab_ai3_search tab_ai3_lbl_search tab_ai3_mg_search tab_ai3_ml_search tab_ai3_strength_search tab_manu_search ntab_searchtext ntab_amcode ntab_ambrand_search ntab_brand_search ntab_a3_search ntab_a3_lbl_search ntab_ai1_search ntab_ai1_lbl_search ntab_ai1_mg_search ntab_ai1_ml_search ntab_ai1_strength_search ntab_ai2_search ntab_ai2_lbl_search ntab_ai2_mg_search ntab_ai2_ml_search ntab_ai2_strength_search ntab_ai3_search ntab_ai3_lbl_search ntab_ai3_mg_search ntab_ai3_ml_search ntab_ai3_strength_search ntab_manu_search	
drop search_typ_am tabsearchtext	
drop brand_search brand_manual manu_manual manu_search a3_search a3_manual a3_lbl_search a3_lbl_manual a3_category ainum ai1_search ai1_lbl_search ai1_strength_search ai2_search ai2_lbl_search ai2_strength_search ai3_search ai3_lbl_search ai3_strength_search ai1_manual ai1_manual_lbl ai1_strength_manual ai2_manual ai2_manual_lbl ai2_strength_manual ai3_manual ai3_manual_lbl ai3_strength_manual hasml

* 1.2.1.5: COMBINE SEARCHED AND MANUAL ENTERED PRODUCT INFO
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  		
	
*Again, the ODK form captures variables separately for products that were searched and pre-populated versus those that were manually entered. The form then auto-combines these so the _search/ _manual can be dropped here
	*$$$ edit or add if variable names have changed, been added or removed.

	
	*odk only keeps strength labels. create new integer vars	
	destring ai*_m*_search, replace	
	
		gen ai1_mg= ai1_mg_search
				replace ai1_mg= ai1_mg_manual if ai1_mg==.	
		gen ai1_ml= ai1_ml_search
				replace ai1_ml= ai1_ml_manual if ai1_ml==.
		gen ai2_mg= ai2_mg_search
				replace ai2_mg= ai2_mg_manual if ai2_mg==.
		gen ai2_ml= ai2_ml_search
				replace ai2_ml= ai2_ml_manual if ai2_ml==.
		gen ai3_mg= ai3_mg_search
				replace ai3_mg= ai3_mg_manual if ai3_mg==.
		gen ai3_ml= ai3_ml_search
				replace ai3_ml= ai3_ml_manual if ai3_ml==.

	drop ai*_m*_*
	drop ai*_strength
	order ai*_m* , after (ai3_ing)
	

	*merge suspension info
	replace a3_searchl_5_detail=a3_manual_5_detail if a3_manual_5_detail!=.
	drop a3_manual_5_detail
	rename a3_searchl_5_detail suspensiontype
	order suspensiontype, after (a3)
	
	order a3_search_5_detail_other a3_manual_5_detail_other a3_manual_other, last

	*destring ai [active ingredient] names 
	destring ai*_ing, replace
		label define ai /// 
		60 "Amodiaquine" 61 "Artemether" 62 "Artemisinin" 63 "Arteether" ///
		64 "Artemotil" 69 "Arterolane" 65 "Artesunate" 66 "Atovaquone" 67 "Chloroproguanil" ///
		68 "Chloroquine" 70 "Dapsone" 71 "Dihydroartemisinin" 72 "Halofantrine" ///
		73 "Hydroxychloroquine" 74 "Lumefantrine" 75 "Mefloquine" 76 "Naphthoquine" ///
		77 "Piperaquine" 78 "Primaquine" 79 "Proguanil" 80 "Pyronodrine" 81 "Pyrimethamine" ///
		82 "Quinacrine" 83 "Quinine" 85 "Sulfadoxine" 86 "Sulfamethoxazole" 87 "Sulfamethoxypyrazine" ///
		88 "Trimethoprim" 89 "Sulfalene" 96 "Other" 98 "Don't know"
		label values ai*_ing ai
	
	*recode dose form categories to run with the ai program correctly 
	gen a3_category =.
	recode a3_category (.=1) if inlist(a3,1,2,3)
	recode a3_category (.=0) if inlist(a3,4,5,6,7,8)
	ta a3 a3_category
	lab var a3_category "form cat var for ais program"
	***

	


	
* 1.2.1.6: CHECK AND CORRECT DUPLICATES
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

	duplicates list key
	
	$$$ drop duplicates found in outlet cleaning if any

	
*1.2.1.7: CORRECT KNOWN ERRORS HIGHLIGHTED DURING DATA COLLECTION
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
	*During data collection, known errors such as duplicate or incomplete/ incorrect entries, erroneous IDs, etc should be recorded by field teams for the analyst. 
	*Fix those issues here or note where in the analysis syntax they are addressed.
	$$$ address any other errors noted during data collection or in the comments 	
	
	
	

* 1.2.1.8: CREATE CLEANING VARIABLES TO MAINTAIN ORIGINAL VALUES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
/* To avoid mass recodes or loss of original values, create _orig variables to
	store these data before cleaning that can then be used to back-compare with cleaned
	data as needed
	*/	
	generate amcode_orig=amcode
	generate a3_orig=a3
	generate brand_orig=brand
	generate manu_orig=manu
	generate amcountry_orig=amcountry
	generate ai1_orig=ai1_ing
	generate ai2_orig=ai2_ing
	generate ai3_orig=ai3_ing
	generate ai1mg_orig=ai1_mg
	generate ai1ml_orig=ai1_ml
	generate ai2mg_orig=ai2_mg
	generate ai2ml_orig=ai2_ml
	generate ai3mg_orig=ai3_mg
	generate ai3ml_orig=ai3_ml
	
	
	
	

*1.2.1.9: MERGE OUTLET-LEVEL DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
	/* Data from the outlet form that each product was audited at are added 
	here by first merging using 'key' that is unique to every form, 
	then by outlet id which is unique to each outlet 
	*/
	
	*$$$note if using the naming conventions from the outlet cleaning syntax, the following should work. otherwise, insert the correct file pathway and file name:
	use	"${datadir}/cleaning/AwL_${country}_${year}-allforms_cleaning.dta", clear
	rename c6 c6_amaudit
	
* MERGE OUTLET-LEVEL DATA

*Use key from all forms to merge relevant cleaning variables
	  rename key amauditkey
	  rename parent_key key 
	  merge m:1 key using ///
		"${datadir}/cleaning/AwL_${country}_${year}-allforms_clean.dta", ///
		 keepusing (key outletid auditlevel eligible consented am_stockcurrent //
			n1 amaudit_complete amaudit_incomplete hasamaudit status //
			c2 c3 c4 c7 c6 s3 s4 s5a s5b s6 c9) 
		
		/* $$$ add merge results here: 

   
*/

	$$$ CHECK MERGE
	*$$$ All antimalarial (am) audit forms should be linked to an outlet form. 
	*$$$ check am audit records that dont match to an outlet here:
		br if _merge==1	
		list key outletid if _merge==1
		list key setofamaudit if _merge==1
		drop if _merge==1
	
	*$$$ check outlet records with no antimalarials. Note not all outlets will necessarily have AM audits.
	*This is expected only if the outlet does not have ams.. 
		br if _merge==2
		list key setofamaudit if _merge==2

	drop _merge
		
	


		
* 1.2.1.10: MERGE AND REPLACE UPDATED MASTERLIST INFO   
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
	/*
	If the antimalarial master list was updated or any changes were made during data
	collection, merge the database to the product data and replace information
	
	The merge uses amcode (which should be unique to each antimalarial in the master database)
	*/
	
	
	
*MERGE AM DATABASE
cap drop _merge
	merge m:1 amcode using "${datadir}/lists/am-masterlist.dta"
/*
	$$$ add merge results:



*/

	
	*check merge against fillmethod (i.e. whether the AM product information 
	*came from the database or was manually entered by a fieldworker
	
		tab _merge fillmethod, m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	*$$$ do additional checks as needed and make changes below
	*br if _merge==1 & fillmethod==1
	*ta amcode if _merge==1 & fillmethod==1
	*br if _merge==1 & fillmethod==1

*to fix errors, replace the am code based on the erroneous key values: e.g. "replace amcode= "NGA-1278" if key=="UUID:5581A3FE-2462-4862-ADEF-AB018033298A/CONSENT_GROUP-SECTION5-AMAUDIT[1]" 

*drop AM products in the master database that were not indentified during fieldwork:
		drop if _merge==2 // $$$ note N dropped here

	 
*remove _merge variable 
	cap drop _merge
	
*rename key
	rename key amauditkey
	
	

	
	 
	 
	
*1.2.1.11: SAVE PREPARED DATA
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
save "${datadir}/cleaning/AwL_${country}_${year}-amaudit_prepared.dta", replace

count // $$$ note N AMs in dataset here
	
		*show codebook and notes
		*codebook
		*notes list


		
		
		
		
********************************************************************************		
********************************************************************************		
********************************************************************************
KW TO MOVE!!!!!!!!!
*PACK TYPE
	destring packagetype, replace
	label define packagetype1 1 "Blister strip / card" 2 "Individual packet" 3 "Loose tablets in a pot, tin, or other container" 4 "Bottle" 5 "Ampoule or vial" 6 "Sachet" 96 "Other packaging type"
	label values packagetype packagetype1
	*drop packagetype_label
	
*PACK SIZE 
*combining different pack type sizes into a single variable; used for cleaning

	gen size=packagesize_blisterpacks , after (packagesize_blisterpacks )
		replace size=packagesize_blisterpacks if size==.
		replace size=packagesize_loose if size==.
		replace size=packagesize_bottle if size==.
		replace size=packagesize_vial if size==.
		replace size=packagesize_sachets if size==.
		replace size=packagesize_other if size==.	
	
*STOCK OUT OK


*VOLUME SOLD MERGE UNIT/PACK 
	gen amsold= amsold_unit, after (amoos)
	replace amsold=amsold_pack if amsold==.
	
*PRICE MERGE UNIT/PACK
	*pack retail price 
	gen retail_price=packageprice_unit, after(amsold)
	replace retail_price= packageprice_pack if retail_price==.
	
	
	*price paid when selling wholesale/resale
	gen ws_amt= wsmin_unit, after(supplier_amt)
	replace ws_amt=wsmin_pack if ws_amt==.
	rename wsmin_price ws_price

KW TO MOVE!!!!!!!!!

********************************************************************************		
********************************************************************************		
********************************************************************************



*******************************************************************************
**# 	1.2.2 ANTIMALARIAL DATA CLEANING
*******************************************************************************/




**# 1.2.2.1: IMPORT PREPARED ANTIMALARIAL DATASET	                       
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
* Open prepared dataset if not already in use
	clear 	
	use "${datadir}/cleaning/AwL_${country}_${year}-amaudit_prepared.dta", clear
	
	count // $$$ record the number of products and confirm this matches the expected number from the earlier data preparation stage




	
	
**#* 1.2.2.2: GENERATE SUM OF STRENGTHS 
		  /*The sumstrength variable is generated which is the sum of the antimalarial
			strengths. This variable is used for subsequent cleaning as it allows for
			products to be more easily identified in many cases (i.e. where artemether 20mg lumefantrine 120mg
			has been entered during data colleciton as "lumefantrine 120mg artemether 20mg" the sum of strengths
			variable has the same value (i.e. 140) in both cases*/
			
			
			*$$$ Before making sum of strengths below, quickly check the manually entered 
*product strengths for any obvious errors (e.g. AL 20/120 that has been entered as 21/120) 	
	foreach i of numlist 1/3 {
		bysort ai`i'_ing: tab1 ai`i'_m* if fillmethod==2
	}
	*$$$
			
			
			**check that ai*_mg when 9998 is not being used for this calculation:
			
			recode ai*_mg (9998=.)
			
			egen sumstrength = rsum(ai1_mg ai2_mg ai3_mg)
				lab var sumstrength "sum of mg strengths"
				order sumstrength, after(ai3_ml)
			ta sumstrength,m
		
	
	
	
		
* CHECKS 
*********************************************************************************
********************************************************************************* 
*CHECK REPORTED COMPLETENESS FOR AM AUDIT 
  tab amaudit_complete, m 
  
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
  br if amaudit_complete==.
  
 	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
 
 	
	**************** INTERVIEWER COMMENTS FROM AM AUDIT AND INTERVIEW OVERALL
	
  /*Review interview comments- comment_int -  Any interview comments that require cleaning of
    outlet-level variables should be flagged and cleaned in the respective
    cleaning step. */
	
	
	
	
*CHECK ANTIMALARIAL COMMENTS - REVIEW AND CLEAN ACCORDINGLY 
	 /*$$$ Before or while checking comments at the end of the antimalarial audit, review
	  any interview comments (comment_int) that require cleaning of antimalarial-level variables
		should be flagged and cleaned in the respective cleaning step. */
	 /*Then, any antimalarial comments here that require cleaning of antimalarial-level
		variables should be flagged and cleaned here. */
		
		
	replace amcomments="." if amcomments==""
	
	replace amcomments="." if amcomments=="NONE" | amcomments=="NO COMMENT" ///
	| amcomments=="NO" | amcomments=="9998"  | amcomments=="NA"  | amcomments=="N/A"  ///
	| amcomments=="NOT APPLICABLE"  | amcomments=="NOTHING"	| regexm(amcomments,"NON") ///
	| regexm(amcomments,"NO COMM") | amcomments=="."
	
	tab amcomments
	*br outletid key amcomments if 	amcomments!="" //antimalarial audit comments
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


		*$$$ check remaining commments and address any data cleaning required 
	 	


	export excel amcomments amauditkey if amcomments!="" using "$cleandir/AM audit commments for review.csv", replace
	*$$$ check comments
	
	
*CHECK PROPORTION MANUALLY ENTERED
 tab fillmethod, m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

  
  **#**1.2.2.3: CONFIRM ALL PRODUCTS ARE ANTIMALARIALS
	br if ai1_ing>90 & ai1_ing<999
	list brand manu ai*_ing amcomments amauditkey if ai1_ing>90 & ai1_ing<999
		/*
		$$$ add results and make changes based on careful review (of images/the same products) if needed:


	*/
	*drop any non-antimalarial products
	/* EXAMPLE:
	drop if amauditkey=="UUID:D9B4BB97-3E51-42E5-92A8-182BAAEC552E/CONSENT_GROUP-SECTION5-AMAUDIT[9]"
	drop if amauditkey=="UUID:6C3BB0F5-89C4-425A-AD24-D1024E7B05E8/CONSENT_GROUP-SECTION5-AMAUDIT[3]"
	*/ 

  
**# 1.2.2.4: CLEAN BRAND NAMES
*it is important that manually entered brand names are cleaned to be as consistent as possible, 
*based on correcting obvious errors, and/or review of product photos.
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  **$$$identify any products without a brand name and add this in where possible:
    br if brand=="9998" | brand =="" 
	*check product pictures for products missing brand
	list amauditkey pic_front pic_ais if brand==""
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	*add in missing brand names from product photos where possible
	/* EXAMPLE:
	*   replace brand="COMBIART" if amauditkey=="UUID:89C8AA0D-D9DB-4E27-8AA0-B2046E00D7F4/CONSENT_GROUP-SECTION5-AMAUDIT[1]" 
*/

	*run basic string cleaning 
	replace brand=trim(brand)
	replace brand=regexr(brand,",","")
	replace brand=regexr(brand," AND "," & ")
	replace brand=regexr(brand,"MG","")
	replace brand=regexr(brand,"ML","")
	replace brand=regexr(brand,"GOUTTE","DROP")
	replace brand=regexr(brand," - ","")
	replace brand=regexr(brand,"FOR INJECTION","INJ")
	replace brand=regexr(brand,"INJECTION","INJ")
	replace brand=regexr(brand,"INJECTABLE","INJ")
	replace brand=regexr(brand,"AMODIAQINE","AMODIAQUINE")
	replace brand=regexr(brand,"ARTEMTHER","ARTEMETHER")
	replace brand=regexr(brand,"SOFT GEL","SOFTGEL")
	replace brand=regexr(brand,"9998","")ta brand if fillmethod==2
 

	*$$$continue cleaning additional manually entered brand names
	list brand if fillmethod==2
	
	**$$$use your preferred string commands (eg. regexm) to clean brand names, 
	/* EXAMPLE:
	*	replace brand="AFABETA" if regexm(brand,"A FABETA") 
	*	replace brand="METALAM ARTESUNATE INJ" if regexm(brand,"ARTESUNATE") & regexm(brand,"INJ") & regexm(brand,"METALAM")
*/
	
	*$$$ we recommend using standard names for generics where appropriate. 
	/* EXAMPLE:
	* list brand if regexm(brand,"AMODIAQUINE")
	*	replace brand="GENERIC AMODIAQUINE" if regexm(brand,"AMODIAQUINE") & !regexm(brand,"ARTESMODIA")& !regexm(brand,"WINTHROP")
*/

	*confirm brand is as consistent as possible with the available data:
	ta brand if fillmethod==2
	ta brand fillmethod, m
	
	
	*quick check cleaning by comparing original values e.g. make sure no mass recodes/errors
	bysort brand: ta brand_orig
	bysort brand_orig: ta brand


**# * 1.2.2.5: CLEAN MANUFACTURERS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*### similar to brand name, clean manufacture names by filling blanks, using standard naming conventions, etc.

	*fix errors that need to be coded as missing
	replace manu="-9998" if manu_orig=="9998"
	replace manu="-9998" if manu_orig=="2"
	replace manu="-9888" if manu_orig=="NOT INDICATED"
	replace manu="-9888" if manu_orig=="NOT CLEAR"
	replace manu="-9888" if manu_orig=="NONE"


	*$$$ check pictures for products missing manufacture name   
	  list amauditkey pic_front pic_ais if manu==""
		/*
		$$$ add results and make changes based on careful review (of images/the same products) if needed:


	*/
	*$$$ correct any missing manufacturers where possible from product photo. eg:
	*replace manu="JIANGSU RUINIAN QIANJIN PHARMA" if amauditkey=="UUID:B3DD5333-F5A6-44D8-9521-1EB0DA48FFBE/CONSENT_GROUP-SECTION5-AMAUDIT[14]" 


	*run basic string cleaning -- overall cleaning of standard terms to help with later stages
	replace manu= trim(manu)
	replace manu = regexr(manu,"PHARMACEUTICALS","PHARMA") 
	replace manu = regexr(manu,"PHARMACEUTICAL","PHARMA") 
	replace manu = regexr(manu,"PHARMS","PHARMA") 
	replace manu = regexr(manu,"PHARM","PHARMA") 
	replace manu = regexr(manu,"PHARMAA","PHARMA") 
	replace manu = regexr(manu,".","") 
	replace manu = regexr(manu,",","") 
	replace manu = regexr(manu,";","") 
	replace manu = regexr(manu,":","") 
	replace manu = regexr(manu,"LIMITED","LTD") 
	replace manu = regexr(manu,"CO LTD","LTD") 
	replace manu = regexr(manu,"PVT LTD","LTD") 
	replace manu = regexr(manu,"PVT.LTD","LTD") 
	replace manu = regexr(manu,"PRIVATE LTD","LTD") 
	replace manu = regexr(manu," AND "," & ") 
	replace manu = regexr(manu,"LTD","") 
	replace manu = regexr(manu,"PVT","")
	replace manu = regexr(manu," PUT ","")
	replace manu = regexr(manu,"HEALTH CARE","HEALTHCARE")
	replace manu = regexr(manu,"  "," ") 
	

	*$$$continue to clean manually entered manufacture names 
	ta manu // if fillmethod==2
	*you may want to tabulate only manually entered names or manually and searched 

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
	/* EXAMPLE:
replace manu="ALLIANCE BIOTECH" if regexm(manu,"ALLIAANCE BIOTECH")
replace manu="PAL PHARMA INDUSTRIES" if regexm(manu,"-9888") & brand=="PALNADAR"
replace manu="JIANGSU RUINIAN QIANJIN PHARMA" if regexm(manu,"JIANGSU RUI")|  regexm(manu,"JIYANGSU RUINAN QIANJIN")|  regexm(manu,"JIYANGSU RULNIAN") | manu=="JSRNQJ PHARMA "|  regexm(manu,"JIANGSU RULNIAN") 

	*/


	*quick check cleaning by comparing original values e.g. make sure no mass recodes
	bysort manu: ta manu_orig
	


**# 1.2.2.6: CHECK BRAND/ MANUFACTURE CONSISTANCY 
* (in general there any given brand should only be made by 1 manufacturer)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bysort brand: ta manu

*************
*confirming that all manufacturers have been correctly cleaned:
*set more on
bysort manu: ta manu_orig
   
 *set more off, perm 
 
 
 
**# 1.2.2.7: COUNTRY OF MANUFACTURE
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ta amcountry,m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


label list amcountry
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

tab amcountry_other if amcountry == 996 | amcountry == 998
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
*$$$ recode all other countries 
	/* EXAMPLE:
	recode amcountry (996=1) if regexm(amcountry_other,"SHANDON") | regexm(amcountry_other,"SHANGDONG") // China
	
	lab def amcountry 901 "MALAYSIA", add 
 	recode amcountry (996=901) if amcountry_other=="MALAYSIA"
*/


*$$$once all other countries recoded, this variable can be dropped
*drop amcountry_other


*Check consistency of country of manufacturer by manufacturer and brand name. 
*nb. some brands and manufacturers may have more than 1 country. Check for known/ obvious errors. 
*This step is required for both search and manual fill antimalarials.  		

	*$$$ check by manufacture 
		bysort manu: tab amcountry, m
			
	*$$$ check by brand 
		bysort brand: tab amcountry, m
		  
							  
							  
	
**# 1.2.2.8: *GENERIC NAME - PREPARATION
*********************************************************************************
*********************************************************************************
 /*The generic name is the combination of active ingredients. This variable is
    generated here as it is needed for subsequent cleaning steps. */

	label list ai
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/



*$$$ SPOT CHECK AND FIX ERRORS WITH AI NUMBERS
	/*spot check prepared data and address any known error or obvious data entry 
	errors e.g. coding for arteminin instead of dihydroartemisinin
	*/ 
	 tab1  ai1_ing ai2_ing ai3_ing
	 
	 *check am comments for any missing active ingredient (ai) information
	/*EXAMPLE:
	 ta amcomments if ai1_ing>95
	 ta amcomments if ai2_ing>95 & ai2_ing!=.
	 ta amcomments if ai3_ing>95 & ai3_ing!=.
 
	 *check am comments for any missing active ingredient (ai) information
	 ta brand if ai1_ing>95
	 */
	
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


	
*GENERATE GNAME - this is the generic name variable (with the active ingredients of each antimalarial)
  *Generic gname_tmp (temp concatenation of active ingredients)
    decode ai1_ing, gen(ai1_tmp)
    decode ai2_ing, gen(ai2_tmp)
    decode ai3_ing, gen(ai3_tmp)
    gen gname_tmp = ai1_tmp, before(ai1_ing)
      replace gname_tmp = gname_tmp + ", " + ai2_tmp if ai2_tmp != ""
      replace gname_tmp = gname_tmp + ", " + ai3_tmp if ai3_tmp != ""
		ta gname_tmp,m
				
  *Generate sumcodes variable (sum of active ingredient codes, similar to 
  *the sumstrength, this helps with product identification for cleaning and 
  *the order of the active ingredients does not matter)
    gen sumcodes = ai1_ing if !inlist(ai1_ing,96,98,.), after(gname_tmp)
      replace sumcodes = ai1_ing + ai2_ing if !inlist(ai2_ing,96,98,.)
      replace sumcodes = ai1_ing + ai2_ing + ai3_ing if !inlist(ai3_ing,96,98,.)
	    
  *Generate gname variable
    *inspecting products with single instance
	bysort gname_tmp: gen nn = _n
    bysort sumcodes: list gname_tmp if nn == 1
    drop nn
	
	gen gname = ., before(gname_tmp)
      lab var gname "generic name"
	  
		replace gname = 1 if sumcodes ==60 //amodiaquine 
		replace gname = 2 if sumcodes ==226 //SP amodiaquine 
		  *note for sumcode==145, there are 2 generics... atovaquone proguanil AND artesunate-pyronaridine
		replace gname = 3  if sumcodes == 145 & ///
			gname_tmp == "Atovaquone, Proguanil"  
		replace gname = 3  if sumcodes == 145 & ///
			gname_tmp == "Proguanil, Atovaquone"  // atovaquone-proguanil 
		replace gname = 4 if sumcodes == 68 // chloroquine
		replace gname = 10 if sumcodes == 73 // hydroxychloroquine sulfate
		replace gname = 11 if sumcodes == 75 //mefloquine 
		replace gname = 14 if sumcodes == 79 //proguanil 
		replace gname = 15 if sumcodes == 81 //pyrimethamine 
		replace gname = 22 if sumcodes == 82 //quinacrine/mepacrine 
		replace gname = 19 if sumcodes == 83 // quinine
		replace gname = 21 if sumcodes == 166 // SP
		replace gname = 30 if sumcodes == 63 // arteether/artemotil
		replace gname = 31 if sumcodes == 61 // artemether
		replace gname = 32 if sumcodes == 65 // artesunate    
		replace gname = 40 if sumcodes == 135 // AL
		replace gname = 42 if sumcodes == 139 // artimisinin-piperaquine
		replace gname = 44 if sumcodes == 125 // ASAQ 
		replace gname = 47 if sumcodes == 140 // ASMQ 
		 replace gname = 49 if sumcodes == 145 & /// 
			gname_tmp == "Artesunate, Pyronaridine"
		replace gname = 49 if sumcodes == 145 & /// 
			gname_tmp == "Pyronaridine, Artesunate" //ASPY
		replace gname = 61 if sumcodes == 146 // arterolane-piperaquine
		replace gname = 55 if sumcodes == 148 // DHA-piperaquine
		replace gname = 50 if sumcodes == 231 // AS-SP
		replace gname = 56 if sumcodes == 236 // DHA-piperaquine-Trimethoprim
		  
	 ta gname, m
	 	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	 
	 list ai*_ing sumcode if gname==.
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	  **note that the full list of generics can be added to, below, and have additional
	  *gname sumcodes added above as needed
   /* gname label included here for referecne as it is useful in cleaning, but lable
   created in varlbl_syntax_amaudit.do
   
   lab def gname ///
      1 "amodiaquine" ///
      2 "SPAQ/ amodiaquine-SP" ///
      3 "atovaquone-proguanil" ///
      4 "chloroquine" ///
      5 "chloroquine-proguanil" ///
      6 "chloroquine-SP" ///
      7 "chlorproguanil-dapsone" ///
      9 "halofantrine" ///
      10 "hydroxychloroquine sulfate" ///
      11 "mefloquine" ///
      12 "mefloquine-SP" ///
      13 "primaquine" ///
      14 "proguanil" ///
      15 "pyrimethamine" ///
      16 "pyrimethamine-dapsone" ///
      18 "quinimax" ///
      19 "quinine" ///
      20 "quinine-SP" ///
      21 "SP" ///
	  22 "Mepacrine/quinacrine" ///
      30 "arteether/artemotil" ///
      31 "artemether" ///
      32 "artesunate" ///
      33 "dihydroartemisinin" ///
      40 "AL" ///
      41 "artemisinin-naphthoquine" ///
      42 "artemisinin-PPQ" ///
      43 "artemisinin-PPQ-primaquine" ///
      44 "ASAQ" ///
      45 "AS-halofantrine" ///
      46 "AS-lumefantrine" ///
      47 "ASMQ" /// 
      48 "AS-PPQ" ///
      49 "AS-pyronaridine" /// 
      50 "AS-SP" ///
      51 "DHA-AQ" ///
      52 "DHA-halofantrine" ///
      53 "DHA-lumefantrine" ///
      54 "DHA-MQ" ///
      55 "DHA-PPQ" ///
      56 "DHA-PPQ-Trim" ///
      57 "DHA-pyronaridine" /// 
      58 "DHA-SP" ///
      59 "chloroquine-PRI" ///
      60 "AL-PRI" ///
      61 "arterolane-PPQ" ///
      95 "not an antimalarial"
	  
	  */
	  
	  
    lab val gname gname
    tab gname, m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	



	
*$$$ check non-antimalarials are actually not AMs, and recode missings
	*non-antimalarials 
	tab1 brand gname_tmp if gname==95
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	*br if gname==95
	
	*$$$ clean any mis-identified AMs above (in code above gname calculation, and rerun) 
	

*$$$ recode missings	
	*missing 
	tab brand if gname==.
	*br if gname==.
	
	
	tab gname, m
	
	bysort gname: ta gname_tmp
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	drop gname_tmp sumcodes ai?_tmp
		
	
*confirm ai's are correct within gname
	bysort gname: tab ai1_ing 
	bysort gname: tab ai2_ing 
	bysort gname: tab ai3_ing 
	
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
					
/*	DROP DATA FOR NON-AMs 
	Once gname is clean, non-antimalarials should be removed from the database. 
	If the outlet has other products, the non-antimalarial can be dropped 
	If the outlet only presented this non-antimalarial product, 
		the interview should be wiped in the outlet level dataset
 */ 
	ta parent_key if gname==95
	*$$$ check if outlet ids where non-ams were audited have other products 
	
	*ta brand if outletid=="1-10-101721-8423" 
	//outlet with nonantimalarial has other antimalarials audited so will drop the product but not outlet record
	/* EXAMPLE:
	drop if amauditkey=="UUID:42C1EE65-CA75-49A2-9F50-BF882F7037A5/CONSENT_GROUP-SECTION5-AMAUDIT[2]"
	*/
	
	
/* CHECK FREQUENCY OF GENERIC NAMES AND SEARCH METHOD
	use this section to determine what gnames are included in the data 
	and what code is relevant below. It is also useful to look at which products are 
	mostly captured through searching the database or manual fill. Only manually 
	filled products will need brand, manufacturer, and strength data cleaned. 
*/ 
	tab gname fillmethod, m 
		
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


	
 
 **# 1.2.2.9: DOSE FORM (CHECK 1 of 3)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Here we will check for common errors in dose form fieldworkers may have made 

/*
(1/3) SUSPENSION TYPE -- 
WE KNOW FIELDWORKERS FIND SUSPENSIONS (POWDER / LIQUID) CONFUSING. THESE REQUIRE SPECIFIC CHECKS

FIELDWORKERS FREQUENTLY CONFUSE LIQUID AND POWDER SUSPENSIONS
FIELDWORKERS FREQUENTLY CONFUSE LIQUID SUSPENSIONS AND SYRUPS

***CHECK ALL FORMS HERE FOR OBVIOUS ERRORS. CONFIRM WITH PHOTOS OR OTHER AUDIT INFO. 

SOME HINTS:
MOST SUSPENSIONS ARE EXPECTED TO BE POWDER. ALL ACT SUSPENSIONS SHOULD BE POWDER. DOCUMENT ANY 
CHLOROQINE/ QUININE/ NON-ACT SUSPENSIONS MAY BE LIQUID OR POWDER

NOTE THAT IF A PRODUCT IS A LIQUID, BUT ITS PACKAGING SAYS "SUSPENSION" AND/OR 
SAYS TO SHAKE BEFORE USE, IT SHOULD BE MARKED AS LIQUID SUSPENSION -- NOT SYRUP


*/
	
	*check suspension type
		ta suspensiontype
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*CHECK ALL LIQUID SUSPENSIONS, INCLUDING IMAGES IF NECESSARY, AND CORRECT AS NEEDED
		
		br if suspensiontype==1
		
		**confirm that liquid suspensions are 1) actually liquids, and 2) actually suspensions (i.e. not syrups)
		list gname brand manu ai1_ing ai1_mg ai1_ml if suspensiontype==1 
		
		list gname brand manu ai1_ing ai1_mg ai1_ml pic_front pic_ai if suspensiontype==1 & ai1_ml==.
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*CONFIRM ALL POWDER SUSPENSIONS ARE ACTUALLY POWDERS:

ta brand if suspensiontype==2

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


	
*/

/*
 *** DOSE FORM (CHECK 1 of 3)

(2/3) Injection type
ANOTHER COMMON FIELDWORKER ERROR IS TO CONFUSE LIQUID AND POWDER INJECTIONS. 

***CHECK ALL FORMS HERE FOR OBVIOUS ERRORS. CONFIRM WITH PHOTOS OR OTHER AUDIT INFO.

HINTS:
ACTs SHOULD NOT BE INJECTABLES OR SYRUPS. ARTESUNATE TABLETS ARE RARE. 
INJECTIONS IN AMPOULES ARE LIQUIDS

INJECTIONS IN VIALS ARE POWDER. POWDER INJECTIONS ARE FREQUENTLY CO-PACKAGED WITH 
AN AMPOULE OF SOLVENT (TO DISSOLVE THE DRY POWDER INJECTABLE) - THESE SHOULD STILL BE 
ENTERED IN THE DATASET AS POWDER INJECTIONS.

*/

bysort gname: ta a3


*Check dose form (a3)
*powder inj:
 
ta gname if a3==6
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*continue to investigate unusual cases
/* EXAMPLE: 
 ta a3 if gname==30

/*
-> gname = 30. arteether/artemotil

                  a3 |      Freq.     Percent        Cum.
---------------------+-----------------------------------
           1. Tablet |          1        0.12        0.12
6. Liquid Injectable |        841       99.88      100.00
---------------------+-----------------------------------
               Total |        842      100.00
*/

list amauditkey  ai1_mg ai1_ml brand  pic_front pic_ais if gname==32 & a3==6

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*/


*liquid inj

ta gname if a3==7
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*continue to investigate unusual cases
	/*EXAMPLE:
	list amauditkey  ai1_mg ai1_ml ai1_mg  brand  pic_front pic_ais if gname==4 & a3==7
	
*/

 *** DOSE FORM (CHECK 1 of 3)

*CHECK OTHER DOSE FORMS ARE CONSISTENT

/**SOME OTHER RULES OF THUMB
1. MOSTLY ACTS SHOULD BE TABLETS, GRANULES OR SUSPENSIONS, AND GRANULES SHOULD ONLY BE ACTS
2. SUPPOSITORIES ARE (TO DATE) RARE, AND SHOULD MOSTLY BE ARTESUNATE
3. INJECTABLES ARE USUALLY MONOTHERAPIES, AND WILL LIKELY BE ARTESUNATE, ARTEMETHER, 
	ARTEETHER, CHLOROQUINE, QUININE
4. SYRUPS ARE GENERALLY ONLY CHLOROQUINE OR QUININE
*/

*$$$ INVESTIGATE (INCLUDING REVIEW OF PRODUCT PHOTOS)
*CORRECT ANY ERRORS IN DATASET
* AND DOCUMENT CASES WHERE THESE RULES ARE NOT CORRECT AND/OR DISCUSS WITH STUDY LEAD



bysort gname: ta a3
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	/* EXAMPLE:
	recode a3 (7=6) if amauditkey=="UUID:D277E3D5-EC3E-47AC-B667-EACD03D267FC/CONSENT_GROUP-SECTION5-AMAUDIT[2]"
*/

bysort gname: ta a7
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	/* EXAMPLE:
	recode a3 (7=6) if amauditkey=="UUID:D277E3D5-EC3E-47AC-B667-EACD03D267FC/CONSENT_GROUP-SECTION5-AMAUDIT[2]"
*/


**# 1.2.2.10: GENERATE NUMBER OF ACTIVE INGREDIENTS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
*Create variable that indicates the number of active ingredients for each product
gen ainum=.
lab var ainum "Number of active ingredients"

	*add AINUM
	recode ainum .=3 if ai3_ing!=.
	recode ainum .=2 if ai2_ing!=. & ai3_ing==.
	recode ainum .=1 if ai1_ing!=. & ai2_ing==. & ai3_ing==.


	
	
**# 1.2.2.11: STRENGTHS - ML/MG or MG - CONSISTENCY BY GNAME
*product strength is an important variable for estimating a number of key indicators

*liquids (i.e. injectables, syrups and liquid suspensions) have strengths as mg/ml
*all other products have strengths as mg
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
*quick check for consistency of strengths by dose form noting which should/ should not have ml strengths  						
*/


*tablets(should not have ml)
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml ///
		if a3==1 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:

*$$$ review product photos and fix any errors based on these, either editing ml or a3


*/

*suppositories	(should not have ml)	
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==2
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:
*$$$ review product photos and fix any errors based on these, either editing ml or a3

*/

*granules	(should not have ml)		
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==3
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:

	*$$$ review product photos and fix any errors based on these, either editing ml or a3

*/
	
*syrups (should have ml)
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==4
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:
*$$$ review product photos and fix any errors based on these, either editing ml or a3

*/
*suspensions (should have ml)	
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==5
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:
*$$$ review product photos and fix any errors based on these, either editing ml or a3

*/
*liquid inj. (should have ml)	
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==6
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:
*$$$ review product photos and fix any errors based on these, either editing ml or a3

*/
*powder inj (should not have ml)
	list amauditkey gname brand ai1_mg ai1_ml ai2_mg ai2_ml ai3_mg ai3_ml if ///
		a3==7
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:

*$$$ review product photos and fix any errors based on these, either editing ml or a3
*/
		

	
**# 1.2.2.12: STRENGTHS - TABLETS, SUPPOSITORIES, GRANULES
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
  /*The following syntax uses the ais programs to check consistency between
	active ingredients and strength using the ais_* programs.
	These checks are only required for manual fill antimalarials. 
	
	/*note that different strengths of a product with the same generic name (gname) are allowed
but they should be consistent. 
eg. Artemether Lumefantrine (AL) might have strengths:
20mg, 120mg
40mg, 240mg
60mg, 360mg
80mg, 480mg
but a strength of 22mg/120mg is likely a data entry error

fix or add any stregths that do not align with known values for each gname
*/

 
 
** TABLETS, SUPPOSITORY, GRANULES  

*WE HAVE CREATED SOME SHORT PROGRAMS TO HELP WITH CHECKING ACTIVE INGREDIENT STRENGTHS
*FOR EACH GENERIC, YOU WILL NEED TO HAVE A LIST OF KNOWN STRENGTHS. 
*WE HAVE INCLUDED THE KNOWN STRENGTHS FOR KNOWN AIS BELOW, BUT THIS LIST MAY NEED TO BE
*UPDATED/ EDITED IN FUTURE IF NEW PRODUCTS/ FORMULATIONS BECOME AVAILABLE

*THE PROGRAMS OUTPUT A TABLE OF PRODUCTS NOT CONFORMING TO KNOWN STRENGTHS FOR 
*FURTHER INVESTIGATION/ EDITS

*INSTRUCTIONS:
*ais_tk1: Checks consistency between 1 active ingredient with known strengths
  for tablets, suppositories and granules. This program takes the following
  arguments:
    1 = generic name code
    2 = active ingredient code
    3 = active ingredient known strengths 
  
To run the program for amodiaquine (generic name code = 1,
active ingredient code = 60), the following command should be run:
ais_tk1 1 60 "75,150,153.1,200,300,306,600"

In the above command the known active ingredient strengths are listed within
quotation marks and separated with commas (no spaces).

NOTE PROGRAM NAMING LOGIC:

program names: ais_tk1; ais_tu; ais_nk3, etc:
ais - means active ingredients
t - for tsg = tablets, suppositories, granules; n - for non-tsg
k - for known (known strengths available); u for unknown
1 - one active ingredient; 2 - two ais; 3 - three ais



*/

$$$
*One active ingredient with known strengths.
ais_tk1 1 60 "75,150,153.1,200,300,306,600"		// amodiaquine 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 4 68 "75,100,150,250,300" 				// chloroquine 		
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
						
ais_tk1 9 72 "233" 								// halofantrine 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 11 75 "250" 							// mefloquine 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 13 78 "5,7.5,15" 						// primaquine 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 14 79 "87,100" 							// proguanil 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 31 61 "40,50" 							// artemether 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 32 65 "50,60,100,200,400" 				// artesunate 	
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
						
ais_tk1 33 71 "20,40,60,80" 					// dihydroartemisinin
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
	
	

ais_tk1 10 73 "200" 							// 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


*One active ingredient with unknown strengths.	
ais_tu 10  "200" 								//hydroxychloroquine sulfate 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tu 15										// pyrimethamine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tu 18 										// quinimax 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk1 19 83 "125,250,300,600"	
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
					
ais_tu 19 										// quinine 	
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tu 30 										// arteether/artemotil
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
	
*Two active ingredient with known strengths.
ais_tk2 3 66 79 "62.5 250" "25 100" 			// atovaquone-proguanil
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk2 55 71 77 "10 15 20 30 40 60 80 120 62.5" "80 120 160 240 320 480 640 960 375" // DHA-PPQ 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk2 21 81 85 "250 500" "12.5 25" 			// SP
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk2 40 61 74 "20 40 40 60 80 180" "120 240 320 360 480  1080" // AL	
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
				
ais_tk2 41 62 76 "125"  "50" // artemisinin-napthoquine - none
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk2 44 65 60 "25 25 50 50 50 50 50 100 100 100 100 200" "67.5 75 135 150 153 153.1 260 270 300 306.2 200 600" // ASAQ
	  			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_tk2 47 65 75 "25 50 50 100 100 100 200 300"  "55 125 250 125 220 250 250 375" // ASMQ
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
  
ais_tk2 47 65 60 "25 25 50 50 50 50 50 100 100 100 100 200" ///
	  "67.5 75 135 150 153 153.1 260 270 300 306.2 200 600" // ASAQ 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
	ais_tk2 47 65 75 "25 50 50 100 100 100 200 300" ///
	  "55 125 250 125 220 250 250 375" // ASMQ
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	ais_tk2 49 65 80 "20 60" "60 180" // ASPY
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

		
**# KW edited for toolkit to here
		
*Two active ingredient with unknown strengths.
	
		ais_tu 5 // chloroquine-proguanil
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 7 // chlorproguanil-dapson
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 16 // pyrimethamine-dapsone
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
		ais_tu 42 // artemisinin-piperaquine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
												
		ais_tu 45 // AS-halofantrine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 46 // AS-lumefantrine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 48 // AS-PPQ
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 51 // DHA-AQ
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 52 // DHA-halofantrine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 53 // DHA-lumefantrine
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 54 // DHA-MQ
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		ais_tu 57 // DHA-pyronardine 
			/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

					
*Three active ingredient with known strengths.
	*all ok for NGA 
		ais_tk3 2 60 "85,86,87" 25 "200 600" "500 500" "25 25" // amodiaquine-SP  
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
		ais_tk3 12 75 "85,86,87" 81 "250" "500" "25" // mefloquine-SP
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	ais_tk3 50 65 "85,86,87" 81 "50 100 100 200" "500 250 500 500" "25 12.5 25 25" // artesunate-SP  
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	ais_tk3 58 71 "85,86,87" 81 "60 160" "500 500" "25 25" //  DHA-SP
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	*Three active ingredient with unknown strengths.
	ais_tu 6 // chloroquine-SP
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	ais_tu 20 // quinine-SP
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	ais_tu 43 // artemisinin-PPQ-primaquine
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
	ais_tu 56 // DHA-PPQ-trimethoprim 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
	
*Final check between active ingredient and strength for manually entered products that appear to be outliers, 
/* EXAMPLE: for suppositories
bysort gname: tab ai1_ing ai1_mg if a3==2 & fillmethod== 2, m
bysort gname: tab ai2_ing ai2_mg if a3==2 & fillmethod== 2, m
bysort gname: tab ai3_ing ai3_mg if a3==2 & fillmethod== 2, m
*/
	
*Explore any specific gnames / strengths that do not match with expected values
/* EXAMPLE: 
list brand a3 ai1_ing ai2_ing ai1_mg ai2_mg ai1_ml ai2_ml amauditkey pic_front pic_ais if a3==2 & gname==40
*/
	
	
	

**# 1.2.2.13: STRENGTHS - SYRUPS, SUSPENSIONS, LIQUID INJECTIONS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

list amauditkey brand a3 gname ai1_ing ai1_mg ai1_ml pic_front pic_ais if ///
(ai1_mg == . | ai1_ml == .) & ai1_ing != . & inlist(a3,4,5,6) 
recode ai1_ml (.=60) if a3==5 & gname==40 & brand=="WINART"

list amauditkey brand gname a3 ai2_ing ai2_mg ai2_ml pic_front pic_ais if ///
(ai2_mg == . | ai2_ml == .) & ai2_ing != . & inlist(a3,4,5,6) & ///
fillmethod == 2
recode ai2_ml (.=60) if a3==5 & gname==40 & brand=="WINART"

list amauditkey brand gname a3 ai3_ing ai3_mg ai3_ml pic_front pic_ais if ///
(ai3_mg == . | ai3_ml == .) & ai3_ing != . & inlist(a3,4,5,6) 
				

				
				
**# 1.2.2.14: ACTIVE INGREDIENT / STRENGTH - CONSISTENCY SYRUPS, SUSPENSIONS, LIQUID INJECTION
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*The following syntax will check consistency between active ingredients and
strength for syrups, suspensions and liquid injections using the ais_*
programs. These checks are only required for manual fill antimalarials. */

*example program:
/*ais_nk1: Checks consistency between 1 active ingredient with known strengths
  for syrups, suspensions, liquid injections and powder injections. This program
  takes the following arguments:
    1 = generic name code
    2 = active ingredient code
    3 = active ingredient known mg strengths
    4 = active ingredient known ml strengths

	Example, to run the program for arteether/artemotil (generic name code
  = 30, active ingredient code == 63 or 64), the following command should be
  run:
    ais_nk1 30 "63,64" "75 150 150 225" "1 1 2 3"
  
  In the above command the active ingredient codes are listed within quotation
  marks and separated with commas (no spaces). The known active ingredient mg
  and ml strengths are listed in quotation marks and separated with spaces (no
  commas). The first mg strength corresponds with the first ml strength, the
  second mg strength corresponds to the second ml strength, etc. */

/*

NOTE PROGRAM NAMING LOGIC:

program names: ais_tk1; ais_tu; ais_nk3, etc:
ais - means active ingredients
t - for tsg = tablets, suppositories, granules; n - for non-tsg
k - for known (known strengths available); u for unknown
1 - one active ingredient; 2 - two ais; 3 - three ais

*/
*One active ingredient with known strengths.
*none in NGA 
ais_nk1 1 60 50 5 // amodiaquine
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 4 68 "25 50 40 80 322.5 40 200 322 64.5 80 60 37.5 50" "5 5 30 5 5 5 5 5 30 60 10 10 60" // chloroquine
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
							
ais_nk1 9 72 100 5 // halofantrine 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 30 "63,64" "75 150 150 225" "1 1 2 3" // arteether/artemotil
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 33 71 160 80 // dihydroartemisinin 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 31 61 "20 20 40 80 100 100 180 300 60 150" "1 2 1 1 1 2 60 100 1 2" // artemether 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 32 65 "30 60 120 30 60 120" ". . . 1 1 1" // artesunate  
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
ais_nk1 19 83 "300 600 100" "1 2 5" // quinine
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
*Two active ingredient with known strengths.
ais_nk2 21 "85,86,87" 81 "250 250 500" "5 10 2.5" "12.5 12.5 25" ///
  "5 10 2.5" // SP
  /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

ais_nk2 55 71 77 80 60 640 60 // DHA-PPQ	
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		
ais_nk2 40 61 74 180 60 1080 60 // AL suspensions
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*One active ingredient with unknown strengths.
ais_nu 19 "100 600" "5 2"// quinine
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*Two and three active ingredients with unknown strengths.
	ais_nu 56 // DHA-PPQ-Trim
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
							
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Final check between active ingredient and strength for manually entered products that appear to be outliers
* Explore any specific gnames / strengths that do not match with expected values
/* EXAMPLE: f
bysort gname ai1_ing: tab ai1_mg ai1_ml if a3_category == 1 , m

list a3 brand ai1_mg if ai1_ml==1 & gname==31
ta manu brand if gname==55 & ai1_mg==1 & ai1_ml==1
ta  brand if gname==55 & ai1_mg==1 & ai1_ml==1
*/
						 
						 
******** 
******** 
	

**# 1.2.2.15: *SALT
*some active ingredients have strength (mg or mg/ml) for the ai+salt. 
*Ensure that a salt is specified in cases where non-base strength was recorded for an active ingredient. 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


numlabel gname ai act_ingred, add

*LABEL 
	label define saltlbl 1 "Bisulphate" 2 "Hydrochloride" 3 "Dihydrochloride" 4 "Gluconate" 5 "Phosphate" 6 "Sulphate" 7 "Tetraphosphate" 96 "Other"
	label values salt saltlbl

	ta salt if hassalt==1, m

*SALT - OTHER-SPECIFY															
	ta salt_other
	
	recode salt (96=2) if regexm(salt_other,"HYDROC") 
	

ta hassalt, m
ta a3 hassalt, m

ta salton
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

***OUR UNDERSTANDING OF ANTIMALARIALS IS THAT ONLY THE FOLLOWING COMBINATIONS
* ARE CORRECT. ALL OTHER SALTS SHOULD BE CHECKED 
*(INCLUDING AGAINST PRODUCT PHOTO) 
*FOR CONFIRMATION:

/*
1. All active ingredients which shouldn't have a salt, don't have a salt. The following active ingredients should not have salts.
	61 = Artemether 
	62 = Artemisinin 
	63 = Arteether
	64 = Artemotil 
	65 = Artesunate 
	66 = Atovaquone
	70 = Dapsone
	71 = Dihydroartemisinin 
	74 = Lumefantrine 
	76 = Naphthoquine 
	78 = Primaquine 
	80 = Pyronodrine
	81 = Pyrimethamine
	82 = Quinacrine 
	85 = Sulfadoxine 
	86 = Sulfamethoxazole 
	87 = Sulfamethoxypyrazine 
	88 = Trimethoprim

2.	If the active ingredient is amodiaquine (60) then there should be hydrochloride, or no salt
3.	If the active ingredient is chloroquine (4) then there should be dihydrochoride or sulphate or no salt
4.	If the active ingredient is halofantrine (72) then there should be  hydrochloride or no salt
5.	If the active ingredient is mefloquine (75) then there should be hydrochloride or no salt
6.	If the active ingredient is piperaquine (77) then there should be phosphate or no salt
7.	If the active ingredient is proguanil (79) then there should be  hydrochloride or no salt
8.	If the active ingredient is quinine (83) then there should be  bisulphate, dihydrochloride, gluconate, hydrochloride, sulphate or no salt

*/
bysort gname: ta salt salton

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

  
	  /*Check that active ingredients which shouldn't have a salts don't have salts.*/
	sort brand
	list brand gname a3 ai*_ing salton salt pic_front if ///
		(inrange(salt,1,8) &  inlist(salton,61,62,63,64,65,66,70,71,74,76,78,80,81,82,85,86,87,88))
		  
	list brand gname a3 salton salt pic_front pic_ais if ///
		(inrange(salt,1,8) &  inlist(salton,61,62,63,64,65,66,70,71,74,76,78,80,81,82,85,86,87,88))

/	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

**no AL salts
	replace salt =. if gname== 40
	replace salton=. if gname== 40
		  
** no SP salts
	replace salt =. if gname== 21
	replace salton=. if gname== 21
	
**DHAPPQ fieldworkers mistake which ai the salt is on - should be the ppq
	recode salton(71=77) if gname==55 | gname==56
		  
**ASAQ - salt should be on Amodiaquine
	recode salton(65=60) if gname==44
	
**SPAQ
	*SPAQ-CO no salt
	replace salt=. if gname== 2 & brand=="SPAQ CO-DS"
	replace salton=. if gname== 2 & brand=="SPAQ CO-DS"
	
** Arterolane-PPQ
	replace salton=77 if gname==61 & brand=="SYNRIAM" & salton!=.
	
*Chloroquine
	recode salton(61=68) if gname==4

	***checking all products 
 bysort gname: tab salton, m
 
 **fixing the salton variable
 ***Chloroquine
 list brand gname a3 ai*_ing salton salt pic_front if gname==4 & salton!=68 & salton!=.
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
recode salton (77=68) if gname==4 & salton!=.
recode salton (83=68) if gname==4 & salton!=.


***Hydroxychloroquine sulphate
 list amauditkey brand gname a3 ai*_ing salton salt pic_front if gname==10 & salton!=73 & salton!=.
 	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

 ***artemether
 list amauditkey brand gname a3 ai*_ing salton salt pic_front if gname==31 & salton!=.
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

***artesunate
 list amauditkey brand gname a3 ai*_ing salton salt pic_front if gname==32 & salton!=.
 	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*Artesunate should not have salts
recode salton (61 65=.) if gname==32 
recode salt (5 96=.) if gname==32 


***mepaquine/quinacrine
 list  brand gname a3 ai*_ing salton salt pic_front if gname==70 & salton!=.
/	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


recode salt(1=2) if gname==70
replace salton=82 if gname==70


***now confirming salts are correct type for the ai's they are associated with:

/*
2.	If the active ingredient is amodiaquine (60) then there should be hydrochloride, or no salt
3.	If the active ingredient is chloroquine (4) then there should be dihydrochoride or sulphate, or phosphate, or no salt
4.	If the active ingredient is halofantrine (72) then there should be  hydrochloride or no salt
5.	If the active ingredient is mefloquine (75) then there should be hydrochloride or no salt
6.	If the active ingredient is piperaquine (77) then there should be phosphate or no salt
7.	If the active ingredient is proguanil (79) then there should be  hydrochloride or no salt
8.	If the active ingredient is quinine (83) then there should be  bisulphate, dihydrochloride, gluconate, hydrochloride, sulphate or no salt

*/


*Amodiaquine
**NB Amodiquine suspensions by NEW GLOBAL should not have salt.
recode hassalt(1=0) if ai1_ing==60 & salton==60 & manu=="NEW GLOBAL PHARMA"

list brand gname a3 ai*_ing salton salt pic_front if gname==1 & !inlist(salt,2,.) 

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

recode salt (1=2) if gname==1 & salt!=.

*Chloroquine
list brand gname a3 ai*_ing salton salt pic_front if gname==4 & !inlist(salt,2,5,6,.) 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

recode salt (1=5) if gname==4 & !inlist(salt,2,5,6,.) 
list pic_front  brand ai1_mg gname salt if ai1_ing==68 & hassalt==1 & salt==6

recode salt (6=5) if ai1_ing==68 & gname==4 & hassalt==1


*Halofantrine
list brand gname a3 ai*_ing salton salt pic_front if (ai1_ing==72 |ai2_ing==72 | ai3_ing==72 )  & !inlist(salt,2,.) 

*Mefloquine
list brand gname a3 ai*_ing salton salt pic_front if (ai1_ing==75 |ai2_ing==75 | ai3_ing==75 )  & !inlist(salt,2,.) 

*Piperaquine
list brand gname a3 ai*_ing salton salt pic_front if (ai1_ing==77 |ai2_ing==77 | ai3_ing==77 )  & !inlist(salt,5,.) 

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

replace salt =5 if ai2_ing==77 & !inlist(salt,5,.) 

*Proguanil
list brand gname a3 ai*_ing salton salt pic_front pic_ais if (ai1_ing==79 |ai2_ing==79 | ai3_ing==79 )  & !inlist(salt,2,.) 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
recode salt (3=.) if (ai1_ing==79 |ai2_ing==79 | ai3_ing==79 )  & !inlist(salt,2,.) 
recode salton (79=.) if (ai1_ing==79 |ai2_ing==79 | ai3_ing==79 )  & !inlist(salt,2,.)  


*Quinine
list brand gname a3 ai*_ing salton salt pic_front pic_ais if (ai1_ing==83 |ai2_ing==83 | ai3_ing==83 )  & !inlist(salt,1,2,3,4,6,.) 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
recode salt (5=6) if (ai1_ing==83 |ai2_ing==83 | ai3_ing==83 )  & !inlist(salt,1,2,3,4,6,.) & regexm(brand,"SUL") 

recode salt (5 96=2) if (ai1_ing==83 |ai2_ing==83 | ai3_ing==83 )  & !inlist(salt,1,2,3,4,6,.) & regexm(brand,"TOBY") 


*recode hassalt based on salton variable
		gen hassalt_orig=hassalt, after (ai3ml_orig)
		
		recode hassalt 0=1 if salton!=.
		recode hassalt 1=0 if  salton==.
		
*

**# PACK TYPE & SIZE 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
**# 1.2.2.16: PACKAGE TYPE 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*PACKAGE TYPE - OTHER
	*recode other pack types 
	ta packagetype_other
	
	/* EXAMPLE:
	recode packagetype (96=3) if packagetype_other=="BOX" 
	recode packagetype (96=5) if packagetype_other=="SINGLE VIAL IN A COMBIPACK" 
	*/
	
	
	ta packagetype, m
	
*drop packagetype_other once the packagetype has been determined
	*drop packagetype_other
	
	
*PACKAGE TYPE - REDEFINE
  /*The type variables were defined in a specific way for data collection
    and the flow of the SurveyCTO program. Here they will be redefined to
    facilitate cleaning. */
  lab def type ///
    1 "package/sachet" ///
    2 "loose/pot" ///
    3 "bottle" ///
    4 "ampoule/vial", modify
  gen type = ., before(packagetype)
    recode type (. = 1) if inlist(packagetype,1,2,6)
    recode type (. = 2) if inlist(packagetype,3)
    recode type (. = 3) if inlist(packagetype,4)
    recode type (. = 4) if inlist(packagetype,5)
    lab var type "package type"
    lab val type type
	
	 tab type packagetype, m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


*CHECKING PACKAGE TYPES BY DOSEFORMS
	
	
	
*ensure that doseforms and package types are correctly aligned
*CONSISTENCY CHECK - PACK SIZE BY PACK TYPE AND DOSE FORM 
*!!!
	*granules -> sachets 
	*syrup -> bottle
	*suppository -> package 
	*suspension -> bottle 
	*injectable (powder or liq) --> ampoule/ vial 
	*tablet --> package or pot 

	tab a3 type,m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

*$$$ explore and fix any errors by examining product photos where needed. 
*EG. FIELDWORKERS FREQUENTLY INDICATE "BOTTLE" FOR INJECTABLES, WHEN THIS SHOULD BE VIAL

	
	*suppositories
	
list brand brand_orig gname type a3 size pic_front pic_ais if a3==2  & !inlist(type,1,2)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
	**granules
	
list brand brand_orig gname type a3 size pic_front pic_ais if a3==3  & !inlist(type,1,2)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
		
	**syrups
list fillmethod amcode brand gname type a3  size pic_front pic_ais if a3==4  & !inlist(type,3)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
	
	**suspensions
list fillmethod amcode brand gname type a3  size pic_front pic_ais if a3==5  & !inlist(type,3)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

	**liquid injections
list  amcode brand gname type a3  size pic_front pic_ais if a3==6  & !inlist(type,4) & size<=5
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

		
	*powder injection
list  amcode brand gname type a3  size ai1_ml pic_front pic_ais if a3==7  & !inlist(type,4) 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

	 **drops
list  amcode brand gname type a3  size ai1_ml pic_front pic_ais if a3==8  & !inlist(type,3) 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		

 
 
**# 1.2.2.17 PACKAGE SIZE (the number of tablets, suppositories, vials, etc. per packagetype)
* DOCUMENT HERE
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
order packagesize_* , after (size)
rename packagesize_* ps_* 


*checking packets/sachets for non-tablet/supp/granule
list amcode brand gname a3 size ai1_ml pic_front if type==1 & a3>3
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		

*checking loose/pot for non-tablet/supp/granule
list amcode brand gname a3 size ai1_ml pic_front if type==2 & a3>2
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		

*checking bottle for non-syrup/suspensions/liquid inj/drops
list amcode brand gname a3 size ai1_ml pic_front if type==3 & !inlist(a3,4,5,6,8)
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		

***checking ampoule/vial for non-injections
list amcode brand  gname a3 ai1_ing ai1_mas size ai1_ml pic_front if type==4 & !inlist(a3,6,7)
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
		

**missing size

br if size==-9888

list amauditkey pic_front pic_ais if size==-9888

	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/



*CHECK / EDIT SIZE WHERE THERE IS ENOUGH EVIDENCE TO DO SO

/* SIZE MEANS THE FOLLOWING FOR EACH PACKTYPE:
TABLETS - NUMBER OF TABLETS PER PACK
SUPPOSITORIES - NUMBER OF SUPPOSITORIES PER PACK
GRANULES - NUMBER OF SACHETS PER PACK
INJECTABLES - NUMBER OF ML PER PACK
DROPS - NUMBER OF ML PER PACK
SUSPENSIONS - NUMBER OF ML PER PACK


Check that package size and package type are consistent:
1.	Tablet, suppository and granules package type should be pot when package size is > 56 (unless exceptions found)
2.	Tablet, suppository and granule package type should be pack when size is <=56.
3.	other products package type should be bottle when package size is > 10ml
4.	other products package type should be vial/ampoule when package size is <=5ml

If you identify inconsistent cases in any of the above checks then:
1.	Check product images
2.	Review audit sheet comments (nt_15).
3.	Search the dataset for other medicines with the same formulation, brand name 
and package size. Edit package type for consistency with these products. 
Consistency means that the package type is commonly associated with the given 
brand name and package size, and is consistent with formulation (e.g. ampoules 
correspond with liquid or powder injections).

It is important that package size and type is consistent with brand name and formulation. 

*/

*tablets in packets
list amcode brand gname ai1_ing size pic_front pic_ais if a3==1 & type==1 & size>56
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

	
	**the rest are correct, but should be pots/ loose (they are in packets, but not for individual sale)
	recode type (1=2) if size>=60 & size!=. & inlist(gname,10,14,19,40,55)

*tablets loose/pots
list amauditkey  brand gname size pic_front pic_ais if a3==1 & type==2 & size<56
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
	
**check size outliers 

*for tablets, suppositories and granules

ta size if inlist(a3,1,2,3)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
ta size type if size>56 & inlist(a3,1,2,3)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
ta gname type if size>56 & inlist(a3,1,2,3)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

**check size outliers for packets
ta size if inlist(type,1)
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

**check size versus strength for ACTs with known size/strengths
*do this by checking for consistency within brand, and/or looking at product photos
*DO THIS FOR EACH ANTIMALARIAL TYPE FOUND IN THE DATASET


ta size sumstrength if gname==40 & a3==1
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

/* EXAMPLE:
*AL 20/120; 40/240; 80/480 are all common ai_mg; with sizes 6;12;18;24

list brand brand_orig ai1_mg ai2_mg ai1mg_orig pic_* size if gname==40 & a3==1 & ai1_mg==80 & ai2_mg==480 & size>6

list brand brand_orig ai1_mg ai2_mg ai1mg_orig pic_* size if gname==40 & a3==1 & ai1_mg==80 & ai2_mg==480 & size>6

*/

ta size sumstrength if gname==44 & a3==1 // ASAQ
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

ta size sumstrength if gname==55 & a3==1 //dhappq
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	
/*EXAMPLE:
list brand brand_orig ai1_mg ai2_mg ai1mg_orig pic_* size if gname==55 & a3==1  & size>6
recode size (4/10=3) if gname==55 & a3==1 & sumstrength==1080
*/


*Suppositories  in packets
list amcode brand gname ai1_ing size pic_front pic_ais if a3==2 & type==1 & size>56 // 

list amcode brand gname ai1_ing size pic_front pic_ais if a3==2 & type==2 & size<56 // 

*granules
list amcode brand gname ai1_ing size pic_front pic_ais if a3==3 & type==1 & size>56 // 

list amcode brand gname ai1_ing size pic_front pic_ais if a3==3 & type==2 & size<56 // 


*nonTSG:
* vials/ampoules - size outlier checks
list amcode brand gname ai1_ing ai1_ml ai1_mg size pic_front pic_ais if inlist(a3,4,5,6,8) & type==4 & size>=10
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/	

*bottles - size outlier checks
list amcode brand gname a3 ai1_ing ai1_ml ai1_mg size pic_front pic_ais if inlist(a3,4,5,6,8) & type==3 & size<10
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

**vials of powder inj:
ta a3 gname if size>10 & type==4
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

ta size if a3==7
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

ta size if type==4 & a3==7
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
 
 
 list amcode brand gname a3 ai1_ing ai1_ml ai1_mg size pic_front pic_ais if inlist(a3,7) & type==4 & size>10 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/



**bottle outlier checks for very large bottles
list amcode brand gname a3 ai1_ing ai1_ml ai1_mg size pic_front pic_ais if inlist(a3,4,5,6,8) & type==3 & size>150
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

	/* EXAMPLE:
**one clear error:
recode size (322=10) if brand=="FENIRAN INJ" 
*/


ta size suspensiontype if a3==5 
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


**injections

ta size ai1_ml if a3==6, m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
*A COMMON ERROR IS FOR FIELDWORKERS TO CONFUSE SIZE AND STRENGTH FOR LIQUID INJECTIONS 

*CONFIRM WITH PRODUCT PHOTOS AND RECODE ACCORDINGLY
/* EXAMPLE:
recode size(.=1) if  a3==6 
*/

ta size ai1_mg if a3==7, m
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

***overall size checks:
bysort a3: ta size,m

**liquid  injections are frequently completed incorrectly by fieldworkers

list gname ai1_mg ai1_ml size  if a3==6 & size>10
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
** inj CHOLORQUINE can be larger
list gname ai1_mg ai1_ml size  if a3==6 & size>10 & gname!=4
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
recode size(. 60 120=1) if (gname==32 | gname==31 ) & inlist(ai1_mg,60,120,160) & a3==6
recode ai1_ml(.=1) if (gname==32 | gname==31 ) & inlist(ai1_mg,60,120,160) & a3==6

****powder injections are likewise often mis-coded
*for powder inj (a3==7) size is number of mg per vial
list gname ai1_mg ai1_ml size  if a3==7 & size<30
replace size=ai1_mg if ai1_ml==. & a3==7 & size<30


bysort type: ta size,m

**set -9888 to missing 
mvdecode size , mv(-9888)


*DROP EXTRA VARIABLES 
*drop ps_*



**suspensions

****fieldworkers find suspensions really difficult to accurately collect data on size/strength...
*often confusing bottle size, dosage, and strengths. 
/*

FOR EXAMPLE: https://onehealthng.com/product/lonart-suspension60ml
THIS PRODUCT IS LONART ARTEMETHER LUMEFANTRINE POWDER SUSPENSION
THE PACKAGING INCLUDES THE FOLLOWING INFORMATION:
LONART 20/120
ARTEMETHER 240MG
LUMEFANTRINE 1440MG
24G/60ML
EACH 5ML CONTAINS ARTEMETHER 20MG AND LUMEFANTRINE 120MG

FIELDWORKERS ARE LIKELY TO INPUT A VARIETY OF VALUES FOR STRENGTH, PACK SIZE, ETC

DATA CLEANING SHOULD AIM FOR CONSISTENCY AND ACCURACY. 
HERE THE SIZE SHOULD EITHER BE 60ML AND THE STRENGTH SHOULD BE 240/1440
-OR- SIZE SHOULD BE 12 (60ML/5ML - I.E. THE PACK CONTAINS 12 DOSES), AND STRENGTHS 20/120.

BOTH ARE CORRECT,AND WILL RESULT IN THE CORRECT NUMBER OF AETDS CALCULATED PER PACK.

HOWEVER, IF FIELDWORKERS HAVE INCLUDED A PACK SIZE OF 5ML AND A STRENGTH OF 20/120, THIS IS 
INCORRECT AND SHOULD BE RECODED

*/



*AL
ta size sumstrength if gname==40 & a3==5
ta ai1_mg ai2_mg if gname==40 & a3==5
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
/* EXAMPLE:

**review photo...
size 24 g in dataset but photo review shows it should be 60 ml
recode size (24=60) if gname==40 & a3==5 & brand=="LONART"
*/

**DHAPPQ
ta size sumstrength if gname==55 & a3==5
ta ai1_mg ai2_mg if gname==55 & a3==5
list ai1_mg ai1_ml ai2_mg ai2_ml   if gname==55 & a3==5 & size==24
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

ta gname if a3==5
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

***Amodiaquine suspensions:
 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==1
 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/


***chloroquine suspensions:
 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==4
 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/

 
***quinine suspensions:
 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==19
 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/
 
***SP suspensions:
 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==1
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 
 
 
***AL suspensions:
 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==40 & ai1_mg<=80
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 *EXAMPLE:
 **all ml shoudl be 5 here for consistency
* recode ai1_ml ai2_ml (60 . =5) if a3==5 & gname==40 & ai1_mg<=80

 list size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==40 & ai1_mg>80
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 
**DHA-PPQ suspensions:
 list pic_front pic_ais size brand ai1_mg ai1_ml ai2_mg ai2_ml suspensiontype if a3==5 & gname==55  
 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 *EXAMPLE:
 ** DHAPPQ is different as no liquid dosage given, just total dose in total final amount 
* recode size (.=80) if a3==5 & gname==55 & ai1_mg==80 & ai2_mg==640

 
 ***checking all powder suspensions:
 
 tab1 ai*ml if a3==5,m
/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 
 
 
 **** injections
 
 list ai1_ing ai1_mg ai1_ml brand a3  pic_front if a3==6 & ai1_ml==.
 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/


 
 ***syrups
  list ai1_ing ai1_mg ai1_ml brand a3  pic_front if a3==4 & ai1_ml==.

 /*
	$$$ add results and make changes based on careful review (of images/the same products) if needed


*/
 
 
 ***following size checks, conduct final checks on suspension ml values using product photos where there are inconsistencies:

 
*AL 
list brand pic_front pic_ais if gname==40 & ai1_ml==. & a3==5
ta brand ai1_ml if gname==40  & a3==5 

bysort ai1_ml: ta  ai1_mg ai2_mg if gname==40  & a3==5 

/* EXAMPLE: 
recode ai1_ml ai2_ml (. 0 24 60=5) if ai1_mg==20 & ai2_mg==120 & gname==40  & a3==5 
recode ai1_ml ai2_ml (. 0 5 24=60) if ai1_mg==180 & ai2_mg==1080 & gname==40  & a3==5 

list brand pic* if ai1_mg==240 & ai2_mg==1440 & gname==40  & a3==5 
recode ai1_ml ai2_ml (. 0 5 24=60) if ai1_mg==240 & ai2_mg==1440 & gname==40  & a3==5 // & brand=="LONART" 
*/

ta ai1_mg ai1_ml if gname==40  & a3==5 & ai1_ml==.,m
list brand pic_front pic_ais ai*mg ai*ml size if gname==40 & ai1_ml==. & a3==5 


*DHAPPQ - review of photos - all ai_mg stregths are for the full bottle size of 80 ml
list brand pic_front pic_ais if gname==55 & ai1_ml==. & a3==5
/* EXAMPLES: 
**P-ALAXIN
recode ai1_ml ai2_ml (.=80) if ai1_mg==80 & ai2_mg==640 & brand=="P-ALAXIN" 
**PIRAMAL TS
recode ai1_ml ai2_ml (. 0 =80) if ai1_mg==80 & ai2_mg==640 & brand=="PIRAMAL TS" 
**PIPART
recode ai1_ml ai2_ml (.=80) if ai1_mg==80 & ai2_mg==640 & brand=="PIPART" 
**FANMET
recode ai1_ml ai2_ml (.=80) if ai1_mg==80 & ai2_mg==640 & brand=="FANMET"
*/

ta  ai1_ml if gname==55  & a3==5

list brand pic_front pic_ais ai1_ml if gname==55 & ai1_ml!=80 & a3==5

tab ai1_mg ai1_ml if a3==5 &  gname==55 ,m

/*EXAMPLE:
*all DHAPPQ suspension powders in NGA database are 80ml
recode ai1_ml ai2_ml (. 0 =80) if gname==55 & ai1_mg==80 & ai2_mg==640 & a3==5
*/

*recode any remaining missing coded values for ai_ml to missing
recode ai*_ml (9998=.)


***Other suspensions

list gname brand pic_front pic_ais ai*_mg ai*_ml if a3==5 & ai1_ml==.

ta ai1_ml a3 if brand=="DR MEYERS MAXIQUINE",m
list a3 gname brand pic_front pic_ais ai*_mg size if brand=="DR MEYERS MAXIQUINE"

/* EXAMPLE:
recode ai1_ml (.=5) if brand=="DR MEYERS MAXIQUINE" & a3==5

list a3 gname brand pic_front pic_ais ai*_mg ai1_ml size if brand=="MALDOX"
recode ai1_ml ai2_ml (.=5) if brand=="MALDOX"  & a3==5
*/

	
	
	
	
**# 1.2.2.18:  REGULATORY CODE
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*$$$ edit variable names and add additional checks if more than one code is recorded

/* EXAMPLE:
		ta mas_code, m

		*/
		/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	

**# 1.2.2.19: EXPIRED PRODUCTS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	lab var expired_pack "Is this product within its expiry date?"

	ta expired_pack,m
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
**# 1.2.2.20:  STOCKED OUT IN LAST 3 MONTHS
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ta amoos, m
	
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/



*VOLUMES 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# 1.2.2.21: AMOUNT SOLD 
	tab1 amsold_*, m
	
	rename amsold sold
	lab var sold "Number of X product sold in last 7 days"
		*fix common typos 
		recode sold 9888=-9888
		recode sold 9988=-9888
		recode sold 9998=-9888
		recode sold 9888=-9888
		recode sold 9777=-9777
		recode sold 9977=-9777
		recode sold 9997=-9777
		recode sold 9777=-9777
		
	tab sold, m
	/*
	$$$ add results and review 


*/
  
 *Check for amount sold outliers. This step is required for both search and manual fill AMs. 
  bysort a3: tab sold fillmethod, m
  
  
  list brand gname type sold if sold>1000
	/*
	$$$ add results  and make changes based on careful review of comments if needed:


*/

list amcomments if sold>1000 
	/*
	$$$ add results  and make changes based on careful review of comments if needed:


*/
  
  
  
**# 1.2.2.22: PRICE 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*RETAIL PRICE TO CUSTOMERS 
	tab1 packageprice_* , m 
	*these are merged as retail_price in data prep
	*drop packageprice_* 
	
	rename retail_price rts_price //to match Benin/ CAmeroon 	
	lab var rts_price "Package price for X product"
		*fix common typos 
		recode rts_price 9888=-9888
		recode rts_price 9988=-9888
		recode rts_price 9998=-9888
		recode rts_price 9888=-9888
		recode rts_price 9777=-9777
		recode rts_price 9977=-9777
		recode rts_price 9997=-9777
		recode rts_price 9777=-9777
		
	tab rts_price, m
	/*
	$$$ add results and make edits based on careful review of comments if needed:


*/
	
	

*PRICE PAID TO SUPPLIER 
	*amount 
	tab1 supplier_amt_* , m 
		/*
	$$$ add results and make changes based on careful review of comments if needed:


*/

	
	lab var supplier_amt "Amount of product X purchased from supplier"
		*fix common typos 
		recode supplier_amt 9888=-9888
		recode supplier_amt 9988=-9888
		recode supplier_amt 9998=-9888
		recode supplier_amt 9888=-9888
		recode supplier_amt 9777=-9777
		recode supplier_amt 9977=-9777
		recode supplier_amt 9997=-9777
		recode supplier_amt 9777=-9777
	
	*price
	lab var supplier_price "Price for product X paid to supplier"
		*fix common typos 
		recode supplier_price 9888=-9888
		recode supplier_price 9988=-9888
		recode supplier_price 9998=-9888
		recode supplier_price 9888=-9888
		recode supplier_price 9777=-9777
		recode supplier_price 9977=-9777
		recode supplier_price 9997=-9777
		recode supplier_price 9777=-9777



*PRICE CHARGED FOR RESALE / WHOLESALE SELLING PRICE
 	*amount
	tab1 wsmin_* , m 
		/*
	$$$ add results and make changes based on careful review of comments if needed:


*/
	*these are merged in data prep
	*drop wsmin_* 
	
	lab var ws_amt "Minimum amount of product X for wholesale"
		*fix common typos 
		recode ws_amt 9888=-9888
		recode ws_amt 9988=-9888
		recode ws_amt 9998=-9888
		recode ws_amt 9888=-9888
		recode ws_amt 9777=-9777
		recode ws_amt 9977=-9777
		recode ws_amt 9997=-9777
		recode ws_amt 9777=-9777
		
	tab ws_amt, m
	/*
	$$$ add results and make changes based on careful review of comments if needed:


*/
	
	*price 
	lab var ws_price "Price for product X sold at wholesale"
		*fix common typos 
		recode ws_price 9888=-9888
		recode ws_price 9988=-9888
		recode ws_price 9998=-9888
		recode ws_price 9888=-9888
		recode ws_price 9777=-9777
		recode ws_price 9977=-9777
		recode ws_price 9997=-9777
		recode ws_price 9777=-9777
		
	ta ws_price
	/*
	$$$ add results  and make changes based on careful review of comments if needed:


*/
	
*PRICE PER AMOUNT/PACK

**### all price variables calculated from the data are *_price_tab2 or *_price_oth2
   
  *Retail sales price (note this is asked for either loose tablets, or packs for retail only)
  *for individual tablets
    gen rts_price_unit = rts_price if ///
      !inlist(rts_price,-9777, -9888) & a3 == 1 & packagetype==3 // tablet
      tab rts_price_unit

	*per pack for all other products  
    gen rts_price_pack = rts_price if ///
      !inlist(rts_price,-9777, -9888) & rts_price_unit==. // other
      tab rts_price_pack

  *Supplier purchase price (note this is asked in form as total amount paid per amount bought)
    gen supplier_price_tab = supplier_price / supplier_amt if ///
      !inlist(supplier_amt,-9777, -9888) & ///
      !inlist(supplier_price,-9777, -9888) 
      tab supplier_price_tab
    
	  
	
  *Wholesale sales price minimum
    gen ws_price_tab = ws_price / ws_amt if ///
      !inlist(ws_amt,-9777, -9888) & ///
      !inlist(ws_price,-9777, -9888) 
      tab ws_price_tab
   

	  
**# 1.2.2.23: PHOTO AVAILABILITY
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ta pic_ok, m
	/*
	$$$ add results 


*/
	
	
	
**# 1.2.2.24: FDC - FIXED DOSE COMBINATION (PRODUCTS WITH COMBINED ACTIVE INGREDIENTS, RATHER THAN SEPARATE DRUGS CO-PACKAGED)
*THIS VARIABLE IS NEEDED TO ESTIMATE NUMBER OF AETDS PER PACK LATER DURING DATA MANAGEMENT
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*FDC AND GENERIC NAME - CONSISTENCY
*FIELDWORKERS FREQUENTLY MAKE ERRORS FOR THIS VARIABLE

  /*Check consistency of FDC and generic name. This step is required for both
    search and manual fill antimalarials. */ 

ta gname fdc if a3_category==1, m row


	*clean fdc
		gen fdc_orig=fdc, after(ai3ml_orig) 
		
		*apply known rules 
			*1 monotherapies are not FDC 
				recode fdc (1 0 = 97) if inlist(gname,1,4,9,10,11,13,14,15,18,19,30,31,32,33)  //*	
			*2 all qaact TSG products should be fdc 
				recode fdc (0 = 1) if a3_category==1 & qaact_n==1
			*3 brand name has fdc or doseform in the name (original before cleaning, since these were removed)
				generate byte fdc_inbrand = strpos(brand_orig, "FDC") > 0 
				recode fdc (0=1) if fdc_inbrand==1 & a3_category==1
			*4 FDC only applies to tablets, suppositories and granules. All supp and granules should be FDC
			recode fdc (1 0 = -97) if a3>1
		
		recode fdc (97= -97) (98= -98) (99=-99)
		
		
		*fdc should be consistent within brand/manu and gname
		
		 egen _tempfdc_grp=group(brand manu gname)
		 bysort _tempfdc_grp: egen _tempfdc_max=max(fdc)
		 recode fdc (-98 -97 0 = 1) if _tempfdc_max==1
		 
		drop _tempfdc_grp  _tempfdc_max
		
		* AL 
		list brand gname manu fdc if fdc!=1 & gname==40 & a3==1
		bysort brand : ta fdc if gname==40 & a3==1
		/*
	$$$ add results 


*/
	
		
		*Check SP

		**Co-arinate by DAFRA is NOT FDC
		list brand gname manu if (regexm(brand,"COARINATE") | regexm(brand,"CO-ARINATE") ) & !regexm(brand,"FDC")
		/*
	$$$ add results 


*/
	
		replace fdc=0 if (regexm(brand,"COARINATE") | regexm(brand,"CO-ARINATE") ) & !regexm(brand,"FDC")
		*Check arsucam
		list brand gname manu pic_front fdc if regexm(brand,"ARSUCAM")
		/*
	$$$ add results 


*/
	
		replace fdc=0 if regexm(brand,"ARSUCAM")
		*Check amonate
		/*
	$$$ add results 


*/
	
		list brand gname manu if regexm(brand,"AMONATE")
		*Check suppositories 
		ta gname if a3==2 // no act supositories

		*Check tablets
		bysort gname: ta brand if fdc==. & a3==1
		/*
	$$$ add results 


*/
	
	  *Investigate combination therapy suppositories that are coded non-FDC status.
		list amauditkey brand gname a3 ai?_ing size packtype if fdc! = 1 & ///
		  inlist(gname,2,3,5,6,7,12,16,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58) & ///
		  a3 == 2
		  /*
	$$$ add results 


*/
		  recode fdc(.=1) if a3==2 & inlist(gname,2,3,5,6,7,12,16,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58)

	  *Investigate combination therapy granules that are coded non-FDC status.

	list amauditkey brand gname a3 ai?_ing size packtype if fdc! = 1 & ///
		  inlist(gname,2,3,5,6,7,12,16,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58) & ///
		  a3 == 3
			  /*
	$$$ add results 


*/  
		  recode fdc(.=1) if a3==3 & inlist(gname,2,3,5,6,7,12,16,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58)

	  *Investigate cases of SP and AL that are coded non-FDC status.
		list amauditkey brand gname a3 ai?_ing size packtype pic_front if fdc! = 1 & ///
		  inlist(gname,21,40) & a3<4 
		    /*
	$$$ add results 


*/  
		  
		 

	  *Check FDC status for all remaining products.
		tab brand if fdc == 0, m
		tab brand if fdc == 1, m
		
		  /*
	$$$ add results 


*/  
		
		**recoding FDC missing
		recode (-99 -98 -98 = .) 

	*Final FDC check: 	
		ta a3 fdc , m
		bysort a3_category ainum : ta gname fdc , m
		

	
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	*END OF QUESTIONNAIRE SECTIONS 
	
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	
	
	
	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# 1.2.2.25: IDENTIFY MANUAL PRODUCTS MATCHED TO MASTERLIST AND ADD AMCODE FROM MASTERLIST	
**
* THIS SECTION ENSURES THAT MANUALY ENTERED PRODUCTS THAT WERE EITHER ALWAYS IN THE
*DATABASE AND JUST MISSED BY FIELDWOKERS, OR WERE ADDED DURING FIELDWORK
*ARE ASSIGNED THE CORRECT DATABASE PRODUCT ID

**it does this by ensuring that the same products get assigned the same amcode
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*CREATE VARS THAT CAN BE MATCHED BETWEEN DATA COLLECTION DATABASE AND MAIN PRODUCT DATABASE
	
		gen a3_tag=string(a3)
		
		gen summary= a3_tag + "-" + string(gname) + "-" + brand + "-" + manu + ///
						string(ai1_mg) + "/"+ string(ai1_ml) + "-" + ///
						string(ai2_mg) + "/"+ string(ai2_ml) + "-" + ///
						string(ai3_mg) + "/" +string(ai3_ml)
		sort summary
		egen temp_product_code = group(summary)
		bysort temp_product_code : ta  fillmeth 
		
       save "${datadir}/cleaning/AwL_${country}_${year}-amaudit_clean.dta", replace
	   
	*export list of amcode and product_code to a separate file with 1 instance of each amcode
		drop if amcode=="" 
		keep (amcode temp_product_code summary)
		sort amcode temp_product_code 

duplicates drop amcode temp_product_code , force
     
			
			ta temp_product_code, sort //should only have freq of 1
			ta amcode, sort // should only have freq of 1 
			
			rename amcode amcode_new
			lab var amcode_new "amcode copied for db merge"
			
		save "${datadir}/lists/product_codes.dta", replace
	
		use "${datadir}/cleaning/AwL_${country}_${year}-amaudit_clean.dta", replace
		
		cap drop _merge
		
		merge m:1 temp_product_code using  "${datadir}/lists/product_codes.dta"
		
		/* add results here:
   

*/
		
		drop temp_product_code 
		
		sort _merge
		compare amcode amcode_new if fillmethod==1
		
		gen databasematch=1 if _merge!=1
		
		ta fillmethod databasematch, m row
		
		/*add results here, fix known errors

*/ 


	save "${datadir}/cleaning/AwL_${country}_${year}-amaudit_clean.dta", replace

	
	
**********************************************************************************	
**#  1.2.3 MERGE QAACT AND NATAPP                          *
********************************************************************************
	/*
	If the antimalarial master list was updated or any changes were made during data
	collection, merge the database to the product data and replace information
	*/
		
*MERGE AM DATABASE

	use "${datadir}/cleaning/AwL_${country}_${year}-amaudit_clean.dta", clear
	
	cap drop _merge
	
	merge m:1 amcode keepusing (amcode qaact_MASTERLIST natapp_MASTERLIST) "${datadir}/lists/am-masterlist.dta"
	/*
	$$$ add results and make changes based on careful review (of images/the same products) if needed:


*/
	
	
	
**# 1.2.3.1: GENERATE A VARIABLE TO IDENTIFY WHICH AUDITED PRODUCTS ARE WHO PRE-QUALIFIED (QAACT)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Generate the QAACT variable.
*This requires a list of WHO pre-qualified products. The ACTwatch Lite Masterlist of antimalarials includes approved antimalarials before 01 july 2024.
* THIS WILL NEED TO BE UPDATED TO REFLECT RECENT CHANGES. CHECK THE WHO/Global Fund WEBSITES FOR THE MOST RECENT LIST
		gen qaact = 0 
		lab var qaact "WHO pre-qualified ACT (YEAR)"
		lab val qaact yesno
		
		*recode for database products 
		*the masterlist includes a column where all produts from who pre-qual list are identified. THIS NEEDS TO BE UPDATED TO REFLECT RECENT CHANGES. CHECK THE WHO WEBSITE FOR THE MOST RECENT LIST 
		*https://extranet.who.int/prequal/medicines
		*Note this list contains some pre-qualified antimalarials that are not ACTs (e.g. SP) here we only want antimalarials so sytax only recodes for set generic names below.
		recode qaact 0=1 if qaact_MASTERLIST==1 & (gname==40 | gname==42 | gname==47 | gname==49 | gname==55 ///
		| gname==44 | gname==50 | gname==56 | gname==61 ) 
	
*NOTE THAT IF ADDITIONAL PRODUCTS ARE IDENTIFIED TO BE WHO PQ DURING FIELDWORK BUT NOT 
* MARKED AS SUCH IN THE DATABASE, ADD CODE HERE TO RECODE THEM TO QAACT==1		

	
		
**# 1.2.3.2 *GENERATE A VARIABLE TO IDENTIFY WHICH AUDITED PRODUCTS ARE NATIONALLY APPROVED (NATAPP)
* This will require a list of nationally approved antimalarials from the appropriate  regulatory body
* For example, in Nigeria, this was obtained through NAFDAC 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Generate the NATAPP variable.
		gen natapp = 0 
		lab var natapp "ACT on nationally approved drug list (YEAR)"
		lab val natapp yesno
		
	*recode for searched products 
		*ideally, the nationally approved antimalarials for this country should be added to the ACTwatch Masterlist of antimalarials. There should be a column added in that dataset that indicates which are nationally approved for this country
		*recode the natapp variable using this datapoint from the masterlist
		recode natapp 0=1 if natapp_MASTERLIST=1 
	

	*recode for manually entered products
*NOTE THAT IF ADDITIONAL PRODUCTS ARE IDENTIFIED TO BE NATONALLY APPROVED DURING FIELDWORK BUT NOT 
* MARKED AS SUCH IN THE DATABASE, ADD CODE HERE TO RECODE THEM TO NATAPP==1
	
	
	
	
*ANTIMALARIAL TRUE - GENERATE
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*
  Generate a variable that indicates if the antimalarial audited was deemed
    valid. This step is required for search and manual fill antimalarials. */
  gen am_true = 0
    recode am_true (0 = 1) if gname > 0 & gname < 62
    lab var am_true "audited antimalarial is true antimalarial?"
			
	ta am_true if hasamaudit==1
	list outletid amauditkey  if am_true==0 & hasamaudit==1
	/*
	$$$ REVIEW AND DROP INCONSISTENT ANTIMALARIALS


*/
	
	
**** removing AMs that are true duplicates (and therefore have no outletid, as 
*identified in the outlet data prep, where 166 ams (from 1 fieldworker) were assoc
*with duplicate form submissions

drop if parent_key==""
drop if amauditkey==""


*creating a new version of the sumstrength variable post-cleaning for further use:
	rename sumstrength sumstrength_orig
	
			egen sumstrength = rsum(ai1_mg ai2_mg ai3_mg)
				lab var sumstrength "sum of mg strengths"
				order sumstrength, after(ai3_ml)
			ta sumstrength,m
			
*renaming unique outlet identifier to match the outlet form:			
	
	rename parent_key key
	




*SAVE CLEAN DATASET
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
save "${datadir}/cleaning/AwL_${country}_${year}-amaudit_clean.dta", replace

	count //add number of observations; confirm it matches the original number, or
	*that there is justification for deletion (duplicate cases, not a real antimalarial, etc) 
	*document reasons here:
	
	
	
		
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
		
			
