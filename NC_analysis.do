cd "/Users/nabarun/Documents/GitHub/covid/"

// Import and save RUCC codes
clear
import excel "ruralurbancodes2013.xls", sheet("Rural-urban Continuum Code 2013") cellrange(A1:F3222) firstrow
rename FIPS fips
rename RUCC_2013 rucc
drop Description County_Name State
save rucc, replace

// Import cell tower mobility data
clear
import delimited "/Users/nabarun/Documents/GitHub/DL-COVID-19/DL-us-mobility-daterow.csv"
	
	* Drop state aggregates
		drop if admin2==""
	
	* Limit to NC
		keep if admin1=="North Carolina"
			drop admin1 admin_level country_code
	
	* Date format
		
		
