

/*******************************************************************************
	ACTwatch LITE 
	Step 3.2 REVIEW, EDIT, AND RUN TABLE SYNTAX
	
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
  

*** .DO FILES FOR STEPS 0-2 AND STEP 3.1 SHOULD BE RUN BEFORE EXECUTING THIS .DO FILE ***		


/*Now that the local definitions have been set in step 3.1, the following .do files for each core indicator can be run. 

Each .do file will produce 4 tables: 

	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural		
	
	
The final modifications required from the user are to: 

3.2.1 	Determine what indicators are included in this analysis. 
		If any indicators have been removed, these should be commented out below using /* */ 

		
3.2.2	Within each indicator that *is* included in the study, the corresponding .do file should be reviewed 

			--> If this study does not require urban/ rural dissagregated results, 
					syntax for tables II and IV should be commented out using /* */ 
			
			--> If this study does not require results for seperate strata e.g. for each state or province, 
					syntax for tables III and IV should be commented out using /* */ 
	
Once syntax for indicators and dissagregations that are not relevant to this study have been commented out, 
the .do files in the /tables_syntax folder (also below) can be run to output data tables to excel for each indicator: 

*/ 
	
	
	$$$ review the Indicator Table for this study and (1) comment out .do files corresponding to indicators NOT included in this study; then
	$$$	review the list of 4 tables for each indicator and determine based on study design and program/ stakeholder interest which dissagregations for each indicator are needed. 
		Open each .do file and comment out any sections that are NOT needed for this analysis
	
	
**********PRIORITY INDICATORS 

*MARKET COMPOSITION 
	*	1.1	Market Composition among antimalarial-stocking outlets
			do "${resultsdir}/tables_syntax/1.1_Market Composition among antimalarial-stocking outlets.do"
			
	*	1.2	Market Composition among outlets with malaria blood-testing
			do "${resultsdir}/tables_syntax/1.2_Market Composition among outlets with malaria blood-testing.do"

*AVAILABILITY
	*	2.1	Availability of antimalarial types in all screened outlets
			do "${resultsdir}/tables_syntax/2.1_Availability of antimalarial types in all screened outlets-KW.do"


	*@PB --- ^^ I have updated the file path ways, table names, and tab names in here to run correctly with all the re-names 
	
	
***@KW the below 2.2 file is incorrect - it has been overwritten - should be amoing all antimalarial-stocking outlets
	*	2.2	Availability of antimalarial types in all antimalarial-stocking outlets
			do "${resultsdir}/tables_syntax/2.2_Availability of antimalarial types in all screened outlets.do"

	*	2.3	Availability of malaria blood testing in all screened outlets
			do "${resultsdir}/tables_syntax/2.3_Availability of tests among all screened outlets.do"

	*	2.4	Availability of malaria blood testing in all antimalarial-stocking outlets
			do "${resultsdir}/tables_syntax/2.4_Availability of tests in all antimalarial-stocking outlets.DO"
		
*VOLUMES		
	*	3.1	Median sales volume of antimalarial AETDs
			do "${resultsdir}/tables_syntax/3.1_Median sales volume of antimalarial AETDs.do"
	
	*	3.2	Median sales volume of antimalarial AETDs among outlets with any sales of that antimalarial type
			do "${resultsdir}/tables_syntax/3.2_Median sales volume of AETDs of outlets with any sales.do"
	
	*	3.3	Median sales volume of malaria blood tests
			do "${resultsdir}/tables_syntax/3.3_Median sales volume of malaria blood tests.do"

	*	3.4	Median sales volume of malaria blood tests among outlets with any sales of that test type
			do "${resultsdir}/tables_syntax/3.4_Median sales volume of tests of outlets with any sales.do"
	
*MARKET SHARE
	*	4.1	Market share of antimalarials
			do "${resultsdir}/tables_syntax/4.1_Market share of antimalarials.do"

	*	4.2	Market share of malaria blood testing overall
			do "${resultsdir}/tables_syntax/4.2_Market share of malaria blood testing overall.do"
		
	*	4.3	Market share of antimalarials by brand and manufacturer
			do "${resultsdir}/tables_syntax/4.3_Market share of antimalarials by brand and manufacturer.do"
		
*SALE PRICE (TO RETAIL CUSTOMERS)
	*	5.1	Sales price of antimalarial tablet AETDs to customers 
			*USD 
			do "${resultsdir}/tables_syntax/5.1a_Sales price of AETDs to customer - USD.do"
			
			*local currency 
			do "${resultsdir}/tables_syntax/5.1b_Sales price of AETDs to customer - Local currency.do"

	*	5.2	Sales price of pre-packaged ACTs to customer
			*USD 
			do "${resultsdir}/tables_syntax/5.2a_Sales price of pre-packaged ACTs - USD.do"
			
			*local currency 
			do "${resultsdir}/tables_syntax/5.2b_Sales price of pre-packaged ACTs - Local currency.do"

	*	5.3	Sales price of malaria blood testing to customers
			*USD 
			do "${resultsdir}/tables_syntax/5.3a_Sales price of tests to customer - USD.do"

			*local currency 
			do "${resultsdir}/tables_syntax/5.3b_Sales price of tests to customer - USD.do"

*PURCHASE PRICE (FROM SUPPLIERS)
*	6.1	Purchase price of antimalarial AETDs from suppliers 
			*USD
			*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!missing 
			
			*local currency 
			do "${resultsdir}/tables_syntax/6.1b_Purchase price of AETDs - Local currency.do"
		
*	6.2	Purchase price of malaria RDTs from suppliers
			*USD
			*!!!!!!!!!!!!!!!!!!!!!!!missing 
			
			*local currency 
			do "${resultsdir}/tables_syntax/6.2b_Purchase price of RDTs - Local currency.do"

*STOCK OUTS	
	*	7.1	Stock outs of antimalarials & *	7.2	Stock outs of RDTs
	*.do file produces one table for antimalarial and RDT stock outs: 
			do "${resultsdir}/tables_syntax/7.1&2_Stock outs of antimalarials and RDTs.do"
		
		
		
		
		
		
		
**********Additional provider interview indicators	

	
8.1	Outlet characteristics	Opening hours: Proportion of outlets open in the daytime only, evening only, both, or other
8.2	Outlet characteristics	Proportion with license: Proportion of outlets with the relevant license and registration to sell medicines (note this question should be tailored to country-specific licensing policy or processes for private sector outlet type included e.g. license to sell pharmaceuticals)
8.3	Outlet characteristics	Proportion with govt inspection/ supervision: Proportion of outlets who have received a government inspection/ supervision in the last year (note this question should be tailored to country-specific policy or process on regulation of each private sector outlet type included e.g. pharmacy regulatory bodies and their inspection process)
9.1	Staff characteristics	Staff health qualifications: Proportion of outlets with at least one member of staff with selected health qualifications (pharmacist, CHW, etc.)
9.2	Staff characteristics	Staff malaria training: Proportion of outlets with at least one member of staff who have received any training on malaria; by training type/ topic (treatment, diagnosis, monitoring/ surveillance, all, or other) in the last 12 months
10.1	Quality Control & Compliance 	Proportion of products that meet a minimum quality standard (within expiration date, has expected/ nationally mandated registration number(s) and any other quality criteria relevant to the given country of implementation) 
10.2	Quality Control & Compliance 	Proportion of outlets that meet a minimum quality standard for product storage (dry, dark area off floor)
11.1	Respondent malaria knowledge	Proportion of respondents who identify an ACT (or specific front-line treatment(s)) as the most effective drug for uncomplicated malaria 
11.2	Respondent malaria knowledge	Proportion of respondents who have heard of and used an RDT for malaria 
11.3	Respondent malaria knowledge	"Proportion of respondents who report requesting evidence of confirmed malaria (e.g., test result, prescription, or referral) from a customer or patient before selling antimalarials.

Note: In many contexts, antimalarials are available over the counter and national policies may not require confirmation of a malaria diagnosis prior to dispensing. However, in alignment with WHO guidelines for malaria (2021), which recommend test-based treatment of malaria before administering antimalarials, this indicator is used to assess provider adherence to best practice."
11.4	Respondent malaria knowledge	Proportion of respondents who would provide an antimalarial to a client IF they had a negative malaria blood test and reasons WHY
12.1	Outlet tech/ digital access & use	Proportion of outlets with functional infrastructure and technology available for the 30 days preceding the interview (where infrastructure includes water, electricity; technology includes internet, phone, tablet/ computer. These may be edited based on needs or expectations in a given country of implementation e.g. countries doing tablet based surveillance)
13.1	Outlet participation in monitoring	Proportion of outlets that report any information on malaria cases
13.2	Outlet participation in monitoring by reporting system	Proportion of outlets that report in to selected reporting systems or using selected forms (expected information systems or forms used to capture data from the private sector should be defined for each country of implementation (e.g. IDSR, HMIS, DHIS2, project-specific NGO lead reporting etc.)
14.1	Business practices	Proportion of outlets acting as wholesalers (i.e. outlets that report selling antimalarials or RDTs to be resold at another outlet/sells wholesale)
14.2	Business practices	Proportion of outlets that sell antimalarials or RDTs online
14.3	Business practices	Customer types:  Proportion of malaria commodities sold to each customer type (e.g. local retail customers, online retail, other retail businesses, other resale/ wholesale businesses)
14.4	Business practices	Supplier types:  Proportion of malaria commodities purchased from each supplier type (e.g. pharmacy, wholesale, importer, manufacture, etc.)
14.5	Business practices	Distribution methods: Proportion of outlets reporting use various methods (pick-up, delivery, third-party carriers) to distribute antimalarials or RDTs to customers
14.6	Business practices	Procurement methods: Proportion of outlets reporting use of various  methods (pick-up, delivery, third-party carriers) to receive antimalarials or RDTs from suppliers
14.7	Business practices	Payment terms: Proportion of outlets reporting using different method of payment for antimalarials (e.g. cash, credit, etc.) to purchase from suppliers
14.8	Business practices	Perception of the stability of the wholesale market: Proportion of outlets reporting perceived market instability or fluctuations (e.g. stock outs, price changes) that impact their purchasing practices 
	
	
	
	
	
