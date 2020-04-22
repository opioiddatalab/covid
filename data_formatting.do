
cd "/Users/nabarun/Documents/GitHub/covid/"

// RUCC 2013 defintion data from SEER
clear all
import excel using "https://seer.cancer.gov/seerstat/variables/countyattribs/Rural.Urban.Continuum.Codes.1974.1983.1993.2003.2013.xls", allstring case(lower)
	rename A oldfips
	rename H rucc
		drop B D-G
			drop if oldfips=="FIPS"
				drop if rucc=="99"
	
		destring oldfips, g(temp)
			gen fips=oldfips if temp>10000
				replace fips="0"+oldfips if temp<10000
					drop temp oldfips C
			
						destring rucc, force replace
	save rucc, replace


// Import RWJF data: Additional Measures
import excel "/Users/nabarun/Documents/GitHub/covid/2019_County_Health_Rankings_Data_v3.xls", sheet("Additional Measure Data") clear
	rename A fips
	rename B state
	rename C county
	
	rename D lifeexp
		la var lifeexp "Life expectancy"
	rename K premdeathageadj
		la var premdeathageadj "Age-Adjusted Premature Mortality"
	rename R childmortrate
		la var childmortrate "Child Mortality Rate"
	rename Y infantmort
		la var infantmort "Infant Mortality Rate"
	rename AE freqphysdist
		la var freqphysdist "% Frequent Physical Distress"
	rename AH freqmentdist
		la var freqmentdist "% Frequent Mental Distress"
	rename AK diabetic
		la var diabetic "% Diabetic (Diabetes prevalence)"
	rename AO hiv
		la var hiv "HIV Prevalence Rate"
	rename AQ foodinsec
		la var foodinsec "% Food Insecure"
	rename AS healthyfoods
		la var healthyfoods "% Limited access to healthy foods"
	rename AU drugod
		la var drugod "Durg overdose mortality rate"
	rename AW crashdeaths
		la var crashdeaths "Motor vehicle crash deaths rate"
	rename AZ nosleep
		la var nosleep "% Insufficient Sleep"
	rename BN medianincome
		la var medianincome "Median household income"
	rename BT schoollunch
		la var schoollunch "% Children eligible for free or reduced price lunch"
	rename BU segregation_bw
		la var segregation_bw "Segregation index: Residential segregation - black/white"
	rename BV segregation_wnw
		la var segregation_wnw "Segregation index: Residential segregation - white/non-white"
	rename BW homiciderate
		la var homiciderate "Homicide rate"
	rename CA firearmdeaths
		la var firearmdeaths "Firearm fatality rate"
	rename CE homeown
		la var homeown "Homeownership: % Homeowners"
	rename CI housingburden
		la var housingburden "% Severe Housing Cost Burden"
		
	// Demographics
	rename CL totalpop
		la var totalpop "Population 2017 Census"
	rename CM youth
		la var youth "% younger than 18 years-old"
	rename CN elderly
		la var elderly "% older than 64 years-old"
	rename CP black_p
		la var black_p "% African-American"
	rename CR native_p
		la var native_p "% Native American"
	rename CT asian_p
		la var asian_p "% Asian American"
	rename CV pacisl_p
		la var pacisl_p "% Pacific Islanders"
	rename CX hispanic
		la var hispanic "% Hispanic"
	rename CZ nhw_p
		la var nhw_p "% Non-Hispanic white"
	rename DB notenglishprof
		la var notenglishprof "% Not proficient in English"
	rename DE female
		la var female "% female"
	rename DG rural
		la var rural "% population rural"
		
		
	local varsofmine "lifeexp premdeathageadj childmortrate infantmort freqphysdist freqmentdist diabetic foodinsec healthyfoods drugod crashdeaths nosleep medianincome schoollunch segregation_bw segregation_wnw homiciderate homeown totalpop youth elderly black_p native_p asian_p pacisl_p hispanic nhw_p female rural housingburden"
	
	keep `varsofmine' fips state county
	
	drop if fips==""
	drop if fips=="FIPS"
	
	destring `varsofmine', replace force
	
	save addlmeasures, replace
	
		
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
	rename ER overcrowding
		la var overcrowding "% of homes with overcrowding"
	
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
	
	keep fips state countyshort ypll food physicalinactive exercise uninsured uninsured_p pcp_rate pcp pcp_ratio mhproviders mhproviders_rate fluvaccine income80 income20 incomeratio drivealone_p longcommute_p overcrowding
	
	distinct fips
	
	save covidchrdetail, replace

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
	
	* Metrics
		di "Samples from baseline period February 17 to March 7, 2020:"
			qui: su samples if date>=mdy(2,17,2020) & date<= mdy(3,7,2020)
			di r(sum)
			
	
	* Create last 3 day moving average of last 3 weekdays
		
		* Keep only last 3 weekdays
		keep if dow(date)!=0 & dow(date)!=6
	
			local latestweekday: disp %td r(max)
				di "`latestweekday'"
					gen latest=`latestweekday'
		
		su date 
			keep if date>=r(max)-2	
			
				by county: egen last3_m50=mean(m50) 
				by county: egen last3_sample=total(samples) 
				by county: egen last3_index=mean(m50_index) 
			
		collapse (max) last3_m50 last3_index last3_sample (sum) samples, by(fips county)
			
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
	
	merge m:1 fips using sixrankings, keep(1 3) nogen
	
	merge 1:1 fips using addlmeasures, keep (1 3) nogen
	
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
								la var q_`i' "Social Distancing: Lowest (1) to Highest (5)"
									drop temp
			replace `i' = -1*`i'
		}
		
	* Generate indicator variable for top 20% of social distancing intensity
		gen toptier = 0
			replace toptier=1 if iso5==5
				la var toptier "Dummy variable comapring top 20% to bottom 80% in mobility decrease"
				
	* Generate indicator variables for mobility change
		qui: tabulate iso5, generate(levels)

// Create variable to indicate staty-at-home orders (1=orders, 0=no orders)
	* Source: Mervosh et al. https://www.nytimes.com/interactive/2020/us/coronavirus-stay-at-home-order.html
	
		gen homeorder=1
			replace homeorder=0 if state=="Arkansas"
			replace homeorder=0 if state=="Iowa"
			replace homeorder=0 if state=="North Dakota"
			replace homeorder=0 if state=="South Dakota"
			replace homeorder=0 if state=="Nebraska"
			replace homeorder=0 if state=="Oklahoma"
				replace homeorder=1 if state=="Oklahoma" & county=="Oklahoma" //OKC Edmond
				replace homeorder=1 if state=="Oklahoma" & county=="Sequoyah" // Sallisaw
				replace homeorder=1 if state=="Oklahoma" & county=="Payne" // Stillwater
				replace homeorder=1 if state=="Oklahoma" & county=="Carter"  // Ardmore
				replace homeorder=1 if state=="Oklahoma" & county=="Cleveland" // Norman, Moore
				replace homeorder=1 if state=="Oklahoma" & county=="Rogers" // Claremore
				replace homeorder=1 if state=="Oklahoma" & county=="Tulsa" // Tulsa
			replace homeorder=0 if state=="Utah"
				replace homeorder=1 if state=="Utah" & county=="Davis"
				replace homeorder=1 if state=="Utah" & county=="Salt Lake"
				replace homeorder=1 if state=="Utah" & county=="Summit"
			replace homeorder=0 if state=="Wyoming"
				replace homeorder=1 if state=="Wyoming" & county=="Teton" // Jackson
				
			la var homeorder "Stay at home order for COVID-19"
				note homeorder: From Mervosh et al. https://www.nytimes.com/interactive/2020/us/coronavirus-stay-at-home-order.html
				note homeorder: As of April 21, 2020
			
		
	
	la var fluvaccine "% Medicare Beneficiaries Getting Flu Vaccine"
 
 save analysiset, replace
 
 
