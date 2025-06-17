

/*******************************************************************************
	ACTwatch LITE 
	Step 2.4 Generate outlet type category variables 
	
********************************************************************************/
/*
This .do file generates outlet type variables used for disaggregating results by outlet category. It classifies outlets into standardized groups such as pharmacies, private facilities, general retailers, and wholesalers, and creates binary indicators for each. 

$$$ REVIEW AND EDIT OUTLET CATEGORIES TO FIT THIS IMPLEMENTATION 

These variables are used throughout the analysis to produce stratified results.
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
**# 2.4 Generate outlet type category variables 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


gen outcat2=3 if c7==1 & c7_profit==1
replace outcat2=4 if c7==1 & (c7_profit==0 | c7_profit==98)
replace outcat2=5 if c7==11
replace outcat2=6 if c7==20
replace outcat2=7 if c7==22 | c7==25 | c7==26
replace outcat2=11 if c7==30 | c7==31 | c7==32
replace outcat2=20 if c7==3


label var outcat2 "Type of outlet recoded"
label define outcat2lbl	3 "Private not-for-profit facility" 4 "Private for-profit facility" 5 "Pharmacy (CP)" 6 "Drug store" 7 "Informal: gen. store/street/home"  11 "Wholesaler/importer/distributer" 20 "Laboratory" , replace
label values outcat2 outcat2lbl
tab outcat2,mi

tab c7 outcat2 if nOut==1, m


	$$$ the outlet types should be edited to match the context as needed. Any changes made to
	the types must be reflected in the analysis syntax files.


		*FACILITIES
			gen pnp=1 if outcat2==3				//private not for profit 
			gen pfp=1 if outcat2==4				//private for profit 

		*PHARMACIES 
			gen pop=1 if outcat2==5 			// pharmacies
			gen ppm=1 if outcat2==6  			// ppmvs (Nigeria) 
		*	gen drs=1 if outcat2==6  			// drug stores

		*INFORMAL
			gen ger=1 if outcat2==7				// general retailers

		*LABORATORY
			gen lab=1 if outcat2==20 			// laboratories

		*WHOLESALE
			gen wls=1 if outcat2==11			// wholesalers

		*TOTALS
			gen prt=1 if inrange(outcat2,4,8) 
			gen for=1 if pnp==1 | pfp==1 | pop ==1 | lab==1
			rename inf informal
			gen inf=1 if ger==1  | itv==1
			ta inf informal

		gen tot=1 if inlist(outcat2,3,4,5,6,7,8,9,20) 

		*Adding labels
			lab var pnp "Private Not For-Profit Facility"
			lab var pfp "Private For-Profit Facility"
			lab var pop "Pharmacy"
			lab var ppm "PPMV"
			lab var drs "Drug store"
			lab var for "Private Formal TOTAL"
			lab var ger "General Retailer" 
			lab var lab "Laboratory"
			lab var itv "Itinerant drug vendor"
			lab var prt "Private total"
			lab var inf "Informal TOTAL"
			lab var tot "Retail TOTAL"
			lab var wls "Wholesale"	
	
	
	
	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
