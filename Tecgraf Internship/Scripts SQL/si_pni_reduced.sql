create materialized view si_pni_reduced as
select
application_date as date,
state, 
settlement_address_city_ibge_code_06 as city_ibge_code_06,
age_group, 
gender, 
vaccine_plataform,
vaccine_dose,
count(*) as doses
from si_pni_simple
where
application_date is not null and
state is not null and
state != 'XX' and 
state != 'None' and
settlement_address_city_ibge_code_06 is not null and
age_group is not null and
gender  is not null and
vaccine_plataform is not null and
vaccine_dose is not null
group by 
application_date,
state ,
settlement_address_city_ibge_code_06,
age_group,
gender,
vaccine_plataform,
vaccine_dose
;

