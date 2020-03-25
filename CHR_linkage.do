		
// Import RWJF data
import excel "/Users/nabarun/Dropbox/DATA/RWJ County Health Rankings/analyticdata/2019 County Health Rankings Data - v3.xls", sheet("Outcomes & Factors SubRankings") cellrange(A2:P3144) firstrow allstring clear

	rename ofRankedCounties totalcounties
	rename Rank lengthoflife
	rename Quartile lengthoflife_q
	rename G qualityoflife
	rename H qualityoflife_q
	rename I healthbehaviors
	rename J healthbehaviors_q
	rename K clinicalcare
	rename L clinicalcare_q
	rename M ses
	rename N ses_q
	rename O physicalenvironment
	rename P physicalenvironment_q
	note: RWJF Community Health Rankings 2019 v3 file
	rename FIPS fips
	drop State County
	
	foreach var of varlist totalcounties-physicalenvironment_q {
	replace `var'="" if `var'=="NR"
	}
	
	destring totalcounties-physicalenvironment_q, replace
	
save sixrankings, replace

import excel "/Users/nabarun/Dropbox/DATA/RWJ County Health Rankings/analyticdata/2019 County Health Rankings Data - v3.xls", sheet("Ranked Measure Data") allstring clear

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
		la var poorphysicaldays "# Physically unhealthy days"
			drop P Q R
	rename S poormentaldays
		la var poormentaldays "# Mentally unhealthy days"
			drop  T U V
	rename X lbw
		la var lbw "% of births with low birth weight (<2500g)"
			drop W Y Z AA
				rename AB lbw_black
					la var lbw_black "% Low Birth Weight among Blacks"
						rename AC lbw_hispanic
							la var lbw_hispanic "% Low Birth Weight among Hispanics"
								rename AD lbw_white
									la var lbw_white "% Low Birth Weight among Whites"
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
	rename AU xsdrinking
		la var xsdrinking "% of adults that report excessive drinking"
			drop AV AW AX
	rename AY alcdriving
		la var alcdriving "# of alcohol-impaired driving deaths"
			rename AZ drivingdeaths
				la var drivingdeaths "# Driving deaths"
					rename BA alcdriving_p
						la var alcdriving_p "% of driving deaths alcohol impaired"
							drop BB BC BD
	rename BE std
		la var std "# Chlamydia Cases"
			rename BF std_r
				la var std_r "Chlamydia cases per 100,000 population"
					drop BG
	rename BH teenbirth
		la var teenbirth "Births per 1,000 females ages 15-19"
			drop BI BJ BK
				rename BL teenbirth_black
					la var teenbirth_black "Teen birth rate among Blacks"
						rename BM teenbirth_hispanic
							la var teenbirth_hispanic "Teen birth rate among Hispanics"
								rename BN teenbirth_white
									la var teenbirth_white "Teen birth rate among Whites"
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
	rename CU hsgrad
		la var hsgrad "# of students expected to graduate"
			rename CV hsgrad_rate
				la var hsgrad_rate "High school graduation rate"
					drop CW
	rename CX somecollege
		la var somecollege "Adults age 25-44 with some post-secondary education"
			rename CZ somecollege_pct
				la var somecollege_pct "% of adults age 25-44 with some post-secondary education"
					drop CY DA DB DC
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
	rename DS singleparent
		la var singleparent "# of children that live in single-parent households"
			rename DT households
				la var households "# of children in households"
					rename DU singleparent_p
						la var singleparent_p "Percentage of children that live in single-parent households"
							drop DV DW DX
	rename DY socialassoc
		la var socialassoc "Number of associations"
			rename DZ socialassoc_r
				la var socialassoc_r "Social Associations per 10,000 population"
					drop EA
	rename EB violentcrime
		la var violentcrime "Number of violent crimes"
			rename EC violentcrime_r
				la var violentcrime_r "Violent crimes per 100,000 population"
					drop ED
	rename EE injury
		la var injury "Number of injury deaths"
			rename EF injury_r
				la var injury_r "Injury mortality rate per 100,000"
					drop EG EH EI
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
		la var drivealone "% of workers who drive alone to work"
			drop EV EW EX
				rename EY drivealone_black
					la var drivealone_black "% of Black workers who drive alone to work"
						rename EZ drivealone_hispanic
							la var drivealone_hispanic "% of Hispanic workers who drive alone to work"
								rename FA drivealone_white
									la var drivealone_white "% of White workers who drive alone to work"
	rename FB drivealone
		la var drivealone "# of workers who commute in their car, truck or van alone"
			rename FC longcommute_p
				la var longcommute_p "Among workers who commute in car alone, % that commute 30+ minutes"
					drop FD FE FF FG
				
	drop if fips=="" | fips=="FIPS"
	
	destring ypll-longcommute_p, replace
	
	cd "/Users/nabarun/Dropbox/Projects/Descartes Lab movement data/"
	
	save chrdetail, replace


clear
	import delimited "/Users/nabarun/Dropbox/Projects/Descartes Lab movement data/counties_flattened.csv"
	
	drop if county==""
		gen date2=date(date,"YMD")
			format date2 %td
				drop date
					rename date2 date

	replace county=regexr(county," County","")
		replace county=regexr(county," Parish","")
			drop if regexm(count,"City of")
				drop if state=="Virgina"

	gen min=m50_count
	gen max=m50_count
	gen median=m50_count
	
	sort state county date
	bysort state county: gen day=_n
	
	bysort state county: egen start3 = mean(m50_count) if inlist(day,1,2,3)
	bysort state county: egen end3 = mean(m50_count) if inlist(day,15,14,13)
	
	collapse (min) min start3 end3 (max) max (median) median, by(state county)

	gen trend=end3-start3
		gen isolating=1 if trend<0 & trend!=.
			replace isolating=0 if trend>=0 & trend!=.
		
merge m:1 state county using chrdetail, keep(3) nogen

	distinct county
	distinct county if trend==.

	drop if trend==.

	distinct county
	
	sort state county 
	
	cd "/Users/nabarun/Dropbox/Projects/Descartes Lab movement data/"
	
 	xtile temp = trend, nq(5)
		gen iso5=.
		 replace iso5=1 if temp==5
			replace iso5=2 if temp==4
				replace iso5=3 if temp==3
					replace iso5=4 if temp==3
						replace iso5=5 if temp==1
							order iso5, a(trend)
								la var iso5 "Social Distancing: Lowest (1) to Highest (5)"
									drop temp
	
	la var fluvaccine "% Medicare Beneficiaries Getting Flu Vaccine"
 
 save analysiset, replace
 
 
