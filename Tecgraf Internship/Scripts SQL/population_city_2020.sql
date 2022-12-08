drop table if exists populacao_municipio_2020;

CREATE TABLE populacao_municipio_2020 (
	city_ibge_code_06 int4 NULL,
	city_name varchar(200) NULL,
	gender varchar(10) NULL,
	age_group varchar(20) NULL,
	population int4 NULL,
	state varchar(10) NULL
);


-- Import data
copy populacao_municipio_2020
from 'D:\Databases\Populacao_Municipio\populacao_municipio_2020.csv'
with null as '' delimiter ',' 
csv header;