library(tidyverse)
library(readr)
library(DBI)

### Postgres Connection ###
db = 'postgres'  
host_db = 'localhost'    
db_port = '5432'  
db_user = 'postgres'  
db_password = 'saude123'
conn = dbConnect(RPostgres::Postgres(), 
                 dbname = db, 
                 host=host_db, 
                 port=db_port,
                 user=db_user, 
                 password=db_password)


###IMPORT DATA - GITLAB###
brazil_cases = read.csv('https://git.tecgraf.puc-rio.br/marcoscavalcanti/icodag2data/-/raw/main/brazil_cases.csv')
brazil_cities =  read.table('https://git.tecgraf.puc-rio.br/marcoscavalcanti/icodag2data/-/raw/main/brazil_cities.csv')
google_mobility_report  =  read.table("https://git.tecgraf.puc-rio.br/marcoscavalcanti/icodag2data/-/raw/main/google_mobility_report.csv") 
oxford_measures  =  read.table()
population_city_2020  =  read.table()
socioeconomic_cities  =  read.table()
socioeconomic_states  =  read.table()
srag  =  read.table()
view_vacc  =  read.table()

##01 Brazil Cases##

mutate(
    country = as.character(country),
    state = as.character(state),
    city_name = as.character(city_name),
    city_ibge_code = as.character(city_ibge_code)
  )


##02 Brazil Cities##
brazil_cities = dbGetQuery(conn,'SELECT * FROM brazil_cities')%>%
  mutate(
    city_ibge_code = as.character(city_ibge_code),
    city_ibge_code_06 = as.character(city_ibge_code_06),
    city_name = as.character(city_name)
  )


##03 Google Mobility Report##
google_mobility_report = dbGetQuery(conn, 'SELECT * FROM google_mobility_report')%>%
  mutate(
    country_code = as.character(country_code),
    country = as.character(country),
    state = as.character(state),
    sub_region = as.character(sub_region),
    metro_area = as.numeric(metro_area),
    iso_3166_2_code = as.character(iso_3166_2_code),
    census_fips_code = as.character(census_fips_code),
    place_id = as.character(place_id),
    date = as.Date(date),
    retail_and_recreation = as.character(retail_and_recreation),
    grocery_and_recreation = as.character(grocery_and_recreation),
    parks = as.character(parks),
    transit_stations = as.character(transit_stations),
    workplaces = as.character(workplaces),
    residential = as.character(residential)
  )

  
##04 Oxford Measures##
oxford_measures = dbGetQuery(conn,'SELECT * FROM oxford_measures')%>%
  mutate(
         date = as.Date(date),
         state = as.character(state),
         c1_school_closing = as.character(c1_school_closing),
         c2_workplace_closing = as.character(c2_workplace_closing),
         c3_cancel = as.character(c3_cancel),
         c4_restrictions_on_gatherings = as.character(c4_restrictions_on_gatherings),
         c5_close_public_transport = as.character(c5_close_public_transport),
         c6_stay_at_home_requirements = as.character(c6_stay_at_home_requirements),
         c7_restrictions_on_internal_movement = as.character(c7_restrictions_on_internal_movement),
         c8_international_travel_controls = as.character(c8_international_travel_controls),
         e1_income_support = as.character(e1_income_support),
         e2_debt_contract_relief = as.character(e2_debt_contract_relief),
         e3_fiscal_measures = as.character(e3_fiscal_measures),
         e4_international_support = as.character(e4_international_support),
         h1_public_information_campaigns = as.character(h1_public_information_campaigns),
         h2_testing_policy = as.character(h2_testing_policy),
         h3_contact_tracing = as.character(h3_contact_tracing),
         h4_emergency_investment_in_healthcare = as.character(h4_emergency_investment_in_healthcare),
         h5_investment_in_vaccines = as.character(h5_investment_in_vaccines),
         h6_facial_coverings = as.character(h6_facial_coverings),
         h7_vaccination_policy = as.character(h7_vaccination_policy),
         h8_protection_of_elderly_people = as.character(h8_protection_of_elderly_people),
         m1_wildcard = as.character(m1_wildcard),
         v1_vaccine_prioritisation_summary = as.character(v1_vaccine_prioritisation_summary),
         v2a_vaccine_availability_summary = as.character(v2a_vaccine_availability_summary), 
         v2b_vaccine_age_eligibility_availability_age_floor_general_popu = as.character(v2b_vaccine_age_eligibility_availability_age_floor_general_popu), 
         v2c_vaccine_age_eligibility_availability_age_floor_at_risk_summ = as.character(v2c_vaccine_age_eligibility_availability_age_floor_at_risk_summ), 
         v2d_medically_clinically_vulnerable_non_elderly = as.character(v2d_medically_clinically_vulnerable_non_elderly),                 
         v2e_education = as.character(v2e_education),                                                
         v2f_frontline_workers_non_healthcare = as.character(v2f_frontline_workers_non_healthcare),                            
         v2g_frontline_workers_healthcare = as.character(v2g_frontline_workers_healthcare),                                
         v3_vaccine_financial_support_summary = as.character(v3_vaccine_financial_support_summary),                            
         confirmedcases = as.character(confirmedcases),                                              
         confirmeddeaths = as.character(confirmeddeaths),                                                
         stringencyindex = as.character(stringencyindex),                                                
         stringencyindexfordisplay = as.character(stringencyindexfordisplay),                                       
         stringencylegacyindex = as.character(stringencylegacyindex),                                         
         stringencylegacyindexfordisplay = as.character(stringencylegacyindexfordisplay),                                 
         governmentresponseindex = as.character(governmentresponseindex),                                     
         governmentresponseindexfordisplay = as.character(governmentresponseindexfordisplay),                               
         containmenthealthindex = as.character(containmenthealthindex),                                     
         containmenthealthindexfordisplay = as.character(containmenthealthindexfordisplay),                                
         economicsupportindex = as.character(economicsupportindex),                                     
         economicsupportindexfordisplay = as.character(economicsupportindexfordisplay)
          )%>%
  select(-c(countryname,
            countrycode,
            regionname,
            jurisdiction,
            c1_flag,
            c2_flag,
            c3_flag,
            c4_flag,
            c5_flag,
            c6_flag,
            c7_flag,
            e1_flag,
            h1_flag,
            h6_flag,
            h7_flag,
            h8_flag,
            confirmedcases,
            confirmeddeaths))

##05 Population City 2020##
population_city_2020 = dbGetQuery(conn,'SELECT * FROM population_city_2020')%>%
  mutate(
    city_ibge_code = as.character(ibge_code),
    city_name = as.character(city_name),
    gender = as.character(gender),
    age_group = as.character(age_group),
    population = as.numeric(population),
    state = as.character(state)
  )

##06 Socioeconomic Cities##
socioeconomic_cities = dbGetQuery(conn,'SELECT * FROM socioeconomic_cities')%>%
  mutate(
    city_ibge_code = as.character(code7),
    city_ibge_code_06 = as.character(code6),
    city_name = as.character(city_name),
    state = as.character(state),
    north_region = as.character(north_region),
    northeast_region = as.character(northeast_region),
    middlewest_region = as.character(middlewest_region),
    southeast_region = as.character(southeast_region),
    south_region = as.character(south_region),
    metropolitan_region = as.character(metropolitan_region),
    cases = as.numeric(cases),
    deaths = as.numeric(deaths),
    gdp = as.numeric(gdp),
    gdp_per_capita = as.numeric(gdp_per_capita),
    gini = as.numeric(gini),
    population = as.numeric(population),
    area = as.numeric(area),
    demographic_density = as.numeric(demographic_density),
    urban_percentage = as.numeric(urban_percentage),
    masculine_percentage = as.numeric(masculine_percentage),
    white_percentage = as.numeric(white_percentage),
    over60_percentage = as.numeric(over60_percentage),
    doctors_100k = as.numeric(doctors_100k),
    ln_doctors_100k = as.numeric(ln_doctors_100k),
    icubeds_100k = as.numeric(icubeds_100k),
    ln_leitos_100mil = as.numeric(ln_leitos_100mil),
    superior_education_percentage = as.numeric(superior_education_percentage)
  )

##07 Socioeconomic States##
socioeconomic_states = dbGetQuery(conn,'SELECT * FROM socioeconomic_states')%>%
  mutate(
    state = as.character(state),
    region = as.character(region),
    area = as.numeric(area),
    gdp_2019 = as.numeric(gdp_2019),
    gdp_per_capita_2019 = as.numeric(gdp_per_capita_2019),
    demographic_density = as.numeric(demographic_density),
    population_2021 = as.numeric(population_2021),
    hdi_2010 = as.numeric(hdi_2010),
    hdi_income_2010 = as.numeric(hdi_income_2010),
    hdi_education_2010 = as.numeric(hdi_education_2010),
    hdi_health_2010 = as.numeric(hdi_health_2010),
    life_expectancy_2010 = as.numeric(life_expectancy_2010)
  )


##08 SRAG Simple##
srag = dbGetQuery(conn,'SELECT * FROM srag_simple')%>%
  rename("date_notification" = "notification_date",
         "date_symptoms" = "symptoms_date",
         "date_outcome" = "outcome_date"
    )%>%
  mutate(
    state = as.character(state),
    gender = as.character(gender),
    age_group = as.character(age_group),
    race = as.character(race),
    schooling = as.character(schooling),
    fever = as.character(fever),
    cough = as.character(cough),
    sore_throat = as.character(sore_throat),
    dyspnea = as.character(dyspnea),
    respiratory_distress = as.character(respiratory_distress),
    saturation = as.character(saturation),
    diarrhea = as.character(diarrhea),
    vomit = as.character(vomit),
    other_symptoms = as.character(other_symptoms),
    risk_factor = as.character(risk_factor),
    heart_disease = as.character(heart_disease),
    hematological_disease = as.character(hematological_disease),
    down_syndrome = as.character(down_syndrome),
    liver_disease = as.character(liver_disease),
    asthma = as.character(asthma),
    diabetes = as.character(diabetes),
    neurological_disease = as.character(neurological_disease),
    lung_disease = as.character(lung_disease),
    immunosuppression = as.character(immunosuppression),
    kidney_disease = as.character(kidney_disease),
    obesity = as.character(obesity),
    others_comorbidities = as.character(others_comorbidities),
    icu = as.character(icu),
    outcome = as.character(outcome)
  )


##09 VIEW VACC##
view_vacc = dbGetQuery(conn,'SELECT * FROM view_vacc')%>%
  mutate(
    date = as.Date(date),
    state = as.character(state),
    city_ibge_code = as.character(city_ibge_code),
    age_group = as.character(age_group),
    gender = as.character(gender),
    vaccine_plataform = as.character(vaccine_plataform),
    vaccine_dose = as.character(vaccine_dose),
    doses = as.numeric(doses)
  )


