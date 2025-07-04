*	3		Price
*	3.1		Purchase price of antimalarial AETDs **in local currency and USD**

/*This .do file produces 4 tables and outputs them to an excel workbook: 
	I. National level resutls
	II. National level results dissagregated by urban/ rural			
	III. Results by strata
	IV. Results by strata dissagregated by urban/ rural					
*/

*Comment out any tables that are not relevant to this implementaiton. 

clear

use "${mngmtdata}/${country}_${year}_rdt_micro_data", clear

***this command ensures that the local macros for outlets, strata and products are available in this do file
*include "${resultsdir}/3.1a_LOCAL_DEFINITIONS antimalarials.do"

include "${resultsdir}/3.1b_LOCAL_DEFINITIONS diagnostics.do"


		 
	 svyset c4 [pweight=wt_allOutlet], strata(strata) fpc(fpc) 
	 svydes
*Droping outlets missing outlet type.
	drop if outcat2==. 

		
**ensuring microscopy included (as well as RDT)
	
	recode countprod (.=1) if total==1

	
foreach v of varlist `outvars1' {
 recode `v' (.=0) if total==1 
 }

	
**# 
********************************************************************************
********************************************************************************
*I. National level resutls
********************************************************************************
********************************************************************************

		*table label
		
local tabname T_i	



	**FOOTNOTES
	
		sum volume if booster==0 
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1 
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1 
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1 
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1 
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1 
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1 
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1 
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=. 
		local footnote9 =r(N)	

	
	*file name and sheet
	putexcel set "${tables}/3.4_Median sales volume of tests outlets with sales_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Median AETD sold") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	
	putexcel C1= ("Footnote: Volume data were available for the following total number of antimalarial products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )

	**tables loop and putexcel output	

		local row=3
		local col=2	

		foreach x of varlist `dvol_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'

		_pctile volume [pw=wt_allOutlet] if `y'==1 & `x'==1  &  volume!=. & volume!=0, p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & countprod==1 & volume!=. & volume!=0

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


	
	
	
	
	
	
**# 
********************************************************************************
********************************************************************************
*I. Rura/Urban level resutls
********************************************************************************
********************************************************************************


		*table label
		
local tabname T_ii



	**FOOTNOTES
	*RURAL
		sum volume if booster==0  & Ru1==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1   & Ru1==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1   & Ru1==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1  & Ru1==1 
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1  & Ru1==1 
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1   & Ru1==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1  & Ru1==1 
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1  & Ru1==1 
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & Ru1==1
		local footnote9 =r(N)	
		
		
		*URBAN
		sum volume if booster==0  & Ru2==1
		local footnote10 =r(N)
		
		sum volume if booster==0 & pnp==1   & Ru2==1
		local footnote11 =r(N)
	
		sum volume if booster==0 & pfp==1   & Ru2==1
		local footnote12 =r(N)
	
		sum volume if booster==0 & pop==1  & Ru2==1 
		local footnote13 =r(N)
		
		sum volume if booster==0 & drs==1  & Ru2==1 
		local footnote14 =r(N)
	
		sum volume if booster==0 & inf==1   & Ru2==1
		local footnote15 =r(N)
		
		sum volume if booster==0 & lab==1  & Ru2==1 
		local footnote16 =r(N)
			
		sum volume if booster==0 & wls==1  & Ru2==1 
		local footnote17 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & Ru2==1
		local footnote18 =r(N)	

	
	*file name and sheet
	putexcel set "${tables}/3.4_Median sales volume of tests outlets with sales_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Median AETD sold") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	putexcel C1= ("Rural Footnote: Volume data were available for the following total number of antimalarial products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	putexcel D1= ("Urban Footnote: Volume data were available for the following total number of antimalarial products=`footnote10';  by outlet type: Private not for profit=`footnote11'; private not for profit=`footnote12'; pharmacy=`footnote13'; PPMV=`footnote14'; informal=`footnote15'; labs = `footnote16'; wholesalers= `footnote17';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote18'" )



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `dvol_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile volume [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1  & volume!=. & volume!=0, p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & countprod==1 & volume!=. & volume!=0

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
				}	
			}
		}
		
**# 
********************************************************************************
********************************************************************************
*III. State level resutls
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {

		*table label
		
local tabname T_iii_`s'	



	**FOOTNOTES
	
		sum volume if booster==0  & `s'==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1  & `s'==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1  & `s'==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1  & `s'==1
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1  & `s'==1
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1  & `s'==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1  & `s'==1
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1  & `s'==1
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & `s'==1
		local footnote9 =r(N)	

	
	*file name and sheet
	putexcel set "${tables}/3.4_Median sales volume of tests outlets with sales_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Median AETD sold") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	
	
	putexcel A2= ("`s' Footnote: Volume data were available for the following total number of antimalarial products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `dvol_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'



		_pctile volume [pw=wt_allOutlet] if `y'==1 & `x'==1  & `s'==1 &  volume!=. & volume!=0, p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1 & `s'==1 & countprod==1 & volume!=. & volume!=0

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
		}	
	}


}
	
	
	
	
	
**# 
********************************************************************************
********************************************************************************
*I. Rural/Urban & State level resutls
********************************************************************************
********************************************************************************


foreach s of varlist `stratumlist' {


		*table label
		
local tabname T_iv_`s'	


	**FOOTNOTES
	*RURAL
		sum volume if booster==0  & Ru1==1 & `s'==1
		local footnote1 =r(N)
		
		sum volume if booster==0 & pnp==1   & Ru1==1 & `s'==1
		local footnote2 =r(N)
	
		sum volume if booster==0 & pfp==1   & Ru1==1 & `s'==1
		local footnote3 =r(N)
	
		sum volume if booster==0 & pop==1  & Ru1==1  & `s'==1
		local footnote4 =r(N)
		
		sum volume if booster==0 & drs==1  & Ru1==1  & `s'==1
		local footnote5 =r(N)
	
		sum volume if booster==0 & inf==1   & Ru1==1 & `s'==1
		local footnote6 =r(N)
		
		sum volume if booster==0 & lab==1  & Ru1==1  & `s'==1
		local footnote7 =r(N)
			
		sum volume if booster==0 & wls==1  & Ru1==1  & `s'==1
		local footnote8 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & Ru1==1 & `s'==1
		local footnote9 =r(N)	
		
		
		*URBAN
		sum volume if booster==0  & Ru2==1 & `s'==1
		local footnote10 =r(N)
		
		sum volume if booster==0 & pnp==1   & Ru2==1 & `s'==1
		local footnote11 =r(N)
	
		sum volume if booster==0 & pfp==1   & Ru2==1 & `s'==1
		local footnote12 =r(N)
	
		sum volume if booster==0 & pop==1  & Ru2==1  & `s'==1
		local footnote13 =r(N)
		
		sum volume if booster==0 & drs==1  & Ru2==1  & `s'==1
		local footnote14 =r(N)
	
		sum volume if booster==0 & inf==1   & Ru2==1 & `s'==1
		local footnote15 =r(N)
		
		sum volume if booster==0 & lab==1  & Ru2==1  & `s'==1
		local footnote16 =r(N)
			
		sum volume if booster==0 & wls==1  & Ru2==1 & `s'==1 
		local footnote17 =r(N)
	
	*Footnote: outlets that met screening criteria for a full interview but did not complete the interview 
	*(were not interviewered or completed a partial interview).
	count if inlist(finalIntStat,203,204,205,207,208,303,304,305,307,308,309,310) & volume!=.   & Ru2==1 & `s'==1
		local footnote18 =r(N)	

	
	*file name and sheet
	putexcel set "${tables}/3.4_Median sales volume of tests outlets with sales_$tabver", sheet("`tabname'") modify

	*labels	
	putexcel A1=("`tabname'")
	putexcel B1=("outlet type 1")
	putexcel B3=("Median AETD sold") C3=("Lower quartile") D3=("Upper quartile") E3=("N")
	putexcel A3=("variable name")
	
	
	
	putexcel C1= ("Rural `s' Footnote: Volume data were available for the following total number of antimalarial products=`footnote1';  by outlet type: Private not for profit=`footnote2'; private not for profit=`footnote3'; pharmacy=`footnote4'; PPMV=`footnote5'; informal=`footnote6'; labs = `footnote7'; wholesalers= `footnote8';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote9'" )
	putexcel D1= ("Urban `s'  Footnote: Volume data were available for the following total number of antimalarial products=`footnote10';  by outlet type: Private not for profit=`footnote11'; private not for profit=`footnote12'; pharmacy=`footnote13'; PPMV=`footnote14'; informal=`footnote15'; labs = `footnote16'; wholesalers= `footnote17';   The number of antimalarial products with volume data, from outlets that met screening criteria for a full interview but did not complete the interview =`footnote18'" )



	**tables loop and putexcel output	

		local row=3
		local col=2

		

		foreach x of varlist `dvol_cov' {
		local row=`row'+1
		local col=2	

		local varlabelx :  var label `x'

		foreach z of varlist `rural' {
		local varlabelz :  var label `z'
		
		foreach y of varlist `outvars1' {
		local varlabely :  var label `y'


		_pctile volume [pw=wt_allOutlet] if `y'==1 & `x'==1 & `z'==1  & `s'==1 & volume!=. & volume!=0, p(25, 50, 75)

			
			putexcel A`row'=("`varlabelx'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'1=("`varlabelz'")
			putexcel `alphacol'2=("`varlabely'")

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r2))
			local col=`col'+1

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r1))
			local col=`col'+1
		
			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(r3))
			local col=`col'+1
			
			count if `y'==1 & `x'==1  & `s'==1 & countprod==1 & volume!=. & volume!=0

			mata: st_local("alphacol", numtobase26((`col')))
			putexcel `alphacol'`row'=(r(N))
			local col=`col'+1
				}	
			}
		}
	}
	
*ends*
