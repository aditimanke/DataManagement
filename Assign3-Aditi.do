*ps 3
*Aditi Manke
*Data Management

cd "D:\PhD Public Affairs\Fall 2017\DataManagement"

/*************importing first dataset************/
//The data is publically available on CAIT Climate Data Explorer, World Resources Institute//
//This dataset focuses on the hostorical emissions of U.S. states from 1990-2011//
//some commands are taken from my previous project on climate change//

use GHG, clear
tostring Year, replace
keep if Year=="2008"
drop if State=="United States"
keep State Year GHGExc CO2 Transportation StateGDP Population EnergyUse

save GHG08, replace
clear

/***********importing second dataset*********/
//The data is publicly available on American Council for an Energy-efficient Economy//
//The data entails the scores of how cities have performed in being energy efficient//

insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeYkJLdmFITFVDams&export=download", clear
rename state State
rename v1 City
keep City State cityscore transportationscore
replace State="Alabama" if State=="AL"
replace State="Alaska" if State=="AK"
replace State="Arizona" if State=="AZ"
replace State="Arkansas" if State=="AR"
replace State="California" if State=="CA"
replace State="Colorado" if State=="CO"
replace State="Connecticut" if State=="CT"
replace State="Delaware" if State=="DE"
replace State="Florida" if State=="FL"
replace State="Georgia" if State=="GA"
replace State="Hawaii" if State=="HI"
replace State="Idaho" if State=="ID"
replace State="Illinois" if State=="IL"
replace State="Indiana" if State=="IN"
replace State="Iowa" if State=="IA"
replace State="Kansas" if State=="KS"
replace State="Kentucky" if State=="KY"
replace State="Louisiana" if State=="LA"
replace State="Maine" if State=="ME"
replace State="Maryland" if State=="MD"
replace State="Massachusetts" if State=="MA"
replace State="Michigan" if State=="MI"
replace State="Minnesota" if State=="MN"
replace State="Mississippi" if State=="MS"
replace State="Missouri" if State=="MO"
replace State="Montana" if State=="MT"
replace State="Nebraska" if State=="NE"
replace State="Nevada" if State=="NV"
replace State="New Hampshire" if State=="NH"
replace State="New Jersey" if State=="NJ"
replace State="New Mexico" if State=="NM"
replace State="New York" if State=="NY"
replace State="North Carolina" if State=="NC"
replace State="North Dakota" if State=="ND"
replace State="Ohio" if State=="OH"
replace State="Oklahoma" if State=="OK"
replace State="Oregon" if State=="OR"
replace State="Pennsylvania" if State=="PA"
replace State="Rhode Island" if State=="RI"
replace State="South Carolina" if State=="SC"
replace State="South Dakota" if State=="SD"
replace State="Tennessee" if State=="TN"
replace State="Texas" if State=="TX"
replace State="Utah" if State=="UT"
replace State="Vermont" if State=="VT"
replace State="Virginia" if State=="VA"
replace State="Washington" if State=="WA"
replace State="West Virginia" if State=="WV"
replace State="Wisconsin" if State=="WI"
replace State="Wyoming" if State=="WY"
replace State="District of Columbia" if State=="DC"

save aceee, replace
clear

/*****importing third dataset*****/
//The data is publicly available on Bureau of Transportation Statistics//
//It contains urban ridership by State and Transit mode data, percent of workers taking rail,busor car//
insheet using "https://docs.google.com/uc?id=0B-xd5ZLItEIeRS0ycUNOT2ZCOFE&export=download", clear
drop in 1/3
rename v1 State
rename v2 Agencies
rename v3 Passtrips
rename v4 Mbus
rename v5 Hrail
rename v6 Lrail
rename v7 Crail
rename v8 Other

destring Agencies, replace
destring Passtrips, replace
destring Mbus, replace
destring Hrail, replace
destring Lrail, replace
destring Crail, replace
destring Other, replace

drop if State=="United States, total1"
drop if State=="1Excludes territories (Puerto Rico and Virgin Islands)"
drop if State=="NOTES:  This table includes data from urban transit agencies that are required to report information to the federal government because they applied for or are direct beneficiaries of urbanized area formula grants (49 USC 5307). Beginning in 2012, data include estimated industry totals for agencies with a Small Systems Waiver in place and Rural reporters. Data are assigned to the state of a transit agency's mailing address.  Details may not add to totals due to rounding. Light rail includes light rail, street car, and hybrid rail modes. Motorbus includes motorbus, commuter bus, and bus rapid transit. Other includes automated guideway, cable car, demand response, ferry boat, inclined plane, monorail, trolley bus, and van pool."
drop if State=="SOURCE: U.S. Department of Transportation, Federal Transit Adminstration, National Transit Database, table 19, available at www.ntdprogram.gov as of July 2015."

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
keep if Year=="2008"

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

/***reshape***/
// all the variables in this dataset are long//
use adi_ps3, clear
gen id=_n
reshape wide Crail, i(id) j(State,string) 
//here Crail is percent of people commuting via rail at state level//

