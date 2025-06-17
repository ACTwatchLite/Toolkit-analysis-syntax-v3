

/*******************************************************************************
	ACTwatch LITE 
	Step 2.8 Define and assign Adult Equivalent Treatment Doses (AETDs)
	
********************************************************************************/
/*
This .do file calculates adult equivalent treatment doses (AETDs) for each antimalarial product in the dataset. AETDs are used to standardize product volumes for pricing and market share indicators. The syntax includes steps to define full treatment courses, adjust for active ingredient strength and salt forms, and generate standardized AETD variables.
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
**# 2.8 AETD
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear

*DEFINE ADULT EQUIVALENT TREATMENT DOSES (AETDS)
************************************************************************************************************


*ACTWATCH LITE AETD CALCULATION

/* ### The following five steps are used to calculate the adult equivalent
 treatment dose (AETD) for each product found in the dataset. 
	*AETD is required for the price and market share indicators
	*1 GENERATE fullcourse1
	*2 ADJUST STRENGTH VALUES TO ACCOUNT FOR SALTS
	*3 GENERATE fullcourse2	
	*4 GENERATE newsize
	*5 GENERATE packageaetd	

* ### The fullcourse syntax (first section) should not need modification unless a new AM treatment has
* been introduced (since Nov 2024). New active ingredients should be added to this
* do file, using published literature to establish the necessary mg dose to treat
* a 60kg adult with malaria. 

note that for combination therapies, the artemisnin component is used to estimate
AETD

*/ 


$$$ review and make any needed changes to the AETD syntax before proceeding (specifically if new antimalarials have come to market since Nov.2024)



*********************
**# 2.9.1: DEFINE THE FULL-COURSE TREATMENT DOSE


*Generate fullcourse 1 variable. 
/* !!!First we create the variable fullcourse1 equal to the full course treatment dose in mg for each generic AM. If you have added additional generic name codes, contact the RM before proceeding.*/
	 
tab gname if productype==1 | productype==2, m
gen fullcourse1=.
lab var fullcourse1 "mg required for one AETD"


*Replace the value of fullcourse1 with the recommended full course treatment dose for a 60kg adult.
/* !!!These values have been determined with reference to WHO guidelines, 
published clinical trials and manufacturer recommendations */

	 
*Amodiaquine
replace fullcourse1=1800 if gname==1


*Amodiaquine sulfadoxine pyrimethamine
replace fullcourse1=1800 if gname==2 

*Atovaquone proguanil 
replace fullcourse1=3000 if gname==3


*Arteether/Artemotil
replace fullcourse1=1050 if gname==30 


*Artemether
replace fullcourse1=480 if gname==31 


*Chloroquine primaquine
replace fullcourse1=1500 if gname==34 


*Artemether lumefantrine
replace fullcourse1=480 if gname==40


*Artemisinin naphthoquine
replace fullcourse1=2400 if gname==41


*Artemisinin piperaquine
replace fullcourse1=504 if gname==42 


*Artemisinin piperaquine primaquine
replace fullcourse1=504 if gname==43 


*Artesunate 
replace fullcourse1=600 if gname==32 


*Artesunate amodiaquine
replace fullcourse1=600 if gname==44


*Artesunate halofantrine
replace fullcourse1=600 if gname==45 


*Artesunate lumefantrine
replace fullcourse1=600 if gname==46 


*Artesunate mefloquine
replace fullcourse1=600 if gname==47 


*Artesunate piperaquine
replace fullcourse1=600 if gname==48 


*Artesunate pyronaridine
replace fullcourse1=600 if gname==49 


*Artesunate sulfadoxine pyrimethamine
replace fullcourse1=600 if gname==50 


*Chlorproguanil dapsone
replace fullcourse1=360 if gname==7


*Chloroquine
replace fullcourse1=1500 if gname==4


*Chloroquine sulfadoxine pyrimethamine
replace fullcourse1=1500 if gname==6 


*Dihydroartemisinin
replace fullcourse1=480 if gname==33 


*Dihydroartemisinin amodiaquine
replace fullcourse1=360 if gname==51


*Dihydroartemisinin halofantrine
replace fullcourse1=360 if gname==52


*Dihydroartemisinin lumefantrine
replace fullcourse1=360 if gname==53 


*Dihydroartemisinin mefloquine
replace fullcourse1=360 if gname==54 


*Dihydroartemisinin piperaquine
replace fullcourse1=360 if gname==55 


*Dihydroartemisinin piperaquine trimethoprim
replace fullcourse1=256 if gname==56 


*Dihydroartemisinin pyronaridine
replace fullcourse1=360 if gname==57 


*Dihydroartemisinin sulfadoxine pyrimethamine
replace fullcourse1=360 if gname==58 


*Chloroquine AL
replace fullcourse1=480 if gname==59


*Halofantrine
replace fullcourse1=1398 if gname==9


*Hydroxychloroquine
*updated Sept 2024 https://www.drugs.com/dosage/hydroxychloroquine.html
replace fullcourse1=1550 if gname==10


*Mefloquine
replace fullcourse1=1000 if gname==11


*Mefloquine sulfadoxine pyrimethamine
replace fullcourse1=1000 if gname==12


*Primaquine
replace fullcourse1=45 if gname==13

  
*Quinacrine
replace fullcourse1=2212 if gname==22


*Quinimax
replace fullcourse1=10500 if gname==18 


*Quinine
replace fullcourse1=10408 if gname==19  


*Quinine sulfadoxine pyrimethamine
replace fullcourse1=10408 if gname==20


*Sulfadoxine pyrimethamine
replace fullcourse1=1500 if gname==21 


*Arterolane-PPQ

replace fullcourse1=450 if gname==61 
ta gname if fullcourse==.

 
********************************************
**# 2.9.2: ADJUST FOR SALT CONTENT

*Check for unusal generic/salt combinations.

/* !!!The following syntax will adjust non-base strengths with the following salts.
		Amodiaquine	hydrochloride
		Chloroquine	dihydrochloride
		Chloroquine phosphate
		Choroquine sulphate
		Halofantrine hydrochloride
		Hydroxychloroquine sulphate
		Mefloquine hydrochloride
		Proguanil hydrochloride
		Quinine	bisulphate	
		Quinine dihydrochloride	
		Quinine hydrochloride
		Quinine sulphate
	 */

$$$ ensure this section	is updated and run to adjust strengths for salts 
	
ta hassalt
ta salton
ta salt

	
* Examples for correction, not exhaustive
 
*Amodiaquine hydrochloride
list   brand aiStrength* gname salt if (ai1_ing==60 |ai2_ing==60 | ai3_ing==60 ) & hassalt==1 
list pic_front pic_ais brand manu aiStrength* gname if ai1_ing==60 & hassalt==1 


replace aiStrength_a = aiStrength_a * 0.765 if ai1_ing==60 & salt==2 & hassalt==1 & salton==60
replace aiStrength_b = aiStrength_b * 0.765 if ai2_ing==60 & salt==2 & hassalt==1 & salton==60
replace aiStrength_c = aiStrength_c * 0.765 if ai3_ing==60 & salt==2 & hassalt==1 & salton==60


*Chloroquine dihydrochloride
list  brand aiStrength* gname salt if ai1_ing==68 & hassalt==1 & salt==2
replace aiStrength_a = aiStrength_a * 0.8 if ai1_ing==68 & salt==2	& hassalt==1 & salton==68


*Chloroquine phosphate
list pic_front  brand aiStrength* gname salt if ai1_ing==68 & hassalt==1 & salt==5
replace aiStrength_a=aiStrength_a * 0.6 if ai1_ing==68 & salt==5 & hassalt==1 & salton==68


*Chloroquine sulphate
list pic_front  brand aiStrength* gname salt if ai1_ing==68 & hassalt==1 & salt==6 & salton==68
*none
/*replace aiStrength_a = aiStrength_a * 0.75 if ai1_ing==68  & salt==7 & excip_a==1
replace aiStrength_b = aiStrength_b * 0.75 if ai2_ing==68 & salt==7  & excip_b==1
replace aiStrength_c = aiStrength_c * 0.75 if ai3_ing==68 & salt==7  & excip_c==1

*/


*Halofantrine hydrochloride
*none
/*
replace aiStrength_a = aiStrength_a * 0.932 if ai1_ing==72  & salt==5 & excip_a==1				
replace aiStrength_b = aiStrength_b * 0.932 if ai2_ing==72  & salt==5 & excip_b==1				
replace aiStrength_c = aiStrength_c * 0.932 if ai3_ing==72  & salt==5 & excip_c==1
*/

*Hydroxychloroquine sulphate
list pic_front  brand aiStrength* gname salt if ai1_ing==73 & hassalt==1 & salt==6

replace aiStrength_a=aiStrength_a * 0.62 if ai1_ing==73 & salt==6  & hassalt==1 & salton==73


*Mefloquine hydrochloride
list pic_front brand aiStrength* gname salt if ai1_ing==75 & hassalt==1 
*none 
/*
replace aiStrength_a = aiStrength_a * (250/274) if ai1_ing==75 & salt==5 & excip_a==1
replace aiStrength_b = aiStrength_b * (250/274) if ai2_ing==75 & salt==5 & excip_b==1			
replace aiStrength_c = aiStrength_c * (250/274) if ai3_ing==75 & salt==5 & excip_c==1
*/


*Proguanil hydrochloride
list pic_front brand aiStrength* gname salt if ai1_ing==79 & hassalt==1 

replace aiStrength_a=aiStrength_a * 0.87 if ai1_ing==79 & salt==2  & hassalt==1 & salton==79


*Quinine bisulphate
list pic_front brand aiStrength* gname salt if ai1_ing==83 & hassalt==1 

replace aiStrength_a = aiStrength_a * 0.592 if ai1_ing==83 & salt==1 & hassalt==1 & salton==83



*Quinine dihydrochloride
list pic_front brand aiStrength* gname salt if ai1_ing==83 & hassalt==1 

replace aiStrength_a = aiStrength_a * 0.82 if ai1_ing==83 & salt==3 & hassalt==1 & salton==83



*Quinine hydrochloride
list pic_front brand aiStrength* gname salt if ai1_ing==83 & hassalt==1 

replace aiStrength_a = aiStrength_a * 0.82 if ai1_ing==83 & salt==2 & hassalt==1 & salton==83


*Quinine sulphate
list pic_front brand aiStrength* gname salt if ai1_ing==83 & hassalt==1 

replace aiStrength_a = aiStrength_a * 0.826 if ai1_ing==83 & salt==6 & hassalt==1 & salton==83


	
*********************
**# 2.9.3: CALCULATE THE NUMBER OF UNITS REQUIRED FOR A FULL COURSE	
	

*Generate fullcourse2
/* !!!Create the variable fullcourse2 for each AM in the dataset with non-missing gname and strength values. Fullcourse 2 equals the number of units required to get the fullcourse1 value.*/	
	 
generate fullcourse2=. 
lab var fullcourse2 "Number of units required for fullcourse1"

	
*Monotherapies
replace fullcourse2=(fullcourse1/aiStrength_a) if !missing(ai1_ing) & ai1_ing!=94 & missing(ai2_ing) & missing(ai3_ing)  & inlist(gname,1,4,10,11,14,15,19,22,30,31,32)
replace fullcourse2=(fullcourse1/aiStrength_b) if missing(ai1_ing) & !missing(ai2_ing) & ai2_ing!=94 & missing(ai3_ing) & inlist(gname,1,4,10,11,14,15,19,22,30,31,32)
replace fullcourse2=(fullcourse1/aiStrength_c) if missing(ai1_ing) & missing(ai2_ing) & !missing(ai3_ing) & ai3_ing!=94 & inlist(gname,1,4,10,11,14,15,19,22,30,31,32)


*SPAQ Amodiaquine sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==2 & ai1_ing==60
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==2 & ai2_ing==60
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==2 & ai3_ing==60


*Atovaqone proguanil
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==3 & ai1_ing==66
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==3 & ai2_ing==66
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==3 & ai3_ing==66


*Chloroquine sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==6 & ai1_ing==68
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==6 & ai2_ing==68
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==6 & ai3_ing==68


*Mefloquine sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==12 & ai1_ing==75
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==12 & ai2_ing==75
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==12 & ai3_ing==75


*Quinine sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==20 & ai1_ing==83
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==20 & ai2_ing==83
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==20 & ai3_ing==83


*Sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==21 & (ai1_ing==81)
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==21 & (ai2_ing==81)
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==21 & (ai3_ing==81)


*Artemether lumefantrine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==40 & ai1_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==40 & ai2_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==40 & ai3_ing==61


*Artemisinin napthoquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==41 & ai1_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==41 & ai2_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==41 & ai3_ing==62


*Artemisinin piperquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==42 & ai1_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==42 & ai2_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==42 & ai3_ing==62


*Artemisinin piperquine primaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==43 & ai1_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==43 & ai2_ing==62
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==43 & ai3_ing==62


*Artusunate amodiaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==44 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==44 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==44 & ai3_ing==65


*Artesunate halofantrine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==45 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==45 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==45 & ai3_ing==65


*Artesunate lumefantrine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==46 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==46 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==46 & ai3_ing==65


*Artesunate mefloquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==47 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==47 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==47 & ai3_ing==65


*Artesunate piperaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==48 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==48 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==48 & ai3_ing==65


*Artesunate pyronaridine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==49 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==49 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==49 & ai3_ing==65


*Artesunate sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==50 & ai1_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==50 & ai2_ing==65
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==50 & ai3_ing==65


*Dihydroartemisinin amodiaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==51 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==51 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==51 & ai3_ing==71


*Dihydroartemisinin halofantrine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==52 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==52 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==52 & ai3_ing==71


*Dihydroartemisinin lumefantrine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==53 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==53 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==53 & ai3_ing==71


*Dihydroartemisinin meflooquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==54 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==54 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==54 & ai3_ing==71


*Dihydroartemisinin piperaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==55 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==55 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==55 & ai3_ing==71


*Dihydroartemisinin piperaquine trimethoprim
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==56 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==56 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==56 & ai3_ing==71


*Dihydroartemisinin pyronaridine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==57 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==57 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==57 & ai3_ing==71


*Dihydroartemisinin sulfadoxine pyrimethamine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==58 & ai1_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==58 & ai2_ing==71
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==58 & ai3_ing==71	


*Chloroquine primaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==59 & ai1_ing==68
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==59 & ai2_ing==68
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==59 & ai3_ing==68


*Artemether lumefantrine primaquine
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==59 & ai1_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==59 & ai2_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==59 & ai3_ing==61


*Arterolane-PPQ // this is a new drug that wasn't present in the previous syntax. basing strength on Arterolane ingredient
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==61 & ai1_ing==69
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==61 & ai2_ing==69
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==61 & ai3_ing==69


*Artemether SP
replace fullcourse2 = (fullcourse1/aiStrength_a) if fullcourse2==. & gname==59 & ai1_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_b) if fullcourse2==. & gname==59 & ai2_ing==61
replace fullcourse2 = (fullcourse1/aiStrength_c) if fullcourse2==. & gname==59 & ai3_ing==61

	
*Document the characteristics of cases that are missing fullcourse2
codebook fullcourse2 if productype==1 | productype==2
tab gname if missing(fullcourse2) & (productype==1 | productype==2)
tab brand if missing(fullcourse2) & (productype==1 | productype==2)
tab a3 if missing(fullcourse2) & (productype==1 | productype==2)

bysort gname: tab1 ai*ing if fullcourse2==.
bysort gname: tab1 aiStrength_* if fullcourse2==.

ta aiStrength_a fullcourse1 if missing(fullcourse2) & (productype==1 | productype==2),m
ta gname fullcourse1 if missing(fullcourse2) & (productype==1 | productype==2),m

list brand ai1_mg ai2_mg gname if missing(fullcourse2) & (productype==1 | productype==2) & fullcourse1!=.


*Replace fullcourse2 to fullcourse1 value for powder injections 
*as the size takes the same value as the ai1_mg for a3==7
replace fullcourse2=fullcourse1 if a3==7
bysort gname:	tab1 aiStrength_* fullcourse1 a3 if fullcourse2>100

	ta aiStrength_a if gname==40
	tab1 a3 suspensiontype if gname==40 & aiStrength_a<10
	ta aiStrength_b if gname==40
	
	
	ta aiStrength_a if gname==55
	ta aiStrength_b if gname==55
	ta a3 if gname==55 & aiStrength_a<10
		
	
************************
**# 2.9.4: STANDARDIZE PRODUCT SIZE

*GENERATE NEW SIZE


/* !!!For tablet products, newsize equals the number of tablets of AETD-defining AM.
		If the tablet is an FDC then newsize = size because FDC cases have all active ingredients in each tablet.
		If the tablet is not an FDC thennewsize = size / 2 except for the following generic names (gname value):
			- amodiaquine sulfadoxine pyrimethamine (2)
			- chloroquine sulfadoxine pyrimethamine (6)
			- mefloquine sulfadoxine pyrimethamine (12)
			- quinine sulfadoxine pyrimethamine (20)
			- artesunate amodiaquine (44)
			- artesunate mefloquine (47)
			- artesunate sulfadoxine pyrimethamine (50)
			- dihydroartemisinin amodiaquine (51)
			- dihydroartemisinin halofantrine (52)
			- dihydroartemisinin mefloquine (54)
			- dihydroartemisinin sulfadoxine pyrimethamine (58)
		Non-FDC packages that are not packaged in a 1:1 ratio (the generics listed above) must be defined by brand name on a case-by-case basis. For these exceptions,
		newsize must be recoded to the number of artemisinin-based active ingredient tablets found within a package.
	 For non-tablets, newsize will equal size.*/


*TABLET MONOTHERAPY: newsize = size

generate newsize=size if inlist(gname,1,4,8,9,10,11,13,14,15,17,18,19,22,30,31,32,33) & productype==1
lab var newsize "Number of AETD defining units in package TSG/NT"
ta newsize a3


*TABLET FDC: newsize = size
replace newsize=size if fdc==1 & productype==1


*TABLET NON-FDC: newsize = size / 2 except for the generics 2,6,12,20,44,47,50,51,52,54,58
replace newsize = size * 0.5 if missing(newsize) & a3==1 & fdc==0 & !inlist(gname,2,6,12,20,44,47,50,51,52,54,58)


*TABLET NON-FDC: exceptions to the 1:1 rule (2,6,12,20,44,47,50,51,52,54,58)
*!!!The ratio of artemisinin-based active ingredients tablets to non artemisinin-based active ingredients tablets are well known in the following brands. 


*Amodiaquine sulfadoxine pyrimethamine (2)
tab gname if gname==2 & a3==1 & fdc==0
replace newsize=size * 0.5 if gname==2 & a3==1 & fdc==0 & ai1_ing==60 & aiStrength_a==600
replace newsize=size * 0.5 if gname==2 & a3==1 & fdc==0 & ai2_ing==60 & aiStrength_b==600
replace newsize=size * 0.5 if gname==2 & a3==1 & fdc==0 & ai3_ing==60 & aiStrength_c==600
replace newsize=size * 0.75 if gname==2 & a3==1 & fdc==0 & ai1_ing==60 & aiStrength_a==200
replace newsize=size * 0.75 if gname==2 & a3==1 & fdc==0 & ai2_ing==60 & aiStrength_b==200
replace newsize=size * 0.75 if gname==2 & a3==1 & fdc==0 & ai3_ing==60 & aiStrength_c==200


*Chloroquine sulfadoxine pyrimethamine (6)
tab gname if gname==6 & a3==1 & fdc==0

*Mefloquine sulfadoxine pyrimethamine (12)
tab gname if gname==12 & a3==1 & fdc==0

*Quinine sulfadoxine pyrimethamine (20)
tab gname if gname==20 & a3==1 & fdc==0

*Artesunate amodiaquine (44)
tab gname if gname==44 & a3==1 & fdc==0
replace newsize=size * 0.5 if gname==44 & a3==1 & fdc==0 & brand!="AMONATE ADULT" & brand!="AMONATE JUNIOR" 
replace newsize=size * 0.5 if gname==44 & a3==1 & fdc==0 & brand=="AMONATE ADULT"


*Artesunate mefloquine (47)		
tab gname if gname==47 & a3==1 & fdc==0

		
*Artesunate sulfadoxine pyrimethamine (50)
tab brand if gname==50 & a3==1 & fdc==0	 
tab1 ai*_mg if gname==50 & a3==1 & fdc==0	 
tab1 ai*_ing if gname==50 & a3==1 & fdc==0	 , nol
replace newsize=size * 0.5 if gname==50 & a3==1 & fdc==0 & ai1_ing==65 & (ai1_mg==100 | ai1_mg==200)

****************
		
/*Dihydroartemisinin amodiaquine (51)		
tab brand if gname==51 & a3==1 & fdc==0
replace newsize=size * 0.5 if tsg_3==1 & tsg_8==0 & gname==51 & (tsg_4_clean=="AMOSININ" | tsg_4_clean=="TALXCIN PLUS")
		
*Dihydroartemisinin halofantrine (52)
tab brand_c if gname==52 & a3==1 & fdc==0
replace newsize=size * 0.5 if tsg_3==1 & tsg_8==0 & gname==52 & (tsg_4_clean=="HALOSININ")
		
*Dihydroartemisinin mefloquine (54)
tab brand_c if gname==54 & a3==1 & fdc==0
tab tsg_4_clean if gname==54 & tsg_3==1 & tsg_8==0	
replace newsize=size * 0.5 if tsg_3==1 & tsg_8==0 & gname==54 & (tsg_4_clean=="MEFLODISIN")

*Dihydroartemisinin sulfadoxine pyrimethamine (58)
tab brand_c if gname==54 & a3==1 & fdc==0
replace newsize=size * 0.5 if productype==1 & fdc==0 & gname==58 & (brand=="MALAXIN-PLUS")

*Chloroquine primaquine (59)
tab brand_c if gname==59 & a3==1 & fdc==0

*Chloroquine artemether lumefantrine (60)
tab brand_c if gname==60 & a3==1 & fdc==0
*/	
	
*NON-TABLETS
replace newsize = size if productype==2

*Document the characteristics of cases that are missing newsize
codebook newsize if productype==1
codebook newsize if productype==2


*SPECIAL CASES

*Camoquine Plus Pediatric / Camoquine Plus Pediatrique (syrup + suspension)
replace newsize=6 if a3==8
replace newsize=6 if brand=="CAMOQUINE PLUS PEDIATRIQUE" & a3!=1


*Artediam Child and Infant (syrup)
*This antimalarial has 2 syrup bottles of 30mL each. One bottle contains artesunate and the other contains amodiaquine.
replace newsize = 30 if productype==2 & brand=="ARTEDIAM CHILD AND INFANT"
replace newsize=size if newsize==.

*Document the characteristics of cases that are missing newsize. Some errors/ missing values may 
*have been missed during cleaning and may require review
codebook newsize if productype==1

tab gname if missing(newsize) & (productype==1) & !missing(aiStrength_a)
tab brand if missing(newsize) & (productype==1) & !missing(aiStrength_a)
tab a3 if missing(newsize) & (productype==1) & !missing(aiStrength_a)

 ***


*********************
**# 2.9.5: STANDARDIZE PRODUCT SIZE

*GENERATE packageaetd	
*!!!This step involves calculating how many AETDs are in each audited product 
*and then checking this against reasonable limits for this variable.

*Generate packageaetd
gen packageaetd=.
	replace packageaetd=newsize/fullcourse2 if fullcourse2!=.
	lab var packageaetd "Number of AETDs Per Package"
tab packageaetd if drugcat2<4

list gname brand a3 packagetype size packageaetd if  packageaetd>10 & packageaetd!=.

*powder injections
tab packageaetd a3
br if packageaetd>10 & packageaetd!=.


*Check if packageaetd is missing for any non-phrophylaxis cases.
/* !!!For all cases it is necessary to determine why packageaetd is missing. Try to resolve/clean the data so packagaetd is not missing. Any changes made should be made to the cleaning syntax file. For further advice please ask the RM.*/

codebook packageaetd if productype==1 | productype==2
tab gname if missing(packageaetd) & (productype==1 | productype==2) & inlist(gname,5,7,8,14,15,16)
tab brand if missing(packageaetd) & (productype==1 | productype==2) & inlist(gname,5,7,8,14,15,16) 
tab a3 if missing(packageaetd) & (productype==1 | productype==2) & inlist(gname,5,7,8,14,15,16)

*Check if packageaetd is too small or too large for any antimalarial
/* !!!With a few exceptions we expect there to be more than .25 AETDs per package. Injections and drops are an exception because the package size is defined as the number of ml in each ampoule. Other exceptions include quinine bisulphate tablets (as the base is only 60% of the salt) and artesunate amodiaquine for infants. It also expects there to be less than 2 AETDs for products that are not packaged in tins. The following syntax will identify any observations where packageaetd is outside the expected range.*/

*Check if packageaetd < 0.25

ta packageaetd, m

list packageaetd a3 aiStrength_* ai?_ing gname brand size if (packageaetd <0.2 & productype!=4) 
ta gname ai1_mg if (packageaetd <0.2 & productype!=4) 

ta aiStrength_a ai1_mg if (packageaetd <0.2 & productype!=4) 
ta gname a3  if (packageaetd <0.2 & productype!=4) 

list gname brand ai1_mg ai1_ml size if (gname==40 | gname==55) & (packageaetd <0.25 &  productype!=4)

tab gname if (packageaetd <0.25 &  productype!=4)
tab brand if (packageaetd <0.25 &  productype!=4)
tab a3 if (packageaetd <0.25 & productype!=4)

list gname brand ai1_mg ai1_ml size a3 if (gname!=40 & gname!=55) & (packageaetd <0.25 &  productype!=4)

**# 2.9.6: FINAL REVIEW AND SAVE

/* !!!Review cases where packageaetd < 0.1 AETDs to ensure cleaning was complete
 and correct. List the reasons why packageaetd < 0.1 AETDs.
 \Check the observations carefully to determine if there are errors in the
 strength, generic name or package size variables. If so correct the data in
 your cleaning syntax file.
 * note that injectables frequently have 0.1 AETD per package
 */

*Check if packageaetd < 0.1

tab1 a3 size if gname>39 & (packageaetd <0.1 &  productype!=4)
tab1  size if gname>39 & (packageaetd <0.1 &  productype!=4) & a3==1
tab1  size type if gname>39 & (packageaetd <0.1 &  productype!=4) & a3>1

*Check if packageaetd > 2
tab gname type if (packageaetd>2 & !missing(packageaetd) & productype==1)
tab type if (packageaetd>2 & !missing(packageaetd) & productype==1)
list packageaetd size amauditkey gname brand if (packageaetd>2 & !missing(packageaetd) & productype==1 & gname>39) & type!=2
ta size if type==1 & gname>39

list packageaetd a3  gname brand size a3 productype if (packageaetd>2 & !missing(packageaetd) )
tab gname if (packageaetd>2 & !missing(packageaetd) )
tab brand if (packageaetd>2 & !missing(packageaetd) )
tab a3 if (packageaetd>2 & !missing(packageaetd) )
tab1 ai1_mg ai1_ml if (packageaetd>2 & !missing(packageaetd) )

ta packageaetd if a3==7
ta size if packageaetd>2
tab1  gname brand packageaetd a3 if size==60 & packageaetd>2 & packageaetd!=.


/* !!!Copy the output from the list and tabulation commands and paste into the 
do file. Review cases where packageaetd > 2 AETDs to ensure cleaning was
 complete and correct. List the reasons why packageaetd > 2 AETDs. 
 Check the observations carefully to determine if there are errors in the 
 strength, generic name or package size variables. If so correct the data 
 in your cleaning syntax file.
	 
	 */


	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
