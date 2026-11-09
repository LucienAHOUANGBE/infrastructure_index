/*******************************************************************************
Do file de mise à jours de traitement des données : Infrastructure
Author : Vignawou Lucien AHOUANGBE
Contact : lucienahouangbe@gmail.com
Date : 15/04/2026

*******************************************************************************/



**# 1. Intialisation
clear all
set more off
version 17  

gl initPath "`c(pwd)'"
gl dtin "${initPath}/Input_Data"
gl dtout "${initPath}/Output_Data"


**# 2. WDI Data
	cap confirm file "${dtin}/WDI_Infrastructure.xlsx"
	if _rc {
		di as err "Lance ce do-file depuis la racine du dépôt (cd ...)"
		exit 601
	}
	* This script comes from : https://sites.google.com/site/lucienahouangbe/others/stata-programs
	
	import excel using "${dtin}/WDI_Infrastructure.xlsx", sheet(elec) firstrow case(l) clear
	ds, has(type numeric)
	foreach v in `r(varlist)' {
		loc m: var label `v'
		ren `v' elec`m'
	}
	ren countrycode ccode
	reshape long elec, i(ccode) j(year)
	levelsof indicatorname
	la var elec `r(levels)'
	drop coun* ind*
	
	glo bases container_port air_transport air_transport_freigth air_transport_passengers railways_goods railways_passengers rail_lines liner_shipping_connexion  mobile_phone fixed_phone internet_user water1 water2 mobile rail_lines_goods rail_lines_passengers // define the name of the global in your code do-file
foreach bas of global bases {
	preserve
		import excel using "${dtin}/WDI_Infrastructure.xlsx", sheet(`bas') firstrow case(l) clear
		
		ds, has(type numeric)
		foreach v in `r(varlist)' {
			loc m: var label `v'
			ren `v' `bas'`m'
		}
		
		ren countrycode ccode
		reshape long `bas', i(ccode) j(year)
		levelsof indicatorname
		la var `bas' `r(levels)'
		drop coun* ind*
		tempfile base0
		save `base0'
	restore

	merge 1:1 ccode year using `base0'
	drop _merge
}



		*** les variables roads
		preserve
			import delimited "${dtin}/WEF_GCIHH_EOSQ057_WIDEF_Road1.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' road`m'
			}
			keep if unit_measure == "1_TO_7"
			ren ref_area ccode
			keep ccode road*
			tempfile road1
			save `road1', replace
		restore
		
		
		preserve
			import delimited "${dtin}/WEF_GCIHH_EOSQ057_WIDEF_Road2.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' road`m'
			}
			keep if unit_measure == "1_TO_7"
			ren ref_area ccode
			keep ccode road*
			tempfile road2
			save `road2', replace
		restore
		
		preserve
			import delimited "${dtin}/WEF_TTDI_EOSQ057_WIDEF_Road3.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' road`m'
			}
			keep if type == "WEF_TTDI_SCR"
			ren ref_area ccode
			keep ccode road*
			tempfile road3
			save `road3', replace
		restore
		
		preserve
			u `road1', clear
			mer 1:1 ccode using `road2', nogen
			mer 1:1 ccode using `road3', nogen
			reshape long road , i(ccode) j(year)
			tempfile road
			save `road', replace
		restore
		
		mer 1:1 ccode year using `road', nogen
		la var road "Quality of roads, 1-7 (best) WEF_TTDI"
		
		*** Air
		preserve
			import delimited "${dtin}/WEF_GCIHH_EOSQ061_WIDEF_Air1.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' air`m'
			}
			keep if unit_measure == "1_TO_7"
			ren ref_area ccode
			keep ccode air*
			tempfile air1
			save `air1', replace
		restore
		
		
		preserve
			import delimited "${dtin}/WEF_TTDI_TTDI_C_09_WIDEF_Air2.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' air`m'
			}
			keep if unit_measure == "1_TO_7"
			ren ref_area ccode
			keep ccode air*
			tempfile air2
			save `air2', replace
		restore
		
		preserve
			import delimited "${dtin}/WEF_TTDI_EOSQ486_WIDEF_Air3.csv", clear
			drop unit_mult
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' air`m'
			}
			keep if type == "WEF_TTDI_SCR"
			ren ref_area ccode
			keep ccode air*
			tempfile air3
			save `air3', replace
		restore
		
		preserve
			u `air1', clear
			mer 1:1 ccode using `air2', nogen
			mer 1:1 ccode using `air3', nogen
			reshape long air , i(ccode) j(year)
			tempfile air
			save `air', replace
		restore
		
		mer 1:1 ccode year using `air', nogen
		la var air "Efficiency of air transport services, 1-7 (best) WEF_TTDI"
		
		preserve
			import delimited "${dtin}/WB_LPI_WIDEF.csv", clear
			drop unit_mult decimals time_format
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' lpi`m'
			}
			
			keep if comp_breakdown_2=="WB_LPI_SC" | comp_breakdown_2=="Not Applicable"
			
			g vars = ""
			replace vars = "lpi_customs" if comp_breakdown_1_label == "Component: Customs"
			replace vars = "lpi_intShip" if comp_breakdown_1_label == "Component: International Shipping"
			replace vars = "lpi_track_trac" if comp_breakdown_1_label == "Component: Tracking and tracing"
			replace vars = "lpi_total" if comp_breakdown_1_label == "Total"
			replace vars = "lpi_timeline" if comp_breakdown_1_label == "Component: Timeliness"
			replace vars = "lpi_logistic" if comp_breakdown_1_label == "Component: Logistics"
			replace vars = "lpi_infra" if comp_breakdown_1_label == "Component: Infrastructure"
			ren ref_area ccode
			isid ccode vars 
			keep ccode vars lpi*
			
			reshape long lpi, i(ccode vars) j(year)
			reshape wide lpi, i(ccode year) j(vars) s
			ren lpi* *
			la var lpi_customs "LPI Component: Customs"
			la var lpi_intShip "LPI Component: International Shipping"
			la var lpi_track_trac "LPI Component: Tracking and tracing"
			la var lpi_total "LPI Total"
			la var lpi_timeline "LPI Component: Timeliness"
			la var lpi_logistic "LPI Component: Logistics"
			la var lpi_infra "LPI Component: Infrastructure"
			
			tempfile lpi
			save `lpi', replace
		restore
		
		merge 1:1 ccode year using `lpi', nogen
		*** 
		*** les variables rails road
		preserve
			import delimited "${dtin}/WEF_GCIHH_EOSQRAILROAD_WIDEF_rail_road_2009-2017", clear
			drop unit_mult* unit_measure_*
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' rail_road`m'
			}
			keep if unit_measure == "1_TO_7"
			ren ref_area ccode
			keep ccode rail_road*
			tempfile rail_road1
			save `rail_road1', replace
		restore
		
		
		preserve
			import delimited "${dtin}/WEF_GCI_RAILINF_WIDEF_rail_road_2017-2019.csv", clear
			drop unit_mult*
			ds, has(type numeric)
			foreach v in `r(varlist)' {
				loc m: var label `v'
				ren `v' rail_road`m'
			}
			keep if unit_measure_id == "1_TO_7"
			ren ref_area_id ccode
			keep ccode rail_road*
			tempfile rail_road2
			save `rail_road2', replace
		restore
		
		
		
		preserve
			u `rail_road1', clear
			*mer 1:1 ccode using `rail_road1', nogen
			mer 1:1 ccode using `rail_road2', nogen
			reshape long rail_road , i(ccode) j(year)
			tempfile rail_road
			save `rail_road', replace
		restore
		
		mer 1:1 ccode year using `rail_road', nogen
		la var rail_road "Quality of railroad infrastructure, 1-7 (best) WEF_GCI"
		
		glo infravars elec container_port air_transport air_transport_freigth air_transport_passengers railways_goods railways_passengers rail_lines liner_shipping_connexion mobile_phone fixed_phone internet_user water1 water2 mobile rail_lines_goods rail_lines_passengers road air lpi_customs lpi_infra lpi_intShip lpi_logistic lpi_timeline lpi_total lpi_track_trac rail_road
		
/*

pca container_port air_transport air_transport_freigth air_transport_passengers railways_goods railways_passengers rail_lines liner_shipping_connexion

pca container_port air_transport air_transport_freigth air_transport_passengers railways_goods railways_passengers rail_lines liner_shipping_connexion, comp(2)

predict infra_ind1 infraind_2
// 0.8386
*/

sa "${dtout}/InfrastructureData.dta", replace

u "${dtout}/InfrastructureData.dta", clear


drop lpi_customs lpi_intShip lpi_logistic lpi_timeline lpi_total lpi_track_trac
drop rail* // manque de données
drop air // s'arrette souvent en 2017
drop water2 // water1 est plus fournit
drop fixed_phone // déclin structurel

drop if year > 2021 | year < 2006


corr  air_transport_freigth air_transport air_transport_passengers
drop air_transport_freigth air_transport // on va prendre passengers seullement (proble corellation)

* imputation par la moyenne entre deux date

sort ccode year
** imputation par la moyenne
foreach v of var elec container_port air_transport_passengers liner_shipping_connexion mobile_phone internet_user water1 mobile road lpi_infra {
	bys ccode: replace `v' = (`v'[_n+1] + `v'[_n-1])/2 if missing(`v')
}

gen tcam = .

** imputation par le taux de croissance annuel moyen (des 5 derniers années)
* pour lpi_infra
forvalues y = 2019(1)2021 {
	cap drop tcam
	bys ccode: g tcam  = lpi_infra[_n-1] * (1 + ((lpi_infra[_n-1]/lpi_infra[_n-5])^(1/4) - 1)) if year == `y'
	*g tcam = L1.lpi_infra * (1 + ((L1.lpi_infra/L6.lpi_infra)^(1/5) - 1)) if year == `y'
	replace lpi_infra = tcam if year == `y' & missing(lpi_infra)	
	drop tcam
}

** container_port
foreach y in 2007 2006 {
	cap drop tcam
	bys ccode: g tcam  = container_port[_n+1] / (1 + ((container_port[_n+5]/container_port[_n+1])^(1/4) - 1)) if year == `y' 
	*g tcam = L1.lpi_infra * (1 + ((L1.lpi_infra/L6.lpi_infra)^(1/5) - 1)) if year == `y'
	replace container_port = tcam if year == `y' & missing(container_port)
	drop tcam
	
}


* standartisation des données : moyenne 0 et écart-type 1


foreach v of var elec container_port air_transport_passengers liner_shipping_connexion mobile_phone internet_user water1 road lpi_infra {
	egen std_`v' = std(`v')
}

glo infra_type1 lpi_infra road liner_shipping_connexion air_transport_passengers
glo infra_type2 lpi_infra road liner_shipping_connexion air_transport_passengers mobile_phone internet_user elec water1

glo std_infra_type1 std_lpi_infra std_road std_liner_shipping_connexion std_air_transport_passengers
glo std_infra_type2 std_lpi_infra std_road std_liner_shipping_connexion std_air_transport_passengers std_mobile_phone std_internet_user std_elec std_water1


egen infra_type1 = rowmean(${std_infra_type1})
egen infra_type2 = rowmean(${std_infra_type2})
 
sa "${dtout}/InfrastructureDataClean.dta", replace

foreach a in AFE AFW ARB CEB CSS EAP EAR EAS ECA ECS EMU EUU FCS HIC HPC IBD IBT IDA IDB IDX INX LAC LCN LDC LIC LMC LMY LTE MEA MIC MNA NAC OED OSS PRE PSS PST SAS SSA SSF SST TEA TEC TLA TMN TSA TSS UMC WLD {
	drop if ccode == "`a'"
}

export delimited ccode year infra_type1 infra_type2 using "${dtout}/InfrastructureIndex.csv", replace


/*
glo infra_type1 lpi_infra
glo infra_type2 lpi_infra road liner_shipping_connexion air_transport_passengers
glo infra_type3 lpi_infra road liner_shipping_connexion air_transport_passengers mobile_phone internet_user elec water1

br ccode year ${infra_type1}
br ccode year ${infra_type2} 


drop if 

br if year > 2005
*/

