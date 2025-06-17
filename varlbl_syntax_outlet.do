*source: [INSERT SOURCE, EG: SurveyCTO]
*last updated [INSERT DATE]

*THIS FILE LABELS THE VARIABLES IN THE OUTLET DATASET. THIS SET OF 
*VARIABLES AND LABELS MAY BE OUTPUTTED DIRECTLY FROM THE DATA COLLECTION SOFTWARE. 

*THE BELOW LABELS ARE EXAMPLES (FROM THE TOOLKIT STANDARD FORM) AND SHOULD BE EDITED. 

	*yes/no
	label define ynlbl 1 "Yes" 0 "No"

	*yes/no/dk
	label define yndlbl 1 "Yes" 0 "No" 98 "Don't know"
	
	*yes/no/dk/na
	label define yndnlbl 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"

	
	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable date ". Confirm today's date:"
	note date: ". Confirm today's date:"

	label variable team "1. Field team"
	note team: "1. Field team"
	label define team 51 "TEAM 1" 52 "TEAM 2" 53 "TEAM 3" 54 "TEAM 4"
	label values team team

	label variable c1a "2. Your name"
	note c1a: "2. Your name"
	label define c1a 1 "NAME 1" 2 "NAME 2" 3 "NAME 3" 4 "NAME 4" 5 "NAME 5" 6 "NAME 6" 7 "NAME 7" 8 "NAME 8" 9 "NAME 9" 10 "NAME 10" 11 "NAME 11" 12 "NAME 12" 13 "NAME 13" 14 "NAME 14" 15 "NAME 15" 16 "NAME 16"
	label values c1a c1a

	label variable c2 "3. State"
	note c2: "3. State"
	label define c2 1 "Administrative area level 1 - Name A" 2 "Administrative area level 1 - Name B" 3 "Administrative area level 1 - Name C"
	label values c2 c2

	label variable c3 "4. Local government area"
	note c3: "4. Local government area"
	label define c3 11 "Administrative area level 2 - Name 1" 12 "Administrative area level 2 - Name 2" 13 "Administrative area level 2 - Name 3" 14 "Administrative area level 2 - Name 4" 15 "Administrative area level 2 - Name 5" 16 "Administrative area level 2 - Name 6" 17 "Administrative area level 2 - Name 7" 18 "Administrative area level 2 - Name 8" 115 "Administrative area level 2 - Name 9" 201 "Administrative area level 2 - Name 10" 202 "Administrative area level 2 - Name 11" 203 "Administrative area level 2 - Name 12" 204 "Administrative area level 2 - Name 13" 205 "Administrative area level 2 - Name 14" 206 "Administrative area level 2 - Name 15" 207 "Administrative area level 2 - Name 16" 208 "Administrative area level 2 - Name 17"
	label values c3 c3

	label variable c4 "5. Ward"
	note c4: "5. Ward"
	label define c4 211126 "Cluster 1" 204105 "Cluster 2" 211127 "Cluster 3" 107054 "Cluster 4" 311257 "Cluster 5" 101001 "Cluster 6" 102011 "Cluster 7" 206115 "Cluster 8" 213140 "Cluster 9" 209121 "Cluster 10" 217145 "Cluster 11" 102012 "Cluster 12" 204106 "Cluster 13" 211129 "Cluster 14" 218155 "Cluster 15" 204107 "Cluster 16" 211130 "Cluster 17" 221166 "Cluster 18" 217146 "Cluster 19" 217147 "Cluster 20" 104037 "Cluster 21" 103022 "Cluster 22" 316267 "Cluster 23" 315266 "Cluster 24" 225175 "Cluster 25" 101002 "Cluster 26" 311259 "Cluster 27" 113079 "Cluster 28" 308242 "Cluster 29" 206116 "Cluster 30" 317268 "Cluster 31" 217148 "Cluster 32" 215142 "Cluster 33"
	label values c4 c4

	label variable auditlevel "6. Is this a retail outlet or wholesale outlet?"
	note auditlevel: "6. Is this a retail outlet or wholesale outlet?"
	label define auditlevel 1 "Retail" 2 "Wholesale"
	label values auditlevel auditlevel

	label variable c7_r "6A. Type of outlet"
	note c7_r: "6A. Type of outlet"
	label define c7_r 1 "For-profit facility/ clinic" 4 "Laboratory" 11 "Pharmacy or dispensary" 20 "Drug shop" 22 "Retail shop" 25 "Street vendor" 26 "At home" 96 "Other"
	label values c7_r c7_r

	label variable c7_ws "6B. Type of wholesaler"
	note c7_ws: "6B. Type of wholesaler"
	label define c7_ws 30 "Importer" 31 "Manufacturer" 32 "Distributor" 11 "Pharmacy wholesale" 96 "Other"
	label values c7_ws c7_ws

	label variable c7_other "* Other, specify"
	note c7_other: "* Other, specify"

	label variable c6 "7. outlet/ business name"
	note c6: "7. outlet/ business name"

	label variable gpslatitude "8. GPS coordinates (latitude)"
	note gpslatitude: "8. GPS coordinates (latitude)"

	label variable gpslongitude "8. GPS coordinates (longitude)"
	note gpslongitude: "8. GPS coordinates (longitude)"

	label variable gpsaltitude "8. GPS coordinates (altitude)"
	note gpsaltitude: "8. GPS coordinates (altitude)"

	label variable gpsaccuracy "8. GPS coordinates (accuracy)"
	note gpsaccuracy: "8. GPS coordinates (accuracy)"

	label variable canscreen "Section 2: SCREENING AND ELIGIBILITY Now proceed into the outlet and introduce "
	note canscreen: "Section 2: SCREENING AND ELIGIBILITY Now proceed in to the outlet and introduce yourself and the study. Interviewer prompt: Hello, my name is \${c1b}. I work for [XXXXX]. We are conducting a study on the availability of antimalarial drugs and malaria screening services in outlet/ businesses like yours in [COUNTRY]. The results will help us improve the availability of appropriate drugs and treatment of malaria in [COUNTRY]. I would like to ask you some questions to see if you can participate in this study. If you are eligible, you are under no obligation to participate, as it is completely voluntary. I would also like to assure you that the answers you give will remain confidential. We won't pass on your details to the authorities, and you won't have to fear any reprisals. INTERVIEWER: Are you able to screen this outlet/ business for participation in the study?"
	label values canscreen ynlbl

	label variable cantscreen "INTERVIEWER Why are you not able to screen this outlet/business for eligibility"
	note cantscreen: "INTERVIEWER Why are you not able to screen this outlet/business for eligibility in the study?"
	label define cantscreen 1 "Outlet is permanently closed" 2 "Staff at outlet refused before screening could take place" 3 "There is no eligible respondent to complete the screening" 4 "Staff at outlet request we come back later for screening" 5 "***Outlet is closed at the time of visit***" 6 "***Outlet has been closed at the time of ALL 3 VISITS and could not be screened*" 96 "Other reason"
	label values cantscreen cantscreen

	label variable cantscreen_other "Specify other reason:"
	note cantscreen_other: "Specify other reason:"

	label variable s3 "1. Do you have any antimalarial medicine in stock today?"
	note s3: "1. Do you have any antimalarial medicine in stock today?"
	label values s3 ynlbl

	label variable s5a "2. Is malaria microscopy screening available here today?"
	note s5a: "2. Is malaria microscopy screening available here today?"
	label values s5a ynlbl

	label variable s5b "3. Are malaria rapid diagnostic tests (RDTs) available here today?"
	note s5b: "3. Are malaria rapid diagnostic tests (RDTs) available here today?"
	label values s5b ynlbl

	label variable s4 "4. Are there any antimalarials that are out of stock today, but that you have of"
	note s4: "4. Are there any antimalarials that are out of stock today, but that you have offered for sale in the last 3 months?"
	label values s4 yndnlbl

	label variable s6 "5. Have you stocked any malaria rapid diagnostic tests (RDTs) in the last 3 mont"
	note s6: "5. Have you stocked any malaria rapid diagnostic tests (RDTs) in the last 3 months ?"
	label values s6 yndnlbl

	label variable retws1 "6. Does this [outlet or business] sell antimalarials or RDT to other outlets tha"
	note retws1: "6. Does this [outlet or business] sell antimalarials or RDT to other outlets that re-sell the products?"
	label values retws1 yndlbl

	label variable retws_confirmdk "Are you sure that no one at this outlet/ business knows if the outlet/ business "
	note retws_confirmdk: "Are you sure that no one at this outlet/ business knows if the outlet/ business sells antimalarials or RDTs to other outlet/ business, bussineses, or health facilities (i.e. for resale)?"
	label values retws_confirmdk ynlbl

	label variable consented "7. INTERVIEWER Did you obtain the consent of the participant?"
	note consented: "7. INTERVIEWER Did you obtain the consent of the participant?"
	label define consented 1 "Yes" 97 "No - the provider refused" 99 "No - a provider was not available or the time is not suitable"
	label values consented consented

	label variable c10 "8. If the provider refused, why?"
	note c10: "8. If the provider refused, why?"
	label define c10 1 "Client load/ crowded with customers" 2 "Thinks it is an inspection or afraid for their permit/ licence" 3 "Not interested" 7 "No reason provided" 96 "Other reason"
	label values c10 c10

	label variable c10_other "Specify other reason"
	note c10_other: "Specify other reason"

	label variable p0 "1. Approximately when is this outlet usually open?"
	note p0: "1. Approximately when is this outlet usually open?"

	label variable p0_other "Opening hours - other specify:"
	note p0_other: "Opening hours - other specify:"

	lab var p0_1 "Outlet open during the day (morning-evening)"
	lab var p0_2 "Outlet open during the evening only"
	lab var p0_3 "Outlet open 24 hrs"
	
	label variable char2 "2. Do you know what year this outlet/ business was established?"
	note char2: "2. Do you know what year this outlet/ business was established?"

	label variable char4 "3. How many people work here?"
	note char4: "3. How many people work here?"

	label variable reg1 "4. Does this outlet have the correct license/ registration to sell medicines her"
	note reg1: "4. Does this outlet have the correct license/ registration to sell medicines here?"
	label define reg1 1 "YES - the repondent REPORTS having this licence" 2 "YES - the repondent REPORTS and you have OBSERVED the licence" 0 "NO - the respondent reports NOT having the licence" 97 "Respondent refused to answer" 98 "Respondent does not know" 99 "NOT APPLICABLE- this outlet type does not require this MoH agreement"
	label values reg1 reg1

	label variable reg2 "5. Has this establishment received a government inspection in the last year?"
	note reg2: "5. Has this establishment received a government inspection in the last year?"
	label values reg2 yndnlbl

	label variable reg2a "6. When was the last visit?"
	note reg2a: "6. When was the last visit?"

	label variable checkpoint1 "End of section 1 of X. CHECKPOINT 1 INTERVIEWER Are you able to continue the int"
	note checkpoint1: "End of section 1 of X. CHECKPOINT 1 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint1 ynlbl

	label variable p8 "1. Do you or anyone in this outlet/ business have any of the following health-re"
	note p8: "1. Do you or anyone in this outlet/ business have any of the following health-related qualifications? Select all that apply"

	label variable p8_other "Specify qualification(s)"
	note p8_other: "Specify qualification(s)"

	label variable char9 "2. Has any staff working at this outlet/ business received malaria-related train"
	note char9: "2. Has any staff working at this outlet/ business received malaria-related training in the last 2 years? Interviewer: If no, select none. If yes, please read all responses below and select all applicable:"

	label variable char9_other "Specify other purpose of training:"
	note char9_other: "Specify other purpose of training:"

	label variable checkpoint2 "End of section 2 of X. CHECKPOINT 2 INTERVIEWER Are you able to continue the int"
	note checkpoint2: "End of section 2 of X. CHECKPOINT 2 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint2 ynlbl

	label variable am_storage_1 "a. Are antimalarials stored in a dry area?"
	note am_storage_1: "a. Are antimalarials stored in a dry area?"
	label values am_storage_1 yndlbl

	label variable am_storage_2 "b. Are antimalarials protected from direct sunlight?"
	note am_storage_2: "b. Are antimalarials protected from direct sunlight?"
	label values am_storage_2 yndlbl

	label variable am_storage_3 "c. Are antimalarials kept on the floor?"
	note am_storage_3: "c. Are antimalarials kept on the floor?"
	label values am_storage_3 yndlbl

	label variable rdt_storage_1 "a. [Observe]: Are RDTs stored in a dry area?"
	note rdt_storage_1: "a. [Observe]: Are RDTs stored in a dry area?"
	label values rdt_storage_1 yndlbl

	label variable rdt_storage_2 "b. [Observe]: Are RDTs protected from direct sunlight?"
	note rdt_storage_2: "b. [Observe]: Are RDTs protected from direct sunlight?"
	label define rdt_storage_2 1 "Yes" 0 "No" 98 "Don't know"
	label values rdt_storage_2 yndlbl

	label variable rdt_storage_3 "c. [Observe]: Are RDTs kept on the floor?"
	note rdt_storage_3: "c. [Observe]: Are RDTs kept on the floor?"
	label values rdt_storage_3 yndlbl

lab var d1 "Outlet has gloves available"
	note d1: "3. Does this outlet/facility have disposable gloves available today for staff to use when seeing customers/patients?"
	label values d1 yndnlbl

	lab var d2 "Outlet has sharps container available"
	note d2: "4. Does this outlet/facility have a sharps container, also called a sharps disposal box or safety box, available today for staff to use?"
	label values d2 yndnlbl

	label variable checkpoint3 "End of section 3 of X. CHECKPOINT 3 INTERVIEWER Are you able to continue the int"
	note checkpoint3: "End of section 3 of X. CHECKPOINT 3 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint3 ynlbl

	label variable p16_name "Generic name:"
	note p16_name: "Generic name:"
	label define p16_name 9 "Amodiaquine" 6 "Artemether" 1 "Artemether-lumefantrine (eg. Coartem, L-Artem)" 7 "Artemisinine" 8 "Artesunate" 2 "Artesunate-amodiaquine" 4 "Artesunate-SP" 10 "Chloroquine" 5 "ACT (artemisinin combination therapies)" 3 "Dihydroartemisinine-piperaquine" 11 "Quinine" 12 "Sulfadoxine-pyrimethamine (eg. Fansidar, SP)" 95 "Not an antimalarial" 96 "Other" 98 "Don't know"
	label values p16_name p16_name

	label variable p16_form "Dosage form:"
	note p16_form: "Dosage form:"
	label define p16_form 1 "Tablet" 2 "Suppository" 3 "Granule" 4 "Syrup" 5 "Suspension" 6 "Liquid Injectable" 7 "Powder Injectable" 8 "Drops" 96 "Other" 97 "Not applicable"
	label values p16_form p16_form

	label variable p16_name_oth "Other, specify:"
	note p16_name_oth: "Other, specify:"

	label variable p21 "9. Have you ever seen or heard of a malaria rapid diagnostic test (RDT)?"
	note p21: "9. Have you ever seen or heard of a malaria rapid diagnostic test (RDT)?"
	label values p21 yndnlbl

	label variable p22 "10. While working at this outlet/ business, have you ever tested a client for ma"
	note p22: "10. While working at this outlet/ business, have you ever tested a client for malaria using an RDT?"
	label values p22 yndnlbl

	label variable p25 "11. Is a prescription or positive malaria test result required to purchase an an"
	note p25: "11. Is a prescription or positive malaria test result required to purchase an antimalarial at this outlet?"
	label values p25 yndnlbl

	label variable p23 "12. Would you recommend that a patient/client take an antimalarial drug if the r"
	note p23: "12. Would you recommend that a patient/client take an antimalarial drug if the rapid diagnostic test is negative for malaria?"
	label define p23 1 "Yes, sometimes" 2 "Yes, always" 3 "No, never" 98 "Don't know"
	label values p23 p23

	label variable p24 "13. Under what circumstances would you recommend that a patient/client take an a"
	note p24: "13. Under what circumstances would you recommend that a patient/client take an antimalarial drug after a negative RDT test for malaria?"

	label variable p24_other "Other circumstances"
	note p24_other: "Other circumstances"

	label variable checkpoint4 "End of section 4 of X. CHECKPOINT 4 INTERVIEWER Are you able to continue the int"
	note checkpoint4: "End of section 4 of X. CHECKPOINT 4 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint4 ynlbl

	lab var dig0 "past 30 days: running water"
	note dig0: "10. In the past 30 days, did this outlet/ business have running water?"
	label values dig0 yndnlbl

	lab var dig1 "past 30 days: electicity"
	label define dig1 1 "Yes - available AND functioning" 2 "Available; NOT functioning" 0 "NO - not available"
	label values dig1 dig1

	lab var dig2 "past 30 days: phone"
	note dig2: "12. In the past 30 days, did this outlet/ business have access to any phone?"
	label define dig2 1 "Yes - available AND functioning" 2 "Available; NOT functioning" 0 "NO - not available"
	label values dig2 dig2

	label variable dig2b "13. What type of phone?"
	note dig2b: "13. What type of phone?"

	label variable dig2c "14. In the past 30 days, did this outlet/ business have network for voice and SM"
	note dig2c: "14. In the past 30 days, did this outlet/ business have network for voice and SMS?"
	label define dig2c 1 "Yes - available AND functioning" 2 "Available; NOT functioning" 0 "NO - not available"
	label values dig2c dig2c

	label variable dig2d "15. Select which of the following applications/ services you have used on this p"
	note dig2d: "15. Select which of the following applications/ services you have used on this phone in the last 30 days:"

	lab var dig3 "past 30 days: internet access"
	note dig3: "16. In the past 30 days, did this outlet/ business have internet connection (WiFi or fixed)?"
	label define dig3 1 "Yes - available AND functioning" 2 "Available; NOT functioning" 0 "NO - not available"
	label values dig3 dig3

	lab var dig4 "past 30 days: tablets/computers"
	note dig4: "17. What type of Internet connection do you use most often to connect to the Internet?"
	label define dig4 1 "Mobile data" 2 "Wi-fi"
	label values dig4 dig4

	label variable dig5 "18. In the past 30 days, did this outlet/ business have access to any tablets or"
	note dig5: "18. In the past 30 days, did this outlet/ business have access to any tablets or computers?"
	label define dig5 1 "Yes - available AND functioning" 2 "Available; NOT functioning" 0 "NO - not available"
	label values dig5 dig5

	label variable dig5b "19. What types of tablets or computers does this outlet/ business have?"
	note dig5b: "19. What types of tablets or computers does this outlet/ business have?"

	label variable dig7_0 "20. For each of the following business activities, identify if you currently use"
	note dig7_0: "20. For each of the following business activities, identify if you currently use digital technology, would like to digitize, or are not interested in digitizing the activity. (Digital technology includes computers, tablets and smartphones with an internet connection)"
	label define dig7_lbl 1 "Uses now" 2 "Not now but wants to" 3 "Not now & not interested" 98 "Don't know" 97 "Refused"
	label values dig7_0 dig7_1 dig7_2 dig7_3 dig7_4 dig7_5 dig7_lbl

	label variable dig7_1 "Managing sales"
	note dig7_1: "Managing sales"
	
	label variable dig7_2 "Managing stock"
	note dig7_2: "Managing stock"
	
	label variable dig7_3 "Placing orders with your suppliers"
	note dig7_3: "Placing orders with your suppliers"
	
	label variable dig7_4 "Paying your suppliers"
	note dig7_4: "Paying your suppliers"
	
	label variable dig7_5 "Managing human resources (e.g. payroll, schedule)"
	note dig7_5: "Managing human resources (e.g. payroll, schedule)"
	
		 
	foreach v of varlist dig7_1 dig7_2 dig7_3 dig7_4 dig7_5  {
	local varlabel :  var label `v'
	 
		gen `v'_uses=0
		recode `v'_uses (0=1) if `v'==1
		lab var `v'_uses "Already uses digital `varlabel'"
		 
		gen `v'_future=0
		recode `v'_future (0=1) if `v'==2
		lab var `v'_future "Wants digital `varlabel' in future"
		 
		gen `v'_no=0
		recode `v'_no (0=1) if inlist(`v',3,97,98)
		lab var `v'_no "Not interested `varlabel'"
	}
	 
	
	label variable dig7b "21. Do you carry out any other types of business activities using digital techno"
	note dig7b: "21. Do you carry out any other types of business activities using digital technology?"
	label values dig7b yndnlbl

	label variable dig7bi "22. Specify other activities:"
	note dig7bi: "22. Specify other activities:"

	label variable checkpoint5 "End of section 5 of X. CHECKPOINT 5 INTERVIEWER Are you able to continue the int"
	note checkpoint5: "End of section 5 of X. CHECKPOINT 5 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint5 ynlbl

	label variable data1 "1. Do you report malaria case data each month?"
	note data1: "1. Do you report malaria case data each month?"
	label values data1 yndnlbl

	label variable data2 "2. What forms and tools do you use to report malaria-related data to higher leve"
	note data2: "2. What forms and tools do you use to report malaria-related data to higher levels of the health system?"

	lab var data2_1 "Reports directly to government"
	lab var data2_2 "Reports directly to DHIS2 platform"
	lab var data2_3 "Reports to specific project/ NGO"
	lab var data2_96 "Reports: Other"
	
	label variable data2b "Other forms and tools used to report data:"
	note data2b: "Other forms and tools used to report data:"

	gen data3_1 =0
	recode data3_1 (0=1) if inlist(data3,1,2,3)
	lab var data3_1 "Last supervisory visit in prev 6 months"
	
	label variable checkpoint6 "End of section 6 of X. CHECKPOINT 6 INTERVIEWER Are you able to continue the int"
	note checkpoint6: "End of section 6 of X. CHECKPOINT 6 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint6 ynlbl

	label variable retonline "1. Does this outlet/ business sell antimalarials or RDTs online?"
	note retonline: "1. Does this outlet/ business sell antimalarials or RDTs online?"
	label values retonline yndnlbl

	label variable p30 "3. How many retail customers did you sell antimalarials/RDTs to in the last 7 da"
	note p30: "3. How many retail customers did you sell antimalarials/RDTs to in the last 7 days?"

	label variable p31 "4. How many wholesale customers did you sell antimalarials/RDTs to in the last 7"
	note p31: "4. How many wholesale customers did you sell antimalarials/RDTs to in the last 7 days?"

	label variable p32_0 "5. Which of the following types of clients or businesses do you sell antimalaria"
	note p32_0: "5. Which of the following types of clients or businesses do you sell antimalarials/RDTs to?"
	label values p32_0 yndlbl

	label variable p32_1 "Individual customers/ clients (i.e. retail only - for consumption not for re-sal"
	note p32_1: "Individual customers/ clients (i.e. retail only - for consumption not for re-sale)"
	label values p32_1 yndlbl

	label variable p32_3 "Terminal wholesalers (e.g. pharmacies, health facilties, etc.) who sell to indiv"
	note p32_3: "Terminal wholesalers (e.g. pharmacies, health facilties, etc.) who sell to indivdual clients ONLY"
	label values p32_3 yndlbl

	label variable p32_4 "Intermediate wholesalers (i.e. outlets/ busineses who supply other outlets/busin"
	note p32_4: "Intermediate wholesalers (i.e. outlets/ busineses who supply other outlets/businesses - e.g. pharmacies who sell to drug shops, wholesalers)"
	label values p32_4 yndlbl

	label variable p32_2 "Individual customers ONLINE"
	note p32_2: "Individual customers ONLINE"
	label values p32_2 yndlbl

	label variable p32_5 "Sell wholesale ONLINE"
	note p32_5: "Sell wholesale ONLINE"
	label values p32_5 yndlbl

	label variable p32_6 "Other"
	note p32_6: "Other"
	label values p32_6 yndlbl

	label variable p32b "Specify other customers:"
	note p32b: "Specify other customers:"

	label variable p34 "6. Can you estimate the proportion of antimalarials/RDTs you sell to each custom"
	note p34: "6. Can you estimate the proportion of antimalarials/RDTs you sell to each customer type in the last year? Report the estimated propotions by volume not cost"
	label values p34 ynlbl

	label variable p34b_1 "Individual customers/ clients (i.e. retail only - for consumption not for re-sal"
	note p34b_1: "Individual customers/ clients (i.e. retail only - for consumption not for re-sale)"

	label variable p34b_3 "Terminal wholesalers (e.g. pharmacies, health facilties, etc. who sell to indivd"
	note p34b_3: "Terminal wholesalers (e.g. pharmacies, health facilties, etc. who sell to indivdual clients ONLY"

	label variable p34b_4 "Intermediate wholesalers (i.e. outlets/ busineses who supply other outlets/busin"
	note p34b_4: "Intermediate wholesalers (i.e. outlets/ busineses who supply other outlets/businesses - e.g. pharmacies who sell to drug shops, wholesalers)"

	label variable p34b_2 "Individual customers ONLINE"
	note p34b_2: "Individual customers ONLINE"

	label variable p34b_5 "Sell wholesale ONLINE"
	note p34b_5: "Sell wholesale ONLINE"

	label variable p34b_6 "Other"
	note p34b_6: "Other"

	label variable l1_1 "8. You sell to TERMINAL WHOLESALERS who sell to individual clients ONLY: What ty"
	note l1_1: "8. You sell to TERMINAL WHOLESALERS who sell to individual clients ONLY: What types of TERMINAL WHOLESALERS do you sell to?"

	label variable l2_1 "9. You sell to INTERMEDIATE WHOLESALERS who sell to other businesses, not to pat"
	note l2_1: "9. You sell to INTERMEDIATE WHOLESALERS who sell to other businesses, not to patients/ individual customers: What types of outlets/ businesses/ providers that re-sell your products do you sell to?"

	label variable ind_0 "10. Where are your customers located? i.e where do they come from to buy your pr"
	note ind_0: "10. Where are your customers located? i.e where do they come from to buy your products?"

	label variable l1_3 "11. How do you distribute your antimalarials/RDTs products ?"
	note l1_3: "11. How do you distribute your antimalarials/RDTs products ?"

	label variable l1_3b "Specify other distribution method(s):"
	note l1_3b: "Specify other distribution method(s):"

	label variable sa1 "1. Suppliers How many different suppliers have you purchased antimalarials and/o"
	note sa1: "1. Suppliers How many different suppliers have you purchased antimalarials and/or RDTs from in the last 3 months?"

	label variable sa2_0 "2. What types of suppliers does this outlet/ business use to purchase antimalari"
	note sa2_0: "2. What types of suppliers does this outlet/ business use to purchase antimalarials and/or RDTs?"
	label values sa2_0 yndlbl

	lab var sa2_1 "Type of supplier: Importer"	
	note sa2_1: "AM  Importer"
	label values sa2_1 yndlbl

	label variable sa2_2 "INTERNATIONAL manufacturer"
	note sa2_2: "INTERNATIONAL manufacturer"
	label values sa2_2 yndlbl

	label variable sa2_3 "LOCAL manufacturer"
	note sa2_3: "LOCAL manufacturer"
	label values sa2_3 yndlbl

	label variable sa2_4 "Distributor"
	note sa2_4: "Distributor"
	label values sa2_4 yndlbl

	label variable sa2_5 "Pharmacy"
	note sa2_5: "Pharmacy"
	label values sa2_5 yndlbl

	label variable sa2_6 "Public sector supply chain"
	note sa2_6: "Public sector supply chain"
	label values sa2_6 yndlbl

	label variable sa2_7 "Other private outlet/ shop"
	note sa2_7: "Other private outlet/ shop"
	label values sa2_7 yndlbl

	label variable sa2_8 "Any other source"
	note sa2_8: "Any other source"
	label values sa2_8 yndlbl
	
	label variable sa2b "Other type of supplier?"
	note sa2b: "Other type of supplier?"
	
	label variable sa3 "3. Can you estimate the proportion of antimalarials and/or RDTs you get from eac"
	note sa3: "3. Can you estimate the proportion of antimalarials and/or RDTs you get from each supplier type?"
	label values sa3 ynlbl

	label variable sa3b_1 "Importer"
	note sa3b_1: "Importer"

	label variable sa3b_2 "INTERNATIONAL manufacturer"
	note sa3b_2: "INTERNATIONAL manufacturer"

	label variable sa3b_3 "LOCAL manufacturer"
	note sa3b_3: "LOCAL manufacturer"

	label variable sa3b_4 "Distributor"
	note sa3b_4: "Distributor"

	label variable sa3b_5 "Pharmacy"
	note sa3b_5: "Pharmacy"

	label variable sa3b_6 "Public sector supply chain"
	note sa3b_6: "Public sector supply chain"

	label variable sa3b_7 "Other private outlet/ shop"
	note sa3b_7: "Other private outlet/ shop"

	label variable sa3b_8 "Any other source"
	note sa3b_8: "Any other source"

	label variable sa4 "2. How do you most often receive your antimalarials and/ or RDTs from supplier(s"
	note sa4: "2. How do you most often receive your antimalarials and/ or RDTs from supplier(s)?"
	label define sa4 1 "The supplier delivers to you" 2 "You pick up the product from the supplier" 3 "Both above situations" 97 "Refuse to answer" 98 "Don't Know"
	label values sa4 sa4

	label variable sa5 "3. What are the common methods of payment to your suppliers for antimalarials an"
	note sa5: "3. What are the common methods of payment to your suppliers for antimalarials and/or RDTs?"

	lab var sa5_1 "Pays suppliers using cash"
	lab var sa5_2 "Pays suppliers using debit/credit card"
	lab var sa5_3 "Pays suppliers using check"
	lab var sa5_4 "Pays suppliers using mobile money"
	lab var sa5_96 "Pays suppliers using other"
	
	label variable sa5_other "Other payment method"
	note sa5_other: "Other payment method"

	label variable sa6 "4. Do you buy antimalarials and/or RDTs on credit from any supplier?"
	note sa6: "4. Do you buy antimalarials and/or RDTs on credit from any supplier?"
	label define sa6 1 "Yes" 0 "No" 97 "Refuse to answer" 98 "Don't know"
	label values sa6 sa6

	label variable sa7 "5. What are the most common credit terms, in terms of number of days to settle p"
	note sa7: "5. What are the most common credit terms, in terms of number of days to settle payment?"

	label variable sa11 "6. What brand of antimalarial do you sell to individual clients or use most ofte"
	note sa11: "6. What brand of antimalarial do you sell to individual clients or use most often at this facilty/outlet?"

	label variable sa12 "Switched supplier due to stockout"
	note sa12: "7. In the past 12 months, did you ever have to use another supplier for because your regular supplier did not have it in stock?"
	label values sa12 yndnlbl

	label variable sa13 "8. In the past 12 months, how has the price to purchase \${sa11} changed?"
	note sa13: "8. In the past 12 months, how has the price to purchase \${sa11} changed?"
	label define sa13 1 "Generally stable" 2 "Changed every 6 months" 3 "Changed every 3 months" 4 "Changed every month" 5 "Changed every 2 weeks" 6 "Changed every week" 7 "More frequently" 98 "Don't know"
	label values sa13 sa13

	label variable sa14 "9. In your opinion, what is the main reason for price changes over the past 12 m"
	note sa14: "9. In your opinion, what is the main reason for price changes over the past 12 months?"
	label define sa14 6 "Inflation / exchange rate" 3 "Competition form other products" 1 "Product scarcity" 2 "Changes in wholesaler margins" 5 "Taxes (income tax, customs)" 96 "Other"
	label values sa14 sa14

	label variable sa14_other "Specify other reasons for price changes:"
	note sa14_other: "Specify other reasons for price changes:"

	label variable sa15 "10. Think about your \${sa11} purchases over the last 12 months. Have prices bee"
	note sa15: "10. Think about your \${sa11} purchases over the last 12 months. Have prices been less stable, about the same, or more stable than in the past two years?"
	label define sa15 1 "Less stable than the previous year" 2 "Unchanged" 3 "More stable than the previous year" 98 "Don’t know"
	label values sa15 sa15
	
	
	lab var sa5_1 "Pays suppliers using cash"
	lab var sa5_2 "Pays suppliers using debit/credit card"
	lab var sa5_3 "Pays suppliers using check"
	lab var sa5_4 "Pays suppliers using mobile money"
	lab var sa5_96 "Pays suppliers using other"
 
	
	lab var sa14_1 "Reason: Product scarcity"
	lab var sa14_2 "Reason: Changes in wholesaler margins"
	lab var sa14_3 "Reason: Competition from other products"
	lab var sa14_4 "Reason: Taxes"
	lab var sa14_5 "Reason: Inflation/ exchange rate changes"

	label variable ws1 "1. Do you import antimalarials?"
	note ws1: "1. Do you import antimalarials?"
	label values ws1 yndlbl

	label variable ws1b "2. Where do you import antimalarials from (include company names and countries w"
	note ws1b: "2. Where do you import antimalarials from (include company names and countries where possible)."

	label variable ws12 "3. In the past 3 months, have you given credit to wholesale customers who purcha"
	note ws12: "3. In the past 3 months, have you given credit to wholesale customers who purchased antimalarials?"
	label values ws12 yndlbl

	label variable ws13 "4. What are the most common terms of your credit in days?"
	note ws13: "4. What are the most common terms of your credit in days?"

	label variable ws5a "1. Does the owner of this business own any other stores or businesses that sell "
	note ws5a: "1. Does the owner of this business own any other stores or businesses that sell antimalarials or RDTs?"
	label define ws5a 1 "Yes" 0 "No" 97 "Refuse to answer" 98 "Don't know"
	label values ws5a ws5a

	label variable ws5b "2. What types of other stores or businesses does the owner own that sell antimal"
	note ws5b: "2. What types of other stores or businesses does the owner own that sell antimalarials or RDTs?"

	label variable ws5b_other "Specify other business type:"
	note ws5b_other: "Specify other business type:"

	label variable p_cmts "1. Interviewer: [OPTIONAL] Please add any other comments or description of their"
	note p_cmts: "1. Interviewer: [OPTIONAL] Please add any other comments or description of their customers, business practices, or distribution network here."

	label variable checkpoint7 "End of Section 7 of X. CHECKPOINT 7 INTERVIEWER Are you able to continue the int"
	note checkpoint7: "End of Section 7 of X. CHECKPOINT 7 INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint7 ynlbl

	label variable n1 "0. Antimalarial Audit Interviewer: Show the photo catalogue of antimalarials and"
	note n1: "0. Antimalarial Audit Interviewer: Show the photo catalogue of antimalarials and request to see the full range of antimalarials the outlet currently has in stock. Confirm the presence of at least one antimalarial at this outlet:"
	label values n1 ynlbl

	label variable n2 "During the screening section of this interview, the provider said antimalarials "
	note n2: "During the screening section of this interview, the provider said antimalarials were present. Please confirm the provider doesn't have any products physically available, or indicate here why there is a discrepancy in responses e.g. the provider doesn't want to show them, etc. Otherwise, go back and change your response to the previous question and continue with the audit."
	label define n2 1 "Yes, I confirm there are NO antimalarials present" 2 "The provider refused to show antimalarials present" 96 "Other reason"
	label values n2 n2

	label variable n2_other "Specify other reason:"
	note n2_other: "Specify other reason:"

	label variable amaudit_complete "15. [Don’t ask provider] Have you been able to record details for all the antima"
	note amaudit_complete: "15. [Don’t ask provider] Have you been able to record details for all the antimalarials that you know are available in the outlet today? ATTN: If **YOU** did not complete **ANY** audits using **THIS** form but your partner audited all antimalarials using their form, select **NO** here and select this reason on the next page."
	label define amaudit_complete 0 "Yes, full audit" 1 "No, audit was not started" 2 "No, audit was only partially completed"
	label values amaudit_complete amaudit_complete

	label variable amaudit_incomplete "Reason for incomplete audit:"
	note amaudit_incomplete: "Reason for incomplete audit:"

	label variable a16 "1. Are there any antimalarials that are out of stock today, but that you have ha"
	note a16: "1. Are there any antimalarials that are out of stock today, but that you have had in stock for the last 3 months?"
	label values a16 yndlbl

	label variable a17 "2. Which of the following types of antimalarials have been OUT OF STOCK in the l"
	note a17: "2. Which of the following types of antimalarials have been OUT OF STOCK in the last 3 months?"

	label variable a17_other "Specify other antimalarial(s) you had out of stock in the last 3 months:"
	note a17_other: "Specify other antimalarial(s) you had out of stock in the last 3 months:"

	label variable checkpoint_am "End of antimalarial audit. CHECKPOINT ANTIMALARIAL AUDIT INTERVIEWER Are you abl"
	note checkpoint_am: "End of antimalarial audit. CHECKPOINT ANTIMALARIAL AUDIT INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint_am ynlbl

	label variable d7 "1. Interviewer: [OBSERVE, ASK TO SEE]: Confirm the presence of at least one RDT "
	note d7: "1. Interviewer: [OBSERVE, ASK TO SEE]: Confirm the presence of at least one RDT at this outlet:"
	label values d7 ynlbl

	label variable d8 "2. During the screening section of this interview, the provider said RDTs were p"
	note d8: "2. During the screening section of this interview, the provider said RDTs were present. Please confirm the provider doesn't have any products physically available, or indicate here why there is a discrepancy in responses e.g. the provider doesn't want to show them, etc. Otherwise, go back and change your response to the previous question and continue with the audit."
	label define d8 1 "I confirm there are NO RDTs present" 2 "The provider refused to show RDTs present" 3 "Someone else on my team has completed or is completing the audit of RDTs here" 96 "Other reason"
	label values d8 d8

	label variable d8_other "Specify other reason:"
	note d8_other: "Specify other reason:"

	label variable rdtaudit_complete "14. Interviewer: Have you been able to record details for all the RDTs that you "
	note rdtaudit_complete: "14. Interviewer: Have you been able to record details for all the RDTs that you know are available in the outlet today? ATTN: If **YOU** did not complete **ANY** audits using **THIS** form but your partner audited all antimalarials using their form, select **NO** here and select this reason on the next page."
	label define rdtaudit_complete 0 "Yes, full audit" 1 "No, audit was not started" 2 "No, audit was only partially completed"
	label values rdtaudit_complete rdtaudit_complete

	label variable rdtaudit_incomplete "15. Reason for incomplete audit:"
	note rdtaudit_incomplete: "15. Reason for incomplete audit:"

	label variable d16 "1. Are there any RDTs that are sold out today, but that you have had in stock fo"
	note d16: "1. Are there any RDTs that are sold out today, but that you have had in stock for the last 3 months?"
	label define d16 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"
	label values d16 d16

	label variable d16_type "2. Which types of RDTs that are sold out today, have you had in stock for the la"
	note d16_type: "2. Which types of RDTs that are sold out today, have you had in stock for the last 3 months?"

	label variable d3 "1. Is malaria microscopy screening available here today?"
	note d3: "1. Is malaria microscopy screening available here today?"
	label values d3 ynlbl

	label variable d3b "During the screening section of this interview, the provider said micrsocopy scr"
	note d3b: "During the screening section of this interview, the provider said micrsocopy screening was available here today. Please confirm that microscopy screening isn't available today or go back and change your response to the previous question and continue with the audit."
	label define d3b 1 "I confirm malaria microscope screening is NOT available today"
	label values d3b d3b

	label variable d4 "2. How many people were tested for malaria at this facility/outlet using microsc"
	note d4: "2. How many people were tested for malaria at this facility/outlet using microscopy in the past 7 days?"

	label variable d5 "3. What is the total cost for a microscopy test for an adult?"
	note d5: "3. What is the total cost for a microscopy test for an adult?"

	label variable d6 "4. What is the total cost for a microscopy test for a child under 5 years of age"
	note d6: "4. What is the total cost for a microscopy test for a child under 5 years of age?"

	label variable checkpoint_rdt "End of blood testing audit. CHECKPOINT RDT AUDIT INTERVIEWER Are you able to con"
	note checkpoint_rdt: "End of blood testing audit. CHECKPOINT RDT AUDIT INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint_rdt ynlbl

	label variable sa1a "Thinking again about your main suppliers for malaria commodities, are you able t"
	note sa1a: "Thinking again about your main suppliers for malaria commodities, are you able to share specific details about your main suppliers such as name and location? We will use this information to conduct additional surveys of businesses and outlets that supply malaria commodities."
	label values sa1a ynlbl

	label variable checkpoint_supp "End of Supplier Details Module. CHECKPOINT SUPPLIER DETAILS INTERVIEWER Are you "
	note checkpoint_supp: "End of Supplier Details Module. CHECKPOINT SUPPLIER DETAILS INTERVIEWER Are you able to continue the interview, that is, this interview has not been interrupted?"
	label values checkpoint_supp ynlbl

	label variable c9 "Interviewer: : Record the result of the interview here:"
	note c9: "Interviewer: : Record the result of the interview here:"
	label define c9 1 "Interview complete" 99 "Interview interrupted (Time not convenient)" 97 "Interview interrupted (Provider refused to continue)" 96 "Other"
	label values c9 c9

	label variable status_other "Specify other survey result:"
	note status_other: "Specify other survey result:"

	label variable end3 "Interviewer: : Additional observations/comments by the interviewer"
	note end3: "Interviewer: : Additional observations/comments by the interviewer"

	
	
	lab var dig2d_3 "Phone app used: Mobile money"
	lab var dig2d_1 "Phone app used: SMS"
	lab var dig2d_2 "Phone app used: WhatsApp / Other messaging applications"
	lab var dig2d_4 "Phone app used: Call"

	lab var ind_0_1 "Customer location: From this community"
	lab var ind_0_2 "Customer location: From neighboring communities"
	lab var ind_0_3 "Customer location: From further away, but within this state"
	lab var ind_0_4 "Customer location: From other states in Nigeria"
	lab var ind_0_5 "Customer location: From other countries"
	lab var ind_0_6 "Customer location: Online/ from the internet"

	lab var online_2_1 "The outlet delivers to customers"
	lab var online_2_2 "Customers come to the outlet to pick them up"
	lab var  online_2_3 "Through third party carriers (eg. Delivery companies, courriers, etc.)"

	lab var p32_1 "Individual customers - retail only"
	lab var p32_3 "Terminal wholsalers"
	lab var p32_4 "Intermediate wholsalers"
