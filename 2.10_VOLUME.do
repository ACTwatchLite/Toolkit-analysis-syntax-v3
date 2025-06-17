

/*******************************************************************************
	ACTwatch LITE 
	Step 2.10 Generate volume variables 
	
********************************************************************************/
/*
This .do file generates volume and market share variables for antimalarials and diagnostics. It creates flags for outlets reporting sales and calculates product volumes standardized by AETD. These outputs are used to analyze market composition and sales volumes.
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
**# 2.10 VOLUME/ MARKET SHARE
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


*DIAGNOSTIC VOLUMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


**# *Manage diagnostic outliers.	
/* $$$ After the diagnostic sensitivity analysis is completed, you will need to return to this section to set volumes to missing or to recode volumes according to the 	 outcome of the sensitivity analysis. Make all edits to the microscopy volume (d3) and rdt volume (r13) variables. */

	 
**# Generate the volume flag variables and volume distributed variables.

*DIAGNOSTIC VOLUMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* !!!The volume flag variables (vf_*) are coded 1 for any outlet with volumes distributed and the volume distributed variables (vd_*) represent the volume distributed at the outlet. */

		
	*Microscopy

				gen vd_micro=d4 if !inlist(d4,-9555, -9777, -9888) 
				gen vf_micro=.
				recode vf_micro (.=1) if vd_micro>=0 & vd_micro!=.

	*RDT
				bysort outletid: egen vd_rdt_temp=total(r13) if productype==3 & !inlist(r13,-9555, -9777, -9888) 
				bysort outletid: egen vd_rdt=max(vd_rdt_temp)
				
				gen vf_rdt=.
				recode vf_rdt (.=1) if vd_rdt>=0 & vd_rdt!=.
				drop vd_rdt_temp
	

*ANTIMALARIAL VOLUMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* $$$In the syntax that follows, modify the if statements as appropriate so that the statements correctly restricts the calculations to valid sales volume and omits
	 inconsistent, refused, dont know and user-missing values.*/

*Generate the volume variable

			gen volume=.
			replace volume=amsold_pack*packageaetd if amsold_pack!=. & packageaetd!=. & !inlist(amsold_pack,-9555, -9777, -9888, 988 , 998, 9888 , 9988, 9997, 9998 ) 
			replace volume=(amsold_unit/size)*packageaetd if amsold_unit!=. & size!=. & packageaetd!=.  & !inlist(amsold_unit,-9555, -9777, -9888,988 , 998, 9888 ,9988, 9997, 9998 ) 
	
				lab var volume "AETDs sold in the past week"
				bysort c7: ta volume
				br gname c7 ai*_mg ai*_ml sold volume size  pic* packsize_master if volume>500 & volume!=.
	

**outlet level variable for median sales among outlets with any sales:
	gen anyAMsales=1 if volume!=. & volume!=0
	bysort outletid: egen st_anyAMsales=max(anyAMsales==1)
	

	
**# Volumes for Brand/Manufacturer market share analysis

*$$$
*this step identifies AM brands and manufacturers with overall sales volumes in
*the dataset exceeding a certain threshold, which are then used for market share
*analysis. In ACTwatch Lite Nigeria 2024, we set this threshold to 
*1000 AETDs reported sold in the previous week in total, but this should 
*be revised according to local conditions

*manufacturers with >1000 AETDs sold (unweighted)
		ta manu
		encode manu, gen(manu_num)
		ta manu_num
		
		bysort manu_num: egen manu_vol_tot=total(volume) if volume!=.
		ta manu_vol_tot,m
		tabulate manu_num if manu_vol_tot>1000 & manu_vol_tot!=.
		/* insert results here:
		
*/

*brands with >1000 AETDs sold (unweighted)		
		ta brand
		encode brand, gen(brand_num)
		
		bysort brand_num: egen brand_vol_tot=total(volume) if volume!=.
		ta brand_vol_tot,m
		tabulate brand_num if brand_vol_tot>1000 & brand_vol_tot!=.
		/* insert results here:
		
*/		

		numlabel brand_num manu_num, add
		bysort manu_num: ta brand_num
		
		bysort brand_num: ta manu_num
		
		ta manu_num if qaact==1
		ta manu if qaact==1

*combine brand and manu into a concatenated variable:
  numlabel brand_num manu_num, remove
  
  decode manu_num, gen(manu_temp)
  decode brand_num, gen(brand_temp)
  
  
  egen manu_brand = concat(manu_temp brand_temp), maxl(30) punct(; )
  
  **create excel output for review
  tabout manu_brand ///
  using "${tables}/manu_brand_tab.xls", cells(freq col) replace

*review
  bysort manu_num : ta qaact
  
  bysort manu : ta qaact
  
  numlabel manu_num, add

    ta manu_num if qaact==1
	/* insert results here:
		
*/		

	numlabel brand_num manu_num, remove

	*create the variables fro analysis, with one var per manufacturer/ brand (or manu-brand
	*combination) with sales exceeding 1000AETDs, and an "other" category for the remaining
	*brands/ manufacturers
	
		ta manu_num if manu_vol_tot>=1000 & manu_vol_tot!=.
		tabulate manu_num if manu_vol_tot>=1000 & manu_vol_tot!=., gen(man_)
		gen man_other =0
		
		recode man_other(0=1) if  manu_vol_tot<1000 & manu_vol_tot!=.
		lab var man_other "All other manufacturers"
		
		tabulate brand_num if brand_vol_tot>=1000 & brand_vol_tot!=., gen(bra_)
		ds bra_* 
		gen bra_other=0
		recode bra_other (0=1) if brand_vol_tot<1000 & brand_vol_tot!=.
		lab var bra_other "All other brands"
		
		gen man_tot =1 if manu_vol_tot!=.
		lab var man_tot "All manufacturers"
	
	
	***manu brand concatenated and "other"
	
	
  bysort manu_brand: egen manbra_tot=total(volume) if volume!=.
		ta manbra_tot,m
	tabulate manu_brand if manbra_tot>=1000 & manbra_tot!=., gen(mb_)
		ds mb_* 
		tab1 mb_*
		gen mb_other=0
		recode mb_other (0=1) if manbra_tot<1000 & manbra_tot!=.
		lab var mb_other "All other manu-brands"
		
		gen mb_tot =1 if manbra_tot!=.
		lab var mb_tot "All manu-brands"
	
*label the vars
	ds mb_* 
		foreach v of varlist `r(varlist)' {
		 local variable_label : variable label `v'
    local variable_label : subinstr local variable_label "manu_brand==" ""
    label variable `v' "`variable_label'"
}
	
		ds bra_* 
		foreach v of varlist `r(varlist)' {
		 local variable_label : variable label `v'
    local variable_label : subinstr local variable_label "brand_num==" ""
    label variable `v' "`variable_label'"
}

		ds man_* 
		foreach v of varlist `r(varlist)' {
		 local variable_label : variable label `v'
    local variable_label : subinstr local variable_label "manu_num==" ""
    label variable `v' "`variable_label'"
}
	desc bra_* man_* mb_*
		 

	

	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
