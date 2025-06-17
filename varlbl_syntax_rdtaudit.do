*source: [INSERT SOURCE, EG: SurveyCTO]
*last updated [INSERT DATE]

*THIS FILE LABELS THE VARIABLES IN THE RDT AUDIT DATASET. THIS SET OF VARIABLES
* AND LABELS MAY BE OUTPUTTED DIRECTLY FROM THE DATA COLLECTION SOFTWARE. 

*THE BELOW LABELS ARE EXAMPLES (FROM THE TOOLKIT STANDARD FORM) AND SHOULD BE EDITED. 


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable fillmethod2 "Do you want to search the database of common products or manually enter informat"
	note fillmethod2: "Do you want to search the database of common products or manually enter information for this product?"
	label define fillmethod2 1 "Search the database" 2 "Manually enter information"
	label values fillmethod2 fillmethod2

	label variable searchtextrdt "Enter all or part of the brand name"
	note searchtextrdt: "Enter all or part of the brand name"

	label variable rdtcode "Select the product you want to audit"
	note rdtcode: "Select the product you want to audit"

	label variable confirmrdt_search "12. Product details Brand: \${rdtBrand_search} Parasite(s): \${parasite_search} "
	note confirmrdt_search: "12. Product details Brand: \${rdtBrand_search} Parasite(s): \${parasite_search} Antigen(s): \${anti_search} Manufactured by: \${rdtManu_search} Confirm these details are correct:"
	label define confirmrdt_search 1 "Yes" 0 "No"
	label values confirmrdt_search confirmrdt_search

	label variable r1 "1. Brand name:"
	note r1: "1. Brand name:"

	label variable r3 "2. Parasite specie(s):"
	note r3: "2. Parasite specie(s):"
	label define r3 1 "Pf" 2 "Pf/Pan" 4 "Pf/Pv" 5 "Pan" 8 "Not indicated" 96 "Other"
	label values r3 r3

	label variable r2 "3. Antigen test(s):"
	note r2: "3. Antigen test(s):"
	label define r2 1 "HRP2" 2 "pLDH" 3 "HRP2/pLDH" 4 "HRP2/Aldolase" 8 "Not indicated" 96 "Other"
	label values r2 r2

	label variable r4 "4. Manufacturer:"
	note r4: "4. Manufacturer:"

	label variable r5code "5. [Observe]: Country of manufacture:"
	note r5code: "5. [Observe]: Country of manufacture:"
	label define r5code 5 "BELGIUM" 6 "BENIN" 7 "CAMEROON" 8 "CANADA" 1 "CHINA" 11 "COTE D'IVOIRE" 9 "CYPRUS" 14 "FRANCE" 4 "GERMANY" 15 "GHANA" 100 "GREECE" 2 "INDIA" 16 "ITALY" 17 "KENYA" 19 "MAURITIUS" 18 "MOROCCO" 20 "NIGERIA" 21 "PAKISTAN" 22 "PORTUGAL" 24 "SINGAPORE" 3 "SOUTH AFRICA" 10 "SOUTH KOREA" 12 "SPAIN" 25 "SWITZERLAND" 26 "TAIWAN" 27 "TOGO" 28 "TURKEY" 23 "UNITED KINGDOM" 13 "UNITED STATES" 29 "VIETNAM" 996 "Other" 998 "No country stated"
	label values r5code r5code

	label variable r5code_other "Specify other country:"
	note r5code_other: "Specify other country:"

	label variable self "6. [Observe]: Is this a self-test kit with buffer, pipette & lancet "
	note self: "6. [Observe]: Is this a self-administration test kit with its buffer, pipette and lancet?"
	label define self 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"
	label values self self

	label variable r13 "7. [Ask]: How many \${rdtBrand} sold/dist'd in last 7 days"
	note r13: "7. [Ask]: How many \${rdtBrand} tests has this outlet sold/ distributed /used in the last 7 days to individual consumers"

	label variable r14 "8. Has the \${rdtBrand} test been out of stock in the last 3 months?"
	note r14: "8. Has the \${rdtBrand} test been out of stock in the last 3 months?"
	label define r14 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"
	label values r14 r14

	label variable r15a "9. Do you or other staff use \${rdtBrand} to test customers in this outlet?"
	note r15a: "9. Do you or other staff use \${rdtBrand} to test customers in this outlet?"
	label define r15a 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"
	label values r15a r15a

	label variable r15b "10. What is the total cost to have a test conducted with the \${rdtBrand} RDT"
	note r15b: "10. What is the total cost to have a test conducted with the \${rdtBrand} RDT (including RDT cost and service fee) for An adult?"

	label variable r15c "A child under 5 years old?"
	note r15c: "A child under 5 years old?"

	label variable r16a "11. Does this outlet provide this brand of RDT for clients to take away for test"
	note r16a: "11. Does this outlet provide this brand of RDT for clients to take away for testing somewhere else?"
	label define r16a 1 "Yes" 0 "No" 98 "Don't know" 99 "Not applicable"
	label values r16a r16a

	label variable r16b "12. What is the cost of the \${rdtBrand} RDT for: An adult?"
	note r16b: "12. What is the cost of the \${rdtBrand} RDT for: An adult?"

	label variable r16c "A child under 5 years old?"
	note r16c: "A child under 5 years old?"

	label variable r17n "13. Most recent purchase, Number of \${rdtBrand} bought"
	note r17n: "13. For the outlet's most recent purchase of \${rdtBrand} RDTs, you bought: Number of RDTs:"

	label variable r17p "For a total price of:"
	note r17p: "For a total price of:"

