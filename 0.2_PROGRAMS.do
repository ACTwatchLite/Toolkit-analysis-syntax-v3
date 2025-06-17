

/*******************************************************************************
	ACTwatch LITE 
	Step 0.2  RUN PROGRAMS
	
********************************************************************************/
/*This set of Stata programs supports pharmaceutical data validation by checking consistency in reported strengths of active pharmaceutical ingredients across various dosage forms. Programs are tailored for products with one, two, or three APIs in solid (ais_tk) and liquid (ais_nk) forms, while ais_tu and ais_nu handle cases with unknown strengths. The strtu utility standardizes text entries. Each program flags discrepancies between recorded and expected strengths based on user-defined inputs, aiding in efficient quality control of drug audit data. These tools are particularly useful for identifying errors in pharmaceutical surveys or national drug monitoring systems.
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
	
	
	
	




********************************************************************************
**# STEP 0.2 - RUN PROGRAMS
*******************************************************************************	

*Trim and convert strings to uppercase (strtu)
  capture  program drop strtu
  program define strtu
  ds _all, has(type string)
  foreach var in `r(varlist)' {
    replace `var' = upper(trim(`var'))
  }
  end
*!!! Attention: this program does not work on french characters 

 
/*ais_tk1: Checks consistency between 1 active ingredient with known strengths
  for tablets, suppositories and granules. This program takes the following
  arguments:
    1 = generic name code
    2 = active ingredient code
    3 = active ingredient known strengths 
  
  Example, to run the program for amodiaquine (generic name code = 1,
  active ingredient code = 60), the following command should be run:
    ais_tk1 1 60 "75,150,153.1,200,300,306,600"
  
  In the above command the known active ingredient strengths are listed within
  quotation marks and separated with commas (no spaces). */
  
  capture  program drop ais_tk1
  program define ais_tk1
  forval i =  1 / 3 {
    list amauditkey gname fillmethod brand ai?_ing ai?_mg pic_front if ///
      a3_category == 1 & fillmethod == 2 & ///
      gname == `1' & ai`i'_ing == `2' & ///
      !inlist(ai`i'_mg,`3')
  }
  end

/*ais_nk1: Checks consistency between 1 active ingredient with known strengths
  for syrups, suspensions, liquid injections and powder injections. This program
  takes the following arguments:
    1 = generic name code
    2 = active ingredient code
    3 = active ingredient known mg strengths
    4 = active ingredient known ml strengths

	Example, to run the program for arteether/artemotil (generic name code
  = 30, active ingredient code == 63 or 64), the following command should be
  run:
    ais_nk1 30 "63,64" "75 150 150 225" "1 1 2 3"
  
  In the above command the active ingredient codes are listed within quotation
  marks and separated with commas (no spaces). The known active ingredient mg
  and ml strengths are listed in quotation marks and separated with spaces (no
  commas). The first mg strength corresponds with the first ml strength, the
  second mg strength corresponds to the second ml strength, etc. */
  capture  program drop ais_nk1
  program define ais_nk1
  *Define strengths combinations and length.
    loc n = wordcount("`3'")
    forvalues i = 1 / `n' {
      loc s1`i': word `i' of `3'
      loc s2`i': word `i' of `4'
    }
  *Run list command for each active ingredient/strength combination.
    forval i =  1 / 3 {
    *1st part of list command.
      loc lcom1 list amauditkey gname fillmethod brand ai?_ing ai?_mg ai?_ml pic_front pic_ais if 
      loc lcom1 `lcom1' a3_category == 0 & fillmethod == 2 & gname == `1' & 
      loc lcom1 `lcom1' inlist(ai`i'_ing,`2')
    *2nd part of list command.
      loc lcom2 ""
      forvalues j = 1 / `n' {
        loc lcom2 `lcom2' & !(ai`i'_mg == `s1`j'' & ai`i'_ml == `s2`j'')
      }
    *Full list command.
      loc lcomf `lcom1' `lcom2'
      `lcomf'
    }
  end

/*ais_tk2: Checks consistency between 2 active ingredient with known strengths
  for tablets, suppositories and granules. This program takes the following
  arguments:
    1 = generic name code
    2 = active ingredient 1 code
    3 = active ingredient 2 code
    4 = active ingredient 1 known strengths
    5 = active ingredient 2 known strengths
  
  Example, to run the program for DHA-PPQ (generic name code = 55, active
  ingredient codes = 71 and 77), the following command should be run:
    ais_tk2 55 71 77 "10 20 40 80" "80 160 320 640" // DHA-PPQ
  
  In the above command the known active ingredient strengths are listed in
  quotations marks and separated by spaces (no commas). */
  capture  program drop ais_tk2
  program define ais_tk2
  *Define active ingredient combinations and length.
    loc ing1 "1 1 2 2 3 3"
    loc ing2 "2 3 1 3 1 2"
    loc n1 = wordcount("`ing1'")
  *Define strengths combinations and length.
    loc n2 = wordcount("`4'")
    forvalues i = 1 / `n2' {
      loc s1`i': word `i' of `4'
      loc s2`i': word `i' of `5'
    }
  *Run list command for each active ingredient/strength combination.
    forvalues i = 1 / `n1' {
      loc i1: word `i' of `ing1'
      loc i2: word `i' of `ing2'
    *1st part of list command.
      loc lcom1 list amauditkey gname fillmethod brand ai?_ing ai?_mg pic_front if a3_category == 1 & 
      loc lcom1 `lcom1' fillmethod == 2 & gname == `1' & ((inlist(ai`i1'_ing,`2') & 
      loc lcom1 `lcom1' inlist(ai`i2'_ing,`3')) 
    *2nd part of list command.
      loc lcom2 ""
      forvalues j = 1 / `n2' {
        loc lcom2 `lcom2' & !(ai`i1'_mg == `s1`j'' & ai`i2'_mg == `s2`j'')
      }
    *Full list command.
      loc lcomf `lcom1' `lcom2')
      `lcomf'
    }
  end

/*ais_nk2: Checks consistency between 2 active ingredient with known strengths
  for syrups, suspensions, liquid injections and powder injections. This program
  takes the following arguments:
    1 = generic name code
    2 = active ingredient 1 code
    3 = active ingredient 2 code
    4 = active ingredient 1 known mg strengths
    5 = active ingredient 2 known ml strengths 
    6 = active ingredient 1 known mg strengths
    7 = active ingredient 2 known ml strengths
  
  Example, to run the program for SP, the following command should be
  run:
    ais_nk2 21 "85,86,87" 81 "250 250 500" "5 10 2.5" "12.5 12.5 25" ///
      "5 10 2.5" // SP
  
  In the above command the active ingredient codes are listed within quotation
  marks and separated with commas (no spaces). The known active ingredient mg
  and ml strengths are listed in quotation marks and separated with spaces (no
  commas). For each activity ingredient, the first mg strength corresponds with
  the first ml strength, the second mg strength corresponds to the second ml
  strength, etc. */
  capture  program drop ais_nk2
  program define ais_nk2
  *Define active ingredient combinations and length.
    loc ing1 "1 1 2 2 3 3"
    loc ing2 "2 3 1 3 1 2"
    loc n1 = wordcount("`ing1'")
  *Define strengths combinations and length.
    loc n2 = wordcount("`4'")
    forvalues i = 1 / `n2' {
      loc s1`i': word `i' of `4'
      loc s2`i': word `i' of `5'
    }
  *Run list command for each active ingredient/strength combination.
    forvalues i = 1 / `n1' {
      loc i1: word `i' of `ing1'
      loc i2: word `i' of `ing2'
    *1st part of list command.
      loc lcom1 list amauditkey gname fillmethod brand ai?_ing ai?_mg ai?_ml pic_front if 
      loc lcom1 `lcom1' a3_category == 0 & fillmethod == 2 & gname == `1' & 
      loc lcom1 `lcom1' ((inlist(ai`i1'_ing,`2') & inlist(ai`i2'_ing,`3')) 
    *2nd part of list command.
      loc lcom2 ""
      forvalues j = 1 / `n2' {
        loc lcom2 `lcom2' & !(ai`i1'_mg == `s1`j'' & ai`i1'_ml == `s2`j'')
        loc lcom2 `lcom2' & !(ai`i2'_mg == `s1`j'' & ai`i2'_ml == `s2`j'')
      }
    *Full list command.
      loc lcomf `lcom1' `lcom2')
      `lcomf'
    }
  end

/*ais_tk3: Checks consistency between 3 active ingredient with known strengths
  for tablets, suppositories and granules. This program takes the following
  arguments:
    1 = generic name code
    2 = active ingredient 1 code
    3 = active ingredient 2 code
    4 = active ingredient 3 code
    5 = active ingredient 1 known strengths
    6 = active ingredient 2 known strengths
    7 = active ingredient 3 known strengths
  
  Example, to run the program for amodiaquine SP (generic name code = 2,
  active ingredient code 1 = 60, active ingredient code 2 = 85, 86 or 87,
  active ingredient code 3 = 25), the following command should be run:
    ais_tk3 2 60 "85,86,87" 25 "200 600" "500 500" "25 25" // amodiaquine-SP  
  
  In the above command the active ingredient codes are listed within quotation
  marks and separated with commas (no spaces). For each active ingredient, the
  known active ingredient strengths are listed in quotations marks and separated
  by spaces (no commas). */
  capture  program drop ais_tk3
  program define ais_tk3
  *Define active ingredient combinations and length.
    loc ing1 "1 1 2 3 2 3"
    loc ing2 "2 3 1 1 3 2"
    loc ing3 "3 2 3 2 1 1"
    loc n1 = wordcount("`ing1'")
  *Define strengths combinations and length.
    loc n2 = wordcount("`5'")
    forvalues i = 1 / `n2' {
      loc s1`i': word `i' of `5'
      loc s2`i': word `i' of `6'
      loc s3`i': word `i' of `7'
    }
  *Run list command for each active ingredient/strength combination.
    forvalues i = 1 / `n1' {
      loc i1: word `i' of `ing1'
      loc i2: word `i' of `ing2'
      loc i3: word `i' of `ing3'
    *1st part of list command.
      loc lcom1 list amauditkey gname fillmethod brand ai?_ing ai?_mg pic_front if a3_category == 1 & 
      loc lcom1 `lcom1' fillmethod == 2 & gname == `1' & ((inlist(ai`i1'_ing,`2') & 
      loc lcom1 `lcom1' inlist(ai`i2'_ing,`3') & inlist(ai`i2'_ing,`4'))
    *2nd part of list command.
      loc lcom2 ""
      forvalues j = 1 / `n2' {
        loc lcom2 `lcom2' & !(ai`i1'_mg == `s1`j'' & 
        loc lcom2 `lcom2' ai`i2'_mg == `s2`j'' &
        loc lcom2 `lcom2' ai`i3'_mg == `s3`j'')
      }
    *Full list command.
      loc lcomf `lcom1' `lcom2')
      `lcomf'
    }
  end

/*ais_tu: Checks consistency between active ingredients and unknown strengths
  for tablets, suppositories and granules. This program takes the following
  arguments:
    1 = generic name code
  
  Example, to run the program for pyrimethamine (generic name code = 15),
  the following command should be run:
    ais_tu 15 */
  capture  program drop ais_tu
  program define ais_tu
  forval i =  1/3 {
    sort ai?_ing
    list fillmethod brand ai?_ing ai?_mg pic_front if ///
      a3_category == 1 & fillmethod == 2 & ///
      gname == `1'
    tab ai`i'_ing ai`i'_mg if ///
      a3_category == 1 & fillmethod == 2 & ///
      gname == `1'
  }
  end

/*ais_nu: Checks consistency between active ingredient and unknown strengths for
  syrups, suspensions, liquid injections and powder injections. This program
  takes the following arguments:
    1 = generic name code
  
  Example, to run the program for quinine (generic name code = 19),
  the following command should be run:
    ais_nu 19 // quinine */
  capture  program drop ais_nu
  program define ais_nu
  forval i =  1/3 {
    sort ai?_ing
    list fillmethod brand ai?_ing ai?_mg ai?_ml pic_front if ///
      a3_category == 0 & fillmethod == 2 & ///
      gname == `1'
    tab ai`i'_ing ai`i'_mg if ///
      a3_category == 0 & fillmethod == 2 & ///
      gname == `1'
  }
  end
  
  
  /* xlscol is a small program to allow us to save to specific column locations in an excel file. 
DO NOT MODIFY THE BELOW
*/
*!!!@PB can we move this to the master users do file with other programs? see note there -- i think we can remove a lot of what Kevin provided and we dont end up using. 
	cap  program drop xlscol
		program define xlscol, rclass
			version 9
			args j
			confirm integer number `j'
			while `j' > 0 {
			local i = mod(`j'-1,26)
			local letter = char(`i' + 65)
			local res `letter'`res'
			local j = int((`j'-`i') / 26)
			}
			dis as text "col = " as res "`res'"
			return local col `res'
		end

  	
	
	
	*************************
	*************************
	******	END 		*****
	*************************
	*************************
