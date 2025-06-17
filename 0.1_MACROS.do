
/*******************************************************************************
	ACTwatch LITE 
	Step 0.1  SET MACROS/LOCATIONS FOR ALL STATA CLEANING AND ANALYSIS ACTIVITIES
	
********************************************************************************/
/*This section creates and sets macros for each sub-folder in the main analysis directory or project directory location. These folder names and macro names should not be modified as later do files use them to locate files. 

Run the .do file below to set most macros. These should not require input.

For the last macro, enter the file pathway for the location of your antimalarial and RDT masterlist .csv files used along side the ODK questionnaire as the searchable datasets for autopopulating information for known/ searched products. 

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
	
	
	
	
	
**# STEP 0.1 - SET MACROS
*******************************************************************************		
*These macros should not require editing

	*set macro for main analysis folder location
		global analydir "${projdir}/12 Analysis syntax"

	*create main folder for data within existing analysis location	
		capture  mkdir "${analydir}/data"
		
	*set macro for main data location
		global datadir "${analydir}/data"
		
	*create folder for raw data if this does not yet exist
		capture  mkdir "${datadir}/raw"
		
	*set macro for raw data location
		global rawdir "${datadir}/raw"
		
	*create folder for sensitivity analysis
		capture  mkdir "${analydir}/x_Senstivity analysis"
		
	*set macro for sensitivity analysis location
		global sensdir "${analydir}/x_Senstivity analysis"	
		
	*create folder for cleaning within existing analysis location	
		capture  mkdir "${datadir}/1_CLEANING"
		
	*set macro for location of cleaning files
		global cleandir "${datadir}/1_CLEANING"
			
	*create folder for stata logs within existing analysis location		
		capture  mkdir "${analydir}/logs"
		
	*set macro for location of logs
		global logs "${analydir}/logs"
		
	*create folder for data management files (part of analysis process)
		capture  mkdir "${datadir}/2_MANAGEMENT"
		
	*set macro for data management files	
		global mngmtdata "${datadir}/2_MANAGEMENT"
		
	*create folder for results output files (part of analysis process)
		capture  mkdir "${analydir}/3_RESULTS"
		
	*set macro for results files	
		global resultsdir "${analydir}/3_RESULTS"

	*create folder for tables output files (part of analysis process)
		*capture  mkdir "${projdir}/13 Results output"
		
	*set macro for tables output files	
		global tables "${projdir}/13 Results output/workbooks"
	
	
*this macro requires input 
	
	*set macro for location of product lists 
		/*EXAMPLE:
		global prodlistdir "${projdir}/Tools/Product lists"
		*/
			

	$$$ confirm the location of the product lists used along side the ODK data collection tool and update here: 
	
	global prodlistdir "${projdir}/[insert file path to location of product lists]"
	
	
	
	
	
	
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
