

/*******************************************************************************
	ACTwatch LITE 
	Step 2.6 Generate antimalarial category type variables 
	
********************************************************************************/
/*
This .do file classifies antimalarial products into standardized treatment categories such as ACTs, artemisinin monotherapies, non-artemisinin therapies, etc. 
It generates key drug category variables used for indicator disaggregation and trend analysis. 

***CATEGORIES SHOULD BE REVIEWED AND ADAPTED FOR EACH IMPELEMNTATION TO REFLECT COUNTRY_SPECIFIC PRODUCTS AND CLASSIFICATIONS***

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
**# 2.6 Generate antimalarial category type variables 
********************************************************************************	
clear
use "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", clear


	$$$ the outlet types should be edited to match the context as needed. Any changes made to
*	the types must be reflected in the analysis syntax files.



*ACTWATCH ANTIMALARIAL CATEGORIES

/*There are several antimalarial category variables that should be generated for
 every survey. There are also other antimalarial category variables that will 
 be required depending if certain antimalarials are found within a country. 
 It is important to consult with the project team and stakeholders to determine
 which additional variables may be required.
	 */ 
	 
*$$$ this .do file requires adaption for specific implementations. Please follow the guidance below to adapt


**# Bookmark #1
***Generate - any ACT, artemisinin monotherapy, non-artemisinin therapy, prophylaxis (broad drug categories)

			tab gname
			tab gname, nol
			gen drugcat1=4 if productype==1 | productype==2
				recode drugcat1 (4=3) if inlist(gname,1,2,3,4,6,9,10,11,12,13,17,18,19,20,21,22)
				recode drugcat1 (4=2) if inlist(gname,30,31,32,33)
				recode drugcat1 (4=1) if gname>=40 & gname<90
			lab var drugcat1 "Broad drug categories"						 
			lab def lbldrugcat1 1 "ACT" 2 "Artemisinin monotherapy" 3 "Non-artemisinin therapy" 4 "Prophylaxis"
			lab val drugcat1 lbldrugcat1
			
			tab gname drugcat1, m
			tab brand drugcat1, m


	
**# 2.7.1: Genreate core antimalraial classification variables

***Generate amCategory - QAACT, non-QAACT, artemisinin monotherapy, non-artemisinin monotherapy
*Historic AMFm antimalarial category variable (back comparability)



			gen amCategory = 4 if !missing(gname) & gname!=5 & gname!=7 & gname!=8 & gname!=14 & gname!=15 & gname!=16 
				recode amCategory (4=2) if gname>=40 & !missing(gname)
				recode amCategory (4=3) if gname==30 | gname==31 | gname==32 | gname==33
				recode amCategory (2=1) if qaact==1
			lab var amCategory "AMFm antimalarial categories"
			lab def lblamCat 1 "QAACT" 2 "Non-QAACT" 3 "Artemisinin monotherapy" 4 "Non-artemisinin therapy"
			lab val amCategory lblamCat

			tab drugcat1 amCategory, m
			tab gname amCategory, m
			tab brand amCategory, m


***Generate anyAM - Antimalarial
*Previously namd anydrug.

			gen anyAM=0 if drugcat1<5
				recode anyAM (0=1) if drugcat1<4
			lab var anyAM "Any Antimalarial"
			lab val anyAM lblyesno
			
			tab drugcat1 anyAM, m
			tab gname anyAM, m
			tab brand anyAM, m



***Generate anyACT - ACT

			gen anyACT=0 if drugcat1<4
				recode anyACT (0=1) if drugcat1==1
			lab var anyACT "Any ACT"
			lab val anyACT lblyesno

			tab drugcat1 anyACT, m
			tab gname anyACT, m
			tab brand anyACT, m
			
**# 2.7.2: Generate WHO pre-qualification and national registration status indicators
			
*** Generate natapp - Nationally registered ACT
/* !!!It is important to provide documentation about the list of nationally 
registered ACTs. The following documentation should be provided. 
The 'source' refers to the individual who provided the list or the web 
address it was found at.*/

/* Nationally registered ACT list
    Title: 
	Author: 
	Publication date: 
	Source: 
	Date list received:
	
!!!Update the code below with reference to the most appropriately-dated
 list of registered ACTs for your country. 
 **the code below uses the information in the AM database. Ensure that the natapp_master
 variable is correct in the database for your country, and that the database has 
 been correctly merged during data cleaning. 
 
 *Alternatively, if you have a list of nationally approaved ACTs, you may wish to 
 code them directly here

*/
**
			*gen natapp=natapp_master if anyACT==1
			
			ta natapp 
			replace natapp=0 if natapp_master==999
			destring natapp, replace

			lab var natapp "Nat registered ACT"
			lab val natapp lblyesno
	
			tab drugcat1 natapp, m
			tab gname natapp, m
			tab brand natapp, m


*** Generate notnatapp - Not nationally registered ACT


			gen notnatapp=0 if drugcat1<4
			recode notnatapp (0=1) if drugcat1==1 & natapp==0
			lab var notnatapp "Not nat registered ACT"
			lab val notnatapp lblyesno

			tab drugcat1 notnatapp, m
			tab gname notnatapp, m
			tab brand notnatapp, m


***Generate flact - First-line ACT

*$$$  *!!!Update with the appropriate first-line gname values. The number of recode rows should equal the number of first-line gname value(s).


* Eg. AL, ASAQ, ASPY and DHAPPQ

			gen flact=0 if drugcat1<4
				recode flact (0=1) if anyACT==1 & gname==40 
				recode flact (0=1) if anyACT==1 & gname==44 
				recode flact (0=1) if anyACT==1 & gname==49
				recode flact (0=1) if anyACT==1 & gname==55 
			lab var flact "First-line ACT (AL, ASAQ, DHAPPQ, ASPY)"
			lab val flact lblyesno
			tab anyACT flact

			tab drugcat1 flact, m
			tab gname flact, m
			tab brand flact, m


*** QAACT
***Disaggregating QAACT into WHO PQ vs NatApp for the country


			gen QA_all =0 if drugcat1<4
				recode QA_all 0=1 if natapp==1 & qaact==1 & drugcat1==1
				lab var QA_all "WHO PQ and Nationally approved ACT" 
			gen QA_WHO =0 if drugcat1<4
				recode QA_WHO 0=1 if natapp==0 & qaact==1 & drugcat1==1
				lab var QA_WHO "WHO PQ ACT, not Nat. Ap."
			gen QA_NAT =0 if drugcat1<4
				recode QA_NAT 0=1 if natapp==1 & qaact==0 & drugcat1==1
				lab var QA_NAT "Nat approved but not WHO PQ ACT"
			gen QA_none =0 if drugcat1<4
				recode QA_none 0=1 if natapp==0 & qaact==0 & drugcat1==1
				lab var QA_none "Not WHO PQ or Nat approved ACT"

 
***Generate faact - First-line QA ACT
*!!!Update with the appropriate first-line gname values. The number of recode rows should equal the number of first-line gname values.


			gen faact=0 if drugcat1<4
				recode faact (0=1) if qaact==1 & gname==40 
				recode faact (0=1) if qaact==1 & gname==44 
				recode faact (0=1) if qaact==1 & gname==49
				recode faact (0=1) if qaact==1 & gname==55 
			lab var faact "FAACT - First-line QAACT (AL, ASAQ, DHAPPQ ASPY)"
			lab val faact lblyesno
			tab qaact faact

			tab drugcat1 faact, m
			tab gname faact, m
			tab brand faact, m
			tab qaact faact, m

***Generate naact - Non first-line QAACT


			gen naact=0 if drugcat1<4
				recode naact (0=1) if qaact==1 & faact==0
				lab var naact "NAACT - QA but not 1st-line ACT"
				lab val naact lblyesno
			tab drugcat1 naact, m
			tab gname naact, m
			tab brand naact, m
			tab qaact naact, m
	


**# 2.7.3: Create dosage-specific QA variables

***pqaact - Pediatric QAACT (2 years, 10kg)
*This syntax defines pediatric qaact by generic, strength and pack size (excluding brand name) 

			gen pqaact=0 if drugcat1<4

			**AL
				replace pqaact=1 if qaact==1 & gname==40 & sumstrength==140 & (size==6 | size==180)
			**ASAQ
				replace pqaact=1 if qaact==1 & gname==44 & sumstrength==203 & (size==6 | size==60)
				replace pqaact=1 if qaact==1 & gname==44 & sumstrength==200 & size==6 
				replace pqaact=1 if qaact==1 & gname==44 & sumstrength==185 & (size==3 | size==30 | size==75)
			**ASMQ
				replace pqaact=1 if qaact==1 & gname==47 & sumstrength==75 & size==6 
			**AS SP
				replace pqaact=1 if qaact==1 & gname==50 & sumstrength==575 & size==4 
			**DHA PPQ
				replace pqaact=1 if qaact==1 & gname==55 & sumstrength==180 & size==3 
			**AS PY
				replace pqaact=1 if qaact==1 & gname==49 & sumstrength==80 &  inlist(size,1,2,3,90)

			lab var pqaact "Pediatric QAACT (2 years, 10kg)"
			lab val pqaact lblyesno
			tab drugcat1 pqaact, m
			tab gname pqaact, m
			tab brand pqaact, m
			tab qaact pqaact, m			
	 

*** pact_fl - Pediatric first-line ACT (2 years, 10kg)
*!!!If the country has more than 1 first-line ACT then create a different pediatric first-line ACT variable for each generic.
*$$$ edit according to national guidelines

			gen pact_fl=0 if drugcat1<4
			* EXAMPLE: 
			replace pact_fl=1 if gname==40 & sumstrength==140 & fdc==1 & (size==6 | size==180) //AL
				replace pact_fl=1 if gname==49 & sumstrength==80  & (size==2 | size==90) //ASPY
				replace pact_fl=1 if gname==44 & sumstrength==185 & fdc==1 & (size==3 | size==30 | size==75) //ASAQ
				replace pact_fl=1 if gname==55 & sumstrength==180 & fdc==1 & size==3  //DHAPPQ
			
			lab var pact_fl "Pediatric first-line ACT - (#INSERT GENERIC NAME) (2 years, 10kg)"
			lab val pact_fl lblyesno

			tab drugcat1 pact_fl, m
			tab gname pact_fl, m
			tab brand pact_fl, m
	 

***aqaact - Adult QAACT (>18 years, 60kg)
*This syntax defines adult qaact by generic, strength and pack size (excluding brand name) 

			gen aqaact=0 if drugcat1<4
			* EXAMPLE: 
				*AL
					replace aqaact=1 if qaact==1 & gname==40 & sumstrength==140 & fdc==1 & (size==24 | size==720)
					replace aqaact=1 if qaact==1 & gname==40 & sumstrength==280 & fdc==1 & size==12
					replace aqaact=1 if qaact==1 & gname==40 & sumstrength==560 & fdc==1 & size==6	
				*ASAQ
					replace aqaact=1 if qaact==1 & gname==44 & sumstrength==203 & fdc==0 & (size==24 | size==240)
					replace aqaact=1 if qaact==1 & gname==44 & sumstrength==200 & fdc==0 & size==24
					replace aqaact=1 if qaact==1 & gname==44 & sumstrength==370 & fdc==1 & (size==6 | size==60 | size==150)
				*ASMQ
					replace aqaact=1 if qaact==1 & gname==47 & sumstrength==450 & fdc==0 & size==9 
					replace aqaact=1 if qaact==1 & gname==47 & sumstrength==300 & fdc==1 & size==6 
				*AS PY - not for adults	
				*DHA PPQ
					replace aqaact=1 if qaact==1 & gname==55 & sumstrength==360 & fdc==1 & (size==9 | size==12)
					replace aqaact=1 if qaact==1 & gname==55 & sumstrength==540 & fdc==1 & (size==6)
					replace aqaact=1 if qaact==1 & gname==55 & sumstrength==720 & fdc==1 & (size==6)
					replace aqaact=1 if qaact==1 & gname==49 & sumstrength==240 & fdc==1 & (size==9 | size==12 | size==90)
			
			lab var aqaact "Adult QAACT (>18 years, 60kg)"
			lab val aqaact lblyesno
		
			tab drugcat1 aqaact, m
			tab gname aqaact, m
			tab brand aqaact, m	
			tab qaact aqaact, m
	


***aact_fl - Adult first-line ACT (18+ years, 60kg)
*!!!If the country has more than 1 first-line ACT then create a different adult first-line ACT variable for each generic.
			gen aact_fl=0 if drugcat1<4
			* EXAMPLE:
				replace aact_fl=1 if gname==40 & sumstrength==140 & fdc==1 & (size==24 | size==720)
				replace aact_fl=1 if gname==40 & sumstrength==260 & fdc==1 & size==12
				replace aact_fl=1 if gname==40 & sumstrength==560 & fdc==1 & size==6
				replace aact_fl=1 if gname==44 & sumstrength==370 & fdc==1 & size==6
				replace aact_fl=1 if qaact==1 & gname==55 & sumstrength==360 & fdc==1 & (size==12)
				
				lab var aact_fl "Adult first-line ACT - AL, DHAPPQ, ASAQ (18+ years, 60kg)"
				lab val aact_fl lblyesno
			tab drugcat1 aact_fl, m
			tab gname aact_fl, m
			tab brand aact_fl, m
			numlabel gname, add
			ta gname
	 

	 
	 
**# 2.7.4: Generate binary variables for commonly encountered antimalarials
	 
***nonqaact - Non-QAACT ACT

			gen nonqaact=0 if drugcat1<4
				recode nonqaact (0=1) if anyACT==1 & qaact==0
				lab var nonqaact "Non-QAACT ACT"
				lab val nonqaact lblyesno
			tab drugcat1 nonqaact, m
			tab gname nonqaact, m
			tab brand nonqaact, m
			tab qaact nonqaact, m	
	 

***nonart - Non-artemisinin therapy


			gen nonart=0 if drugcat1<4
				recode nonart (0=1) if drugcat1==3
				lab var nonart "Non-artemsinin therapy"
				lab val nonart lblyesno
			tab drugcat1 nonart, m
			tab gname nonart, m
			tab brand nonart, m	
	 

***CQ - Chloroquine & hydroxychloroquine sulphate (packaged alone)


			gen CQ=0 if drugcat1<4
				recode CQ (0=1) if (gname==4 | gname==10)
				label var CQ "Chloroquine - packaged alone" 
				lab val CQ lblyesno
			tab drugcat1 CQ, m
			tab gname CQ, m
			tab brand CQ, m		

***SP - Sulfadoxine pyrimethamine

			gen SP=0 if drugcat1<4
				recode SP (0=1) if gname==21
				label var SP "Sulfadoxine pyrimethamine" 
				lab val SP lblyesno
			tab drugcat1 SP, m
			tab gname SP, m
			tab brand SP, m			


***SPAQ - SP-Amodiaquine

			gen SPAQ=0 if drugcat1<4
				recode SPAQ (0=1) if gname==2
				label var SPAQ "SP-Amodiaquine" 
				lab val SPAQ lblyesno
			tab drugcat1 SPAQ, m
			tab gname SPAQ, m
			tab brand SPAQ, m				


*Atovaquone-Proguanil 
			gen ATOPRO=0 if drugcat1<4
				recode ATOPRO (0=1) if gname==3
				label var ATOPRO "Atovaquone-Proguanil"
				lab val ATOPRO lblyesno
			tab drugcat1 ATOPRO, m
			tab gname ATOPRO, m
			tab brand ATOPRO, m

*Mefloquine
			gen MQ=0 if drugcat1<4
				recode MQ (0=1) if gname==11
				label var MQ "Mefloquine"
				lab val MQ lblyesno
			tab drugcat1 MQ, m
			tab gname MQ, m
			tab brand MQ, m

***QN - Quinine (combined quinine and quinimax; any doseform)

			gen QN=0 if drugcat1<4
				recode QN (0=1) if (gname==18 | gname==19)
				label var QN "Quinine"
				lab val QN lblyesno
			tab drugcat1 QN, m
			tab gname QN, m
			tab brand QN, m				
	

***oralQN - Oral quinine
*!!!Check that the dosage a3 values used below match those of the current survey.

			gen oralQN=0 if drugcat1<4
				recode oralQN (0=1) if QN==1 & inlist(a3,1,3,4,5,8)		// tablets, granules, syrup, suspension, drops
				lab var oralQN "Oral quinine"
				lab val oralQN lblyesno
			tab drugcat1 oralQN, m
			tab gname oralQN, m
			tab brand oralQN, m
			tab a3 oralQN, m			
	 

*injQN - Injectable quinine
*!!!Check that the dosage a3 values used below match those of the current survey.

			gen injQN=0 if drugcat1<4
				recode injQN (0=1) if QN==1 & (a3==6 | a3==7)	// liquid injection 
				lab var injQN "Injectable quinine"
				lab val injQN lblyesno
			tab drugcat1 injQN, m
			tab gname injQN, m
			tab brand injQN, m
			tab a3 injQN, m			
	


*nonart - Non-artemisinin therapy - other (so not SP, CQ or QN)

			gen nonartoth=0 if drugcat1<4
				recode nonartoth (0=1) if drugcat1==3 & !inlist(gname,4,10,21,2,18,19)
				lab var nonartoth "Other non-artemsinin therapy"
				lab val nonartoth lblyesno
			tab drugcat1 nonartoth, m
			tab gname nonartoth, m
			tab brand nonartoth, m			

*artmono - Artemisinin monotherapy

			gen artmono=0 if drugcat1<4
				recode artmono (0=1) if drugcat1==2
				lab var artmono "Artemisinin monotherapy"
				lab val artmono lblyesno
			tab drugcat1 artmono, m
			tab gname artmono, m
			tab brand artmono, m			
			

*oartmono - Oral artemisinin monotherapy
*!!!Check that the dosage a3 values used below match those of the current survey.

			gen oartmono=0 if drugcat1<4
				recode oartmono (0=1) if inlist(gname,30,31,32,33) & inlist(a3,1,3,4,5,9)	// tablet, granule, syrup, suspension, suspension+granule
				lab var oartmono "Oral artemisinin monotherapy"
				lab val oartmono lblyesno
			tab drugcat1 oartmono, m
			tab gname oartmono, m
			tab brand oartmono, m
			tab a3 oartmono, m		

*noartmono - Non-oral artemisinin monotherapy

			gen noartmono=0 if drugcat1<4
				recode noartmono (0=1) if drugcat1==2 & oartmono!=1
				lab var noartmono "Non-oral artemisinin monotherapy"
				lab val noartmono lblyesno
			tab drugcat1 noartmono, m
			tab gname noartmono, m
			tab brand noartmono, m
			tab a3 noartmono, m 		
	 


*AS -  artesunate

			gen AS=0 if drugcat1<4
				recode AS (0=1) if gname==32 
				lab var AS "artesunate"
				lab val AS lblyesno
			tab drugcat1 AS, m
			tab gname AS, m
			tab brand AS, m
		tab a3 AS, m 			

*injAS - Injectable artesunate

			gen injAS=0 if drugcat1<4
				recode injAS (0=1) if gname==32 & (a3==6 | a3==7)  // liquid injection, powder injection
				lab var injAS "Injectable artesunate"
				lab val injAS lblyesno
			tab drugcat1 injAS, m
			tab gname injAS, m
			tab brand injAS, m
			tab a3 injAS, m 			

*recAS - Rectal artesunate

			gen recAS=0 if drugcat1<4
				recode recAS (0=1) if gname==32 & a3==2
				lab var recAS "Rectal artesunate"
				lab val recAS lblyesno
			tab drugcat1 recAS, m
			tab gname recAS, m
			tab brand recAS, m
			tab a3 recAS, m 			
	

*AR -  artemether

			gen AR=0 if drugcat1<4
				recode AR (0=1) if gname==31 
				lab var AR "artemether"
				lab val AR lblyesno
			tab drugcat1 AR, m
			tab gname AR, m
			tab brand AR, m
			tab a3 AR, m 			


*injAR - Injectable artemether

			gen injAR=0 if drugcat1<4
				recode injAR (0=1) if gname==31 & (a3==6 | a3==7)	// liquid injection, powder injection
				lab var injAR "Injectable artemether"
				lab val injAR lblyesno
			tab drugcat1 injAR, m
			tab gname injAR, m
			tab brand injAR, m
			tab a3 injAR, m 			

*AE -  arteether

			gen AE=0 if drugcat1<4
				recode AE (0=1) if gname==30
				lab var AE "arteether/artemotil"
				lab val AE lblyesno
			tab drugcat1 AE, m
			tab gname AE, m
			tab brand AE, m
			tab a3 AE, m 			


*injAE - Injectable arteether/artemotil

			gen injAE=0 if drugcat1<4
				recode injAE (0=1) if gname==30 & (a3==6 | a3==7)	// liquid injection, powder injection
				lab var injAE "Injectable arteether/artemotil"
				lab val injAE lblyesno
			tab drugcat1 injAE, m
			tab gname injAE, m
			tab brand injAE, m
			tab a3 injAE, m			


**# 2.7.5: Generate severe malaria treatment variable
			
			
			
*severe - Any severe malaria treatment

			gen severe=0 if drugcat1<4
				recode severe (0=1) if injQN==1 | injAS==1 | recAS==1 | injAR==1 | injAE==1
				lab var severe "Any severe malaria treatment"
				lab val severe lblyesno
			tab drugcat1 severe, m
			tab gname severe, m
			tab brand severe, m
			tab a3 severe, m			
 


*sev_fl - First-line severe malaria treatment
/* !!!Update with the appropriate first-line gname and a3 values. 
The number of recode rows should equal the number of first-line gname-a3 
combinations. Pre-referral treatment for severe malaria should be included 
in this variable.*/

$$$ edit based on national guidelines for first-line severe malaria treatment
	 
			gen sev_fl=0 if drugcat1<4
			/* EXAMPLE:
			recode sev_fl (0=1) if injAS==1
			*/
			
				lab var sev_fl "First-line sev_fl malaria treatment - Inj AR"
				lab val sev_fl lblyesno
			tab drugcat1 sev_fl, m
			tab gname sev_fl, m
			tab brand sev_fl, m
			tab a3 sev_fl, m			
 

 
 
**# 2.7.6: Customize for country-specific needsNext 
 
 
 
/* !!!The following antimalarial category variables depend upon the products/generics audited during the survey. The following generic names and abbreviations should be used when generating new variables. The use of standard abbreviations will allow for standardization across datasets and efficient modification of tables syntax.

				 gname value   Generic Name									Abbreviation
							1	Amodiaquine										AQ
							2	Amodiaquine sulfadoxine pyrimethamine			AQSP
							3	Atovaquone proguanil							ATOPRO
							4	Chloroquine										CQ
							5	Chloroquine proguanil							CQPRO
							6	Chloroquine sulfadoxine pyrimethamine			CQSP
							7	Chlorproguanil dapsone							CPDAP
							9	Halofantrine									HAL
							10	Hydroxychloroquine sulfate						HXCQ
							11	Mefloquine										MQ
							12	Mefloquine sulfadoxine pyrimethamine			MQSP
							13	Primaquine										PRI
							14	Proguanil										PRO
							15	Pyrimethamine									PYR
							16	Pyrimethamine dapsone							PDAP
							18 	Quinimax										QN (combined with quinine)
							19	Quinine											QN
							20	Quinine sulfadoxine pyrimethamine				QNSP
							21	Sulfadoxine pyrimethamine						SP
							30	Arteether/artemotil								AE
							31	Artemether										AR
							32	Artesunate										AS
							33	Dihydroartemisinin								DHA
							34	Chloroqine primaquine							CQPRI
							40	Artemether lumefantrine							AL
							41	Artemisinin naphthoquine						ANAP
							42	Artemisinin piperaquine							APPQ
							43	Artemisinin piperaquine primaquine				APPQPRI
							44	Artesunate amodiaquine							ASAQ
							45	Artesunate halofantrine							ASHAL
							46	Artesunate lumefantrine							ASL
							47	Artesunate mefloquine							ASMQ
							48	Artesunate piperaquine							ASPPQ
							49	Artesunate pyronaridine							ASPYR
							50	Artesunate sulfadoxine pyrimethamine			ASSP
							51	Dihydroartemisinin 								DHA
							52	Dihydroartemisinin halofantrine					DHAHAL
							53	Dihydroartemisinin lumefantrine					DHAL
							54	Dihydroartemisinin mefloquine					DHAMQ
							55	Dihydroartemisinin piperaquine					DHAPPQ
							56	Dihydroartemisinin piperaquine trimethoprim		DHAPPQTRI
							57	Dihydroartemisinin pyronaridine					DHAPYR
							58	Dihydroartemisinin sulfadoxine pyrimethamine	DHASP
							59  Artemether lumefantrine primaquine				ALPQ
							61  Arterolane piperaquine							ARPPQ

*!!!The following syntax can be used to generate dummy variables for generics. Three examples for common generics are provided below the model syntax.

*/

label list gname
/* gname:
           1 amodiaquine
           2 amodiaquine-SP
           3 atovaquone-proguanil
           4 chloroquine
           5 chloroquine-proguanil
           6 chloroquine-SP
           7 chlorproguanil-dapsone
           9 halofantrine
          10 hydroxychloroquine sulfate
          11 mefloquine
          12 mefloquine-SP
          13 primaquine
          14 proguanil
          15 pyrimethamine
          16 pyrimethamine-dapsone
          18 quinimax
          19 quinine
          20 quinine-SP
          21 SP
          30 arteether/artemotil
          31 artemether
          32 artesunate
          33 dihydroartemisinin
          40 AL
          41 artemisinin-naphthoquine
          42 artemisinin-PPQ
          43 artemisinin-PPQ-primaquine
          44 ASAQ
          45 AS-halofantrine
          46 AS-lumefantrine
          47 ASMQ
          48 AS-PPQ
          49 AS-pyronaridine
          50 AS-SP
          51 DHA-AQ
          52 DHA-halofantrine
          53 DHA-lumefantrine
          54 DHA-MQ
          55 DHA-PPQ
          56 DHA-PPQ-Trim
          57 DHA-pyronaridine
          58 DHA-SP
          59 chloroquine-PRI
          60 AL-PRI
          61 arterolane-PPQ
          95 not an antimalarial

*/

ta gname
ta gname, nol

label list gname

*AL
*ASAQ
*APPQ
*ASPYR
*ASSP
*DHAPPQ
*Arterolane PPQ
*DHA-PPQ-Trim


*** Generate ACT antimalarials
*AL - Artemether lumefantrine

			gen AL=0 if drugcat1<4
				recode AL (0=1) if gname==40 
				label var AL "Artemether lumefantrine" 
				lab val AL lblyesno
			tab drugcat1 AL, m
			tab gname AL, m
			tab brand AL, m				


* ASAQ - Artesunate amodiaquine

			gen ASAQ=0 if drugcat1<4
				recode ASAQ (0=1) if gname==44
				label var ASAQ "Artesunate amodiaquine" 
				lab val ASAQ lblyesno
			tab drugcat1 ASAQ, m
			tab gname ASAQ, m
			tab brand ASAQ, m			


*APPQ - artemisinin piperaquine

			gen APPQ=0 if drugcat1<4
				recode APPQ (0=1) if gname==42
				label var APPQ "Artemisinin-PPQ" 
				lab val APPQ lblyesno
			tab drugcat1 APPQ, m
			tab gname APPQ, m
			tab brand APPQ, m			
		

* ASSP - AS-SP

			gen ASSP=0 if drugcat1<4
				recode ASSP (0=1) if gname==50
				label var ASSP "AS-SP" 
				lab val ASSP lblyesno
			tab drugcat1 ASSP, m
			tab gname ASSP, m
			tab brand ASSP, m


*DHAPPQ - Dihydroartemisinin-Piperaquin

			gen DHAPPQ=0 if drugcat1<4
				recode DHAPPQ (0=1) if gname==55
				label var DHAPPQ "Dihydroartemisinin-Piperaquine" 
				lab val DHAPPQ lblyesno
			tab drugcat1 DHAPPQ, m
			tab gname DHAPPQ, m
			tab brand DHAPPQ, m			



*DHAPPQTRI - DHA-PPQ-Trimethoprim

			gen DHAPPQTRI=0 if drugcat1<4
				recode DHAPPQTRI (0=1) if gname==56
				label var DHAPPQTRI "DHA-PPQ-Trimethoprim" 
				lab val DHAPPQTRI lblyesno
			tab drugcat1 DHAPPQTRI, m
			tab gname DHAPPQTRI, m
			tab brand DHAPPQTRI, m 


*ARPPQ - Arterolane PPQ

			gen ARPPQ=0 if drugcat1<4
				recode ARPPQ (0=1) if gname==61
				label var ARPPQ "Arterolane PPQ" 
				lab val ARPPQ lblyesno
			tab drugcat1 ARPPQ, m
			tab gname ARPPQ, m
			tab brand ARPPQ, m			


*!!!The following syntax can be used to generate generic QAACT dummy variables. 
*Examples for common QAACTs are provided below 

***ALqaact - Artemether Lumefantrine QAACT

			gen ALqaact=0 if drugcat1<4
				recode ALqaact (0=1) if gname==40 & qaact==1
				label var ALqaact "AL QAACT" 
				lab val ALqaact lblyesno
			tab drugcat1 ALqaact, m
			tab gname ALqaact, m
			tab brand ALqaact, m			
	
*ASAQqaact - ASAQ QAACT

			gen ASAQqaact=0 if drugcat1<4
				recode ASAQqaact (0=1) if gname==44 & qaact==1
				label var ASAQqaact "ASAQ QAACT" 
				lab val ASAQqaact lblyesno
			tab drugcat1 ASAQqaact, m
			tab gname ASAQqaact, m
			tab brand ASAQqaact, m			
	


*DHAPPQqaact - Dihydroartemisinin-Piperaquin QAACT

			gen DHAPPQqaact=0 if drugcat1<4
				recode DHAPPQqaact (0=1) if gname==55 & qaact==1
				label var DHAPPQqaact "DHAPPQ QAACT" 
				lab val DHAPPQqaact lblyesno
			tab drugcat1 DHAPPQqaact, m
			tab gname DHAPPQqaact, m
			tab brand DHAPPQqaact, m			
	
	
*!!!The following syntax can be used to generate generic non-QAACT ACT dummy variables. 
*Examples for common non-QAACT ACTs are provided below 

*ALnonqaact - Artemether Lumefantrine non-QAACT


			gen ALnonqaact=0 if drugcat1<4
				recode ALnonqaact (0=1) if gname==40 & nonqaact==1
				label var ALnonqaact "AL non-QAACT" 
				lab val ALnonqaact lblyesno
			tab drugcat1 ALnonqaact, m
			tab gname ALnonqaact, m
			tab brand ALnonqaact, m				
	
	
*DHAPPQnonqaact - DHAPPQ non-QAACT


			gen DHAPPQnonqaact=0 if drugcat1<4
				recode DHAPPQnonqaact (0=1) if gname==55 & nonqaact==1
				label var DHAPPQnonqaact "DHAPPQ non-QAACT" 
				lab val DHAPPQnonqaact lblyesno
			tab drugcat1 DHAPPQnonqaact, m
			tab gname DHAPPQnonqaact, m
			tab brand DHAPPQnonqaact, m				
	
	 	
	
*ASAQ - non-QAACT

			gen ASAQnonqaact=0 if drugcat1<4
				recode ASAQnonqaact (0=1) if gname==44 & nonqaact==1
				label var ASAQnonqaact "ASAQ non-QAACT" 
				lab val ASAQnonqaact lblyesno
			tab drugcat1 ASAQnonqaact, m
			tab gname ASAQnonqaact, m
			tab brand ASAQnonqaact, m	

	
*otherACT - Other ACTs not reported individually
*!!!There should be an if statement for each ACT reported individually 
*(i.e. number of if statements rows = number of ACTs reported that are not of the
*named  types listed separately (i.e. AL, ASAQ, etc).


			gen otherACT=0 if drugcat1<4
				recode otherACT (0=1) if anyACT==1 & gname!=40 & ///
													 gname!=55 & ///
													 gname!=61 & /// 
													 gname!=42 & /// 
													 gname!=44
				label var otherACT "Other ACTs not reported individually"
				label val otherACT lblyesno
			tab drugcat1 otherACT, m
			tab gname otherACT, m
			tab brand otherACT, m		
			
	
*otherNonart - Other non-artemisinin therapy not reported individually
*!!!There should be an if statement for each non-artemsinin reported individually 
*(i.e. number of if statements rows = number of ACTs reported that are not of the
*named  types listed separately (i.e. CQ, SP, etc).

			gen otherNonart=0 if drugcat1<4
			recode otherNonart (0=1) if nonart==1 & gname==1 | ///
													gname==3 | ///
													gname==14 | ///
													gname==15 | ///
													gname==22 
											
			label var otherNonart "Other non-artemisinin therapy inc. AQ, ATPRO, PRO, PYRIM, Mepacine not reported individually"
			label val otherNonart lblyesno

			tab drugcat1 otherNonart, m
			tab gname otherNonart, m
			tab brand otherNonart, m			
			
			
/* drugcat2 - QAACT only, QAACT & nationally registered ACT,
* nationally registered ACT only, other ACT, oral artemisinin monotherapy, 
* non-oral artemisinin monotherapy, Non-artemisinin therapy, prophylaxis 
(narrow drug categories)*/

*!!!Check that the dosage a3 values used below match those of the current survey.

			recode drugcat1 (1=4) (2=5) (3=7) (4=8), gen(drugcat2)
			recode drugcat2 (5=6) if a3==2 | a3==6 | a3==7							// suppository, liquid injection, powder injection
			recode drugcat2 (4=2) if natapp==1 & qaact==1
			recode drugcat2 (4=1) if qaact==1
			recode drugcat2 (4=3) if natapp==1
	
			lab var drugcat2 "Narrow drug categories"
			lab def lbldrugcat2 1 "QAACT only" 2 "QAACT & nationally registered ACT" 3 "Nationally registered ACT only" 4 "Other ACT" 5 "Oral artemisinin monotherapy" 6 "Non-oral artemisinin monotherapy" 7 "Non-artemisinin therapy" 8 "Prophylaxis"
			lab val drugcat2 lbldrugcat2

			tab drugcat1 drugcat2
			tab gname drugcat2
			tab brand drugcat2
			tab a3 drugcat2	
			
	 */



*Generate antimalarial category variables for all tablet and non-tablet + ACT generic name combinations which have one or more case.
/* !!!Letters at end of variable names represent generic name abbreviations. Generate variables for all cases in dataset with one or more case. Total number of cases
	 coded to 1 for all variables should match frequency AMaudited coded 1 for all ACT generics.*/
	 
	 *these can be used for price analysis
	 
***Tablets

			gen cmb_tab_AL=0 if drugcat1<4
			replace cmb_tab_AL=1 if (gname==40 ) & a3==1
			
			gen cmb_tab_ANAP=0 if drugcat1<4
			replace cmb_tab_ANAP=1 if gname==41 & a3==1
			
			gen cmb_tab_APPQ=0 if drugcat1<4
			replace cmb_tab_APPQ=1 if gname==42 & a3==1
			
			gen cmb_tab_APPQPRI=0 if drugcat1<4
			replace cmb_tab_APPQPRI=1 if gname==43 & a3==1
	
			gen cmb_tab_ASAQ=0 if drugcat1<4
			replace cmb_tab_ASAQ=1 if gname==44 & a3==1
			
			gen cmb_tab_ASHAL=0 if drugcat1<4
			replace cmb_tab_ASHAL=1 if gname==45 & a3==1
			
			gen cmb_tab_ASL=0 if drugcat1<4
			replace cmb_tab_ASL=1 if gname==46 & a3==1
			
			gen cmb_tab_ASMQ=0 if drugcat1<4
			replace cmb_tab_ASMQ=1 if gname==47 & a3==1
			
			gen cmb_tab_ASPPQ=0 if drugcat1<4
			replace cmb_tab_ASPPQ=1 if gname==48 & a3==1
			
			gen cmb_tab_ASPYR=0 if drugcat1<4
			replace cmb_tab_ASPYR=1 if gname==49 & a3==1
			
			gen cmb_tab_ASSP=0 if drugcat1<4
			replace cmb_tab_ASSP=1 if gname==50 & a3==1
			
			gen cmb_tab_DHA=0 if drugcat1<4
			replace cmb_tab_DHA=1 if gname==51 & a3==1
			
			gen cmb_tab_DHAHAL=0 if drugcat1<4
			replace cmb_tab_DHAHAL=1 if gname==52 & a3==1
			
			gen cmb_tab_DHAL=0 if drugcat1<4
			replace cmb_tab_DHAL=1 if gname==53 & a3==1
			
			gen cmb_tab_DHAMQ=0 if drugcat1<4
			replace cmb_tab_DHAMQ=1 if gname==54 & a3==1
			
			gen cmb_tab_DHAPPQ=0 if drugcat1<4
			replace cmb_tab_DHAPPQ=1 if gname==55 & a3==1
			
			gen cmb_tab_DHAPPQTRI=0 if drugcat1<4
			replace cmb_tab_DHAPPQTRI=1 if gname==56 & a3==1
			
			gen cmb_tab_DHAPYR=0 if drugcat1<4
			replace cmb_tab_DHAPYR=1 if gname==57 & a3==1
			
			gen cmb_tab_DHASP=0 if drugcat1<4
			replace cmb_tab_DHASP=1 if gname==58 & a3==1
			
			gen cmb_tab_ARPPQ=0 if drugcat1<4
			replace cmb_tab_ARPPQ=1 if gname==61 & a3==1
			
			gen cmb_tab_otherACT=0 if drugcat1<4
			replace cmb_tab_otherACT=1 if !inlist(gname,40,42,44,55,61) & a3==1
			


****Non-tablets

			gen cmb_ntb_AL=0 if drugcat1<4
				replace cmb_ntb_AL=1 if (gname==40 | gname==60) & inlist(a3,2,9)
			gen cmb_ntb_ANAP=0 if drugcat1<4
				replace cmb_ntb_ANAP=1 if gname==41 & inlist(a3,2,9)
			gen cmb_ntb_APPQ=0 if drugcat1<4
				replace cmb_ntb_APPQ=1 if gname==42 & inlist(a3,2,9)
			gen cmb_ntb_APPQPRI=0 if drugcat1<4
				replace cmb_ntb_APPQPRI=1 if gname==43 & inlist(a3,2,9)
			gen cmb_ntb_ASAQ=0 if drugcat1<4
				replace cmb_ntb_ASAQ=1 if gname==44 & inlist(a3,2,9)
			gen cmb_ntb_ASHAL=0 if drugcat1<4
				replace cmb_ntb_ASHAL=1 if gname==45 & inlist(a3,2,9)
			gen cmb_ntb_ASL=0 if drugcat1<4
				replace cmb_ntb_ASL=1 if gname==46 & inlist(a3,2,9)
			gen cmb_ntb_ASMQ=0 if drugcat1<4
				replace cmb_ntb_ASMQ=1 if gname==47 & inlist(a3,2,9)
			gen cmb_ntb_ASPPQ=0 if drugcat1<4
				replace cmb_ntb_ASPPQ=1 if gname==48 & inlist(a3,2,9)
			gen cmb_ntb_ASPYR=0 if drugcat1<4
				replace cmb_ntb_ASPYR=1 if gname==49 & inlist(a3,2,9)
			gen cmb_ntb_ASSP=0 if drugcat1<4
				replace cmb_ntb_ASSP=1 if gname==50 & inlist(a3,2,9)
			gen cmb_ntb_DHA=0 if drugcat1<4
				replace cmb_ntb_DHA=1 if gname==51 & inlist(a3,2,9)
			gen cmb_ntb_DHAHAL=0 if drugcat1<4
				replace cmb_ntb_DHAHAL=1 if gname==52 & inlist(a3,2,9)
			gen cmb_ntb_DHAL=0 if drugcat1<4
				replace cmb_ntb_DHAL=1 if gname==53 & inlist(a3,2,9)
			gen cmb_ntb_DHAMQ=0 if drugcat1<4
				replace cmb_ntb_DHAMQ=1 if gname==54 & inlist(a3,2,9)
			gen cmb_ntb_DHAPPQ=0 if drugcat1<4
				replace cmb_ntb_DHAPPQ=1 if gname==55 & inlist(a3,2,9)
			gen cmb_ntb_DHAPPQTRI=0 if drugcat1<4
				replace cmb_ntb_DHAPPQTRI=1 if gname==56 & inlist(a3,2,9)
			gen cmb_ntb_DHAPYR=0 if drugcat1<4
				replace cmb_ntb_DHAPYR=1 if gname==57 & inlist(a3,2,9)
			gen cmb_ntb_DHASP=0 if drugcat1<4
				replace cmb_ntb_DHASP=1 if gname==58 & inlist(a3,2,9)			
			gen cmb_ntb_ARPPQ=0 if drugcat1<4
				replace cmb_ntb_ARPPQ=1 if gname==61 & inlist(a3,2,9)		
				
			**others
			gen cmb_ntb_otherACT=0 if drugcat1<4
				replace cmb_ntb_otherACT=1 if !inlist(gname,40,42,44,55,61) & inlist(a3,2,9)
			
	 */
	
	
*****	
		
**** Active Ingredient (AI) STRENGTH variables for AETD calculations


			cap drop aiStrength_a aiStrength_b aiStrength_c

			gen aiStrength_a = ai1_mg if ai1_mg!=. & productype==1 // all TSGs - number of mg per tablet
			replace aiStrength_a = ai1_mg if ai1_mg!=. & a3==7 // powder inj - number of mg in vial/dose
			replace aiStrength_a = ai1_mg/ai1_ml if ai1_mg!=. & ai1_ml!=. & a3!=7 & productype!=1 // other nt - number of mg per ml
			lab var aiStrength_a "Strength of Active Ingredient A"


			gen aiStrength_b = ai2_mg if ai2_mg!=. & productype==1 // all TSGs
			replace aiStrength_b = ai2_mg if ai2_mg!=. & a3==7 // powder inj
			replace aiStrength_b = ai2_mg/ai2_ml if ai2_mg!=. & ai2_ml!=. & a3!=7 & productype!=1 // other nt
			lab var aiStrength_b "Strength of Active Ingredient B"


			gen aiStrength_c = ai3_mg if ai3_mg!=. & productype==1 // all TSGs
			replace aiStrength_c = ai3_mg if ai3_mg!=. & a3==7 // powder inj
			replace aiStrength_c = ai3_mg/ai3_ml if ai3_mg!=. & ai3_ml!=. & a3!=7 & productype!=1 // other nt
			lab var aiStrength_c "Strength of Active Ingredient C"


			tab1 aiStrength_?, m
			tab2 a3 aiStrength_*, m firstonly
				
			list ai1_ing ai1_mg ai1_ml brand a3 pic_front if a3!=. & 	aiStrength_a==.	
			
			cap drop sumstrength
			egen sumstrength=rsum(aiStrength_a aiStrength_b aiStrength_c)
			label variable sumstrength "Sum of product's strengths"
	
 
 
	
*natrxg - antimalarial that is included in the National Malaria Treatment Guidelines
/* !!!This variable is unique for each country and should be generated by considering the antimalarials recommended in the  National Malaria Treatment Guidlines. Please refer to the data management guidelines for further instruction. The variable is generated below according to the Cambodia treatment guidelines.*/

$$$ confirm what the natioanl treatment guidelines include and edit accordingly 

			gen natrxg=0 if drugcat1<4

			**AL natrxg
			recode natrxg (0=1) if a3==1 & gname==40 & sumstrength==140 & fdc==1 
			recode natrxg (0=1) if a3==1 & gname==40 & sumstrength==280 & fdc==1 
			recode natrxg (0=1) if a3==1 & gname==40 & sumstrength==560 & fdc==1 

			**ASAQ natrxg
			recode natrxg (0=1) if a3==1 & gname==44 & sumstrength==92.5 & fdc==1
			recode natrxg (0=1) if a3==1 & gname==44 & sumstrength==185 & fdc==1 
			recode natrxg (0=1) if a3==1 & gname==44 & sumstrength==370 & fdc==1 

			***DHAPPQ
			recode natrxg (0=1)  if a3==1 & gname==55 & sumstrength==180 & fdc==1 
			recode natrxg (0=1)  if a3==1 & gname==55 & sumstrength==360 & fdc==1 
			recode natrxg (0=1)  if a3==1 & gname==55 & sumstrength==720 & fdc==1 

			***ASPY
			recode natrxg (0=1)  if a3==3 & gname==49 & sumstrength==80 
			
**severe malaria

			*Artesunate AR
				recode natrxg (0=1) if a3==6 & gname==32 
				recode natrxg (0=1) if a3==7 & gname==32 
			*Artemether AS
				recode natrxg (0=1) if a3==6 & gname==31 
				recode natrxg (0=1) if a3==7 & gname==31 
			*QN
				recode natrxg (0=1) if a3==6 & gname==19
				recode natrxg (0=1) if a3==7 & gname==19
			*AR suppository
				recode natrxg (0=1) if a3==2 & gname==32

				lab var natrxg "Antimalarial included in National Malaria Treatment Guidelines"
				lab val natrxg lblyesno 			


***notnatrxg - antimalarial that is not included in the National Malaria Treatment Guidelines

			gen notnatrxg=0 if drugcat1<4
				recode notnatrxg (0=1) if natrxg==0
				lab var notnatrxg "Antimalarial not included in National Malaria Treatment Guidelines"
				lab val notnatrxg lblyesno
				
				
/* !!!It is very important that this variable is closely reviewed to ensure it is 
consistent with the National treatment guidelines. 
Review the following tabulations in detail to ensure coding was 
accurate and products were not misclassified. Review cases that have a brand
 name indicating the product should be included in the national treatment
 guidelines that were not, and brands that should not be included in the national
 treatment guidelines but were. These misclassifications may represent underlying 
 problems with data cleaning, whereby additional cleaning could be conducted,
 or for which cleaning needs to be corrected. */
 
 
			tab natrxg notnatrxg
			tab gname notnatrxg
			tab brand notnatrxg
			tab a3 notnatrxg


*********************************************************************************
**# 2.7.7: Conduct quality checks

*******prepackaged QA and non-QA ACTs tablets
**#  * QA AL variables


***** QA AL variables

	gen qaal_1=0
		replace qaal_1=1 if a3==1 & qaact==1 & gname==40 & ((sumstrength==140 & size==6) | (sumstrength==140 & size==60))
		label var qaal_1 "QA AL pack size 1 (for an infant 5-15kg)"
		label define qaal_1 0"0. No" 1"1. Yes"
		label values qaal_1 qaal_1
	tab qaal_1

	gen qaal_2=0
		replace qaal_2=1 if a3==1 & qaact==1 & gname==40 & ((sumstrength==280 & size==6) | (sumstrength==280 & size==60) | (sumstrength==140 & size==12) ) 
		label var qaal_2 "QA AL pack size 2 (for a child 15-25 kgs)"
		label define qaal_2 0"0. No" 1"1. Yes"
		label values qaal_2 qaal_2
	tab qaal_2

	gen qaal_3=0
		replace qaal_3=1 if a3==1 & qaact==1 & gname==40 & ((sumstrength==140 & size==18))
		label var qaal_3 "QA AL pack size 3 (for an adolescent 25-35 kgs)"
		label define qaal_3 0"0. No" 1"1. Yes"
		label values qaal_3 qaal_3
	tab qaal_3

	gen qaal_4=0
		replace qaal_4=1 if a3==1 & qaact==1 & gname==40 & ((sumstrength==560 & size==6) | (sumstrength==560 & size==60) | (sumstrength==140 & size==240))
		label var qaal_4 "QA AL pack size 4 (for an adult 35+ kgs)"
		label define qaal_4 0"0. No" 1"1. Yes"
		label values qaal_4 qaal_4
	tab qaal_4

***** Non-QA AL variables

	gen nqaal_1=0
		replace nqaal_1=1 if a3==1 & qaact==0 & gname==40 & ((sumstrength==140 & size==6) | (sumstrength==140 & size==60))
		label var nqaal_1 "Non-QA AL pack size 1 (for an infant 5-15kg)"
		label define nqaal_1 0"0. No" 1"1. Yes"
		label values nqaal_1 nqaal_1
	tab nqaal_1

	gen nqaal_2=0
		replace nqaal_2=1 if a3==1 & qaact==0 & gname==40 & ((sumstrength==280 & size==6) | (sumstrength==280 & size==60) | (sumstrength==140 & size==12) ) 
		label var nqaal_2 "Non-QA AL pack size 2 (for a child 15-25 kgs)"
		label define nqaal_2 0"0. No" 1"1. Yes"
		label values nqaal_2 nqaal_2
	tab nqaal_2

	gen nqaal_3=0
		replace nqaal_3=1 if  a3==1 & qaact==0 & gname==40 & ((sumstrength==140 & size==18))
		label var nqaal_3 "Non-QA AL pack size 3 (for an adolescent 25-35 kgs)"
		label define nqaal_3 0"0. No" 1"1. Yes"
		label values nqaal_3 nqaal_3
	tab nqaal_3

	gen nqaal_4=0
		replace nqaal_4=1 if a3==1 & qaact==0 & gname==40 & ((sumstrength==560 & size==6) | (sumstrength==560 & size==60) | (sumstrength==140 & size==240))
		label var nqaal_4 "Non-QA AL pack size 4 (for an adult 35+ kgs)"
		label define nqaal_4 0"0. No" 1"1. Yes"
		label values nqaal_4 nqaal_4
	tab nqaal_4
		


********************************************************************************

**ensuring RDTs included
	
			cap drop countprod
			gen countprod=1 if anyAM==1
			recode countprod (.=1) if rdt_true==1
 			
	
	
	
	save "${mngmtdata}/${country}_${year}_am_rdt_os_cleaned_long_wt.dta", replace

	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
