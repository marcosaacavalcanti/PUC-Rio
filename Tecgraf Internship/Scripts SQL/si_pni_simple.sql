DROP TABLE if EXISTS si_pni_simple;

CREATE TABLE IF NOT EXISTS si_pni_simple as(
SELECT
        CAST(NULLIF(paciente_idade, '') AS numeric) AS age,  
        CASE
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 5  THEN '0-4'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 10 THEN '5-9'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 15 THEN '10-14'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 20 THEN '15-19'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 30 THEN '20-29'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 40 THEN '30-39'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 50 THEN '40-49'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 60 THEN '50-59'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 70 THEN '60-69'
            WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 80 THEN '70-79'
            ELSE '80+'
        END AS age_group,
        TRIM(paciente_enumsexobiologico) AS gender,
        CASE
            WHEN TRIM(vacina_codigo) IN ('89', '85') THEN 'astrazeneca'
            WHEN TRIM(vacina_codigo) = '88' THEN 'janssen'
            WHEN TRIM(vacina_codigo) = '86' THEN 'coronavac'
            WHEN TRIM(vacina_codigo) = '87' THEN 'pfizer'
            ELSE 'sem_identificacao'
        END AS vaccine_plataform,
        CASE
            WHEN TRIM(vacina_codigo) = '88' THEN 'D_unica'
            WHEN TRIM(vacina_descricao_dose) like '1%' THEN 'D1'
            WHEN TRIM(vacina_descricao_dose) like '2%' THEN 'D2'
            WHEN TRIM(vacina_descricao_dose) like '%Adicional%' THEN 'D_adicional'
            else 'D_reforco'
        END AS vaccine_dose,
        TRIM(vacina_grupoatendimento_nome) as vaccine_description_group,
        TRIM(vacina_categoria_nome) as classfication, 
        TO_DATE(TRIM(vacina_dataaplicacao),'YYYY-MM-DD') as date,
        TRIM(paciente_endereco_uf) AS state,
        TRIM(estabelecimento_municipio_codigo) AS city_ibge_code_06
        
        
    FROM si_pni_bruto
   
    WHERE TO_DATE(TRIM(vacina_dataaplicacao),'YYYY-MM-DD') > TO_DATE('2021-01-14','YYYY-MM-DD')

);

