## Download Packages
pacman::p_load(
  rio,
  here,
  tidyverse,
  janitor)


## Import tables
tabela_cod_municipio_populacao <- import('tabela_cod_municipio_populacao.csv')
tabela_d1 <- import('tabela_d1.csv')
tabela_d2 <- import('tabela_d2.csv')
tabela_du <- import('tabela_du.csv')



## Table population cleaning
tabela_cod_municipio_populacao <- tabela_cod_municipio_populacao %>%
  rename("cod_ibge" = "V1", 
         "nome_municipio" = "V2",
         "populacao_etaria" = "V3")

tabela_cod_municipio_populacao <- tabela_cod_municipio_populacao %>%
  group_by(cod_ibge)%>%
  mutate(populacao = sum(populacao_etaria))%>%
  select(cod_ibge,nome_municipio,populacao)%>%
  distinct() %>% 
  ungroup()

tabela_cod_municipio_populacao$cod_ibge <-
  as.character(tabela_cod_municipio_populacao$cod_ibge)



## Tables vaccination cleaning
tabela_d1 <- tabela_d1 %>%
  rename("data_aplicacao" = "V1", "cod_ibge" = "V2","d1" = "V3")
  

tabela_d2 <- tabela_d2 %>%
  rename("data_aplicacao" = "V1", "cod_ibge" = "V2","d2" = "V3")

tabela_du <- tabela_du %>%
  rename("data_aplicacao" = "V1", "cod_ibge" = "V2","du" = "V3")


#### Joining data
## Gerando uma tabela com combinações de todos os dias e municipios

df_todos_dias <- tibble(
  data = seq.Date(as.Date("2021-01-15"), 
                  max(as.Date(tabela_d1$data_aplicacao),
                      as.Date(tabela_d2$data_aplicacao),
                      as.Date(tabela_du$data_aplicacao)),
                  by = "1 day")
  )


data_cidades <- left_join(tabela_cod_municipio_populacao, 
                          df_todos_dias, 
                          by = as.character()) %>% 
  ungroup()


df_cidades_vacina <- 
  data_cidades %>% 
  mutate(data = as.Date(data)) %>% 
  left_join(tabela_d1 %>%
              mutate(data_aplicacao = as.Date(data_aplicacao))
              , by = c("data" = "data_aplicacao",
                              "cod_ibge" = "cod_ibge")
            ) %>% 
  left_join(tabela_d2 %>%
              mutate(data_aplicacao = as.Date(data_aplicacao))
            , by = c("data" = "data_aplicacao",
                     "cod_ibge" = "cod_ibge")
            ) %>% 
  left_join(tabela_du %>%
              mutate(data_aplicacao = as.Date(data_aplicacao))
            , by = c("data" = "data_aplicacao",
                     "cod_ibge" = "cod_ibge")
            ) %>% 
  drop_na(nome_municipio) %>%
  mutate(d1 = replace_na(d1, 0)) %>%
  mutate(d2 = replace_na(d2, 0)) %>%
  mutate(du = replace_na(du, 0))
  


# 
# j1 <- left_join(tabela_d1,
#                 tabela_d2,
#                 by = c("data_aplicacao"="data_aplicacao",
#                        "cod_ibge"="cod_ibge"))
# 
# j2 <- left_join(tabela_d1,
#                 tabela_d2,
#                 by = c("data_aplicacao"="data_aplicacao",
#                        "cod_ibge"="cod_ibge"))
# 
# j3 <- left_join(j1,tabela_du,
#                 by = c("data_aplicacao"="data_aplicacao",
#                        "cod_ibge"="cod_ibge"))
# 
# tabela_bruta <- left_join(j2, tabela_cod_municipio_populacao,
#                           by = c("cod_ibge" = "cod_ibge")) 
# 
# data_cidades %>% 
#   left_join(df_todos_dias, tabela_bruta)


## Tabela Bruta cleaning
# tabela_bruta <- tabela_bruta %>%
#   drop_na(nome_municipio)%>%
#   mutate(d1 = replace_na(d1,0))%>%
#   mutate(d2 = replace_na(d2,0))%>%
#   mutate(du = replace_na(du,0))

## Cumsum
tabela_bruta <- df_cidades_vacina %>%
  arrange(cod_ibge, data) %>% 
  group_by(cod_ibge)%>%
  mutate(acumulado_d1 = cumsum(d1)) %>%
  mutate(acumulado_d2 = cumsum(d2)) %>%
  mutate(acumulado_du = cumsum(du)) %>%
  select(-c("d1","d2","du")) %>% 
  ungroup()


## Select columns and compute coverture
dataset_doses_by_date_city <- tabela_bruta %>%
  mutate(cobertura_d1 = acumulado_d1 / populacao)%>%
  mutate(cobertura_d2 = acumulado_d2 / populacao)%>%
  mutate(cobertura_du = acumulado_du / populacao)%>%
  select(data_aplicacao = data,
         cod_ibge,
         nome_municipio,
         populacao,
         acumulado_d1,
         acumulado_d2,
         acumulado_du,
         cobertura_d1,
         cobertura_d2,
         cobertura_du)
   
dataset_doses_by_date_city <- dataset_doses_by_date_city%>%
  select(-c("nome_municipio"))


export(dataset_doses_by_date_city,"dataset_doses_by_date_city_3.csv")


## Export: Ultimo dia do mês
dataset_doses_by_date_city_mes <- 
  dataset_doses_by_date_city %>% 
  mutate(ano_mes = format(as.Date(data_aplicacao), "%Y-%m")) %>% 
  group_by(cod_ibge, ano_mes) %>% 
  filter(row_number() == max(row_number())) %>% 
  ungroup() %>% 
  select(-ano_mes)

export(dataset_doses_by_date_city_mes,"dataset_doses_by_date_city_mes.csv", sep = ';')
