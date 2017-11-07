*ps4
*Aditi Manke
*Data Management

cd "D:\PhD Public Affairs\Fall 2017\DataManagement"

//importing and restructuring data//
global a xd5ZLItEIeekoxWHJuX19oZDQ
insheet using "https://docs.google.com/uc?id=OB-"$a"&export=download",clear //this is not working//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeekoxWHJuX19oZDQ&export=download",clear

//to get rid of first row
drop in 1/1
//destring using loops//
foreach var of varlist _all {
if "`var'" != "v1" capture destring `var', replace force
}
//using loop appeared to be convenient and time saving//
//to destring other variables//
//following is the long method//
destring v2, replace
destring emissionstotals, replace
destring v4, replace
destring emissionsbygas, replace
destring v6, replace
destring v7, replace
destring v8, replace
destring emissionsbysector, replace
destring v10, replace
destring v11, replace
destring v12, replace
destring v13, replace
destring v14, replace
destring energyemissionsbysubsector, replace
destring v16, replace
destring v17, replace
destring v18, replace
destring v19, replace
destring v20, replace
destring socioeconomicdata, replace
destring v22, replace
destring v23, replace

//renaming variables//
rename v1 State
rename v2 Year
rename emissionstotals GHGExc
rename v4 GHGInc
rename emissionsbygas CO2
rename v6 CH4
rename v7 N2O
rename v8 FGas
rename emissionsbysector Energy
rename v10 IndustrialProcesses
rename v11 Agriculture
rename v12 Waste
rename v13 LandUse
rename v14 BunkerFuels
rename energyemissionsbysubsector ElectricPower
rename v16 Commercial
rename v17 Residential
rename v18 Industrial
rename v19 Transportation
rename v20 FugitiveEmissions
rename socioeconomicdata StateGDP
rename v22 Population
rename v23 EnergyUse
rename vehiclesper1000people Vehicles
rename meantraveltimetowork Traveltime

save GHG, replace
clear

//keeping data of one year using loop//
use GHG
tostring Year, replace
foreach v in Year {
keep if `v'=="2011" 
} 

drop if State=="United States"

//trying to create dummy variable and see interactions with carbon emissions & population//
generate gdp=.
foreach var of varlist StateGDP {
local mean=`r(mean)'
if "`var'">"`mean'" { 
        replace gdp=1
		}
else {
     replace gdp=0 if "`var'">"0" & "`var'"<"`mean'"
	 }
} // in this code, gdp is taking only first condition// 

/****other way****/ //following code is not working//
generate gpd=.
local s StateGDP
foreach var of varlist `s'{
replace gpd=1 if `var'>256995.5 replace gpd=0 if `var'>0 & `var'<256995.5
}

foreach v of varlist StateGDP Transportation{
cap drop `v'M `v'D
sum `v'
loc mean= `r(mean)' 
di "the mean for variable `v' is `mean'"
//gen `v'M=`v'-`mean'
gen `v'D=0 //assume no non-missing
replace `v'D=1 if `v'>`mean'
}
//always chck
sort StateGDP
l State StateGDP StateGDPD, sepby(StateGDPD)

//Egen//
use GHG, clear
tostring Year, replace
keep if Year=="2011"
drop if State=="United States"

egen avg_StateGDP=mean(StateGDP) 
//taking average of State GDP and later observing the relation between GDP and state emissions//
gen dev_StateGDP=StateGDP-avg_StateGDP 
//looking at how much individual state gdp's deviate from the average//
bys State: egen avgState_StateGDP=mean(StateGDP) 
//sorted original GDP of each state respectively//

use GHG, clear
tostring Year, replace
keep if Year=="2011"
drop if State=="United States"
collapse StateGDP Transportation Traveltime, by(census_region)
l
gen GDP = (StateGDP>256995.5)
l State StateGDP avg_StateGDP dev_StateGDP GDP in 1/20, nola

egen avg_Traveltime=mean(Traveltime)

gen TT = (Traveltime>23.74902)
l State avg_StateGDP avg_Traveltime GDP TT in 1/20, nola 
//The assumption over here was that the states having GDP above the average StateGDP would also have travel time above the average travel time to work
//it was interesting to see states whose GDP was less than avg StateGDP had higher travel time to work, this might be due to lack of transportation
//or the distance from home to work is much greater.

/***********importing second dataset*********/
//The data is publicly available on American Council for an Energy-efficient Economy//
//The data entails the scores of how cities have performed in being energy efficient//

insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeYkJLdmFITFVDams&export=download", clear
rename state State
rename v1 City
keep City State cityscore transportationscore
foreach v of varlist State {
replace `v'="Alabama" if `v'=="AL"
replace `v'="Alaska" if `v'=="AK"
replace `v'="Arizona" if `v'=="AZ"
replace `v'="Arkansas" if `v'=="AR"
replace `v'="California" if `v'=="CA"
replace `v'="Colorado" if `v'=="CO"
replace `v'="Connecticut" if `v'=="CT"
replace `v'="Delaware" if `v'=="DE"
replace `v'="Florida" if `v'=="FL"
replace `v'="Georgia" if `v'=="GA"
replace `v'="Hawaii" if `v'=="HI"
replace `v'="Idaho" if `v'=="ID"
replace `v'="Illinois" if `v'=="IL"
replace `v'="Indiana" if `v'=="IN"
replace `v'="Iowa" if `v'=="IA"
replace `v'="Kansas" if `v'=="KS"
replace `v'="Kentucky" if `v'=="KY"
replace `v'="Louisiana" if `v'=="LA"
replace `v'="Maine" if `v'=="ME"
replace `v'="Maryland" if `v'=="MD"
replace `v'="Massachusetts" if `v'=="MA"
replace `v'="Michigan" if `v'=="MI"
replace `v'="Minnesota" if `v'=="MN"
replace `v'="Mississippi" if `v'=="MS"
replace `v'="Missouri" if `v'=="MO"
replace `v'="Montana" if `v'=="MT"
replace `v'="Nebraska" if `v'=="NE"
replace `v'="Nevada" if `v'=="NV"
replace `v'="New Hampshire" if `v'=="NH"
replace `v'="New Jersey" if `v'=="NJ"
replace `v'="New Mexico" if `v'=="NM"
replace `v'="New York" if `v'=="NY"
replace `v'="North Carolina" if `v'=="NC"
replace `v'="North Dakota" if `v'=="ND"
replace `v'="Ohio" if `v'=="OH"
replace `v'="Oklahoma" if `v'=="OK"
replace `v'="Oregon" if `v'=="OR"
replace `v'="Pennsylvania" if `v'=="PA"
replace `v'="Rhode Island" if `v'=="RI"
replace `v'="South Carolina" if `v'=="SC"
replace `v'="South Dakota" if `v'=="SD"
replace `v'="Tennessee" if `v'=="TN"
replace `v'="Texas" if `v'=="TX"
replace `v'="Utah" if `v'=="UT"
replace `v'="Vermont" if `v'=="VT"
replace `v'="Virginia" if `v'=="VA"
replace `v'="Washington" if `v'=="WA"
replace `v'="West Virginia" if `v'=="WV"
replace `v'="Wisconsin" if `v'=="WI"
replace `v'="Wyoming" if `v'=="WY"
replace `v'="District of Columbia" if `v'=="DC"
}
save aceee, replace
clear

/*****importing third dataset*****/
//The data is publicly available on Bureau of Transportation Statistics//
//It contains urban ridership by State and Transit mode data, percent of workers taking rail,busor car//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeRS0ycUNOT2ZCOFE&export=download", clear
drop in 1/3
//destring variables using loop//
foreach var of varlist _all {
if "`var'" != "v1" capture destring `var', replace force
}
rename v1 State
rename v2 Agencies
rename v3 Passtrips
rename v4 Mbus
rename v5 Hrail
rename v6 Lrail
rename v7 Crail
rename v8 Other

di length("sadas")
drop if length(State)>22
compress
drop if State=="United States, total1"
save ridership, replace
clear

/*****importing fourth dataset*****/
//The data is publicly available on Bureau of Transportation Statistics//
//It contains Mean Travel time to work by State//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeZzBnLThBUVVmVmM&export=download", clear
rename state State
drop if State=="United States, total"

save commute, replace
clear

/*****importing fifth dataset*****/
//The data is publicly available on State Policy Index//
//It contains various land laws, gasoline tax, renewable tax/policies at State level//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeZWdrRm9Rakg2THc&export=download", clear
drop in 1/2
keep v1 v2 v13 v16 v20
rename v1 State
rename v2 Year
rename v13 fgastax1
rename v16 fcap
rename v20 fcpi
foreach v in Year {
keep if `v'=="2008" 
}
save tax, replace
clear

/*****merge datasets*****/
/****merge 1****/
use GHG08,clear
merge 1:1 State using ridership.dta

rename _merge merge1
/****merge 2****/
merge 1:1 State using commute.dta

rename _merge merge2
/****merge 3****/
merge 1:1 State using tax.dta

rename _merge merge3
/****merge 4****/
merge 1:m State using aceee.dta

rename _merge merge4

save adi_ps3,replace
clear

collapse perc*, by(State)

//***merge datasets using macros and loop***//
local f ridership.dta commute.dta
use GHG08
foreach file of local f{
merge 1:1 State using `file'
drop _merge
} 

foreach var of varlist numberofworkers Passtrips {
//local workers = subinstr(`var',",","",.) 
//rename `var' `workers'
replace `var' = subinstr(`var',",","",.) 
destring `var',gen(`var'Des)
}
drop numberofworkers Passtrips
rename numberofworkersDes workers
rename PasstripsDes Passtrip
rename percentpublictransportationexclu PPubtrans
save adi_ps4, replace
clear
	 
//performing regressions//
use adi_ps4
local c Mbus Crail Population
local c1 EnergyUse StateGDP Population
reg CO2 `c'
reg CO2 `c1'
//doing analyses region wise, trying to explore if there is any effect on carbon emissions by travel mode region wise//
input str734 name byte region
"Alabama"        3
"Alaska"         4
"Arizona"        4
"Arkansas"       3
"California"     4
"Colorado"       4
"Connecticut"    1
"Delaware"       3
"Florida"        3
"Georgia"        3
"Hawaii"         4
"Idaho"          4
"Illinois"       2
"Indiana"        2
"Iowa"           2
"Kansas"         2
"Kentucky"       3
"Louisiana"      3
"Maine"          1
"Maryland"       3
"Massachusetts"  1
"Michigan"       2
"Minnesota"      2
"Mississippi"    3
"Missouri"       2
"Montana"        4
"Nebraska"       2
"Nevada"         4
"New Hampshire"  1
"New Jersey"     1
"New Mexico"     4
"New York"       1
"North Carolina" 3
"North Dakota"   2
"Ohio"           2
"Oklahoma"       3
"Oregon"         4
"Pennsylvania"   1
"Rhode Island"   1
"South Carolina" 3
"South Dakota"   2
"Tennessee"      3
"Texas"          3
"Utah"           4
"Vermont"        1
"Virginia"       3
"Washington"     4
"Washington DC"  3
"West Virginia"  3
"Wisconsin"      2
"Wyoming"        4
end
// macros & loop//
local vars "region"
foreach v of local vars {
label def `v' 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
label val `v' `v'
} 
//other way of doing it//
label values census_region census_region
label def census_region 1 "Northeast", modify
label def census_region 2 "Midwest", modify
label def census_region 3 "South", modify
label def census_region 4 "West", modify


levelsof region,loc(re)
foreach v of varlist Passtrip workers Transportation {
foreach r of local re{
di "-------------------------------------------------"
di "`r' or `: label region `r''"
 regress CO2 `v' if region==`r'
}
}  
  loc l : label census_region 4
  di "`l'"

  //scatter plots using loops//
foreach v of varlist StateGDP Crail {
twoway (scatter CO2 `v') (lfit CO2 `v'), name(gr`v',replace)
} //i have named each graph so at the end of loop I get to see all graphs instead of last one//
foreach V of varlist Mbus Passtrip {
   foreach Y of varlist CO2 workers {
   twoway (scatter `Y' `V') (lfit `Y' `V'), name(gr`v',replace)
   }
}   


/***reshape***/
// all the variables in this dataset are long//
use adi_ps3, clear
gen id=_n
reshape wide Crail, i(id) j(State,string) 
//here Crail is percent of people commuting via rail at state level//


