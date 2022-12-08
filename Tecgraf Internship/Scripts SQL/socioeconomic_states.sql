-- CREATE TABLE DADOS SOCIOECONOMICOS UF

create table dados_socioeconomicos_uf(
uf varchar,
regiao varchar,
area numeric,
pib_2019 numeric,
pib_per_capta_2019 numeric,
densidade_demografica numeric,
populacao_2021 numeric,
idh_2010 numeric,
idh_renda_2010 numeric,
idh_educacao numeric,
idh_saude_2010 numeric,
expectativa_de_vida_2010 numeric
);

copy dados_socioeconomicos_uf
from 'D:\Databases\Socioeconomico\dados_socioeconomicos_uf.csv'
with delimiter ','
csv header
