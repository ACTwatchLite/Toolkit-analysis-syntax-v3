
/*******************************************************************************
	ACTwatch LITE 
	Step 3.3 Output data for the study flow diagram
	
********************************************************************************/
/*This .do file produces a table and outputs it to excel the table shows the Final Interview Status code and number or participants for each stage (i.e. N screened, N eligible, N completed full interview, etc)

The first column of the table is for the full study (across all strata)

subsequent results are for each named stratum 

Note that this table is different to other table outputs in that it does not 
follow the usual option for 4 levels of results:

/*This .do file produces 1 table with results for national level, and strata. 
	I. National level results - i.e. across the whole geographic reach for which the study was designed to be representative.
	III. Results by other strata - i.e. if you have other geographical stratification (eg. region/ state)
*/

*NOTE THAT THIS IS DIFFERENT TO OTHER ACTWACTH LITE DO FILES AS IT STACKS THE 
*NATIONAL AND STRATUM LEVEL RESULTS TOGETHER IN A SINGLE SHEET (IF STRATUM RESULTS ARE REQUIRED)

The syntax is annotated and should be modified according to the study needs. 
*/


*FINAL INTERVIEW STATUS FOR EACH OUTLET IS MEASURED AT THE OUTLET LEVEL. 
*OUTLET DATASET SHOULD BE IDENTIFIED HERE, 
*EXAMPLE: 
use "${mngmtdata}/${country}_${year}_outlet_data", clear

*THIS ANALYSIS USES UNWEIGHTED DATA

*A FILE CONTAINING LOCAL MACROS FOR ANALYSIS SHOULD BE UPDATED, AND CALLED BELOW:
***this command ensures that the local macros for outlets, strata and products are available in this do file

*EXAMPLE: 
include "${resultsdir}/local_definitions.doh"

**# 
********************************************************************************
********************************************************************************
*I. National level results
********************************************************************************
********************************************************************************

*table label
	
	local tabname T0_i

*file name and sheet
	putexcel set "${resultsdir}/diagrams/0.i flow diagram_$tabver", sheet("`tabname'") modify

	*labels for the excel sheet	
	putexcel A1=("`tabname'")
	putexcel A4=("Label code for interview status")
	putexcel C2=("TOTAL N")
	
	putexcel B1=("Full sample")
	
	putexcel B3=("Total outlets screened")
	


	ta finalIntStat, matcell(A) matrow(B) 	// final interview status variable used for this diagram using the tab command
	putexcel C3=(r(N))						// puts the total N outlets for overall study
	putexcel B4=matrix(B)					// puts the finalIntStat values into column B in excel
	putexcel C4=matrix(A)					// puts the number of cases associated with each finalIntStat value into column C in excel
	
	
**# 
********************************************************************************
********************************************************************************
*III. STRATUM RESULTS
********************************************************************************
********************************************************************************

*table label
	
	local tabname T0_i

*file name and sheet
	putexcel set "${tables}/0.i flow diagram_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel A4=("Label code for interview status")
	putexcel C2=("TOTAL N")
	
	putexcel E1=("[STRATUM 1]") 			// add stratum names inside quotation marks
	putexcel F1=("[STRATUM 2]")
	putexcel H1=("[STRATUM 3]")				
							// continue to add strata below as needed
	
	putexcel B3=("Total outlets screened")
	
		
		local col=4

	foreach s of varlist  `stratumlist' {
		local row=3
		ta finalIntStat if `s'==1, matcell(A) matrow(B)
		
			mata: st_local("alphacol", numtobase26((`col')))	
			putexcel `alphacol'`row'=(r(N))
			local row=`row'+1
			
			mata: st_local("alphacol", numtobase26((`col')))			
			putexcel `alphacol'`row'=matrix(B)
			local col=`col'+1		
			
			mata: st_local("alphacol", numtobase26((`col')))			
			putexcel `alphacol'`row'=matrix(A)
			local col=`col'+1		
						
	}
	
	
	*ends
	
	
	
	
	
	
	
	
	
	
	
	
	
