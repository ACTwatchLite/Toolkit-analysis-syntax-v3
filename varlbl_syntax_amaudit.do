*source: [INSERT SOURCE, EG: SurveyCTO]
*last updated [INSERT DATE]

*THIS FILE LABELS THE VARIABLES IN THE ANTIMALARIAL AUDIT DATASET. THIS SET OF 
*VARIABLES AND LABELS MAY BE OUTPUTTED DIRECTLY FROM THE DATA COLLECTION SOFTWARE. 

*THE BELOW LABELS ARE EXAMPLES (FROM THE TOOLKIT STANDARD FORM) AND SHOULD BE EDITED. 



	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable fillmethod "INTERVIEWER: Please select how you would like to select the product you are audi"
	note fillmethod: "INTERVIEWER: Please select how you would like to select the product you are auditing:"
	label define fillmethod 1 "Search the database" 2 "Manually enter information"
	label values fillmethod fillmethod

	label variable search_typ_am "Is this antimalarial a TABLET dose form?"
	note search_typ_am: "Is this antimalarial a TABLET dose form?"
	label define search_typ_am 1 "Yes" 0 "No" 98 "Don't know"
	label values search_typ_am search_typ_am

	label variable tabsearchtext "Enter all or part of the brand name"
	note tabsearchtext: "Enter all or part of the brand name"

	label variable tab_amcode "Select the product you want to audit"
	note tab_amcode: "Select the product you want to audit"

	label variable ntab_searchtext "Enter all or part of the brand name"
	note ntab_searchtext: "Enter all or part of the brand name"

	label variable ntab_amcode "Select the product you want to audit"
	note ntab_amcode: "Select the product you want to audit"

	label variable confirmam_search "Product details Dosage form: \${a3_lbl_search} Brand: \${brand_search} Active in"
	note confirmam_search: "Product details Dosage form: \${a3_lbl_search} Brand: \${brand_search} Active ingredient(s) and strength(s): \${ai1_lbl_search} - \${ai1_strength_search} \${ai2_lbl_search} - \${ai2_strength_search} \${ai3_lbl_search} - \${ai3_strength_search} Manufacturer: \${manu_search} Confirm these details are correct:"
	label define confirmam_search 1 "Yes" 0 "No"
	label values confirmam_search confirmam_search

	label variable a3_searchl_5_detail "What type of suspension:"
	note a3_searchl_5_detail: "What type of suspension:"
	label define a3_searchl_5_detail 1 "Liquid" 2 "Powder" 96 "Other"
	label values a3_searchl_5_detail a3_searchl_5_detail

	label variable a3_search_5_detail_other "Specify other dosage form:"
	note a3_search_5_detail_other: "Specify other dosage form:"

	label variable a3_manual "1. Dosage form:"
	note a3_manual: "1. Dosage form:"
	label define a3_manual 1 "Tablet" 2 "Suppository" 3 "Granule" 4 "Syrup" 5 "Suspension" 6 "Liquid Injectable" 7 "Powder Injectable" 8 "Drops" 96 "Other" 97 "Not applicable"
	label values a3_manual a3_manual

	label variable a3_manual_5_detail "What type of suspension:"
	note a3_manual_5_detail: "What type of suspension:"
	label define a3_manual_5_detail 1 "Liquid" 2 "Powder" 96 "Other"
	label values a3_manual_5_detail a3_manual_5_detail

	label variable a3_manual_5_detail_other "Specify other suspension form:"
	note a3_manual_5_detail_other: "Specify other suspension form:"

	label variable a3_manual_other "Specify other dosage form:"
	note a3_manual_other: "Specify other dosage form:"

	label variable brand_manual "2. Brand name:"
	note brand_manual: "2. Brand name:"

	label variable manu_manual "3. Manufacturer of \${brand_manual}"
	note manu_manual: "3. Manufacturer of \${brand_manual}"

	label variable ainum "4. How many active ingredients are in \${brand_manual} ?"
	note ainum: "4. How many active ingredients are in \${brand_manual} ?"

	label variable ai1_manual "5. Active ingredient 1 of \${brand_manual}"
	note ai1_manual: "5. Active ingredient 1 of \${brand_manual}"
	label define ai1_manual 60 "Amodiaquine" 63 "Arteether" 61 "Artemether" 62 "Artemisinin" 64 "Artemotil" 69 "Arterolane" 65 "Artesunate" 66 "Atovaquone" 67 "Chloroproguanil" 68 "Chloroquine" 70 "Dapsone" 71 "Dihydroartemisinin" 72 "Halofantrine" 73 "Hydroxychloroquine" 74 "Lumefantrine" 75 "Mefloquine" 76 "Naphthoquine" 77 "Piperaquine" 78 "Primaquine" 79 "Proguanil" 81 "Pyrimethamine" 80 "Pyronaridine" 82 "Quinacrine" 83 "Quinine" 85 "Sulfadoxine" 89 "Sulfalene" 86 "Sulfamethoxazole" 87 "Sulfamethoxypyrazine" 88 "Trimethoprim" 96 "Other" 98 "Don't Know"
	label values ai1_manual ai1_manual

	label variable ai1_mg_manual "6. Strength of \${ai1_manual_lbl} mg:"
	note ai1_mg_manual: "6. Strength of \${ai1_manual_lbl} mg:"

	label variable ai1_ml_manual "mL:"
	note ai1_ml_manual: "mL:"

	label variable ai2_manual "7. Active ingredient 2 of \${brand_manual}"
	note ai2_manual: "7. Active ingredient 2 of \${brand_manual}"
	label define ai2_manual 60 "Amodiaquine" 63 "Arteether" 61 "Artemether" 62 "Artemisinin" 64 "Artemotil" 69 "Arterolane" 65 "Artesunate" 66 "Atovaquone" 67 "Chloroproguanil" 68 "Chloroquine" 70 "Dapsone" 71 "Dihydroartemisinin" 72 "Halofantrine" 73 "Hydroxychloroquine" 74 "Lumefantrine" 75 "Mefloquine" 76 "Naphthoquine" 77 "Piperaquine" 78 "Primaquine" 79 "Proguanil" 81 "Pyrimethamine" 80 "Pyronaridine" 82 "Quinacrine" 83 "Quinine" 85 "Sulfadoxine" 89 "Sulfalene" 86 "Sulfamethoxazole" 87 "Sulfamethoxypyrazine" 88 "Trimethoprim" 96 "Other" 98 "Don't Know"
	label values ai2_manual ai2_manual

	label variable ai2_mg_manual "8. Strength of \${ai2_manual_lbl} mg:"
	note ai2_mg_manual: "8. Strength of \${ai2_manual_lbl} mg:"

	label variable ai2_ml_manual "mL:"
	note ai2_ml_manual: "mL:"

	label variable ai3_manual "9. Active ingredient 3 of \${brand_manual}"
	note ai3_manual: "9. Active ingredient 3 of \${brand_manual}"
	label define ai3_manual 60 "Amodiaquine" 63 "Arteether" 61 "Artemether" 62 "Artemisinin" 64 "Artemotil" 69 "Arterolane" 65 "Artesunate" 66 "Atovaquone" 67 "Chloroproguanil" 68 "Chloroquine" 70 "Dapsone" 71 "Dihydroartemisinin" 72 "Halofantrine" 73 "Hydroxychloroquine" 74 "Lumefantrine" 75 "Mefloquine" 76 "Naphthoquine" 77 "Piperaquine" 78 "Primaquine" 79 "Proguanil" 81 "Pyrimethamine" 80 "Pyronaridine" 82 "Quinacrine" 83 "Quinine" 85 "Sulfadoxine" 89 "Sulfalene" 86 "Sulfamethoxazole" 87 "Sulfamethoxypyrazine" 88 "Trimethoprim" 96 "Other" 98 "Don't Know"
	label values ai3_manual ai3_manual

	label variable ai3_mg_manual "10. Strength of \${ai3_manual_lbl} mg:"
	note ai3_mg_manual: "10. Strength of \${ai3_manual_lbl} mg:"

	label variable ai3_ml_manual "mL:"
	note ai3_ml_manual: "mL:"

	label variable amcountry "1. Country of manufacture for \${brand}"
	note amcountry: "1. Country of manufacture for \${brand}"
	label define amcountry 5 "BELGIUM" 6 "BENIN" 7 "CAMEROON" 8 "CANADA" 1 "CHINA" 11 "COTE D'IVOIRE" 9 "CYPRUS" 14 "FRANCE" 4 "GERMANY" 15 "GHANA" 100 "GREECE" 2 "INDIA" 16 "ITALY" 17 "KENYA" 19 "MAURITIUS" 18 "MOROCCO" 20 "NIGERIA" 21 "PAKISTAN" 22 "PORTUGAL" 24 "SINGAPORE" 3 "SOUTH AFRICA" 10 "SOUTH KOREA" 12 "SPAIN" 25 "SWITZERLAND" 26 "TAIWAN" 27 "TOGO" 28 "TURKEY" 23 "UNITED KINGDOM" 13 "UNITED STATES" 29 "VIETNAM" 996 "Other" 998 "No country stated"
	label values amcountry amcountry

	label variable amcountry_other "Specify other country:"
	note amcountry_other: "Specify other country:"

	label variable fdc "2. Is this a fixed dose combination?"
	note fdc: "2. [Observe]: Is this a fixed dose combination?"
	label define fdc 1 "Yes" 0 "No" 98 "Don't know" 97 "Not applicable"
	label values fdc fdc

	label variable hassalt "3. Do any of the active ingredients have a salt?"
	note hassalt: "3. Do any of the active ingredients have a salt?"
	label define hassalt 1 "Yes" 0 "No" 98 "Don't know"
	label values hassalt hassalt

	label variable salt "Specify the salt"
	note salt: "Specify the salt"
	label define salt 1 "Bisulphate" 2 "Hydrochloride / Chlorohydrate" 3 "Dihydrochloride" 4 "Gluconate" 5 "Phosphate" 6 "Sulphate" 7 "Tetraphosphate" 96 "Other"
	label values salt salt

	label variable salt_other "Specify the other salt:"
	note salt_other: "Specify the other salt:"

	label variable salton "Which active ingredient has the salt?"
	note salton: "Which active ingredient has the salt?"
	label define salton 60 "Amodiaquine" 63 "Arteether" 61 "Artemether" 62 "Artemisinin" 64 "Artemotil" 69 "Arterolane" 65 "Artesunate" 66 "Atovaquone" 67 "Chloroproguanil" 68 "Chloroquine" 70 "Dapsone" 71 "Dihydroartemisinin" 72 "Halofantrine" 73 "Hydroxychloroquine" 74 "Lumefantrine" 75 "Mefloquine" 76 "Naphthoquine" 77 "Piperaquine" 78 "Primaquine" 79 "Proguanil" 81 "Pyrimethamine" 80 "Pyronaridine" 82 "Quinacrine" 83 "Quinine" 85 "Sulfadoxine" 89 "Sulfalene" 86 "Sulfamethoxazole" 87 "Sulfamethoxypyrazine" 88 "Trimethoprim" 96 "Other" 98 "Don't Know"
	label values salton salton

	label variable salton_other "Specify the active ingredient that has the salt:"
	note salton_other: "Specify the active ingredient that has the salt:"

	label variable packagetype "4. [Observe]: Pack type for \${brand}:"
	note packagetype: "4. [Observe]: Pack type for \${brand}:"
	label define packagetype 1 "Plaquette / carte" 2 "Individual packet" 3 "Loose tablets in a pot, tin, or other container" 4 "Bottle" 5 "Ampoule or vial" 6 "Sachet" 96 "Other packaging type"
	label values packagetype packagetype

	label variable packagetype_other "Specify other packaging type:"
	note packagetype_other: "Specify other packaging type:"

	label variable packagesize_blisterpacks "5. [Observe]: Number of \${a3_lbl} in each \${packageType_label}"
	note packagesize_blisterpacks: "5. [Observe]: Number of \${a3_lbl} in each \${packageType_label}"

	label variable packagesize_loose "5. [Observe]: Number of loose \${a3_lbl} in a pot, tin, or other container"
	note packagesize_loose: "5. [Observe]: Number of loose \${a3_lbl} in a pot, tin, or other container"

	label variable packagesize_bottle "5. [Observe]: Volume of the bottle:"
	note packagesize_bottle: "5. [Observe]: Volume of the bottle:"

	label variable packagesize_vial "5. [Observe]: Volume of the ampoule/ vial:"
	note packagesize_vial: "5. [Observe]: Volume of the ampoule/ vial:"

	label variable packagesize_sachets "5. [Observe]: Number of sachets"
	note packagesize_sachets: "5. [Observe]: Number of sachets"

	label variable packagesize_other "5. [Observe]: Amount/number in each \${packageType_other}"
	note packagesize_other: "5. [Observe]: Amount/number in each \${packageType_other}"

	label variable amoos "6. Was \${brand} ever out of stock in the last 3 months?"
	note amoos: "6. Was \${brand} ever out of stock in the last 3 months?"
	label define amoos 1 "Yes" 0 "No" 98 "Don't know"
	label values amoos amoos

	label variable unexpired_pack "7. [Observe]: Check the expiration date. Has this product expired?"
	note unexpired_pack: "7. [Observe]: Check the expiration date. Has this product expired?"
	label define unexpired_pack 1 "Yes" 0 "No" 98 "Don't know"
	label values unexpired_pack unexpired_pack

	label variable reg_code "8. [Observe]: Does the product have a registration rumber from the national regu"
	note reg_code: "8. [Observe]: Does the product have a registration rumber from the national regulatory authority?"
	label define reg_code 1 "Yes" 0 "No" 98 "Don't know"
	label values reg_code reg_code

	label variable amsold_unit "9. How many loose tablets of of \${brand} has this outlet has sold/distri"
	note amsold_unit: "9. How many loose tablets of of \${brand} has this outlet has sold/distributed in the last 7 days to individual customers?"

	label variable amsold_pack "10. How many \${packageType_label} (s) of \${brand} has this outlet has s"
	note amsold_pack: "10. How many \${packageType_label} (s) of \${brand} has this outlet has sold/distributed in the last 7 days to individual customers?"

	label variable packageprice_unit "11. What was the cost or price for one loose tablet of \${brand} for the "
	note packageprice_unit: "11. What was the cost or price for one loose tablet of \${brand} for the most recent individual customer?"

	label variable packageprice_pack "12. What was the cost for one \${packageType_label} of \${brand} for the "
	note packageprice_pack: "12. What was the cost for one \${packageType_label} of \${brand} for the most recent sale to an individual customer?"

	label variable supplier_amt_unit "How many loose tablets did you purchase?"
	note supplier_amt_unit: "How many loose tablets did you purchase?"

	label variable supplier_amt_pack "How many \${packageType_label} (s) of \${brand} did you purchase?"
	note supplier_amt_pack: "How many \${packageType_label} (s) of \${brand} did you purchase?"

	label variable supplier_price "What was the total purchase price?"
	note supplier_price: "What was the total purchase price?"

	label variable pic_ok "14. [ASK PROVIDER!!!]Can you take a photo of this product?"
	note pic_ok: "14. [ASK PROVIDER!!!]Can you take a photo of this product?"
	label define pic_ok 1 "Yes" 0 "No"
	label values pic_ok pic_ok

	label variable pic_front "TAKE A PHOTO OF THE FRONT OF THE PRODUCT/b> OR THE SIDE/SPACE THAT INCLUDES THE "
	note pic_front: "TAKE A PHOTO OF THE FRONT OF THE PRODUCT/b> OR THE SIDE/SPACE THAT INCLUDES THE BRAND NAME: Tap photo to focus. Retake if the image is not clear."

	label variable pic_ais "TAKE A PHOTO OF THE SIDE OF THE PRODUCT THAT INCLUDES ACTIVE INGREDIENT INFORMAT"
	note pic_ais: "TAKE A PHOTO OF THE SIDE OF THE PRODUCT THAT INCLUDES ACTIVE INGREDIENT INFORMATION : Tap photo to focus. Retake if the image is not clear."


