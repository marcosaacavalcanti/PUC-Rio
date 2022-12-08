### BRASILIO DEATHS GROUPED BY DATE AND CITY ###
#################################################

### Install Packages ###
pacman::p_load(
  rio,
  here,
  tidyverse,
  janitor,
  zoo,
  writexl,
  spatstat.utils,
  imputeTS)

### Import Data ###
download.file("https://data.brasil.io/dataset/covid19/caso_full.csv.gz", "caso_full.csv.gz")
case_full = read_csv("caso_full.csv.gz")

### Selecting Variables ###
case_full = case_full %>%
  select(date,city_ibge_code,new_deaths)

### Selecting Time Interval ###
dates = tibble(date = seq.Date(as.Date("2020-03-01"),
                                  as.Date(max(case_full$date)),
                                  by = "1 day"))
dates = as.Date(as.vector(dates$date))

### city_cod_ibge ###
codes = unique(case_full$city_ibge_code)
codes = na.omit(codes[codes >= 100000])

### Dataset Full ###
combine = paste0(rep(dates,length(codes)),
                  rep(codes,length(dates)))
combine = data.frame(date = substr(combine,1,10),
                      city_ibge_code = substr(combine,11,17))

combine$date = as.character(combine$date)
combine$city_ibge_code <- as.character(combine$city_ibge_code)
case_full$date = as.character(case_full$date)
case_full$city_ibge_code = as.character(case_full$city_ibge_code)

dataset = combine %>%
  left_join(case_full, by = c("date" = "date",
                         "city_ibge_code" = "city_ibge_code"))%>%
  arrange(date)

dataset$new_deaths[is.na(dataset$new_deaths)] = 0

dataset = dataset %>%
  group_by(city_ibge_code)%>%
  mutate(cumulative_deaths = cumsum(new_deaths))%>%
  ungroup()%>%
  select(-c("new_deaths"))


### Dataset last day of each month ###
dataset_last = dataset %>%
  mutate(year_month = format(as.Date(date), "%Y-%m"))%>%
  group_by(city_ibge_code, year_month)%>%
  filter(row_number() == max(row_number())) %>% 
  ungroup() %>% 
  select(-c("year_month"))
