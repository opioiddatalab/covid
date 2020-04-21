
// COMPARE March 1 to April 11 in Google and DL data by county-day


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

	* Create quintiles of DL mobility
	/*
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
		*/
	save dl_x_valid, replace
	



// Process Google app check-in data
clear
import delimited "/Users/nabarun/Documents/GitHub/covid/fips-google-mobility-daily-as-of-04-20-20.csv", stringcols(1) numericcols(5 6 8)  

	* Format date 				
		gen date=date(report_date, "YMD")
			format date %td
				order date, first
					drop report_date
	
	* Note data start and end dates for graphs
		su date 
			local latest: disp %td r(max)
				di "`latest'"
			local earliest: disp %td r(min)
				di "`'earliest'"
	
	* Retain latest data
	*su googledate 
	*		local latest: disp %td r(max)
	*			di "Keeping only records in Google mobility scrape from `latest'"
	*				keep if googledate==r(max)
		
		
	save google_x_valid, replace
	

	merge 1:1 date fips using dl_x_valid
	
	tab _merge
		keep if _merge==3
			drop _merge country_code admin_level
			
	* Variable cleanup
	

	
	foreach var of varlist retail_and_recreation_percent_ch-residential_percent_change_from_ {
	
		capture confirm numeric variable `var'
		if !_rc {
		
		destring `var', replace force
		*replace `var' = regexr(`var', "NULL","")
		*encode `var', replace force
		}
	
	}
	destring retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha workplaces_percent_change_from_b, replace force
		
	xtile retailrec = retail_and_recreation_percent_ch, n(10)
	xtile dl10 = m50_index, n(10)
	
	egenmore corretail = corr(retailrec,m50_index)
	
	heatplot retailrec dl10
	
