
create table socioeconomic_cities  (
city_ibge_code_07 varchar, --1
city_ibge_code_06 varchar, --2
city_name varchar, --3
state varchar, --4
capital int, --5
type_urban varchar, --6
metropolitan_region int, --7
north_region int, --8
northeast_region int, --9
centralwest_region int, --10
southeast_region int, --11
south_region int, --12
cases int, --13
deaths int, --14
gdp numeric, --15
gdp_per_capita numeric, --16
gini numeric, --17
population numeric, --18
area numeric, --19
demographic_density numeric, --20
urban_percentage numeric, --21
masculine_percentage numeric, --22
white_percentage numeric, --23
over60_percentage numeric, --24
doctors_100k numeric, --25
ln_doctors_100k numeric, --26
icu_beds_100k numeric, --27
ln_icu_beds_100k numeric, --28
superior_education_population_percentage numeric, --29
cob_esf numeric, --30
cob_acs numeric, --31
mhdi numeric, --32
mhdi_educ numeric, --33
mhdi_longevity numeric, --34
mhdi_income numeric, --35
perc_votes_bolsonaro numeric, --36
distance_capital numeric, --37
pct_san_adeq numeric, --38
mean_idh numeric, --39
hdi_level varchar, --40
svi_original numeric, --41
population_adults numeric, --42
pricare_cov numeric, --43
fhs_cov numeric --44
)


copy teste
from 'D:\Databases\Socioeconomico\city_socioeconomic_data.csv'
WITH NULL AS ''  delimiter ';'
csv header;


