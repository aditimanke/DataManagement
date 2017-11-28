*ps 5
*Aditi Manke
*Data Management

cd "D:\PhD Public Affairs\Fall 2017\DataManagement"

/* The aim here is to establish a reltionship between public transit and carbon emissions
My project is about the role public transit can play in reducing carbon emissions.
I am going to use state level data for now and I intend to do metro level analysis for my future work
and research paper.*/
                   **********************************
                   ***********Section One************
                   **********************************
/* importing first data set*/
/*The data is publically available on CAIT Climate Data Explorer, World Resources Institute
This dataset focuses on the hostorical emissions of U.S. states from 1990-2011*/
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeekoxWHJuX19oZDQ&export=download",clear
drop in 1/1
foreach var of varlist _all {
if "`var'" != "v1" capture destring `var', replace force
}
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
//looking at historical emissions of United States over the years//
use GHG
keep if State=="United States"
line CO2 Year, mlabel(Year), ytitle(Carbon emissions) xtitle(Year)
//emissions of California state//
use GHG
keep if State=="California"
twoway(scatter CO2 StateGDP, mlabel(Year)) (lfit CO2 StateGDP), ytitle("Carbon Emissions")xtitle("CA GDP")
//Regressions//
use GHG
keep if Year=="2011"
drop if State=="United States"
local c StateGDP Population
reg CO2 `c'
outreg2 using ps5.doc, replace ctitle(Model 1)
reg CO2 EnergyUse `c'
outreg2 using ps5.doc, append ctitle(Model 2)
//Dummy variables//
generate gpd=.
local s StateGDP
foreach var of varlist `s'{
replace gpd=1 if `var'>256995.5 
replace gpd=0 if `var'>0 & `var'<256995.5
}

generate trans=.
local p Transportation
foreach var of varlist `p'{
replace trans=1 if `var'>37.06764
replace trans=0 if `var'>0 & `var'<37.06764
}

reg CO2 gdp trans
outreg using ps5.doc, append ctitle(Model 3)

                              **************************
                              ********Section Two*******
                              *************************
/* In this section my analysis is at state level, trying to understand the correlation between
carbon emissions and public transit system. The variables analysed here are percent of Car use
percent of public transit use, number of workers and passenger trips made across states*/
/*importing second data set*/
insheet using "https://docs.google.com/uc?id=1HRNlx_Z0LF0_FJnHO9GkF6ni4YcEBxDs&export=download", clear
drop in 1/4
rename v1 State
rename v15 CO2
di length("sadas")
drop if length(State)>21
drop if State=="Total?"
drop in 1/1
keep State CO2
destring CO2, replace
save Stateemit, replace
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
//merge the three datasets//
local f ridership.dta commute.dta
use Stateemit
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
rename percentcartruckorvandrovealone PercofCar
save ps5, replace
clear
la var Passtrip "Passenger trips traveled"
la var PPubtrans "Percent of Pub transit use"
la var PercofCar "Percent of people car use"
la var workers "No. of Workers"
la var CO2 "Carbon Emissions"
save ps5, replace
//descriptive statistics//
gr bar CO2, over(Passtrip) over(PercofCar)
hist Passtrip //skewed to the right//
hist PPubtrans //skewed to the right//
foreach v of varlist Passtrip Crail {
twoway (scatter CO2 `v') (lfit CO2 `v'), name(gr`v',replace)
}
foreach V of varlist Mbus Passtrip {
   foreach Y of varlist CO2 workers {
   twoway (scatter `Y' `V') (lfit `Y' `V'), name(gr`v',replace)
   }
}
//Regressions//
local a Passtrip workers
loacal a1 PPubtrans `a'
local a2 PercofCar `a1'
reg CO2 `a'
outreg2 using ps.doc, replace ctitle(Model 1) label
reg CO2 `a1'
outreg2 using ps.doc, append ctitle(Model 2) label
reg CO2 `a2'
outreg using ps.doc, append ctitle(Model 3) label
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
local vars "region"
foreach v of local vars {
label def `v' 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", modify
label val `v' `v'
} 
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

                            ************************
							*******Section Three****
							************************
/*This section focuses on metro level analysis of public transit and energy use*/
/***********importing fifth dataset*********/
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
//still have to add data for this section//
