
cd "/Users/nabarun/Documents/GitHub/covid/"

// Import RWJF data

import excel "2019_County_Health_Rankings_Data_v3.xls", sheet("Ranked Measure Data") allstring clear

	rename A fips
	rename B state
	rename C county
	rename D ypll
		la var ypll "Premature death - Years of Potential Life Lost Rate"
			drop E F G
				rename H ypll_black
					la var ypll_black "Black Years of Potential Life Lost Rate"
						rename I ypll_hispanic
							la var ypll_hispanic "Hispanic Years of Potential Life Lost Rate"
								rename J ypll_white 
									la var ypll_white "White Years of Potential Life Lost Rate"
	rename K fairpoorhealth
		la var fairpoorhealth "% in fair or poor health"
			drop L M N
	rename O poorphysicaldays

	rename AE smokers
		la var smokers "% of Adults who smoke tobacco"
			drop AF AG AH
	rename AI obesity
		la var obesity "% of Adults that report BMI >= 30"
			drop AJ AK AL
	rename AM food
		la var food "Food Environment Index - Indicator of access to healthy foods - 0 is worst, 10 is best"
			drop AN
	rename AO physicalinactive
		la var physicalinactive "% of adults that report no leisure-time physical activity"
			drop AP AQ AR
	rename AS exercise
		la var exercise "% of population with access to places for physical activity"
			drop AT
	rename AY alcdriving
		la var alcdriving "# of alcohol-impaired driving deaths"
			rename AZ drivingdeaths
				la var drivingdeaths "# Driving deaths"
					rename BA alcdriving_p
						la var alcdriving_p "% of driving deaths alcohol impaired"
							drop BB BC BD
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
	rename BX dentist
		la var dentist "# of dentists"
			rename BY dentist_rate
				la var dentist_rate "Dentists per 100,000 population"
					rename BZ dentist_ratio
						la var dentist_ratio "Population to Dentists ratio"
							drop CA
								drop dentist_ratio
	rename CB mhproviders
		la var mhproviders "# of mental health providers (MHP)"
			rename CC mhproviders_rate
				la var mhproviders_rate "Mental Health Providers per 100,000 population"
					rename CD mhproviders_ratio
						la var mhproviders_ratio "Population to Mental Health Providers ratio"
							drop CE
								drop mhproviders_ratio
	rename CF prevhosp
		la var prevhosp "# Discharges for Ambulatory Care Sensitive Conditions per 100,000 Medicare Enrollees"
			rename CH prevhosp_black
				la var prevhosp_black "Preventable Hosp. Rate for Blacks"
					rename CI prevhosp_hispanic
						la var prevhosp_hispanic "Preventable Hosp. Rate for Hispanics"
							rename CJ prevhosp_white
								la var prevhosp_white "Preventable Hosp. Rate for Whites"
									drop CG 
	rename CK mamo
		la var mamo "% of female Medicare enrollees having an annual mammogram (age 65-74)"
			rename CM mamo_black
				la var mamo_black "% mamography screened among Blacks"
					rename CN mamo_hispanic
						la var mamo_hispanic "% mamography screened among Hispanics"
							rename CO mamo_white
								la var mamo_white "% mamography screened among Whites"
									drop CL
	rename CP fluvaccine
		la var fluvaccine "% of annual Medicare enrollees having an annual flu vaccination"
			rename CR fluvaccine_black
				la var fluvaccine_black "% flu vaccinated among Blacks"
					rename CS fluvaccine_hispanic
						la var fluvaccine_hispanic "% flu vaccinated among Hispanics"
							rename CT fluvaccine_white
								la var fluvaccine_white "% flu vaccinated among Whites"
									drop CQ

	rename DD unemployed
		la var unemployed "Number of people ages 16+ unemployed and looking for work"
			rename DE laborforce
				la var laborforce "Size of the labor force"
					rename DF unemployed_p
						la var unemployed_p "% ages 16+ unemployed and looking for work"
							drop DG
	rename DH childpoverty
		la var childpoverty "Percentage of children (under age 18) living in poverty"
			rename DL childpoverty_black
				la var childpoverty_black "% Black child poverty"
					rename DM childpoverty_hispanic
						la var childpoverty_hispanic "% Hispanic child poverty"
							rename DN childpoverty_white
								la var childpoverty_white "% White child poverty"		
									drop DI DJ DK			
	rename DO income80
		la var income80 "80th percentile of median household income"
			rename DP income20
				la var income20 "20th percentile of median household income"
					rename DQ incomeratio
						la var incomeratio "Ratio of household income at 80th% to income at 20th %"
							drop DR

	rename EJ airpol
		la var airpol "PM2.5 Avg. daily amount of fine particulate matter in micrograms per cubic meter"
			drop EK
	gen int waterviolation=.
		replace waterviolation=1 if EL=="Yes"
		replace waterviolation=0 if EL=="No"
			order waterviolation, a(EL)
				label define binary 1 "Yes" 0 "No"
					label values waterviolation binary
						drop EM EL
	rename EN housingprob
		la var housingprob "% of households with at least 1 of 4 housing problems: overcrowding, high housing costs, or lack of kitchen or plumbing facilities"
			drop EO EP
	rename EQ housingburden
		la var housingburden "% of households with high housing costs"
			rename ER overcrowding
				la var overcrowding "% of households with overcrowding"
					rename ES inadhousing
						la var inadhousing "% of households with lack of kitchen or plumbing facilities"
							drop ET
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
	
	drop P Q R S T U V W X Y Z AA AB AC AD AU AV AW AX BE BF BG BH BI BJ BK BL BM BN CU CV CW CX CY CZ DA DB DC DS DT DU DV DW DX DY DZ EA EB EC ED EE EF EG EH EI EY EZ FA  
	
	distinct fips
	
	save chrdetail, replace

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

// Import cell tower mobility data
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
				by county: egen last3_m50=mean(m50) if weekdays >= lastweekday-2 & weekdays!=.
				by county: egen last3_sample=total(samples) if weekdays >= lastweekday-2 & weekdays!=.
				by county: egen last3_pctchange=mean(m50_index) if weekdays >= lastweekday-2 & weekdays!=.

		collapse (max) last3_m50 last3_pctchange last3_sample date (sum) samples, by(fips county)
			la var last3_m50 "Median km traveled (last 3 weekdays)"
			la var last3_sample "Number of cell trace samples during last 3 weekdays"
			la var last3_pctchange "% change in median mobility since baseline"
			note last3_pctchange: Baseline 17Feb to 07Mar; % change since then until last 3 weekdays
	
		distinct fips

	save dlmobility, replace
	
	
// Merge datasets
		
	clear
	use chrdetail
	
	merge 1:1 fips using dlmobility, keep(1 3) nogen

	merge 1:1 fips using rucc, keep(1 3) nogen
	order county, a(fips)

	drop if county==""
	
	merge 1:1 county state using google_mobility, keep(1 3) nogen

	drop if last3_m50==.
		
	sort state county 
	
//	Create quintiles
		
	local vars last3_pctchange subunit_grocery subunit_parks subunit_residential subunit_retail subunit_transit subunit_work
	
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
	
	la var
	
	* Create quintiles of DL mobility
	xtile temp = last3_pctchange, nq(5)
		gen iso5=.
		 replace iso5=1 if temp==5
			replace iso5=2 if temp==4
				replace iso5=3 if temp==3
					replace iso5=4 if temp==2
						replace iso5=5 if temp==1
							order iso5, a(trend)
								la var iso5 "Distancing: Lowest (1) to Highest (5)"
									drop temp
	
	* Create quintiles of Google Location Services data
	xtile temp = last3_pctchange, nq(5)
		gen iso5=.
		 replace iso5=1 if temp==5
			replace iso5=2 if temp==4
				replace iso5=3 if temp==3
					replace iso5=4 if temp==2
						replace iso5=5 if temp==1
							order iso5, a(trend)
								la var iso5 "Distancing: Lowest (1) to Highest (5)"
									drop temp
	
	la var fluvaccine "% Medicare Beneficiaries Getting Flu Vaccine"
 
 save analysiset, replace
 
 
