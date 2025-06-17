
the file pathways need to be updated once we finalize SP names


/*******************************************************************************
	ACTWATCH LITE 
	MASTER .DO FILE 
********************************************************************************/
/*The purpose of this .do file is to set up the ACTwatch analysis for this country/ implemetnation and then run all subsequent .do files to prep, clean, and manage market survey data then output tables
*/
  
/*The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  
*/
  
 /*
 	NOTE ALL .DO FILES CALLED HERE REQUIRE MANUAL INPUTS OR EDITS BEFORE FINALIZING.	
	WITHIN EACH .DO FILE CALLED HERE, REVIEW LINES OF SYNTAX MARKED WITH "$$$". 
	MANAGE/CLEAN DATA ACCORDINGLY. 
	ONCE ALL $$$ ARE ADDRESSED IN ALL .DO FILES -> 
	THIS MASTERFILE CAN BE USED TO RUN DATA CLEANING, MANAGEMENT, THEN PRODUCE OUTPUT TABLES.
	
STEPS: 
SECTION A - Basic set-up
	*INITIALIZE STATA
	**INITIATE FORM-SPECIFIC PARAMETERS 
	*SET USER AND FILEPATHWAYS 

SECITON B - Execute .do files 
	*0  SET UP
	*1	CLEANING
	*2	MANAGEMENT 
	*3 	ESULTS 

See the data analysis guidelines for a more detailed description and instructions for specific steps 

*/



********************************************************************************
**********************      SECTION A      *************************************

*INITIALIZE STATA
	*clear memory 
		clear all
	*set Stata version to 14 if needed for compatibility
		*version 14
	*set output width to 250 characters.
		set linesize 250
	*set "more" prompt off.
		set more off
		

	
*INITIATE FORM-SPECIFIC PARAMETERS 
*******************************************************************************	
$$ Set specific global parameters for this study. Ensure that the [country] and [year] for your study are included below:

	/* EXAMPLE:
	global country NGA
	global year 2024
	*/
	
	global country [insert 3 letter abbrevation for country here]
	global year [insert year of study here]
	

*SET USER AND FILEPATHWAYS 
*******************************************************************************	
$$ Set the folder location for each analyst (user) so that all later do files can run using the same syntax. The folder locations need to match those for each user's folders. 
* It is recommended that shared folders (Onedrive, or similar) are used for all data and analysis files. 


/*EXAMPLE FOR STEP 0.3: 
Lets say that today Sara wants to use the .do files. They should remove the '*' 
from before their user number below (1 in this example) and run the subsequent
syntax to set the directory for her computer. 
*/

/**** USER NUMBERS: 1 = [Sara] ; 2 = [Jim]; 3 = [Jo]
	global user 1 //Sara
	*global user 2 //Jim
	*global user 3 //Jo
	
  if $user ==1 {
		//change the stata directory to set the main analysis directory for user1 here: 	
		cd "C:\Users\SARA\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkitl\12 Analysis syntax"
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "C:\Users\SARA\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkit"
		
		
		display "***** User set to user1: SARA *****"
				}
				
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
		
	else if $user ==2 {
			//change the stata directory to set the main analysis directory for user1 here: 	
		cd "C:\Users\JIM\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkitl\12 Analysis syntax"
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "C:\Users\JIM\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkit"
		
		
		display "***** User set to user2: JIM *****"
				}
			
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							
	else if $user ==3 {
		//change the stata directory to set the main analysis directory for user1 here: 	
		cd "C:\Users\JO\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkitl\12 Analysis syntax"
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "C:\Users\JO\Population Services International\ACTwatch Lite - Documents\ACTwatch Lite Toolkit"
		
		
		display "***** User set to user3: JO *****"
				}
				
				
				*/
	
	
	
$$$ Edit the syntax for each user/ analyst for this study

**** USER NUMBERS: 1 = [user 1 name] ; 2 = [user 2 name]; 3 = [user 3 name]; etc.
	*global user 1 //user1 name
	*global user 2 //user2 name
	*global user 3 //user3 name
*!!! note that you can add any number of users to this syntax. ensure that for each user, an additional "else if" loop is created below
	
	*for each user you will need to add a file path for the "cd" command, and for the "global projdir" commands below. Once you have done this,
	*no further changes should need to be made to filepaths in the syntax files.
	
	
  if $user ==1 {
		//change the stata directory to set the main analysis directory for user1 here: 
		cd "[insert the main analysis directory for user1 here]" 
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "[insert the main project directory location here]" 
		
		display "***** User set to [user1 name] *****"
				}
				
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
			else if $user ==2 {
		//change the stata directory to set the main analysis directory for user1 here: 
		cd "[insert the main analysis directory for user1 here]" 
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "[insert the main project directory location here]" 
		
		display "***** User set to [user2 name] *****"
				}
			
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							
			else if $user ==3 {
			
		//change the stata directory to set the main analysis directory for user1 here: 
		cd "[insert the main analysis directory for user1 here]" 
		
		
		//create a global macro to identify the main project directory location here 
		global projdir "[insert the main project directory location here]" 
		
		
		display "***** User set to [user3 name] *****"
				}

				
				
				
			
				
********************************************************************************
**********************      SECTION B      *************************************


$$$ The syntax below can be used to run all other .do files for the data cleaning and analysis required for assessment of the core indicators for ACTwatch Lite included in the toolkit. 
*Each .do file requires review and manual inputs/ edits where indicated (with "$$$")
		
	*/		
		

**#	STEP 0	SET UP
*******************************************************************************
/*The purpose of these .do files are to perform additional set up for the ACTwatch Lite analysis including setting macros, running programs, and creating .dta files of product lists
*/

	*0.1 macros
		
		clear 
		do "${projdir}/12 Analysis syntax/0_SETUP/0.1_MACROS.do"  
		
	*0.2 programs
		
		clear
		do "${projdir}/12 Analysis syntax/0_SETUP/0.2_PROGRAMS.do"  
	
	*0.3 product lists 
		//creates .dta files for the product lists used along side the quantitative ODK form
		* this do file should not require edits 
		* this do file only needs to be run once
		clear 
		do "${projdir}/12 Analysis syntax/0_SETUP/0.3_PRODUCTLISTS.do"  		
		
		
	
 
**# STEP 1	CLEANING
*******************************************************************************
* These .do files prepare raw data, converting .csv to .dta, adding variable labels, cheking unique identifiers, appending and merging data. 
	  

	*1.1 outlet data
		//prepares and cleans outlet level data 
		* requires manual cleaning of each variable 
		clear
		do "${projdir}/12 Analysis syntax/1_CLEANING/1.1_CLEANING-OUTLET.do"  	
					
	*1.2 antimalarial audits 
		//prepares and cleans antimalarial audit data 
		* requires manual review of data merges and cleaning of each variable 
		clear
		do "${projdir}/12 Analysis syntax/1_CLEANING/1.2_CLEANING-ANTIMALARIALS.do"  	
			
	*1.3 RDT audits 
		//prepares and cleans RDT audit data 
		* requires manual review of data merges and cleaning of each variable 
		clear
		do "${projdir}/12 Analysis syntax/1_CLEANING/1.3_CLEANING-RDT.do"  	

	*1.4 supplier data 
		//prepares and cleans reported supplier information  
		* requires manual review of data merges and cleaning of each variable 
		* if this implementation is using reported supplier information to inform data collection at higher levels of the supply chain, this cleaning should be done **during** data collection 
		clear
		do "${projdir}/12 Analysis syntax/1_CLEANING/1.4_CLEANING-SUPPLIER.do"  	




**# STEP 2	DATA MANAGEMENT
*******************************************************************************
* These .do files ....
*	  

		clear 
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.1_LONG-DATASET.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.2_WEIGHTS.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.3_DENOMINATORS.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.4_OUTLET-CATEGORIES.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.5_BLOODTEST-CATEGORIES.do"
			
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.6_ANTIMALARIAL-CATEGORIES.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.7_STOCKING.do"
			
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.8_AETD.do"
		
		clear 
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.9_MACROS_AND_PRICES.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.10_VOLUME.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.11_PROVIDER.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.12_FINALDATASETS.do"
		
		clear
		do "${projdir}/12 Analysis syntax/2_MANAGEMENT/2.13_SENSITIVITYANALYSIS.do"


	
	

	

	
	
**# STEP 3	RESULTS TABLES
*******************************************************************************
	
* SET VERSION # FOR TABLES OUTPUT
$$$ add table version for output below. default is v0
global tabver = "v0"


* RUN .DO FILES FOR ALL RELEVANT INDICATORS
/* 	Each .do file will export up to 4 tables in to an excel workbook: 
		i. National level results
		ii. National level results disaggregated by urban/ rural
		iii. Results by strata
		iv. Results by strata dissagregated by urban/ rural	
	
	Run .do files for all relevant indicators in your study. 
	
	
	Check data have accuratly exported to excel workbooks. 
	Within each workbook, tables are formatted and charts are automated. 
	These tables and charts should be inserted into the Report Template.
	
*/	


	*Tables Troubleshooting
/*
if syntax stops running, check the following:
1. Are all variables labeled?
2. Are all variable labels less than 30 characters long? - the Putexcel command will not run if >30 characters
3. Are outlet variables coded 1 or missing (no zeros)
4. Are all stocking (outlet-level) variables coded 1 or missing (no zeros)
5. Are all price and volume variables' missing values coded to . and not -9999 or similar?
*/
			
			
	*do "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"
	*do "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"
	*do "${resultsdir}/3.2_MODIFY_AND_RUN_TABLE_SYNTAX.do"
	*3.X 
		//Table .do files are numbered to match the corresponding indicator in the indicator table 
		*Run each relevant .do file for indicators assessed in this study
		*comment out .do files for indicators that have been removed.
	
	*0	Study design outputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
			*study eligibility flow diagram(s)
		do "${resultsdir}/3.3_FLOW-DIAGRAM.do"
	
	
	*1	Market Composition ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*1.1_Market Composition among antimalarial-stocking outlets
		do "${resultsdir}/tables_syntax/1.1_Market Composition among antimalarial-stocking outlets.do"
			
			*1.2_Market Composition among outlets with malaria blood-testing
		do "${resultsdir}/tables_syntax/1.2_Market Composition among outlets with malaria blood-testing.do"
	
	
	*2	Availability ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*2.1_Availability of antimalarial types in all screened outlets
		do "${resultsdir}/tables_syntax/2.1_Availability of antimalarial types in all screened outlets.do"
			*2.2_Availability of antimalarial types in all antimalarial-stocking outlets
		do "${resultsdir}/tables_syntax/2.2_Availability of antimalarial types in all antimalarial-stocking outlets.do"
			*2.3_Availability of tests among all screened outlets
		do "${resultsdir}/tables_syntax/2.3_Availability of tests among all screened outlets.do"
			*2.4_Availability of tests in all antimalarial-stocking outlets
		do "${resultsdir}/tables_syntax/2.4_Availability of tests in all antimalarial-stocking outlets.do"
	
	
	*3	Median sales volumes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*3.1_Median sales volume of antimalarial AETDs
		do "${resultsdir}/tables_syntax/3.1_Median sales volume of antimalarial AETDs.do"
			*3.2_Median sales volume of AETDs of outlets with any sales.
		do "${resultsdir}/tables_syntax/3.2_Median sales volume of AETDs of outlets with any sales.do"
			*3.3_Median sales volume of malaria blood tests
		do "${resultsdir}/tables_syntax/3.3_Median sales volume of malaria blood tests.do"
			*3.4_Median sales volume of tests of outlets with any sales
		do "${resultsdir}/tables_syntax/3.4_Median sales volume of tests of outlets with any sales.do"
	
	
	*4	Market Share~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*4.1_Market share of antimalarials
		do "${resultsdir}/tables_syntax/4.1_Market share of antimalarials.do"
			*4.2_Market share of malaria blood testing overall
		do "${resultsdir}/tables_syntax/4.2_Market share of malaria blood testing overall.do"
			*4.3_Market share of antimalarials by brand and manufacturer
		do "${resultsdir}/tables_syntax/4.3_Market share of antimalarials by brand and manufacturer.do"
	
	
	*5	Purchase Price ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*5.3aSales price of AETDs to customer - USD
		do "${resultsdir}/tables_syntax/5.1a_Sales price of AETDs to customer - USD.do"
			*5.3b_Sales price of AETDs to customer - Local currency
		do "${resultsdir}/tables_syntax/5.1b_Sales price of AETDs to customer - Local currency.do"
			*5.2aSales price of pre-packaged ACTs - USD
		do "${resultsdir}/tables_syntax/5.2a_Sales price of pre-packaged ACTs - USD.do"
			*5.2b_Sales price of pre-packaged ACTs - Local currency
		do "${resultsdir}/tables_syntax/5.2b_Sales price of pre-packaged ACTs - Local currency.do"
			*5.3a_Sales price of tests to customer - USD
		do "${resultsdir}/tables_syntax/5.3a_Sales price of tests to customer - USD.do"
			*5.3b_Sales price of tests to customer -local currency
		do "${resultsdir}/tables_syntax/5.3b_Sales price of tests to customer -local currency.do"
	
	
	*6	Wholesale prices~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*6.1b_Purchase price of AETDs - Local currency
		do "${resultsdir}/tables_syntax/6.1b_Purchase price of AETDs - Local currency.do"
			*6.2b_Purchase price of RDTs - Local currency
		do "${resultsdir}/tables_syntax/6.2b_Purchase price of RDTs - Local currency.do"
	
	
	*7	Stock outs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			*7.1&2_Stock outs of antimalarials and RDTs
		do "${resultsdir}/tables_syntax/7.1&2_Stock outs of antimalarials and RDTs.do"
	
	
	
	*AI 1-4 
	*ADDITIONAL INDICATOR TABLES
		
			*AI.1 product quality characteristics
		do "AI.1 product quality characteristics.do"
		
			*AI.2 product quality characteristics
		do "AI.2 outlet characteristics.do"
		
			*AI.3 product quality characteristics
		do "AI.3 provider characteristics.do"
		
			*AI.4 product quality characteristics
		do "AI.4 supplier characteristics.do"
		
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
