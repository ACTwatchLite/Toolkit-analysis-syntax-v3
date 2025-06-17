

/*******************************************************************************
	ACTwatch LITE 
	Step 2.11 Generate provier interview variables
	
********************************************************************************/
/*
This .do file generates variables from the provider interview. It includes indicators such as whether the provider can identify ACTs as the most effective treatment, has received training, or has access to technology/ infrastructure.
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
**# 2.11 PROVIDER INTERVIEW INDICATORS 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


**# 	
*MOST EFFECTIVE REPORTED ANTIMALARIAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Provider reports ACT as most effective treatment for uncomplicated malaria.
*###Correct responses include any specific ACT, or reference to 'ACT'.*/ 
		
				ta p16_name p16_form, m
				gen effectiveAM=0 if p16_name!=. 
				lab var effectiveAM "Names tablet-ACT as most effective AM"
				/*recode if correct generic is selected. Below is the label list for reference: 
						9	Amodiaquine
						6	Artemether
						1	Artemether-lumefantrine (eg. Coartem, L-Artem)
						7	Artemisinine
						8	Artesunate
						2	Artesunate-amodiaquine
						4	Artesunate-SP
						10	Chloroquine
						5	ACT (artemisinin combination therapies)
						3	Dihydroartemisinine-piperaquine
						11	Quinine
						12	Sulfadoxine-pyrimethamine (eg. Fansidar, SP)
						95	Not an antimalarial
						96	Other
						98	Don't know
			*/
				recode effectiveAM (0=1) if inlist(p16_name,1,2,3,4,5)
				*recode if tablet if not selected 
				recode effectiveAM (1=0) if p16_form!=1

				tab1 effectiveAM* if nOut==1


**# 
*PROVIDER WOULD RECOMMEND ANTIMALARIAL TREATMENT TO PATIENT AFTER  NEGATIVE TEST RESULT~~~~~~~
	*Generate provider would recommend antimalarial treatment to patient after negative test variable.
	/* !!!Code for inconsistent should be recoded to missing.*/
			
				tab p23
				tab p23,nol
				gen treatNegTest=p23
				recode treatNegTest (98=.)
				label var treatNegTest "Treat negative test with an AM"
			
	*Generate dummy variables for would recommend antimalarial treatment to patient after negative test variable.
	*!!!The tables syntax requires a variable for providers who responded 'some' and for providers who responded 'all'.
		
				tab treatNegTest
					gen treatNegTestSome=treatNegTest
					recode treatNegTestSome (2=0) (3=0) 
				tab treatNegTest treatNegTestSome
					gen treatNegTestAll=treatNegTest
					recode treatNegTestAll (2=1) (1=0) (3=0) 
				tab treatNegTest treatNegTestAll
					gen treatNegTestNev=treatNegTest
					recode treatNegTestNev (1 2=0) (3=1)
					
	 
		*Generate denominator variable for provider would recommend antimalarial treatment to patient after negative test variable series.
	*!!!Denominator for the question below is providers who responded yes to p23 (p23=1 or p23=2).
			
				gen denomNegTest=1 if p23==1 | p23==2
				label var denomNegTest "Denominator for 'treat neg test' series"
	

	*Document reasons given for provider would recommend antimalarial treatment to patient after negative test.
	/* !!!Identify the top 3 reasons and create an 'other' category which includes all reasons other than the top 3. There should be as many rows documented for the 'other'category as there are reported reasons with >=1 case.*/
		
				tab p24
			/*	Insert results here, and use to label the variables below

*/				
				tab1 p24_1-p24_other if nOut==1, nol
		
	*Generate variables for the top 3 reasons and an 'other' variable representing all other reported reasons for providing antimalarial treatment after a negative test. 
		
				*(#TOP 3 REASON VARIABLE LABEL)	
					gen treatNegTest_1=0 if p24!=""
					recode treatNegTest_1 (0=1) if p24_1==1
					replace treatNegTest_1=. if denomNegTest!=1 
					label var treatNegTest_1 "[MOST COMMON REASON GIVEN]"

				*(#TOP 3 REASON VARIABLE LABEL)	
					gen treatNegTest_2=0 if p24!=""
					recode treatNegTest_2 (0=1) if p24_2==1
					replace treatNegTest_2=. if denomNegTest!=1 
					label var treatNegTest_2 "[2ND MOST COMMON REASON GIVEN]"

				*(#TOP 3 REASON VARIABLE LABEL)	
					gen treatNegTest_3=0 if p24!=""
					recode treatNegTest_3 (0=1) if p24_6==1
					replace treatNegTest_3=. if denomNegTest!=1 
					label var treatNegTest_3 "[3RD MOST COMMON REASON GIVEN]"

				*Other reasons for recommending antimalarial treatment after a negative test.
				*!!!Other captures any other reason mentioned, excluding the top 3.
					gen treatNegTest_O=0 if  p24!=""
					recode treatNegTest_O (0=1) if p24_3==1 | p24_4==1 | p24_5==1 | p24_7==1 | p24_oth!=""
					replace treatNegTest_O=. if denomNegTest!=1 
					label var treatNegTest_O "Other reason (not top 3)"

				tab1 treatNegTest_1 treatNegTest_2 treatNegTest_3 treatNegTest_O if nOut==1	
	

	** product storage
	
	recode am_storage* rdt_storage* (98=.)

	
	
**# 
*OUTLETS WITH AT LEAST ONE MEMBER OF STAFF WITH A HEALTH QUALIFICATION ~~~~~~~~~

	*Outlets with at least one member of staff with a health qualification.
	/* $$$ Modify this syntax in light of your questionnaire and the last data 
	management syntax used in the country. Here:
	1	Pharmacist
	2	Doctor
	3	Nurse
	4	Midwife
	5	Laboratory technician / Laboratory assistant
	6	Pharmacy technician / Pharmacy assistant
	7	Caregiver
	8	Counsellor (HIV, TB, Family Planning, etc.)
	9	Community health worker
	10	Apprentice 
	96	Other 
	98	Don't know
	99	No (other) health-related qualification(s)
	*/

	ta p8
	ta p8_other
	tab1 p8* if nOut==1

	gen Hq=0 if p8_any!=. 
		foreach n of numlist 1 2 3 4 6 7 9 10 {
		recode Hq(0=1) if p8_`n'==1 
		}
	tab Hq

	gen healthqual=0
	recode healthqual (0=1) if p8_1==1 |p8_2==1 |p8_3==1 |p8_4==1 |p8_5==1 |p8_6==1
	lab var healthqual "At least one staff member has a health qualification"
	
	
*Outlet characteristics

*1 person works at outlet	
	gen char4_1=0
	recode char4_1 (0=1) if char4==1
	lab var char4_1 "Only one person works at outlet"
	
**# 
*CASE MANAGEMENT TRAINING, SUPERVISION, SUPPORT AND SURVEILLANCE
$$$ Variable names may need modification for different surveys. EXAMPLE BELOW:
/*
1	Malaria diagnosis
2	Malaria treatment
3	Malaria case recording and reporting (surveillance)
96	Other
99	None
98	Don't know
*/
	tab char9
	list char9_other if char9_other!="" & nOut==1


	*ppm_dx - received training on malaria diagnosis in the past year
	gen ppm_dx=0 if char9!=""
		recode ppm_dx (0=1) if char9_1==1
		lab var ppm_dx "Received training on malaria diagnosis in the past year"
		lab val ppm_dx lblyesno
	tab ppm_dx


	*ppm_rx - received training on the national treatment guidelines in the past year
	gen ppm_rx=0 if  char9!=""
		recode ppm_rx (0=1) if char9_2==1
		lab var ppm_rx "Received training on malaria treatment in the past year"
		lab val ppm_rx lblyesno
	tab ppm_rx


	*ppm_sx - received training on malaria surveillance
	gen ppm_sx=0 if  char9!=""
		recode ppm_sx (0=1) if char9_3==1
		lab var ppm_sx "Received training on malaria surveillance in the past year"
		lab val ppm_sx lblyesno
	tab ppm_sx

	*ppm_mx - received training on malaria diagnosis, natl treatment and surveillance
	gen ppm_mx=0 if  char9!=""
		recode ppm_mx (0=1) if ppm_dx==1 & ppm_rx==1 & ppm_sx==1
		lab var ppm_mx "Received training on treatment, diag and surveillance in the past year"
		lab val ppm_mx lblyesno
	tab ppm_mx
	
	***ppm_any ANY malaria training
	gen ppm_any=ppm_dx
	recode ppm_any (0=1) if ppm_rx==1 |ppm_sx==1 |ppm_mx==1
	lab var ppm_any "A member of staff has recieved any malaria training in past yr"
	
	*Ever seen or heard of an RDT?
	gen p21_1=p21
	recode p21_1 (98=0) (99=.)
	lab var p21_1 "Ever heard of or seen an RDT"
	gen p22_1=p22
	recode p22_1 (98=0) (99=.)
	lab var p22_1 "Ever used an RDT on a client"
	
	
	*Do you sell online?
	recode retonline (98=0) (99=.)

*Outlet - price stability
**AMs
	recode sa2_* (98=.) 	
 
	recode sa6 (98=0) (99 97=.)
	gen sa13_1=sa13
	recode sa13_1 (1=1) (2/98=0)
	lab var sa13_1 "12 month prices stayed generally stable"
	gen sa13_2=sa13
	recode sa13_2 (4 5 6 7 =1) (1 2 3 98 =0)
	lab var sa13_2 "12 month prices have changed at least every month"
	gen sa13_3=sa13
	recode sa13_3 (4 5 6 7 1 98=0) ( 2 3  =1)
	lab var sa13_3 "12 month prices have changed less frequently than monthly"
	tab sa14, gen(sa14_)
**RDTS

	recode d1 d2 (98 =0) (99=.)
	
	recode st2_* (98=.) 
	recode st6 (98=0) (99 97=.)
	lab var st6 "Buys on credit from supplier"
	gen st13_1=st13
	recode st13_1 (1=1) (2/98=0)
	lab var st13_1 "12 month prices stayed generally stable"
	gen st13_2=st13
	recode st13_2 (4 5 6 7 =1) (1 2 3 98 =0)
	lab var st13_2 "12 month prices have changed at least every month"
	gen st13_3=st13
	recode st13_3 (4 5 6 7 1 98=0) ( 2 3  =1)
	lab var st13_3 "12 month prices have changed less frequently than monthly"
	tab st14, gen(st14_)
 
	
**# 
*MOBILE PHONE, INTERNET AND DIGITAL PREPAREDNESS - MID ~~~~~~~~~~~~~~~~~~~~~~~~~~

*mid_mp - mobile internet and digital- has mobile
gen mid_mp=0 if  char11!=.
	recode mid_mp (0=1) if char11==1
	lab var mid_mp "has access to mobile phone"
	lab val mid_mp lblyesno
tab mid_mp

*mid_sp - mobile internet and digital- mobile is a smartphone
gen mid_sp=0 if  char11!=.
	recode mid_sp (0=1) if char12==1
	lab var mid_sp "has access to smartphone"
	lab val mid_sp lblyesno
tab mid_sp

*mid_ic - mobile internet and digital- internet connection
gen mid_ic=0 if  char11!=.
	recode mid_ic (0=1) if char13==1
	lab var mid_ic "has connected to internet in last month"
	lab val mid_ic lblyesno
tab mid_ic

*mid_wf - mobile internet and digital- wifi connectivity
gen mid_wf=0 if  char11!=.
	recode mid_wf (0=1) if char14==2
	lab var mid_wf "has WIFI connection"
	lab val mid_wf lblyesno
tab mid_wf

*mid_mm - mobile internet and digital- has mobile money app
gen mid_mm=0 if  char15!="" 
	recode mid_mm (0=1) if char15_3==1
	lab var mid_mm "has mobile money"
	lab val mid_mm lblyesno
tab mid_mm

tab1 working*
*mid_wc - mobile internet and digital- has working laptop, desktop or tablet computer
gen mid_wc=0 if  char15!=""
	recode mid_wc (0=1) if working_computer==1 | working_laptop==1 | working_tablets==1
	lab var mid_wc "has laptop, desktop or tablet computer"
	lab val mid_wc lblyesno
tab mid_wc

*mid_wi - mobile internet and digital- has working internet connection
gen mid_wi=0 if  char15!=""
	recode mid_wi (0=1) if (working_mobileconnect==1 | working_internet==1) & working_electricity==1
	lab var mid_wi "has working internet and electricity"
	lab val mid_wi lblyesno
tab mid_wi

tab1 usedig*

*mid_st - mobile internet and digital- use digital for stock, ordering and suppliers
gen mid_st=0 
	recode mid_st (0=1) if usedig_sales==1 | usedig_stock==1 | usedig_orders==1 | usedig_pay==1
	lab var mid_st "use digital for sales, stock, orders or paying suppliers"
	lab val mid_st lblyesno
tab mid_st

**# 
* CASE REPORTING/ PARTICIPATION IN SURVEILLANCE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

recode dig0 dig1 dig2 dig3 dig5 (98 99 =  0) (2=0) 
 
*data3 data4
recode data4 (98 =0) (99=.)
lab def data4 0 "No/ don't know", modify
 
 
 
	tab1 data*
	gen dat_mr=0 if eligible!=.
		recode dat_mr (0=1) if data1==1
		lab var dat_mr "reports data monthly to health system"
		lab val dat_mr lblyesno
	tab dat_mr

	/* $$$LABEL VALUES GIVEN BELOW AS EXAMPLE, BUT WILL VARY AND SECTION BELOW NEEDS TO BE EDITED:
	1	Directly to government
	2	Directly in to DHIS2 platform
	3	To specific project/ NGO
	96	Other
	98	Don't know
	*/ 

	gen dat_gov=0 if dat_mr==1
		recode dat_gov (0=1) if data2_1==1
		lab var dat_gov "reports directly to government"
		lab val dat_gov lblyesno
	tab dat_gov

	gen dat_dhis=0 if dat_mr==1
		recode dat_dhis (0=1) if data2_2==1
		lab var dat_dhis "reports directly to DHIS2 platform"
		lab val dat_dhis lblyesno
	tab dat_dhis

	gen dat_ngo=0 if dat_mr==1
		recode dat_ngo (0=1) if data2_3==1
		lab var dat_ngo "reports to specific project or NGO"
		lab val dat_ngo lblyesno
	tab dat_ngo


	*dat_sv - data - have you / outlet had supervisory visit?
	gen dat_sv=0 if eligible!=.
		recode dat_sv (0=1) if data3!=0 & data3!=98 & data3!=5
		lab var dat_sv "had supervisory visit within the last year"
		lab val dat_sv lblyesno
	tab dat_sv


	*dat_sl - data -wrriten feedback from supervision?
	gen dat_sl=0 if dat_sv==1
		recode dat_sl (0=1) if data3c==1 
		lab var dat_sl "recieved feedback from supervision visit"
		lab val dat_sl lblyesno
	tab dat_sl


	*dat_st - data - recieved surveillance training and a checklist
	gen dat_st=0 if eligible!=.
		recode dat_st (0=1) if data4==1 
		lab var dat_st "received a checklist for malaria surveillance"
		lab val dat_st lblyesno
	tab dat_st


**# 
** LICENSE AND REGISTRATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tab1 reg*

/* INCLUDE RESULTS BELOW AND EDIT VARIABLES/ LABELS FOR REGISTRATION STATUS AS NEEDED: 


*/

$$$ EXAMPLE BELOW, WILL NEED TO BE ADAPTED TO LOCAL CONTEXT:
/*reg_1 - registation status -  does this facility have an active license?
gen reg_ab=0 if eligible!=.
	recode reg_ab (0=1) if reg1==1 |reg1==2
	lab var reg_ab "PCN license reported or observed"
	lab val reg_ab lblyesno
tab reg_ab

*reg_mh - registation status -  does this facility have an active license?
gen reg_mh=0 if eligible!=.
	recode reg_mh (0=1) if reg2==1 |reg2==2
	lab var reg_mh "PPMV license reported or observed"
	lab val reg_mh lblyesno
tab reg_mh

*reg_mh - registation status -  does this facility have an active license from ABRP AND MOH?
gen reg_2l=0 if eligible!=.
	recode reg_2l (0=1) if reg5==1 & reg5==1
	lab var reg_2l "Other licence license reported or observed"
	lab val reg_2l lblyesno
tab reg_2l

*reg_mh - Has this facilty recieved a govt inspection in th past year?
gen reg_gi=0 if eligible!=.
	recode reg_gi (0=1) if reg6 ==1
	lab var reg_gi "facilty recieved a govt inspection in th past year?"
	lab val reg_gi lblyesno
tab reg_gi

lab var licence_any "Has (reported/observed) operating licence"
*/


	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
