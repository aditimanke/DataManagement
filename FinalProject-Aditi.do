*Final Project
*Aditi Manke
*Data Management 
cd "D:\PhD Public Affairs\Fall 2017\DataManagement"
/*The aim here is to establish a relationship between transportation and carbon emissions and how it
affects climate or climate change.The different transit modes to study are buses, trains, and trams. Commute in between cities is dominated by
high-rail, airlines and coaches. In my research the focus will be only on public transit systems
existing in cities and also focusing on transit systems which use energy efficient fuels.
Gases that contribute to the greenhouse gas effect include: Carbon dioxide (CO2), Methane(CH4), and
Nitrous Oxide(N2O). For this project I will be focusing on CO2 emissions and gasoline consumption.
This research is relevant in today's time as stabalizing the climate is the biggest challenge of 21st century
and Transportation accounts for 29 percent of greenhouse gas emissions in United states and in 2016
the sector produced more carbon pollution which makes it important to assess the operations of public transit systems
and the policy actions needed to address climate change.
Proposed Research questions for the study (these are likely to change as I come across more literature/research paper):
1. How public transit systems can reduce carbon emissions?
2. what are the impacts of public transit systems on climate?
3. How technological improvements in transit systems can reduce greenhouse gas emissions?*/
/*The dataset used in the analysis are publicly available 
1. Historical emissions data United States
http://www.wri.org/resources/data-sets/cait-historical-emissions-data-countries-us-states-unfccc
2. Carbon emissions data 
https://www.eia.gov/environment/emissions/carbon/
3. Urban Transit Ridership by State and Transit Mode
https://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/state_transportation_statistics/state_transportation_statistics_2015/chapter-4/table4_4
4. Commuting to work 
https://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/state_transportation_statistics/state_transportation_statistics_2015/chapter-4/table4_1
5. Fuel and Energy data (City level)
https://www.transit.dot.gov/ntd/data-product/2016-fuel-and-energy
6. Transit Operating Statistics (City Level)
https://www.transit.dot.gov/ntd/data-product/2016-service
7. American Council for an Energy-Efficient Economy (City Level)
https://database.aceee.org/city-scorecard-rank
*/
                   **********************************
                   ***********Section One************
                   **********************************
/* importing first data set*/
/*The data is publically available on CAIT Climate Data Explorer, World Resources Institute
This dataset focuses on the hostorical emissions of U.S. states from 1990-2011*/
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeekoxWHJuX19oZDQ&export=download",clear
drop in 1/1
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
//Label Variables//
la var CO2 "Carbon dioxide Emissions"
la var StateGDP "GDP of State"
la var EnergyUse "Energy Consumption"
la var Vehicles "No. of Vehicles/1000 people"
la var Traveltime "Mean travel time to work"
save GHG, replace
clear
//looking at historical emissions of United States over the years//
use GHG
keep if State=="United States"
line CO2 Year, mlabel(Year), ytitle("Carbon emissions") xtitle("Year")
clear
//emissions of California state//
use GHG
keep if State=="California"
twoway(scatter CO2 StateGDP, mlabel(Year)) (lfit CO2 StateGDP), ytitle("Carbon Emissions")xtitle("CA GDP")
clear
use GHG
keep if Year=="2011"
drop if State=="United States"
corr CO2 StateGDP
corr CO2 Transportation
corr StateGDP Transportation
corr Population Transportation
//Regressions//
local c StateGDP Population
reg CO2 `c'
outreg2 using ps6.doc, replace ctitle(Model 1)
reg CO2 EnergyUse `c'
outreg2 using ps6.doc, append ctitle(Model 2)
//Dummy variables//
generate gdp=.
local s StateGDP
foreach var of varlist `s'{
replace gdp=1 if `var'>256995.5 
replace gdp=0 if `var'>0 & `var'<256995.5
}
generate trans=.
local p Transportation
foreach var of varlist `p'{
replace trans=1 if `var'>37.06764
replace trans=0 if `var'>0 & `var'<37.06764
}
reg CO2 gdp trans
outreg using ps6.doc, append ctitle(Model 3)
/*Section one helped me to understand the statistical relationship between the variables especially betweem
carbon dioxide emissions and transportation energy emissions. This understanding pushed me further 
to look at other variables impacting carbon emissions like commute time to work, no. of workers,
no. of people using various forms of transit modes*/
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
destring v1, replace
destring v2, replace
destring v3, replace
destring v4, replace
destring v5, replace
destring v6, replace
destring v7, replace
destring v8, replace
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
replace `var' = subinstr(`var',",","",.) 
destring `var',gen(`var'Des)
}
drop numberofworkers Passtrips
rename numberofworkersDes workers
rename PasstripsDes Passtrip
rename percentpublictransportationexclu PPubtrans
rename percentcartruckorvandrovealone PercofCar
save ps6, replace
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
outreg2 using assign.doc, replace ctitle(Model 1) label
reg CO2 `a1'
outreg2 using assign.doc, append ctitle(Model 2) label
reg CO2 `a2'
outreg using assign.doc, append ctitle(Model 3) label
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
/*Section two helped me to better equip myself with the undertsanding of public transportation and it's
impact on climate change. Though there is no statistical significance between carbon emissions and percent of car used, commuter rail
used, or heavy rail used but if we look at the coefficient estimates; it does seem that usage of transit systems makes a significant amount of difference
in carbon emissions. The other drawback in this section was that it looked at State. To better understand transit modes its better to use
city level data and the following section looks at that*/
                            ************************
							*******Section Three****
							************************
/*This section focuses on metro level analysis of public transit and energy use.
There are still things which are remaining to analyze the data: Descriptive Statistics and Regressions.
So far the data has been cleaned and reshaped*/
/***********importing fifth dataset*********/
//The data is publicly available on American Council for an Energy-efficient Economy//
//The data entails the scores of how cities have performed in being energy efficient//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeYkJLdmFITFVDams&export=download", clear
rename state State
rename v1 City
keep City State cityscore transportationscore
save aceee, replace
clear
/***********importing sixth dataset**********/
//The data is publicly available on the National Transit Database//
insheet using "https://docs.google.com/uc?id=1C0uZullrRYlzfGWHKbxs66ennZ4D1-rW&export=download",clear
rename name Agency
rename city City
rename state State 
keep Agency City State legacyntdid ntdid organizationtype primaryuzapopulation agencyvoms mode typeofservice averagepassengertriplengthmi passengersperhour vehiclemiles trainmiles unlinkedpassengertrips passengermiles
save Service6, replace
clear
/***********importing seventh dataset********/
insheet using "https://docs.google.com/uc?id=197A3-ttIl3a614UD2MHqsjoFviW8iOB-&export=download",clear
rename name Agency
rename city City
rename state State
rename tos typeofservice
tostring ntdid, replace
keep Agency City State legacyntdid ntdid organizationtype primaryuzapopulation agencyvoms mode typeofservice modevoms dieselgal gasolinegal electricpropulsionkwh diesel gasoline electricpropulsion
save Fuel6, replace
clear   
//merge datasets//
use Service6, clear
merge m:m State using Fuel6.dta
rename _merge merge1
//second merge//
merge m:m State using aceee.dta
save final_adi, replace
clear
/***reorganizing the dataset***/
use final_adi
rename primaryuzapopulation uzapop
rename averagepassengertriplengthmi avgtriplgth
rename unlinkedpassengertrips passtrips
//label variables//
la var uzapop "Urbanized Population of the area"
la var avgtriplgth "Average trip lenght"
la var passengersperhour "Average Passengers per hour"
la var passtrips "Unlinked Passenger trips"
la var passengermiles "Passenger Miles travelled"
//converting 0 to missing values//
foreach var of varlist uzapop vehiclemiles trainmiles passengermiles dieselgal gasolinegal electricpropulsionkwh diesel gasoline electricpropulsion {
replace `var'="." if `var'=="0"
}
drop avgtriplgth agencyvoms vehiclemiles trainmiles modevoms
//destring variables//
foreach var of varlist uzapop dieselgal gasolinegal electricpropulsionkwh diesel gasoline electricpropulsion {
replace `var' = subinstr(`var',",","",.)
destring `var', replace
} 
foreach var of varlist passtrips passengermiles {
replace `var' = subinstr(`var',",","",.)
destring `var', replace
}  
destring passengersperhour, replace
//making my own data dictionary for variables in stata //
note uzapop: The population of the urbanized area primarily served by the agency.
note passtrips: The number of passengers who board public transportation vehicles. Passengers are counted each time they board a vehicle no matter how many vehicles they use to travel from their origin to their destination.
note passengermiles: The cumulative sum of the distances ridden by each passenger.
note dieselgal: Gallons of conventional (petroleum) diesel fuel used.
note gasolinegal: Gallons of gasoline used.
note electricpropulsionkwh: Kilowatt-hours of electricity used to propel vehicles by directly providing power via a third rail or overhead catenary.
note diesel: Agencies report use of conventional diesel and biodiesel separately, but do not report the miles traveled by conventional diesel- and biodiesel-fueled vehicles separately. This table reflects that reporting structure. Gallons of conventional diesel and gallons of biodiesel used are added together to calculate miles per gallon for diesel vehicles.
save final_adi, replace
/****trying to understand the dataset and correlation between variables. For this I will
focus only on one state****/
use final_adi,clear
keep if State=="CA"
drop merge1 _merge
drop transportationscore 
corr dieselgal passtrips //positive correlation between the two//
corr diesel passengermiles uzapop //no correlation//
corr dieselgal passengermiles uzapop //strong positive correlation between diesel gas consumed and passengermiles travelled//
gen both=mode+"_"+typeofs
drop passengersperhour typeofservice mode
reshape wide uzapop passtrips passengermiles dieselgal gasolinegal electricpropulsionkwh diesel gasoline electricpropulsion cityscore, i(ntdid) j(both) string

//descriptive statistics//
twoway(scatter dieselMB_DO uzapopMB_DO) (lfit dieselMB_DO uzapopMB_DO), ytitle("Motorbus miles travelled on Diesel")xtitle("Urbanized population using Motorbus")
twoway(scatter dieselMB_DO passtripsMB_DO) (lfit dieselMB_DO passtripsMB_DO), ytitle("Motorbus miles travelled on Diesel")xtitle("Passenger trips on Motorbus")
graph bar uzapopMB_DO passtripsMB_DO, over(dieselMB_DO)
compress
graph bar uzapopMB_DO passtripsMB_DO, over(City)
reg dieselMB_DO uzapopMB_DO passtripsMB_DO passengermilesMB_DO
reg dieselgalMB_DO uzapopMB_DO passtripsMB_DO passengermilesMB_DO
//there is no statistical significance that for every passenger trip travelled on motorbus there is decrease in gallons of diesel used for motor bus//
//I still need to dig deep into literature to do a profound data analysis on the relations between transit systems and carbon emissions//
/*****looking at California and Pennsylvania State****/
use final_adi
keep if inlist(State,"CA","PA") 
reg dieselgal uzapop passtrips
global b uzapop passtrips
reg dieselgal $b if mode=="CB"
reg dieselgal $b if mode=="MB"
reg gasolinegal $b if mode=="LR"
//there is no statistical significance that for every passenger trip travelled on motorbus or commuter bus there is decrease in gallons of diesel used//
//also there is no variability of the response data around its mean//
/*I have to keep reading literature on this topic and integrate CO2 emissions at city level and CO2 emissions from different modes,
maybe analysis of those data set along with demographics data might say something about the relationship.*/
//I am going to keep working on this and hopefully publish a paper out of this.//
