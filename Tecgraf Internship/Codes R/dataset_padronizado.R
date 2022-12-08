###                 ###
#######################

### Install Packages ###
pacman::p_load(
  tidyverse,
  janitor,
  zoo,
  DBI)


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


### Import Data ###
oxford = dbGetQuery(conn,'SELECT
                           date,
                           state,
                           c1_school_closing,
                           c2_workplace_closing,
                           c3_public_events,
                           c4_restrictions_on_gatherings,
                           c5_close_public_transport,
                           c6_stay_at_home_requirements,
                           c7_restrictions_on_internal_movement,
                           c8_international_travel_controls,
                           h1_public_information_campaigns,
                           h6_facial_coverings
                           FROM oxford_measures')%>%
  mutate(date = as.Date(date))
deaths = dbGetQuery(conn,'SELECT outcome_date,state,age_group,outcome FROM SRAG_SIMPLE')%>%
  rename('date' = 'outcome_date')
vacc = dbGetQuery(conn,'SELECT date,state,age_group,vaccine_dose,doses FROM SI_PNI_REDUCED')
population = dbGetQuery(conn,'SELECT * FROM POPULATION_CITY_2020')
dbDisconnect(conn)



### Data Management ###

## df
date = tibble(date = seq.Date(as.Date("2021-01-01"),as.Date("2021-12-31"),by = "1 day"))
date_v = date$date
state_v = c('AC','AL','AM','AP','BA','CE','DF','ES','GO','MA','MG','MS','MT','PA','PB',
            'PE','PI','PR','RJ','RN','RO','RR','RS','SC','SE','SP','TO')
day_v = 1:365
age_group_v = c('20-39','40-49','50-59','60+')

df = data.frame(date = rep(date_v,each = length(state_v)*length(age_group_v)),
                day = rep(day_v, each = length(state_v)*length(age_group_v)),
                state = rep(state_v,length(date_v),each = length(age_group_v)),
                age_group = rep(age_group_v,length(date_v)*length(state_v)))



## oxford table
df = df %>%
  left_join(oxford, by = c("date" = "date",
                           "state" = "state"))

## deaths table
deaths = deaths %>%
  filter(outcome == 'Death')%>%
  mutate(age_group = case_when(
    age_group == "20-39" ~ "20-39",
    age_group == "40-49" ~ "40-49",
    age_group == "50-59" ~ "50-59",
    age_group == "60-69" ~ "60+",
    age_group == "70-79" ~ "60+",
    age_group == "80+"   ~ "60+"))%>%
  na.omit()%>%
  mutate(deaths = rep(1,length(date)))%>%
  group_by(date,state,age_group)%>%
  mutate(deaths = sum(deaths))%>%
  ungroup()%>%
  distinct()

df = df %>%
  left_join(deaths,
            by = c("date"= "date",
                   "state" = "state",
                   "age_group" = "age_group"))


## vacc table
teste = vacc %>%
  mutate(age_group = case_when(
    age_group == "20-29" ~ "20-39",
    age_group == "30-39" ~ "20-39",
    age_group == "40-49" ~ "40-49",
    age_group == "50-59" ~ "50-59",
    age_group == "60-69" ~ "60+",
    age_group == "70-79" ~ "60+",
    age_group == "80+"   ~ "60+"))%>%
  drop_na()%>%
  group_by(data,uf,idade_grupo,vacina_dose)%>%
  mutate(doses = sum(doses))%>%
  ungroup()%>%
  relocate(data,uf,idade_grupo,vacina_dose,doses)%>%
  distinct()%>%
  pivot_wider(names_from = "vacina_dose",
              values_from = "doses")%>%
  mutate(D1 = as.numeric(D1),
         D2 = as.numeric(D2),
         D_adicional = as.numeric(D_adicional),
         D_reforco = as.numeric(D_reforco),
         D_unica = as.numeric(D_unica),
         D1 = na.fill(D1,0),
         D2 = na.fill(D2,0),
         D_unica = na.fill(D_unica,0),
         D2 = D2 + D_unica)%>%
  select(-c("D_adicional","D_reforco","D_unica"))%>%
  rename("d1" = "D1",
         "d2" = "D2")
  
df = df %>%
  left_join(tabela_vacc, by = c("data" = "data",
                                "uf" = "uf",
                                "idade_grupo" = "idade_grupo"))


## population table
tabela_populacao = tabela_populacao %>%
  mutate(idade_grupo = case_when(
    idade_grupo == "20-29" ~ "20-39",
    idade_grupo == "30-39" ~ "20-39",
    idade_grupo == "40-49" ~ "40-49",
    idade_grupo == "50-59" ~ "50-59",
    idade_grupo == "60-69" ~ "60+",
    idade_grupo == "70-79" ~ "60+",
    idade_grupo == "80+"   ~ "60+"))%>%
  drop_na(idade_grupo)%>%
  group_by(uf,idade_grupo)%>%
  mutate(populacao = sum(populacao))%>%
  ungroup()%>%
  relocate(uf,idade_grupo,populacao)%>%
  distinct()

df = df %>%
  left_join(tabela_populacao, by = c("uf" = "uf",
                                "idade_grupo" = "idade_grupo"))


### DATASET ###
dataset_paulo_padronizado = df %>%
  mutate(obitos = as.numeric(obitos),
         casos = as.numeric(casos),
         d1 = as.numeric(d1),
         d2 = as.numeric(d2),
         populacao = as.numeric(populacao),
         obitos = na.fill(obitos,0),
         casos = na.fill(casos,0),
         d1 = na.fill(d1,0),
         d2 = na.fill(d2,0))%>%
  group_by(uf,idade_grupo)%>%
  arrange(data)%>%
  mutate(d1_acumulado = cumsum(d1))%>%
  mutate(d1_mm7 = rollmean(d1,k = 7,fill = 0,align = "right"))%>%
  mutate(d2_acumulado = cumsum(d2))%>%
  mutate(d2_mm7 = rollmean(d2,k = 7,fill = 0,align = "right"))%>%
  mutate(obitos_acumulado = cumsum(obitos))%>%
  mutate(obitos_mm7 = rollmean(obitos,k = 7,fill = 0,align = "right"))%>%
  mutate(casos_acumulado = cumsum(casos))%>%
  mutate(casos_mm7 = rollmean(obitos,k = 7,fill = 0,align = "right"))%>%
  ungroup()%>%
  mutate(d1_cobertura = d1_acumulado / populacao)%>%
  mutate(d2_cobertura = d2_acumulado / populacao)%>%
  mutate(d1_padrao = d1/max(d1))%>%
  mutate(d1_acumulado_padrao = d1_acumulado/max(d1_acumulado))%>%
  mutate(d1_mm7_padrao = d1_mm7/max(d1_mm7))%>%
  mutate(d1_cobertura_padrao = d1_cobertura/max(d1_cobertura))%>%
  mutate(d2_padrao = d2/max(d2))%>%
  mutate(d2_acumulado_padrao = d2_acumulado/max(d2_acumulado))%>%
  mutate(d2_mm7_padrao = d2_mm7/max(d2_mm7))%>%
  mutate(d2_cobertura_padrao = d2_cobertura/max(d2_cobertura))%>%
  mutate(obitos_padrao = obitos/max(obitos))%>%
  mutate(obitos_mm7_padrao = obitos_mm7/max(obitos_mm7))%>%
  mutate(obitos_acumulado_padrao = obitos_acumulado/max(obitos_acumulado))%>%
  mutate(casos_padrao = casos/max(casos))%>%
  mutate(casos_mm7_padrao = casos_mm7/max(casos_mm7))%>%
  mutate(casos_acumulado_padrao = casos_acumulado/max(casos_acumulado))%>%
  mutate(c1_school_closing_padrao = 
           as.numeric(c1_school_closing)/
           as.numeric(max(c1_school_closing)))%>%
  mutate(c2_workplace_closing_padrao = 
           as.numeric(c2_workplace_closing)/
           as.numeric(max(c2_workplace_closing)))%>%
  mutate(c3_cancel_padrao = 
           as.numeric(c3_cancel)/
           as.numeric(max(c3_cancel)))%>%
  mutate(c4_restrictions_on_gatherings_padrao = 
           as.numeric(c4_restrictions_on_gatherings)/
           as.numeric(max(c4_restrictions_on_gatherings)))%>%
  mutate(c5_close_public_transport_padrao = 
           as.numeric(c5_close_public_transport)/
           as.numeric(max(c5_close_public_transport)))%>%
  mutate(c6_stay_at_home_requirements_padrao = 
           as.numeric(c6_stay_at_home_requirements)/
           as.numeric(max(c6_stay_at_home_requirements)))%>%
  mutate(c7_restrictions_on_internal_movement_padrao = 
           as.numeric(c7_restrictions_on_internal_movement)/
           as.numeric(max(c7_restrictions_on_internal_movement)))%>%
  mutate(c8_international_travel_controls_padrao = 
           as.numeric(c8_international_travel_controls)/
           as.numeric(max(c8_international_travel_controls)))%>%
  mutate(h1_public_information_campaigns_padrao = 
           as.numeric(h1_public_information_campaigns)/
           as.numeric(max(h1_public_information_campaigns)))%>%
  mutate(h6_facial_coverings_padrao = 
           as.numeric(h6_facial_coverings)/
           as.numeric(max(h6_facial_coverings)))%>%
  relocate(data,
           dia,
           uf,
           idade_grupo,
           c1_school_closing,
           c2_workplace_closing,
           c3_cancel,
           c4_restrictions_on_gatherings,
           c5_close_public_transport,
           c6_stay_at_home_requirements,
           c7_restrictions_on_internal_movement,
           c8_international_travel_controls,
           h1_public_information_campaigns,
           h6_facial_coverings,
           obitos,
           obitos_acumulado,
           obitos_mm7,
           casos,
           casos_acumulado,
           casos_mm7,
           d1,        
           d1_acumulado,
           d1_cobertura,
           d2,
           d2_acumulado,
           d2_cobertura,
           c1_school_closing_padrao,
           c2_workplace_closing_padrao,
           c3_cancel_padrao,
           c4_restrictions_on_gatherings_padrao,
           c5_close_public_transport_padrao,
           c6_stay_at_home_requirements_padrao,
           c7_restrictions_on_internal_movement_padrao,
           c8_international_travel_controls_padrao,
           h1_public_information_campaigns_padrao,
           h6_facial_coverings_padrao,
           obitos_padrao,
           obitos_acumulado_padrao,
           obitos_mm7_padrao,
           casos_padrao,
           casos_acumulado_padrao,
           casos_mm7_padrao,
           d1,
           d1_acumulado_padrao,
           d1_mm7_padrao,
           d1_cobertura_padrao,
           d2,
           d2_acumulado_padrao,
           d2_mm7_padrao,
           d2_cobertura_padrao)
