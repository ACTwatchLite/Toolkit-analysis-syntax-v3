

/*******************************************************************************
	ACTwatch LITE 
	Step 3.1 Set local definitions for diagnostic info
	
********************************************************************************/
/*
Defines all analysis macros used for ACTwatch Lite analysis diagnostic indicators 

The user must customized each before running analysis.

*/


/*The following flags are used throughout the syntax.
  $$$ = Breaks the do-file to remind analyst to modify syntax.
  /* EXAMPLE: */ = Sample syntax from pilot studies for reference
  
Please inital all comments/ responses and make note of changes.  
*/

	
	

/*******************************************************************************
********************************************************************************
********************************************************************************

							*** IMPORTANT ***

*THIS FILE DEFINES ALL THE ANALYSIS FOR ACTWATCH LITE DIAGNOSTICS RESULTS
							
***THIS LOCAL_DEFINITIONS DO-HEADER FILE (.DOH) IS WHERE ALL MACROS ARE DEFINED 
*FOR THE DIAGNOSTICS ANALYSIS

*IT IS ESSENTIAL THAT THE ANALYST REVIEWS AND MODIFIES THIS FILE TO MATCH THE 
*STUDY CHARACTERISTICS, INCLUDING OUTLET TYPES, STUDY STRATA, AND KEY VARIABLES
*FOR ANALYSIS. 

*WE HAVE PROVIDED EXAMPLES FOR EACH PART, WITH EXPLANATIONS BUT THIS FILE SHOULD
*BE CAREFULLY REVIEWED AND REVISED AS NEEDED.

*IN EACH ANALYSIS DO FILE THAT IS RUN, THIS DO HEADER FILE IS CALLED AT THE START
*WITH THE COMMAND "include" 

********************************************************************************

*USING THIS FILE MEANS THAT NO CHANGES SHOULD BE NEEDED TO THE ANALYSIS FILES 
**** EXCEPT **** 
THE CHOICE OF WHICH TABLES TO PRODUCE, I.E.:

	I. National level results - i.e. across the whole geographic reach for which the study was designed
	II. National level results disaggregated by urban/ rural - i.e. if your study is stratified by urban/rural, the II results show that disaggregation
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
	IV. Results by strata dissagregated by urban/ rural - i.e. other geographical stratification (eg. region/ state) and urban/rural

...WHICH CAN BE COMMENTED OUT USING: /*  */ AS NEEDED

*******************************************************************************/

*0.1 SET UP FOR DIAGNOSTICS

*GENERATING SOME VARIABLES THAT NEED TO BE CONSISTENT IN THE COMBINED AM AND RDT DATASETS
cap  gen total=1 if rdt_true==1 |  vf_micro==1
cap gen microscopy=1 if vf_micro==1

**ensuring RDTs included in denominator for combined am/rdt results tables
	cap drop countprod
	gen countprod=1 if anyAM==1
	recode countprod (.=1) if rdt_true==1

***
*1.1 STUDY STRATA [REQUIRED FOR III AND IV TABLES] 

*list the study strata variables 
*(should be variables value = 1 if case located in that stratum or otherwise =. (missing), named for each stratum) in the line below the ds below
	
	gen strata1=1 if strata==11
	gen strata2=1 if strata==22
	gen strata3=1 if strata==33
	
	*EXAMPLE: 
	ds ///
strata1 strata2 strata3
	local stratumlist= r(varlist)
	
	tab1 `stratumlist',m 	
	/*
	ds ///
[add study strata variables here]
	local stratumlist= r(varlist)
	
	tab1 `stratumlist',m 				// confirm that values are only either 1 or . [missing] and are mutually exclusive
	*/
	
*******************************************************************************
	
*1.2 RURAL/URBAN [REQUIRED FOR II AND IV TABLES] 

*list the rural/ urban definition variables 
*(should be variables value = 1 if case located in that stratum or otherwise =. (missing)) in the line below the ds below
	
	*EXAMPLE: 
		ds ///
Ru1 Ru2
		local rural = r(varlist) 
/*

	ds ///
[add Rural/ urban vars here]
		local rural = r(varlist) 
*/	
*******************************************************************************


*2 OUTLET TYPE LISTS FOR ANALYSIS
* these lists should be updated to include the outlet types visited in your study
*******************************************************************************

*2.1 ALL OUTLET VARIABLES INCLUDING WHOLESALE AND TOTALS [USED FOR TABLES WHERE FULL
* MARKET DATA PRESENTED]
*### add in the list of outlet variables after the "ds" for all outlets. Note 
*that the local macro name is unique to each set of outlet variables

	*EXAMPLE: 
			ds ///
pnp pfp pop lab drs inf tot wls
			local outvars1 = r(varlist)
/*

			ds ///
[include list of outlet binary variables here]
			local outvars1 = r(varlist)
*/	
	
*******************************************************************************/
	
*2.2 OUTLET VARIABLES EXCLUDING WHOLESALE [USED FOR TABLES WHERE RETAIL ONLY REPORTED]
		*EXAMPLE: 	
			ds ///
pnp pfp pop lab drs inf tot
			local outvars2 = r(varlist)
		/*
		
		ds ///
[include list of outlet binary variables here]
			local outvars2 = r(varlist)
		
*/
********************************************************************************/
		
*2.3 OUTLET VARIABLES FOR MARKET COMPOSITION ANALYSIS (IE. EXCLUDING TOTALS AND NO WHOLESALE, JUST ACTUAL OUTLET TYPES)
		*EXAMPLE: 
			ds ///
pnp pfp pop lab drs inf 
			local outvars3 = r(varlist)
/*

		ds ///
[include list of outlet binary variables here]
			local outvars3 = r(varlist)
	*/
	
*******************************************************************************/
	
*2.4 OUTLET VARIABLES FOR MARKET SHARE ANALYSIS (IE. EXCLUDING WHOLESALE, AND WITH THE "TOTAL" LISTED FIRST)
		*EXAMPLE: 
			ds ///
tot pnp pfp pop lab drs inf 
			local outvars4 = r(varlist)
/*

		ds ///
[include list of outlet binary variables here]
			local outvars4 = r(varlist)
*/			
*******************************************************************************/
	
*3.1b DIAGNOSTIC STOCKING VARIABLES
* (Outlet-level binary variables that denote whether a 
*particular product is in stock - used for availabilty indicators)
* these all have the st_ prefix

* EXAMPLE:
		ds ///
st_test st_micro st_rdt  st_qardt // testing
			local testvars = r(varlist)
/*

		ds ///
[add in list of variables here]
			local testvars = r(varlist)
	*/		
*******************************************************************************/
				
*3.5 VOLUME VARIABLES FOR DIAGNOSTIC MARKET SHARE
*(binary variables for antimalarial products for which the 
*sales volumes will be estimated. 
* the list should have an indicator for all diagnostics (total in the example below) 
* first in the list

* EXAMPLE: 
			ds ///
 total microscopy /// overall diagnostics and microscopy
 rdt_true qardt rdtmanu_1 rdtmanu_2 rdtmanu_3  rdtmanu_oth rdtmanu_dk // rdt categories
			local dvol_cov = r(varlist)		
			/*
	ds ///
 [add in the list of variables here]
			local dvol_cov = r(varlist)				
			*/
*******************************************************************************/
			
*3.6 RDT VARIABLES
*used for volumes and price, include an overall rdt variable first, followed by PQ/QARDT
* different manufacturers, etc
 * EXAMPLE: 
			ds ///
 rdt_true qardt rdtmanu_1 rdtmanu_2 rdtmanu_3 // microscopy binary variable
			local rdtvars = r(varlist)					
/*

ds ///
 [add in the list of variables here]
			local rdtvars = r(varlist)		
*/
*******************************************************************************/

*3.6 MICROSCOPY VARIABLE
*used for volumes and price, include the overall (product-level) microscopy variable
 * EXAMPLE: 
			ds ///
microscopy // microscopy binary variable
			local microvars = r(varlist)		
			/*
		ds ///
 [add in the list of variables here]
			local microvars = r(varlist)			
			
	
*******************************************************************************/
*ENDS
