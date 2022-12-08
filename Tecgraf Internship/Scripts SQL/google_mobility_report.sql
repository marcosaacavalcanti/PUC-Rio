create table global_mobility_report (
country_regio_code varchar,
country_region varchar,
sub_region_1 varchar,
sub_region_2 varchar,
metro_area varchar,
iso_3166_2_code varchar,
census_fips_code varchar,
place_id varchar,
date date,
retail_and_recreation_percent_change_from_baseline int,
grocery_and_pharmacy_percent_change_from_baseline int,
parks_percent_change_from_baseline int,
transit_stations_percent_change_from_baseline int,
workplaces_percent_change_from_baseline int,
residential_percent_change_from_baseline int
);



copy global_mobility_report
from'D:\Databases\Global_Mobility_Report\Global_Mobility_Report.csv'
with null as ''
csv header
