
cd "/Users/nabarun/Documents/GitHub/covid/"

// Import RWJF data

import excel "2019_County_Health_Rankings_Data_v3.xls", sheet("Ranked Measure Data") allstring clear

	rename A fips
	rename B state
	rename C county
	rename D ypll
		la var ypll "Premature death - Years of Potential Life Lost Rate"

	rename AM food
		la var food "Food Environment Index - Indicator of access to healthy foods - 0 is worst, 10 is best"
			drop AN
	rename AO physicalinactive
		la var physicalinactive "% of adults that report no leisure-time physical activity"
			drop AP AQ AR
	rename AS exercise
		la var exercise "% of population with access to places for physical activity"
			drop AT
	rename BO uninsured
		la var uninsured "# under age 65 without insurance"
			rename BP uninsured_p
				la var uninsured_p "% under age 65 without insurance"
					drop BQ BR BS
	rename BT pcp
		la var pcp "# of primary care physicians (PCP) in patient care"
			rename BU pcp_rate
				la var pcp_rate "Primary Care Physicians per 100,000 population"
					rename BV pcp_ratio
						la var pcp_ratio "Population to Primary Care Physicians ratio"
							drop BW
	rename CB mhproviders
		la var mhproviders "# of mental health providers (MHP)"
			rename CC mhproviders_rate
				la var mhproviders_rate "Mental Health Providers per 100,000 population"
					rename CD mhproviders_ratio
						la var mhproviders_ratio "Population to Mental Health Providers ratio"
							drop CE
								drop mhproviders_ratio
	rename CP fluvaccine
		la var fluvaccine "% of annual Medicare enrollees having an annual flu vaccination"

	rename DO income80
		la var income80 "80th percentile of median household income"
			rename DP income20
				la var income20 "20th percentile of median household income"
					rename DQ incomeratio
						la var incomeratio "Ratio of household income at 80th% to income at 20th %"
							drop DR
	rename EU drivealone_p
		la var drivealone_p "% of workers who drive alone to work"
			drop EV EW EX
			
	rename FB drivealone
		la var drivealone "# of workers who commute in their car, truck or van alone"
			rename FC longcommute_p
				la var longcommute_p "Among workers who commute in car alone, % that commute 30+ minutes"
					drop FD FE FF FG
				
	drop if fips=="" | fips=="FIPS"
	
	destring ypll-longcommute_p, replace
	
	rename county countyshort
	
	keep fips state countyshort ypll food physicalinactive exercise uninsured uninsured_p pcp_rate pcp pcp_ratio mhproviders mhproviders_rate fluvaccine income80 income20 incomeratio drivealone_p longcommute_p
	
	distinct fips
	
	save covidchrdetail, replace

// Process Google app check-in data
clear
import delimited "/Users/nabarun/Documents/GitHub/covidnc/data/export-2020-04-05.csv" 
	
	drop v1
		
	* Convert proportions to percents 
	ds, has(type numeric)	
	foreach var of varlist `r(varlist)'  {
		replace `var'=`var'*100
		}

	* Format date and retain latest data
		rename subunit_name county
			order county, a(report_date)
				replace report_date=substr(report_date,1,10)
					gen googledate=date(report_date, "YMD")
						format googledate %td
							order googledate, first
								drop report_date
		
		su googledate 
			local latest: disp %td r(max)
				di "Keeping only records in Google mobility scrape from `latest'"
					keep if googledate==r(max)
		
	* Rename variables for consistency
		rename unit_name state
		
		drop unit*
		
	save google_mobility, replace
	
	distinct state county

// Import Descartes Labs
	clear
	import delimited "https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv", encoding(ISO-8859-9) stringcols(6) 

	* Drop state aggregates
		drop if admin2==""

	* Format date
		gen date2=date(date,"YMD")
			format date2 %td
				drop date
					rename date2 date
		
	* Note data start and end dates for graphs
		su date 
			local latest: disp %td r(max)
				di "`latest'"
			local earliest: disp %td r(min)
				di "`'earliest'"
	
	* Rename variables for consistency
		rename admin1 state
		rename admin2 county
	
	* Create last 3 day moving average of last 3 weekdays
		bysort county (date): egen weekdays=seq() if dow(date)!=0 & dow(date)!=6
			by county: egen lastweekday=max(weekdays)
			by county: egen firstweekday=min(weekdays)
			
				by county: egen last3_m50=mean(m50) if weekdays >= lastweekday-2 & weekdays!=.
				by county: egen last3_sample=total(samples) if weekdays >= lastweekday-2 & weekdays!=.
				by county: egen last3_index=mean(m50_index) if weekdays >= lastweekday-2 & weekdays!=.
				
				by county: egen first3_m50=mean(m50) if weekdays <= firstweekday+2 & weekdays!=.
				by county: egen first3_sample=total(samples) if weekdays <= firstweekday+2 & weekdays!=.
				by county: egen first3_index=mean(m50_index) if weekdays <= firstweekday+2 & weekdays!=.
				
				
		collapse (max) last3_m50 last3_index last3_sample first3_index first3_sample first3_m50 date (sum) samples, by(fips county)
			
			la var last3_m50 "Median km traveled (last 3 weekdays)"
			la var last3_sample "Number of cell trace samples during last 3 weekdays"
			la var last3_index "Total % change in median mobility since baseline"
			note last3_index: Baseline 17Feb to 07Mar; % change since then until last 3 weekdays
	
	
		distinct fips

	* Create quintiles of DL mobility
	
	xtile temp = last3_index, nq(5)
		gen iso5=.
		 replace iso5=1 if temp==5
			replace iso5=2 if temp==4
				replace iso5=3 if temp==3
					replace iso5=4 if temp==2
						replace iso5=5 if temp==1
							order iso5, a(last3_index)
								la var iso5 "Distancing: Lowest (1) to Highest (5)"
									drop temp
		
	save dlmobility, replace
	
	
// Merge datasets
		
	clear
	use covidchrdetail
	
	merge 1:1 fips using dlmobility, keep(1 3) nogen

	merge 1:1 fips using rucc, keep(1 3) nogen
	order county, a(fips)

	drop if county==""
	
	merge 1:1 county state using google_mobility, keep(1 3) nogen

	drop if last3_m50==.
		
	sort state county 
	
//	Create quintiles
		
	local vars subunit_grocery subunit_parks subunit_residential subunit_retail subunit_transit subunit_work
	
	foreach i of local vars {
	xtile temp = `i', nq(5)
		gen q_`i'=.
		 replace q_`i'=1 if temp==5
			replace q_`i'=2 if temp==4
				replace q_`i'=3 if temp==3
					replace q_`i'=4 if temp==2
						replace q_`i'=5 if temp==1
							order q_`i', a(`i')
								la var q_`i' "Distancing: Lowest (1) to Highest (5)"
									drop temp
		}
		
	
	la var fluvaccine "% Medicare Beneficiaries Getting Flu Vaccine"
 
 save analysiset, replace
 
 
