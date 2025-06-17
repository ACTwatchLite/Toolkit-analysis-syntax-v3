
/*******************************************************************************
	ACTwatch LITE 
	Step 2.2 APPLY SAMPLING WEIGHTS
	
********************************************************************************/
/*
This .do file applies sampling weights to the cleaned analytic dataset. It imports and merges the sampling weights file, generates strata and rural/urban variables, creates market share and all-outlet weight variables, and prepares booster and FPC variables if applicable. The output is a weighted dataset ready for analysis.
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
**# 2.2 APPLY SAMPLING WEIGHTS 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long.dta", clear



**# 2.3.X  Import sampling weights excel file and save it in stata format

import excel "[insert directory to use sampling weights excel file]", sheet("name") firstrow clear
save "[insert directory to use sampling weights excel file]", replace


			/* EXAMPLE:
				import excel "$projdir/7. Analysis/NGA sample weights/NGA_Sampling weights template v2.xlsx", sheet("Main cluster") firstrow clear
				rename main_wt1 main_wt
				rename type area
				save "${mngmtdata}/${country}_${year}_weights.dta", replace
			*/

*** Merge sampling weight dataset and antimalarial/RDT cleaned dataset

use "${mngmtdata}/${country}_${year}_[insert here antimalarial and RDT combined dataset]", clear
cap drop _merge
merge m:1 c4 using "${mngmtdata}/${country}_${year}_weights.dta"
order nOut main_wt area, after (c4)

*** Generate strata variables

cap drop strata
cap codebook strata
gen strata=.

$$$ update with code for PSUs within each stratum here:L				
recode strata (.=1) if inlist(c4, "[insert code of each cluster from strata 1]") // strata 1
/* EXAMPLE: 
recode strata (.=1) if inlist(c4, 101001,101002,101003,101004,102011,102012,103022,103035,104037,104038,105040,105042,105045,106047,106049,106050,106051,106053,107054,107055,108056,108057,108059,108061,108063,108064,109066,109067,110069,110071,110072,110074,111075,112076,112077,113079,113081,113082,113083,114084,114086,114087,115088,115089) // Abia
*/

recode strata (.=2) if inlist(c4, "[insert code of each cluster from strata 2]") // strata 2
recode strata (.=3) if inlist(c4, "[insert code of each cluster from strata 3]") // strata 3

lab def stratalbl 1 "strata1" 2 "strata2" 3 "strata3",replace
lab val strata stratalbl
ta strata, m
		

***Booster sample variable if applicable


				*Booster variable
					gen booster1= booster
					lab var booster1 "Outlet in booster sample"
					lab val booster1 lblyesno
					ta booster1
					recode booster1(.=0)
					
				*boosterT, boosterN, boosterY - booster dummy variables
				*!!!The following dummy variables are generated specifically for the detaile sample description table (Table X2).
					gen boosterT=1
					gen bootsterN=1 if booster==0
					gen bootsterY=1 if booster==1


 
*** Create a dummy variable for each strata in order to generate the table output. 
* There should be as many generation commands below a
* The stT dummy variable was created to indicate any outlet irrespective of strata status and necessary for the detailed sample description table (Table X2)

gen StT=1
gen St1=1 if strata==(1)
gen St2=1 if strata==(2)
gen St3=1 if strata==(3)

*Add labels for each strata
lab var St1 "Strata1"
lab var St2 "Strata2"
lab var St3 "Strata3"
				


*** RURAL/URBAN

codebook area

gen rural=1 if area=="rural"
recode rural(.=0) if area=="urban"
lab var rural "Rural area"

gen Ru1=1 if rural==1
lab var Ru1 "Rural"
gen Ru2=1 if rural==0
lab var Ru2 "Urban"			


***Generate Rural x strata variables

gen Sr1=1 if St1==1 & Ru1==1
lab var Sr1 "[insert name of stratum 1] Rural"
gen Sr2=1 if St1==1 & Ru2==1
lab var Sr1 "[insert name of stratum 1] Urban"

gen Sr3=1 if St1==2 & Ru1==1
lab var Sr1 "[insert name of stratum 2] Rural"
gen Sr4=1 if St1==2 & Ru2==1
lab var Sr1 "[insert name of stratum 2] Urban"
	
gen Sr5=1 if St1==3 & Ru1==1
lab var Sr1 "[insert name of stratum 3] Rural"
gen Sr6=1 if St1==3 & Ru2==1
lab var Sr1 "[insert name of stratum 3] Urban"			

 
***Create the market share weight variable (wt_marketShare).

		gen wt_marketShare=main_wt
		label var wt_marketShare "Sampling weight: Market share"			
					
$$$ Ensure outlets that were a part of the booster sample (if relevant) are assigned a zero weight for market share:
/* EXAMPLE: 

	replace wt_marketShare=0 if outletid=="1-101002-045511" | outletid=="1-101002-088580" | outletid=="1-101002-110642" | outletid=="1-101002-118143" | outletid=="1-101002-137679" | ///
		outletid=="1-101002-145736" | outletid=="1-101002-181221" | outletid=="1-101002-186853" | outletid=="1-101002-189100" | outletid=="1-101002-213861" | outletid=="1-101002-225154" | ///
		outletid=="1-101002-250856" | outletid=="1-101002-398300" | outletid=="1-101002-587158" | outletid=="1-101002-592688" | outletid=="1-101002-710950" | outletid=="1-101002-753922" | ///
		outletid=="1-101002-766957" | outletid=="1-101002-767768" | outletid=="1-101002-804943" | outletid=="1-101002-849138" | outletid=="1-101002-929908" | outletid=="1-101002-995577" | ///
		outletid=="1-101003-023393" | outletid=="1-101003-143035" | outletid=="1-101003-311198" | outletid=="1-101003-348168" | outletid=="1-101003-498839" | outletid=="1-101003-883904"

*/

***Create the weight for all other indicators. Only one level of boostering used.

gen wt_allOutlet=booster_wt /* EXAMPLE: if c2==11
replace wt_allOutlet=booster_wt if c2==10 & c7==11				
replace wt_allOutlet=1 if c7==12
*/

	
***Create the outlet weight variable (wt_allOutlet).	

replace wt_allOutlet=wt_marketShare if wt_allOutlet==.
label var wt_allOutlet "Sampling weight: Indicators excluding market share"
	
*** Checking outputs

ta wt_allOutlet,m
ta wt_marketShare,m
ta c7 if wt_allOutlet==. &nOut==1 ,m
ta c7 if wt_allOutlet==. &nOut==1 ,m
list outletid c2 c4 if wt_allOutlet==. &nOut==1 
	
*** Save the dataset
			
save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long.dta", replace
 
 
 
 
*Generate FPC variable (Finite population correction) 
		cap drop fpc
		gen fpc=.
	
	/* EXAMPLE:
	calculated by dividing the number of PSUs (eg. wards) sampled in a stratum (eg. State) 
	by the total number of PSUs in that stratum
	
	replace fpc=(45)/(249) if strata==1 // Stratum 1 name 
	replace fpc=(50)/(484) if strata==2 // Stratum 2 name 
	replace fpc=(30)/(377) if strata==3 // Stratum 3 name 
	*/
	$$$ add in fpc calculations as shown in example above
	
	
		lab var fpc "Finite Popn Correction for svyset"
		tab fpc strata, m

*Regenerate nOut to ensure variable not compromised during weighting.
		cap drop nOut
		bysort outletid: gen nOut=_n==1
		lab var nOut "Flags one entry for each outlet"


**Save dataset
save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace



	
	
	
	
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
