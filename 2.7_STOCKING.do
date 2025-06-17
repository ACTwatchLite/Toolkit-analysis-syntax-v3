

/*******************************************************************************
	ACTwatch LITE 
	Step 2.7 Generate availability (stocking) variables 
	
********************************************************************************/
/*
This .do file generates outlet-level stocking variables for key antimalarial and diagnostic categories. These binary variables indicate whether an outlet had at least one product of a given type available at the time of the survey and are used to calculate availability indicators in the results tables.
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
**# 2.7 Generate availability (stocking) variables 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear

	$$$ the antimalarial types should be edited to match the context as needed. Any changes made to
*	the types must be reflected in the analysis syntax files.

*ACTWATCH STOCKING VARIABLES

/*In this step, variables are created at the outlet level that flag availability 
of antimalarials based on the values of the dummy variables created in the 
previous step. 

These are the variables that will be used to output the 
reference document availability figures.
	 */ 
	 
* ### The syntax should require only minimal modification (i.e. to include/ exclude 
*certain AM types according to what is found in the field.


**# Bookmark #1

*DIAGNOSTICS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


			***Any malaria test availability
					gen st_test=.
						recode st_test (.=1) if d3==1 | rdt_true==1 
						recode st_test (.=0) if d3==0 & rdt_true==0
						tab st_test if nOut==1, m
					bysort outletid: egen st_test1=max(st_test==1)
					drop st_test
					rename st_test1 st_test
					lab var st_test "Stocks any diagnostic test"
					lab val st_test lblyesno

			***Microscopy availability
					bysort outletid: egen st_micro=max(d3==1)
					lab var st_micro "Stocks malaria microscopy?"
					lab val st_micro lblyesno
					tab st_micro if nOut==1, m

			***RDT availability
					bysort outletid: egen st_rdt=max(rdt_true==1)
					lab var st_rdt "Stocks malaria RDT"
					lab val st_rdt lblyesno
					tab st_rdt if nOut==1, m

			***QARDT availability
					bysort outletid: egen st_qardt=max(qardt==1)
					recode st_qardt (0=.) if d7==.
					lab var st_qardt "Stocks QARDT"
					lab val st_qardt lblyesno
					tab st_qardt if nOut==1, m
	
	/*
	Note, the following variable is generated to represent any test for any screened outlet. This variable is to be used
	only for Table S1 ==> Readiness for malaria case management ==> Proportion of all screened outlets ==> malaria blood testing.
	*/
				gen st_s1_test1=.
					recode st_s1_test1 (.=1) if d3==1 | rdt_true==1
					recode st_s1_test1 (.=0) if (d3!=1 & rdt_true!=1) & screened==1
				bysort outletid: egen st_s1_test=max(st_s1_test1==1)
		
				lab var st_s1_test "Table S1: stocks any diagnostic test, all screened outlets"
				lab val st_s1_test lblyesno
		
				tab st_s1_test if nOut==1, m
				tab st_s1_test eligible if nOut==1, m	
	  
	 
**# Bookmark #2
	
****to make the stocking variables (used for all availability analysis), 
$$$ copy all binary variables created and paste here after the ds:
	
	
				ds ///
			anyAM anyACT notnatapp flact qaact natapp QA_all QA_WHO QA_NAT QA_none faact naact pqaact aqaact aact_fl nonqaact ///
			nonart CQ SP SPAQ QN oralQN injQN nonartoth artmono oartmono noartmono AS injAS recAS AR injAR AE injAE ///
			severe sev_fl AL ASAQ APPQ DHAPPQ ARPPQ ALqaact ASAQqaact DHAPPQqaact ALnonqaact DHAPPQnonqaact ///
			ASAQnonqaact otherACT otherNonart ///
			rdtmanu_1 rdtmanu_2 rdtmanu_3 rdtmanu_other rdtmanu_dk 
			
			foreach v of varlist `r(varlist)' {
			bysort outletid: egen st_`v'=max(`v'==1)
			lab var st_`v' "`v'"
			}


	


	
	
*COMPOSITE INDICATORS


			* stocks flact and testing 
				gen st_flactTest=0 if screened==1
					replace st_flactTest=1 if faact==1 & st_test==1  
					lab var st_flactTest "Stocks first-line ACT treatment and malaria testing"
				tab2 st_flactTest faact st_test if nOut==1, firstonly m


			* stocks flact and NOT testing 
				gen st_flactNoTest=0 if screened==1
					replace st_flactNoTest=1 if faact==1 & st_test!=1  
					lab var st_flactNoTest "Stocks first-line ACT treatment and not malaria testing"
				tab2 st_flactNoTest faact st_test if nOut==1, firstonly m



***stockouts
** Ensure a17_ variables match the definitions here, or modify the syntax:

			*all ACTS
				gen so_ACT=0 if screened==1
				recode so_ACT (0=1) if a17_5==1 & st_anyACT==0
				lab var so_ACT "Stocked out of ACTs"
			*AL
				gen so_AL=0 if screened==1
				recode so_AL (0=1) if a17_1==1 & st_AL==0
				lab var so_AL "Stocked out of AL"
			*ASAQ
				gen so_ASAQ=0 if screened==1
				recode so_ASAQ (0=1) if a17_2==1 & st_ASAQ==0
				lab var  so_ASAQ "Stocked out of ASAQ" 
			*DHAPPQ
				gen so_DHAPPQ=0 if screened==1
				recode so_DHAPPQ (0=1) if a17_3==1 & st_DHAPPQ==0
				lab var so_DHAPPQ "Stocked out of DHAQPPQ"
			*Artemether
				gen so_AR=0 if screened==1
				recode so_AR (0=1) if a17_6==1 & st_AR==0
				lab var so_AR "Stocked out of artemether"
			*Artesunate
				gen so_AS=0 if screened==1
				recode so_AS (0=1) if a17_8==1 & st_AS==0
				lab var so_AS "Stocked out of artesunate"
			*Chloroquine
				gen so_CQ=0 if screened==1
				recode so_CQ (0=1) if a17_10==1 & st_CQ==0
				lab var so_CQ "Stocked out of CQ"
			*Quinine
				gen so_QN=0 if screened==1
				recode so_QN (0=1) if a17_11==1 & st_QN==0
				lab var so_QN "Stocked out of QN"
			*SP
				gen so_SP=0 if screened==1
				recode so_SP (0=1) if a17_12==1 & st_SP==0
				lab var so_SP "Stocked out of SP"

			*RDT	
				gen so_rdt=0 if (rdt_stock==1 | micro_stockcurrent==1 | s6==1) // any outlet with current or past diagnostics
				recode so_rdt (0=1) if d16==1
				lab var so_rdt "Stocked out of RDT"


***Generate composite availability (stocking) variables.

			*st_anyCQ includes CQ packaged alone and also co-packaged with primaquine
				gen anyCQ=0 if drugcat1<4
					recode anyCQ (0=1) if CQ==1 //| CQPRI==1
					lab var anyCQ "Any CQ"
					lab val anyCQ lblyesno
				tab drugcat1 anyCQ, m
				tab gname1 anyCQ, m
				tab brand anyCQ, m
				bysort outletid: egen st_anyCQ=max(anyCQ==1)

			*st_anyAL includes AL packaged alone and also co-packaged with primaquine
				gen anyAL=0 if drugcat1<4
					recode anyAL (0=1) if AL==1 //| ALPRI==1
					lab var anyAL "Any AL"
					lab val anyAL lblyesno
				tab drugcat1 anyAL, m
				tab gname1 anyAL, m
				tab brand anyAL, m
				bysort outletid: egen st_anyAL=max(anyAL==1)

			*Following variable represents outlets that stocked oartmono in the past three months but not currently.
				bysort outletid: egen st_oartmonoso=max(oartmono==1)
				replace st_oartmonoso=0 if st_oartmono==1
				replace st_oartmonoso=0 if st_oartmonoso==.
					lab var st_oartmonoso "Stocks oral artemisinin monotherapy in the past three months but not currently"
					lab val st_oartmonoso lblyesno
					
					
					

		*###count of ACT types stocked at a given facility for MFT readiness indicator


		egen mft_act_count=rowtotal(st_AL st_ASAQ st_APPQ st_DHAPPQ st_ARPPQ st_otherACT)
		lab var mft_act_count "Count of ACT types stocked"
		ta mft_act_count if nOut==1
		ta gname otherACT 
		
		*Stocks 2 or more ACTs (MFT readiness)
		gen st_2acts=0
		recode st_2acts(0=1) if mft_act_count>1 & mft_act_count!=.
		lab var st_2acts "Stocks 2 or more ACTs"


			*Label availabiltiy (stocking) variables.
				lab var st_anyAM "Any antimalarial"
				lab var st_anyACT "ACT"
				lab var st_natapp "Nationally regd ACT"
				lab var st_notnatapp "Non-nat regd ACT"
				lab var st_qaact "QAACT"
				lab var st_nonqaact "Non-QAACT"
				lab var st_nonart "Non-artemisinin therapy"
				lab var st_CQ "CQ - packaged alone"
				lab var st_SP "SP"
				lab var st_QN "QN"
				lab var st_oralQN "Oral QN"
				lab var st_injQN "Injectable QN"
				lab var st_artmono "Artemisinin monotherapy"
				lab var st_oartmono "Oral artemisinin monotherapy"
				lab var st_noartmono "Non-oral art. monotherapy"
				lab var st_injAS "Injectable artesunate"
				lab var st_recAS "Rectal artesunate"
				lab var st_injAR "Injectable artemether"
				lab var st_severe "Severe malaria treatment"
				lab var st_otherACT "Any other ACT"
				*lab var st_otherNonart "other non-artemisinin therapy not reported individually"
				label var st_AL "AL"
				*label var st_ASSP "ASSP"
				label var st_DHAPPQ "DHAPPQ"
				label var st_ARPPQ "ARPPQ"
				lab var st_QA_all "ACT: WHO PQ & NAT"
				lab var st_QA_WHO "ACT: WHO PQ, not NAT"
				lab var st_QA_NAT "ACT: NAT, not WHO PQ"
				lab var st_QA_none "ACT: not WHO PQ or NAT"
				lab var st_SPAQ "SPAQ"
				*lab var st_ATOPRO "Atovaquone Proguanil"
				*lab var st_MQ "Mefloquine"
				lab var st_nonartoth "Other non-artemisinins"
				lab var st_AS "Artesunate"
				lab var st_AL "AL"
				lab var st_ASAQ "ASAQ"
				*lab var st_ASPYR "ASPY"
				lab var st_DHAPPQ "DHAPPQ"
				lab var st_ARPPQ "ARPPQ"
				*lab var st_DHAPPQTRI "DHAPPQ-Trim"
				lab var st_ALqaact "QA AL"
				lab var st_otherACT "any other ACT"
				lab var st_DHAPPQqaact "QA DHAPPQ"
				*lab var st_ASAQqaact "QA ASAQ"
				*lab var st_ALnonqaact "non-QA AL"
				*lab var st_DHAPPQnonqaact "non-QA DHAPPQ"
				*lab var st_ASAQnonqaact "non-QA ASAQ"
				lab var st_anyCQ "Any CQ"
				lab var st_anyAL "Any AL"

	 
	

	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
