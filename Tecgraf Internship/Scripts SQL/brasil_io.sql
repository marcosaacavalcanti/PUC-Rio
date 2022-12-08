-- BRASIL_IO --

create table brasil_io (
city_name varchar(200),
city_ibge_code_07 varchar(7),
date date,
epidemological_week varchar(6),
estimated_population integer,
estimated_population_2019 integer,
is_last varchar(5),
is_repeated varchar(5),
last_available_confirmed numeric,
last_available_confirmed_per_100k_inhabitants numeric,
last_available_date date,
last_available_death_rate numeric,
last_available_deaths integer,
order_for_place numeric,
place_type varchar(200),
state varchar(2),
new_confirmed integer,
new_deaths integer
);

copy brasil_io
from 'D:\Databases\Basil_io\caso_full.csv'
with delimiter ','
csv header

