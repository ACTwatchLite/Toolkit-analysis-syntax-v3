
/*******************************************************************************
	ACTwatch LITE 
	Step 2.9  COMPLETE DOCUMENTATION & SET LOCAL MACROS FOR CPI AND EXCHANGE RATES
	
********************************************************************************/
/*
This section documents and sets macros required for price data analysis in USD or for trends over time. 
***If this implementation does not include conversion or trend analysis, this .do file may not need to be adapted and run***

The .do captures the data collection dates, years included in trend analysis, Consumer Price Index (CPI) values, and exchange rates for both the first survey year and the current survey year. These values are used to calculate cumulative inflation and convert prices to USD. Once this information is documented, the analyst manually sets macros (e.g., cpiFIRST, cpiCURRENT, exFIRST, exCURRENT, exDC) based on the study-specific values. These macros are referenced in downstream price analyses and must be completed before proceeding.
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
**# 2.9.1  DOCUMENT & SET MACROS   
*******************************************************************************

*$$$ COMPLETE THE FOLLOWING DOCUMENTATION 
 
/*!!!

**FOR STUDY DESIGNS NOT REQUIRING USD/ OVER TIME ANALYSIS, SKIP TO SECTION 2.1.2 BELOW

*** THE FOLLOWING SECTION IS REQUIRED FOR STUDIES THAT WISH TO: 
	1) PRESENT PRICE DATA IN USD AS WELL AS LOCAL CURRENCY 
	and/ or
	2) CONDUCT PRICE COMPARISONS OVER TIME USING PREVIOUS ACTWATCH/ ACTWATCH LITE DATA



	All of the following documentation is required so that CPIs (consumer price
	indices - for inflation) and exchange rates can be replicated. 
	
	The CPI should be documented for the year of the first survey included in the 
	trend analysis and also for the year of the current survey. The average annual 
	exchange rate should be documented for the year of the first survey included 
	in the trend analysis and also for the year of the current survey. The 
	average exchange rate for the period of data collection should also be documented.
	If you are unsure which years will be used in the trend analysis then then contact the RM.

*SURVEY CHARACTERISTICS
	*Data collection start date: (#START DATE)
	*Data collection end date: (#END DATE)
	*Years included in trend analysis:  (YEAR #S)

*CPI (CONSUMER PRICES INDEX)
	SOURCE:  
	
	SUMMARY:
	(#YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS): 
	(#CPIS FOR EACH YEAR FROM FIRST SURVEY TO CURRENT YEAR):
	(#YEAR OF CURRENT SURVEY): 
	(#CPI FOR YEAR OF CURRENT SURVEY):
	 
*EXCHANGE RATE (USD-LOCAL CURRENCY)
	SOURCE: 
	
	SUMMARY:
	(#YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS): 
	(#EXCHANGE RATE FOR YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS):
	(#YEAR OF CURRENT SURVEY): 
	(#EXCHANGE RATE FOR YEAR OF CURRENT SURVVEY):
	(#EXCHANGE RATE FOR DATA COLLECTION PERIOD): 

*/	

**Calculate nb cpiFIRST using the below %'s as follows:
	
/*	###WORKED EXAMPLE BELOW:

*SURVEY CHARACTERISTICS
	*Data collection start date: 01/05/2025
	*Data collection end date: 07/06/2025
	*Years included in trend analysis: 2023 AND 2025 (CURRENT STUDY YEAR)

*CPI (CONSUMER PRICES INDEX)
	SOURCE:  https://data.worldbank.org/indicator/FP.CPI.TOTL.ZG
	
	SUMMARY:
	(#YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS): 2023
	(#CPIS FOR EACH YEAR FROM FIRST SURVEY TO CURRENT YEAR): 1.181 (2023), 1.001 (2024)
	(#YEAR OF CURRENT SURVEY): 2025
	(#CPI FOR YEAR OF CURRENT SURVEY): 0.997
	 
*EXCHANGE RATE (USD-LOCAL CURRENCY)
	SOURCE: https://www.xe.com/currencytables/?from=XAF
	
	SUMMARY:
	(#YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS): 2023
	(#EXCHANGE RATE FOR YEAR OF FIRST SURVEY INCLUDED IN TREND ANALYSIS): 610.12
	(#YEAR OF CURRENT SURVEY): 2025
	(#EXCHANGE RATE FOR YEAR OF CURRENT SURVEY): 574.02
	(#EXCHANGE RATE FOR DATA COLLECTION PERIOD): 582.19
*/


*$$$ calculate the cumulative inflation rate for the period (= the product of each year's CPI):

  /* EXAMPLE: 
	display 1.181 * 1.001 * 0.997
	*/
	
	
$$$ SET LOCAL MACROS BASED ON SURVEY SPECIFICS RECORDED IN THE DOCUMENTATION ABOVE

	
  /* EXAMPLE:
	local	cpiFIRST 	= 1.1786345 
			//  inflation rate since first year of time series for analysis = 2023 (1.181 * 1.001 * 0.997)
	local 	cpiCURRENT	= 0.997 // inflation rate for year of data collection
	local 	exFIRST 	= 610.12 // exchange rate for first year in time series for analysis
	local 	exCURRENT	= 574.02 // exchange rate for year of data collection
	local 	exDC		= 582.19 // exchange rate for data collection period

/*

	local	cpiFIRST 	= 
	local 	cpiCURRENT	= 
	local 	exFIRST 	= 
	local 	exCURRENT	= 
	local 	exDC		= 
	



******************************************************************************* 
**# 2.9.2 PRICE
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


**NOTE: FOR STUDY DESIGNS NOT REQUIRING USD/ OVER TIME ANALYSIS, ONLY INDICATORS 
**MARKED WITH A § BELOW ARE REQUIRED

/* For studies inclding USD or overtime analysis, the following syntax will 
require three modifications to adapt the syntax to the current survey.

1. Modifying the if statements as appropriate so that the statements correctly 
	restrict the variables to valid price values and omit inconsistent, 	
	refused, don't know and user-missing values. 
	The range of valid price values will depend upon the number of digits allowed 
	in the audit sheet price variables which in turn is dictated by the 
	local currency.
2. SECTION 2.1.1 (above) sets macros for CPI and exchange rates that are called 
	for these calculations. Confirm they have been updated before running this section


*/

/* ANTIMALARIAL selling prices may be calculated in the following 9 units:
	§	1. Per unit, data collection period, local currency unit (DC LCU).
	§	2. Per package, data collection period, local currency unit (DC LCU).
		3. Per package, data collection period, US dollars (DC USD).
		4. Per package, deflated to year of first survey included in trend analysis, US dollars (FIRST USD).
	§	5. Per AETD, data collection period, local currency unit (DC LCU)
		6. Per AETD, deflated to year of first survey included in trend analysis, local currency unit (FIRST LCU)
		7. Per AETD, data collection period, US dollars (DC USD)
		8. Per AETD, year of current survey, US dollars (CURRENT USD)
		9. Per AETD, deflated to year of first survey included in trend analysis, US dollars (FIRST USD)
	
*DIAGNOSTIC selling prices are calculated in the following 5 units
	§	1. Data collection period, local currency unit (DC LCU)
		2. Deflated to year of first survey included in trend analysis, local currency unit (FIRST LCU)
		3. Data collection period, US dollars (DC USD)
		4. Year of current survey, US dollars (CURRENT USD)
		5. Deflated to year of first survey included in trend analysis, US dollars (FIRST USD)
		
*If this is the first ACTwatch conducted, remove time-series indicators 

*/
		

**# 		
*SELLING PRICE
********************************************************************************
 
*ANTIMALARIALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*1. Per unit, data collection period, local currency unit (DC LCU).

				cap drop unitPrice
				gen unitPrice=.
					lab var unitPrice "Selling price per unit (tab/supp/sachet/mL/mg), local currency, data collection period (DC LCU)"
				ta unitPrice
				ta size

				ta size if rts_price<150
				ta brand gname if rts_price<150
				replace unitPrice=rts_price/size if rts_price!=. & size!=. & rts_price<99995 & size<9999 & rts_price>0	

*2. Per package, data collection peroid, local currency unit (DC LCU).

				gen packagePrice=.
				replace packagePrice = unitPrice * size if size!=. & unitPrice!=.
				lab var packagePrice "Selling price per package, local currency, data collection period (DC LCU)"
				codebook packagePrice if productype==1 | productype==2	
	

*3. Per package, data collection period, US dollars (DC USD).
	*Exchange rate - data collection period: 1 USD = (#exDC)

				gen usppriceperpackageDC=.
				replace usppriceperpackageDC=(packagePrice/`exDC') if packagePrice!=.
				lab var usppriceperpackageDC "Selling price per package (DC USD)"
				tab usppriceperpackageDC if (productype==1 | productype==2), m	

*4. Per package, deflated to year of first survey included in trend analysis, US dollars (FIRST USD).
	
				*CPI - first year: 1
				*CPI - current year: 121.285367464332
				*Exchange rate - first survey year: 1 USD = 489.9017638
					gen usppriceperpackageFIRST=.
					replace usppriceperpackageFIRST=packagePrice*((1)/(`cpiFIRST'))/(`exFIRST') if packagePrice!=.
					lab var usppriceperpackageFIRST "Selling price per package (FIRST USD)"
					tab usppriceperpackageFIRST if (productype==1 | productype==2), m
					
	
*5. Per AETD, data collection period, local currency unit (DC LCU)

				gen ppriceperaetd=.
				replace ppriceperaetd=packagePrice/packageaetd if packagePrice!=. & packageaetd!=.
				lab var ppriceperaetd "Selling price per AETD (DC LCU)"
				tab ppriceperaetd if (productype==1 | productype==2), m
	
				list  gname brand rts_price if ppriceperaetd==. & (productype==1 | productype==2)
				tab gname if ppriceperaetd==. & (productype==1 | productype==2)
				tab brand if ppriceperaetd==. & (productype==1 | productype==2)
				tab a3 if ppriceperaetd==. & (productype==1 | productype==2)
	

*6. Per AETD, deflated to year of first survey included in trend analysis, local currency unit (FIRST LCU)
	*CPI - first year: (1)
	*CPI - current year: ()

				gen ppriceperaetdFIRST=.
				replace ppriceperaetdFIRST=ppriceperaetd*((1)/(`cpiFIRST'))
				lab var ppriceperaetdFIRST "Selling price per AETD (FIRST LCU)"
				tab ppriceperaetdFIRST if (productype==1 | productype==2), m	
				
	
*7. Per AETD, data collection period, US dollars (DC USD)
	*Exchange rate - data collection period: 1 USD = (#exDC)

				gen usppriceperaetdDC=.
				replace usppriceperaetdDC=ppriceperaetd/`exDC'
				lab var usppriceperaetdDC "Selling price per AETD (DC USD)"
				tab usppriceperaetdDC if (productype==1 | productype==2), m
	
	
*8. Per AETD, year of current survey, US dollars (CURRENT USD)
	*Exchange rate - current survey: 1 USD = (606.80375)

				gen usppriceperaetdCURRENT=.
				replace usppriceperaetdCURRENT=ppriceperaetd/`exCURRENT'
				lab var usppriceperaetdCURRENT "Selling price per AETD (CURRENT USD)"
				tab usppriceperaetdCURRENT if (productype==1 | productype==2), m
	

*9. Per AETD, deflated to year of first survey included in trend analysis, US dollars (FIRST USD)
	*Exchange rate - first survey: 1 USD = 456.617 in 2009

				gen usppriceperaetdFIRST=.
				replace usppriceperaetdFIRST=ppriceperaetdFIRST/`exFIRST'
				lab var usppriceperaetdFIRST "Selling price per AETD (FIRST USD)"
				tab usppriceperaetdFIRST if (productype==1 | productype==2), m	
				
				
*MICROSCOPY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*1  Data collection period, local currency unit (DC LCU)

		*Adult
			tab1 d5, m
			gen pptestAdultTotal=.
			replace pptestAdultTotal=d5 if !inlist(d5,-9555, -9777, -9888)
			lab var pptestAdultTotal "Total selling price microscope - adult (DC LCU)"	
	
	
		*Child
			tab1 d6, m
			gen pptestChildTotal=.
			replace pptestChildTotal=d6 if !inlist(d5,-9555, -9777, -9888)
			lab var pptestChildTotal "Total selling price microscope - child (DC LCU)"	
	
*2 Deflated to year of first survey included in trend analysis, local currency unit (FIRST LCU)


		*Adult
		gen pptestAdultTotalFIRST=pptestAdultTotal*(`cpiFIRST' / `cpiCURRENT')
		lab var pptestAdultTotalFIRST "Total selling price microscope - adult (FIRST LCU)"	
		
		*Child
		gen pptestChildTotalFIRST=pptestChildTotal*(`cpiFIRST' / `cpiCURRENT')
		lab var pptestChildTotalFIRST "Total selling price microscope - child (FIRST LCU)"	
		
*3 Data collection period, US dollars (DC USD)
*Exchange rate - data collection period

		*Adult
		gen uspptestAdultTotalDC=pptestAdultTotal/`exDC'
		lab var uspptestAdultTotalDC "Total selling price microscope - adult (DC USD)"	

		*Child
		gen uspptestChildTotalDC=pptestChildTotal/`exDC'
		lab var uspptestChildTotalDC "Total selling price microscope - child (DC USD)"	

		
*4 Year of current survey, US dollars (CURRENT USD)
	*Exchange rate - current survey: 1 USD = (#exCURRENT)

		*Adult
		gen uspptestAdultTotalCURRENT=pptestAdultTotal/`exCURRENT'
		lab var uspptestAdultTotalCURRENT "Total selling price microscope - adult (CURRENT USD)"	
		
		*Child
		gen uspptestChildTotalCURRENT=pptestChildTotal/`exCURRENT'
		lab var uspptestChildTotalCURRENT "Total selling price microscope - child (CURRENT USD)"	
		
		
*5 Deflated to year of first survey included in trend analysis, US dollars (FIRST USD)
	*Exchange rate - first survey: 1 USD = (#exFIRST)

		*Adult
		gen uspptestAdultTotalFIRST=pptestAdultTotalFIRST/`exFIRST'
		lab var uspptestAdultTotalFIRST "Total selling price microscope - adult (FIRST USD)"	
	
		*Child
		gen uspptestChildTotalFIRST=pptestChildTotalFIRST/`exFIRST'
		lab var uspptestChildTotalFIRST "Total selling price microscope - child (FIRST USD)"	
	
*RDT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


*1. Data collection period, local currency unit (DC LCU)

		tab1 r15b r16b, nolab
		gen pprdtAdultOutlet=.
			replace pprdtAdultOutlet=r15b if r15b<99995
			lab var pprdtAdultOutlet "Outlet selling price RDT - adult (DC LCU)"
		gen pprdtAdultAway=.
			replace pprdtAdultAway=r16b if r16b<99995
			lab var pprdtAdultAway "Away selling price RDT - adult (DC LCU)"	

		
*2. Deflated to year of first survey included in trend analysis, local currency unit (FIRST LCU)
	*CPI (first year): (#cpiFIRST)
	*CPI (current year): (#cpiCURRENT)

			*Adult
			gen pprdtAdultOutletFIRST=pprdtAdultOutlet*(100/`cpiFIRST')
				lab var pprdtAdultOutletFIRST "Outlet selling price RDT - adult (FIRST LCU)"
			gen pprdtAdultAwayFIRST=pprdtAdultAway*(100/`cpiFIRST')
				lab var pprdtAdultAwayFIRST "Away selling price RDT - adult (FIRST LCU)"	

	

*3. Data collection period, US dollars (DC USD)
	*Exchange rate - data collection period: 1 USD = (#exDC)

			*Adult
			gen uspprdtAdultOutletDC=pprdtAdultOutlet/`exDC'
				lab var uspprdtAdultOutletDC "Outlet selling price RDT - adult (DC USD)"
			gen uspprdtAdultAwayDC=pprdtAdultAway/`exDC'
				lab var uspprdtAdultAwayDC "Away selling price RDT - adult (DC USD)"	
	

*4. Year of current survey, US dollars (CURRENT USD)
	*Exchange rate - current survey: 1 USD = (#exCURRENT)

			*Adult
			gen uspprdtAdultOutletCURRENT=pprdtAdultOutlet/`exCURRENT'
				lab var uspprdtAdultOutletCURRENT "Outlet selling price RDT - adult (CURRENT USD)"
			gen uspprdtAdultAwayCURRENT=pprdtAdultAway/`exCURRENT'
				lab var uspprdtAdultAwayCURRENT "Away selling price RDT - adult (CURRENT USD)"	
	
		
*5. Deflated to year of first survey included in trend analysis, US dollars (FIRST USD)
	*Exchange rate - first survey: 1 USD = (#exFIRST)

				*Adult
				gen uspprdtAdultOutletFIRST=pprdtAdultOutletFIRST/`exFIRST'
					lab var uspprdtAdultOutletFIRST "Outlet selling price RDT - adult (FIRST USD)"
				gen uspprdtAdultAwayFIRST=pprdtAdultAwayFIRST/`exFIRST'
					lab var uspprdtAdultAwayFIRST "Away selling price RDT - adult (FIRST USD)"	
	

	
**# 
*PERCENTAGE MARK-UPS
********************************************************************************

*ANTIMALARIALS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*###To calculate the percentage mark-up, first calculate the wholesale purchase price per unit (tablet, suppository, sachet, ml, mg (powder injection)).

				gen supplier_price_all=supplier_price_tab
				replace supplier_price_all=supplier_price_oth if supplier_price_all==.
				lab var supplier_price_all "price paid to supplier, unit cost"
	
				ta supplier_price_all,m
	
	
				gen _tempsup_packprice=supplier_price/supplier_amt_pack if supplier_price!=. & supplier_amt_pack!=.
				gen _tempsup_indtabprice=supplier_price/supplier_amt_unit if supplier_price!=. & supplier_amt_unit!=.
	
				ta packageaetd if _tempsup_indtabprice!=.
				ta packageaetd if _tempsup_packprice!=.
	
				gen _tempsup_price_all=_tempsup_packprice
				replace _tempsup_price_all=_tempsup_indtabprice if _tempsup_price_all==.	


* Wholesale price per AETD, data collection period, local currency units (DC LCU)
				gen ws_price_all=ws_price_tab
				replace ws_price_all=ws_price_oth if ws_price_al==.
				lab var ws_price_all "Price charged for wholesale, unit cost"

				gen suppriceperaetd=.
				replace suppriceperaetd=_tempsup_price_all/packageaetd if supplier_price!=. & packageaetd!=. & supplier_amt!=.
				lab var suppriceperaetd "Wholesale purchase price per AETD (DC LCU)"

*Generate markup variable.

				generate markup=(rts_price-unitsuppPrice)/unitsuppPrice if unitsuppPrice!=. & unitsuppPrice>0
				replace markup=0 if unitsuppPrice==0 & unitPrice==0
				replace markup=. if unitsuppPrice==0 & unitPrice>0
				lab var markup "Percent markup on a package" 
				summ markup, d

*Generate markup per aetd variable.

				generate markupaetd=(ppriceperaetd-suppriceperaetd)/suppriceperaetd if suppriceperaetd !=. & suppriceperaetd !=0
				replace markupaetd=0 if suppriceperaetd==0 & markupaetd==0
				replace markupaetd=. if suppriceperaetd==0 & markupaetd>0
				lab var markupaetd "Percent markup per AETD" 
				summ markupaetd, d


*Gen markup raw amount in DC USD per AETD

				gen ppricemarkupaetd = ppriceperaetd - suppriceperaetd
				lab var ppricemarkupaetd "raw markup value per AETD in USD DC"
				summ ppricemarkupaetd, d
				ta ppricemarkupaetd,m

	
	*then reconverting to packages:
	*packageaetd

				gen ppricemarkupval= (packageaetd*ppriceperaetd) - (packageaetd*suppriceperaetd)
				summ ppricemarkupval,
				lab var ppricemarkupval "raw markup value of pack in USD DC"
		
				summ ppricemarkupval
				ta ppricemarkupval,m

*RDTs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*###RDT mark-ups are based on comparing the away price with the wholesale purchase price.

*RDT wholesale purchase price (last wholesale purchase / number purchased)

				gen unitRdtWholePrice=.
				tab r17n
				tab r17p
				replace unitRdtWholePrice=r17p/r17n if r17p!=. & r17n!=. & !inlist(r17p,-9555, -9777, -9888) & !inlist(r17n,-9555, -9777, -9888)
				lab var unitRdtWholePrice "Wholesale purchase price for RDTs
	

*Adult mark-up 

				tab r15b
				gen markupAdult=(r15b-unitRdtWholePrice)/unitRdtWholePrice if !missing(unitRdtWholePrice)
				replace markupAdult=0 if unitRdtWholePrice==0 & r15b==0
				lab var markupAdult "RDT % mark-up for adult (away test retail price)"
				sum markupAdult
	

***Markup_absolute value  for RDTS

				gen usppricemarkupvalDCrdt= ((r15b/`exDC' )-(unitRdtWholePrice/`exDC')) 
				lab var usppricemarkupvalDCrdt "raw markup value in USD DC"
	
				summ usppricemarkupvalDCrdt
				ta usppricemarkupvalDCrdt,m
	
				replace usppricemarkupvalDCrdt=. if usppricemarkupvalDCrdt<0
	

*Cases with negative markups.
*$$$Investigate the reason why markups were negative. Document the number of cases of and reasons for negative markups.

				tab c7 if markupAdult<0

	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
