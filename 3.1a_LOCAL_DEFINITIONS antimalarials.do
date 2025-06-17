

/*******************************************************************************
	ACTwatch LITE 
	Step 3.1 Set local definitions
	
********************************************************************************/
/*
Defines all analysis macros used for ACTwatch Lite analysis, including study strata, outlet types, and key indicator variables. 

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

*THIS FILE DEFINES ALL THE ANALYSIS FOR ACTWATCH LITE
							
***THIS .DO IS WHERE ALL MACROS ARE DEFINED FOR THE ANALYSIS

*IT IS ESSENTIAL THAT THE ANALYST REVIEWS AND MODIFIES THIS FILE TO MATCH THE 
*STUDY CHARACTERISTICS, INCLUDING OUTLET TYPES, STUDY STRATA, AND KEY VARIABLES
*FOR ANALYSIS. 

*WE HAVE PROVIDED EXAMPLES FOR EACH PART, WITH EXPLANATIONS BUT THIS FILE SHOULD
*BE CAREFULLY REVIEWED AND REVISED AS NEEDED.

*IN EACH ANALYSIS DO FILE THAT IS RUN, THIS DO FILE IS CALLED AT THE START
*WITH THE COMMAND "include" 

********************************************************************************

*USING THIS FILE MEANS THAT NO CHANGES SHOULD BE NEEDED TO THE ANALYSIS FILES 
**** EXCEPT **** 
THE CHOICE OF WHICH TABLES TO PRODUCE, I.E.:

	I. National level results - i.e. across the whole geographic reach for which the study was designed
	II. National level results disaggregated by urban/ rural - i.e. if your study is stratified by urban/rural, the II results show that disaggregation
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
	IV. Results by strata dissagregated by urban/ rural - i.e. other geographical stratification (eg. region/ state) and urban/rural

...WHICH CAN BE COMMENTED OUT USING: /*  */ AS NEEDED IN SUBSEQUENT STEPS/ .DO FILES

*******************************************************************************/





**# 3.1.1 STUDY STRATA [REQUIRED FOR III AND IV TABLES] 
*******************************************************************************

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
	

	/*ds ///
$$$ [add study strata variables here e.g. strat1 strat2 strat3]
	local stratumlist= r(varlist)
	
	tab1 `stratumlist',m 	// confirm that values are only either 1 or . [missing] and are mutually exclusive
	*/
	

**# 3.1.2 RURAL/URBAN [REQUIRED FOR II AND IV TABLES] 
*******************************************************************************

*list the rural/ urban definition variables 
*(should be variables value = 1 if case located in that stratum or otherwise =. (missing)) in the line below the ds below
	
	*EXAMPLE: 
		ds ///
Ru1 Ru2
		local rural = r(varlist) 
/*

	ds ///
$$$ [add Rural/ urban vars here]
		local rural = r(varlist) 
*/	

**# 3.1.3 OUTLET TYPE LISTS FOR ANALYSIS
*******************************************************************************

* These lists should be updated to include the outlet types visited in your study

**********ALL OUTLET VARIABLES INCLUDING WHOLESALE AND TOTALS [USED FOR TABLES WHERE FULL MARKET DATA PRESENTED]

*### add in the list of outlet variables after the "ds" for all outlets. Note that the local macro name is unique to each set of outlet variables

*EXAMPLE: 
			ds ///
pnp pfp pop lab drs inf tot wls
			local outvars1 = r(varlist)
/*

			ds ///
$$$ [include list of outlet binary variables here]
			local outvars1 = r(varlist)
	
*/	
**********OUTLET VARIABLES EXCLUDING WHOLESALE [USED FOR TABLES WHERE RETAIL ONLY REPORTED]

*EXAMPLE: 	
			ds ///
pnp pfp pop lab drs inf tot
			local outvars2 = r(varlist)
		/*
		
		ds ///
$$$ [include list of outlet binary variables here]
			local outvars2 = r(varlist)
		*/

********** OUTLET VARIABLES FOR MARKET COMPOSITION ANALYSIS (IE. EXCLUDING TOTALS AND NO WHOLESALE, JUST ACTUAL OUTLET TYPES)

*EXAMPLE: 
			ds ///
pnp pfp pop lab drs inf 
			local outvars3 = r(varlist)
/*

		ds ///
[include list of outlet binary variables here]
			local outvars3 = r(varlist)
*/	
	
********** OUTLET VARIABLES FOR MARKET SHARE ANALYSIS (IE. EXCLUDING WHOLESALE, AND WITH THE "TOTAL" LISTED FIRST)

*EXAMPLE: 
			ds ///
tot pnp pfp pop lab drs inf 
			local outvars4 = r(varlist)
/*	

		ds ///
[include list of outlet binary variables here]
			local outvars4 = r(varlist)
*/
			
********** OUTLET VARIABLES FOR MANUFACTURER AND BRAND MARKET SHARE (I.E. ONLY TOTAL AND WHOLESALE TYPES)

*EXAMPLE: 
					ds tot wls
		local outvars6 = r(varlist)
/*		
		
		ds ///
[include list of outlet binary variables here]
			local outvars6 = r(varlist)

*/
	
**# 3.1.4 INDICATORS FOR ANALYSIS
*******************************************************************************/

**********  AM STOCKING VARIABLES
* (Outlet-level binary variables that denote whether a 
*particular product is in stock - used for availabilty indicators)
* these all have the st_ prefix

*** add in the list of am stocking vars after the "ds": 

	* EXAMPLE:
	ds ///
st_anyAM st_anyACT st_AL st_ASAQ st_APPQ st_DHAPPQ st_ARPPQ st_otherACT /// ACTs
st_natapp st_qaact   st_QA_all st_QA_WHO st_QA_NAT st_QA_none st_2act /// pq ACTs etc
st_nonart st_oralQN st_CQ st_SP st_SPAQ st_nonartoth /// non-art oral
st_oartmono st_noartmono /// mono oral
st_severe st_recAS st_injAS st_injAR st_injAE st_injQN // severe
			local covars = r(varlist)	
		/*
			ds ///
[add in list of variables here]
			local covars = r(varlist)	
*/

**********  PRICE VARIABLES 
*(binary variables for antimalarial products for which the prices
*will be estimated. These are usually the main types of antimalarials found in your
*study)
* EXAMPLE:
				ds ///
 anyAM  anyACT  AL  ASAQ APPQ  DHAPPQ  ARPPQ  otherACT /// ACTs
 natapp    qaact   QA_all  QA_WHO  QA_NAT  QA_none /// pq ACTs etc
 nonart  oralQN CQ  SP  SPAQ  nonartoth /// non-art oral
 oartmono  
			local pri_cov = r(varlist)	
		/*
			ds ///
[add in the list of variables here]
			local pri_cov = r(varlist)			
*/
********** VOLUME VARIABLES 
*(binary variables for antimalarial products for which the 
*sales volumes will be estimated. These are usually the main types of 
* antimalarials found in your study). 
*!!! They should be mutually exclusive 
		
* EXAMPLE: 
		ds ///
 anyAM /// total
 AL ASAQ APPQ DHAPPQ ARPPQ otherACT /// ACTs
 QN CQ SP SPAQ nonartoth /// non-art oral
 oartmono /// mono oral
 recAS injAS injAR injAE  // severe
			local vol_cov = r(varlist)	
		/*
			
			ds ///
 [add in the list of variables here]
			local vol_cov = r(varlist)
		*/
		
**********  VOLUME VARIABLES FOR PQ CATEGORIES 
*(binary variables for antimalarial products for which the 
*sales volumes will be estimated, but instead of active ingredients, the ACT types are by PQ/ no-PQ, nationally
* approved, etc. 
*!!! They should be mutually exclusive 
		
* EXAMPLE: 
			ds ///
 anyAM /// total
 QA_all QA_WHO QA_NAT QA_none /// ACTs
 QN CQ SP SPAQ nonartoth /// non-art oral
 oartmono /// mono oral
 recAS injAS injAR injAE  // severe
			local vol_cov2 = r(varlist)	
	/*
		
			ds ///
 [add in the list of variables here]
			local vol_cov2 = r(varlist)	

			*/
**********  PREPACKAGED ANTIMALARIALS
*binary variables for different PQ/QA and non-QA ACT types commonly found in your
*study - used to calculate prices
* EXAMPLE:
			ds ///
 qaal_1 qaal_2 qaal_3 qaal_4 /// pre-packaged prequalified AL
 nqaal_1 nqaal_2 nqaal_3 nqaal_4 // pre-packaged non-prequalified AL
			local pp_cov = r(varlist)	
	/*
			ds ///
 [add in the list of variables here]
			local pp_cov = r(varlist)
	*/

**********  STOCKOUTS
*outlet level binary  indicators of whether a product is stocked out. As these 
*specific product types are likely to vary by study, we have included automated 
*syntax here to include all stock-out variables collected:

gen so_any=1 if a16==1
lab var so_any "Outlet reports any stockout"
		ds ///
so_* //these are the stockout vars
		local oosvars = r(varlist)

********** BRANDS AND MANUFACTURERS FOR VOLUME CALCULATIONS (MARKET SHARE)
*product level variables for manufacturer-brand combinations (mb); manufacturers (manu);
* and brands (brand); automated. Uses variable created in data management that 
*indicate brands, manufacturers and brand-manufacturer combinations for which at least
*1000 AETDs were reported sold in the previous week. This threshold can be changed in the 
*data management syntax. 
		 

		ds anyAM mb_* 
		local mbcovars = r(varlist)	
			foreach x of varlist `mbcovars' {
				recode `x' (0 = .) 
		}
		
		ds anyAM man_* 
		local manuvars = r(varlist)	
			foreach x of varlist `manuvars' {
				recode `x' (0 = .) 
		}
		
		
		ds anyAM bra_* 
		local brandvars = r(varlist)	
			foreach x of varlist `brandvars' {
				recode `x' (0 = .) 
		}
		
		
**********  PRODUCT QUALITY VARIABLES
*antimalarial product level quality measures for X1 table:
*EXAMPLE: 
	ds ///
mas_code nafdac_code expired_pack
	local amqual = r(varlist)
/*
ds ///
 [add in the list of variables here]
			local amqual = r(varlist)
*/
			
			
**********  OUTLET CHARACTERISTICS
* full set of outlet characterisic variables can be added here. 

* EXAMPLE:
	ds ///
p0_1 p0_2 p0_3 /// opening hours
licence_any /// has a licence
reg6 /// has had a gov't inspection in past year
healthqual ///health qual
ppm_dx ppm_rx ppm_sx ppm_mx ppm_any /// malaria training
am_storage* rdt_storage* /// Antimalarial storage conditions
d1 d2 /// diagnostic preparedness
retonline /// online sales
online_2_1 online_2_2 online_2_3 /// how supply online customers
p32_1 p32_3 p32_4 p32_2 p32_5 /// customer types 
ind_0_1 ind_0_2 ind_0_3 ind_0_4 ind_0_5 ind_0_6 /// customer locations
dig0 dig1 dig2 dig2d_3 dig2d_1 dig2d_2 dig2d_4 dig3 dig5 /// availabilty of key resources
data1 data2_1 data2_2 data2_3 data2_96   dat_sl data4 // surveillance and reporting
	local outchar = r(varlist)
/*

ds ///
 [add in the list of variables here]
			local outchar = r(varlist)
*/
  
**********  SUPPLIER CHARACTERISTICS
*outlet level variables for the X4 table for AM/RDT supplier characteristics



* EXAMPLE: 
			ds ///
sa2_* /// types of am supplier
sa5_1 sa5_2 sa5_3 sa5_4 sa5_5 sa5_96 /// supplier payment means
sa6 /// buy drugs on credit
sa12 /// switch due to stock out
sa13_* /// price changes
sa14_1 sa14_2 sa14_3 sa14_4 sa14_5 // reasons for price change
			local suppvar = r(varlist)
/*
ds ///
 [add in the list of variables here]
			local suppvar = r(varlist)
			
			
			
	
