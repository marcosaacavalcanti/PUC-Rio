-- CREATE TABLE srag_simple

DROP TABLE IF EXISTS srag_simple;

CREATE TABLE srag_simple AS
SELECT 
        TO_DATE(TRIM(dt_notific),'DD/MM/YYYY') as notification_date,
        TO_DATE(TRIM(dt_sin_pri),'DD/MM/YYYY') as symptoms_date,
        TRIM(sg_uf_not) as state,
        TRIM(cs_sexo) as gender, 
        CASE
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 5  THEN '0-4'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 10 THEN '5-9'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 15 THEN '10-14'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 20 THEN '15-19'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 30 THEN '20-29'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 40 THEN '30-39'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 50 THEN '40-49'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 60 THEN '50-59'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 70 THEN '60-69'
            WHEN CAST(NULLIF(nu_idade_n, '') AS numeric) < 80 THEN '70-79'
            ELSE '80+'
        END AS age_group,
        CASE
            WHEN cs_raca = '1' THEN 'White'
            WHEN cs_raca = '2' THEN 'Black'
            WHEN cs_raca = '3' THEN 'Asiam'
            WHEN cs_raca = '4' THEN 'Brown'
            WHEN cs_raca = '5' THEN 'Indigenous'
            ELSE 'not_informed'
        END AS race, 
        CASE
            WHEN cs_escol_n = '0' THEN 'illiterate'
            WHEN cs_escol_n = '1' THEN 'elementary_school'
            WHEN cs_escol_n = '2' THEN 'primary_education'
            WHEN cs_escol_n = '3' THEN 'secondary_education'
            WHEN cs_escol_n = '4' THEN 'tertiary_education'
            ELSE 'not_informed'
        END AS schooling, 
        CASE
            WHEN febre  = 1 THEN 1
            ELSE 0
        END AS fever,
        CASE
            WHEN tosse = 1 THEN 1
            ELSE 0
        END AS cough,
        CASE
            WHEN garganta  = 1 THEN 1
            ELSE 0
        END AS sore_throat,
        CASE
            WHEN dispneia = 1 THEN 1
            ELSE 0
        END AS dyspnea,
        CASE
            WHEN desc_resp = 1 THEN 1
            ELSE 0
        END AS respiratory_distress,
        CASE
            WHEN saturacao = 1 THEN 1
            ELSE 0
        END AS saturation,
        CASE
            WHEN diarreia = 1 THEN 1
            ELSE 0
        END AS diarrhea,
        CASE
            WHEN vomito  = 1 THEN 1
            ELSE 0
        END AS vomit,
        CASE
            WHEN outro_sin = 1 THEN 1
            ELSE 0
        END AS other_symptoms,
        CASE
            WHEN cardiopati = 1 THEN 1
            ELSE 0
        END AS heart_disease,
        CASE
            WHEN hematologi = 1 THEN 1
            ELSE 0
        END AS hematological_disease,
        CASE
            WHEN sind_down = 1 THEN 1
            ELSE 0
        END AS down_syndrome,
        CASE
            WHEN hepatica  = 1 THEN 1
            ELSE 0
        END AS liver_disease,
        CASE
            WHEN asma = 1 THEN 1
            ELSE 0
        END AS asthma,
        CASE
            WHEN diabetes  = 1 THEN 1
            ELSE 0
        END AS diabetes,
        CASE
            WHEN neurologic = 1 THEN 1
            ELSE 0
        END AS neurological_disease,
        CASE
            WHEN pneumopati = 1 THEN 1
            ELSE 0
        END AS lung_disease,
        CASE
            WHEN imunodepre = 1 THEN 1
            ELSE 0
        END AS immunosuppression,
        CASE
            WHEN renal = 1 THEN 1
            ELSE 0
        END AS kidney_disease,
        CASE
            WHEN obesidade = 1 THEN 1
            ELSE 0
        END AS obesity,
        CASE
            WHEN out_morbi = 1 THEN 1
            ELSE 0
        END AS others_comorbidities,
        CASE
            WHEN uti = 1 THEN 1
            ELSE 0
        END AS icu,
        TO_DATE(TRIM(dt_evoluca),'DD/MM/YYYY') as outcome_date,
        CASE
            WHEN evolucao = '1' THEN 'Discharge'
            WHEN evolucao = '2' THEN 'Death'
            ELSE 'not_informed'
        END AS outcome 
 
        FROM srag_bruto;