*ps2
*Aditi Manke
*Data Management
//great! good preamble with clear and concise information

//and good description of data, btw can also block comment many lines
/* this
is
a 
block
comment
*/

//and good description of what you are trying to do here!
//The data is publically available on CAIT Climate Data Explorer, World Resources Institute//
//This dataset focuses on the hostorical emissions of U.S. states from 1990-2011//
//some commands are taken from my previous project on climate change//
//aim to merge it with local city database, which covers performance of cities on being energy efficient//

//importing and restructuring data//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeekoxWHJuX19oZDQ&export=download",clear 

cd "D:\PhD Public Affairs\Fall 2017\DataManagement"


//renaming variables
//maybe personal prefrence, but most people dont capitalize first letter of var name
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

l in 1 //can nicely see how things are named now and what they used to be

//and now get rid of first row
drop in 1/1

//to destring other variables
destring *, replace


save GHG, replace  //this part doesnt make sense you clear memory so there is nothing to work with
//! it breaks here; guess you meant to load it back here
use GHG, clear

//keeping data of one year//
keep if Year==2011
drop if State=="United States"

//gen & replace//
tab StateGDP
tab StateGDP, mi

//could explain here that you gen a dummy for mean, and better yet label properlu;
//and name of var should be like gdpMean or sth like that
generate gdp=.
replace gdp=1 if StateGDP>256995.5
replace gdp=0 if StateGDP>0 & StateGDP<256995.5
la var gdp "gdp gt mean"

//same here
gen trans=.
replace trans=1 if Transportation>37.06764
replace trans=0 if Transportation>0 & Transportation<37.06764

//this part doesnt do anything
/*
//Egen//
use GHG, clear
tostring Year, replace
keep if Year=="2011"
drop if State=="United States"
*/

egen avg_StateGDP=mean(StateGDP) 
//taking average of State GDP and later observing the relation between GDP and state emissions//
gen dev_StateGDP=StateGDP-avg_StateGDP 
//looking at how much individual state gdp's deviate from the average//
bys State: egen avgState_StateGDP=mean(StateGDP) //sorted original GDP of each state respectively//



//collapse//
ssc install dataex
input str20 name byte census_region
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
//r(199) command end unrecognized//
label values census_region census_region
label def census_region 1 "Northeast", modify
label def census_region 2 "Midwest", modify
label def census_region 3 "South", modify
label def census_region 4 "West", modify

//there is a big mistake here!
 edit State name //places do not match!! should rather save the inputed names on hd
 //and then merge them!




collapse StateGDP Transportation, by(census_region)
l
//looking at the average gdp and emissions from transportation sector region wise//

use GHG, clear
tostring Year, replace
keep if Year=="2011"
drop if State=="United States"
collapse StateGDP Transportation Traveltime, by(census_region)
l


//limitation: it was really difficult to play around with codes like recode and collapse for this dataset since I could not destring variable State and group them region wise like East, West etc//
//and recoding other numeric variables was not making any sense//

gen GDP = (StateGDP>256995.5)
l State StateGDP avg_StateGDP dev_StateGDP GDP in 1/20, nola

egen avg_Traveltime=mean(Traveltime)

gen TT = (Traveltime>23.74902)
l State avg_StateGDP avg_Traveltime GDP TT in 1/20, nola 
//The assumption over here was that the states having GDP above the average StateGDP would also have travel time above the average travel time to work
//it was interesting to see states whose GDP was less than avg StateGDP had higher travel time to work, this might be due to lack of transportation
//or the distance from home to work is much greater. 

/*merge*/
use GHG, clear //again this doesntmakes sense--it is kind of dangling there; 
//and doesnt do anything beacuse the next insheet destroys it

insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeYkJLdmFITFVDams&export=download", clear
ta state //these are 2 letter codes! should have a corresponding codes in the other dataset!
//and there are many--so should collapse them!
rename state State

save aceee, replace
clear


use GHG,clear
ta State
keep if Year==2011

merge 1:1 State using aceee.dta
//error r(459), variable State does not uniquely identify observations in the master data//

//good start! but needs more work and care!!
