####INSTALL PACKAGES#######
library(tidyverse)
library(shiny)
library(shinythemes)
library(rsconnect)
library(dygraphs)
library(xts)
library(dplyr)
library(zoo)
library(plotly)
library(shinyjs)
library(ggplot2)
library(ggplotify)
library(DescTools)
library(readxl)
library(shinydashboard)
library(shinyWidgets)
library(rintrojs)
library(shinyjs)
library(lubridate)
library(plotly)
library(DBI)
library(janitor)
# library(geobr)
library(sf)
library(data.table)
library(scales)
library(lubridate)
library(DT)
library(readr)
library(here)
library(rio)


###POSTGRES CONNECTION###
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



###IMPORT DATA###
vacc_table = dbGetQuery(conn,'SELECT * FROM view_vacc')
population_table = dbGetQuery(conn,'SELECT * FROM tabela_populacao')
uf = dbGetQuery(conn,'SELECT * FROM uf')
dbDisconnect(conn)


###DATA WRANGLING#####

# vacc_table
vacc_table = vacc_table %>%
  pivot_wider(names_from = c("vacina_dose","vacina_plataforma"),
              values_from = doses)%>%
  mutate(D1_astrazeneca = na.fill(as.numeric(D1_astrazeneca),0),
         D1_coronavac = na.fill(as.numeric(D1_coronavac),0),
         D1_pfizer = na.fill(as.numeric(D1_pfizer),0),
         D_unica_janssen = na.fill(as.numeric(D_unica_janssen),0),
         D2_astrazeneca = na.fill(as.numeric(D2_astrazeneca),0),
         D2_coronavac = na.fill(as.numeric(D2_coronavac),0),
         D2_pfizer = na.fill(as.numeric(D2_pfizer),0),
         D_adicional_astrazeneca = na.fill(as.numeric(D_adicional_astrazeneca),0),
         D_adicional_coronavac = na.fill(as.numeric(D_adicional_coronavac),0),
         D_adicional_pfizer = na.fill(as.numeric(D_adicional_pfizer),0),
         D_reforco_astrazeneca = na.fill(as.numeric(D_reforco_astrazeneca),0),
         D_reforco_coronavac = na.fill(as.numeric(D_reforco_coronavac),0),
         D_reforco_pfizer = na.fill(as.numeric(D_reforco_pfizer),0))%>%
  group_by(uf,idade_grupo)%>%
  arrange(data)%>%
  mutate(D1_astrazeneca_cum = cumsum(D1_astrazeneca),
         D1_coronavac_cum = cumsum(D1_coronavac),
         D1_pfizer_cum = cumsum(D1_pfizer),
         D_unica_janssen_cum = cumsum(D_unica_janssen),
         D2_astrazeneca_cum = cumsum(D2_astrazeneca),
         D2_coronavac_cum = cumsum(D2_coronavac),
         D2_pfizer_cum = cumsum(D2_pfizer),
         D_adicional_astrazeneca_cum = cumsum(D_adicional_astrazeneca),
         D_adicional_coronavac_cum = cumsum(D_adicional_coronavac),
         D_adicional_pfizer_cum = cumsum(D_adicional_pfizer),
         D_reforco_astrazeneca_cum = cumsum(D_reforco_astrazeneca),
         D_reforco_coronavac_cum = cumsum(D_reforco_coronavac),
         D_reforco_pfizer_cum = cumsum(D_reforco_pfizer))
  

# population_table
population_table = population_table%>%
  rename("populacao_100k" = "populacao")%>%
  mutate(populacao_100k = as.numeric(populacao_100k/100000))
  
total_pop = population_table%>%
  select(-c("idade_grupo"))%>%
  group_by(uf)%>%
  mutate(uf = uf,
         idade_grupo = "TOTAL",
         populacao_100k = sum(populacao_100k))

population_table = population_table %>%
  add_row(uf = total_pop$uf,
          idade_grupo = total_pop$idade_grupo,
          populacao_100k = total_pop$populacao_100k)%>%
  distinct()%>%
  arrange(uf)

# uf
uf = uf$uf

# join tables
df = left_join(vacc_table,
               population_table,
               by =c("uf" = "uf",
                     "idade_grupo" = "idade_grupo"))%>%
  mutate(D1_astrazeneca_100k = (D1_astrazeneca_cum / populacao_100k),
         D1_coronavac_100k = (D1_coronavac_cum / populacao_100k),
         D1_pfizer_100k = (D1_pfizer_cum / populacao_100k),
         D_unica_janssen_100k = (D_unica_janssen_cum / populacao_100k),
         D2_astrazeneca_100k = (D2_astrazeneca_cum / populacao_100k),
         D2_coronavac_100k = (D2_coronavac_cum / populacao_100k),
         D2_pfizer_100k = (D2_pfizer_cum / populacao_100k),
         D_adicional_astrazeneca_100k = (D_adicional_astrazeneca_cum / populacao_100k),
         D_adicional_coronavac_100k = (D_adicional_coronavac_cum / populacao_100k),
         D_adicional_pfizer_100k = (D_adicional_pfizer_cum / populacao_100k),
         D_reforco_astrazeneca_100k = (D_reforco_astrazeneca_cum / populacao_100k),
         D_reforco_coronavac_100k = (D_reforco_coronavac_cum / populacao_100k),
         D_reforco_pfizer_100k = (D_reforco_pfizer_cum / populacao_100k))




df = df %>%
  rename('Pfizer' = 'D1_pfizer_cum',
         'Astrazeneca' = 'D1_astrazeneca_cum',
         'Coronavac' = 'D1_coronavac_cum',
         'Janssen' = 'D_unica_janssen')%>%
  pivot_longer(cols = c(Pfizer,
                        Astrazeneca,
                        Coronavac,
                        Janssen)
               , names_to = 'plataformas')%>%
  mutate(D1_total  = value/1000000)%>%
  filter(uf == 'SP',
         idade_grupo == '50-59')


# stacked area chart
ggplotly(ggplot(df, aes(x = data,
                        y = D1_total, 
                        fill = forcats::fct_rev(plataformas))) +
           geom_area() +
           labs(title = "1st Doses By Manufacturer",
                x = "Date",
                y = "Doses in Millions",
                fill = "Manufacturer") +
           scale_fill_brewer(palette = "Set2") +
           theme_minimal()
)









######ESTRUTURA DO SHINY APP#####


######UI##########

ui <- fluidPage(sidebarLayout(
  sidebarPanel(useShinyjs(),
               # criando caixa de selecao de estados
               selectInput(inputId = 'vaccination_state_statistics2',
                           label = 'State:',
                           choices = uf, # precisa ser um vetor com valores unicos
                           selected = 'TOTAL',
                           multiple = FALSE)),
  
  mainPanel(plotlyOutput("graph"))
)
)


#######SERVER#######


server  <- function(input, output, session)({ 
  # plotly estatísticas de vacinação
  
  output$graph <- renderPlotly({
    
    fig <- plot_ly(data = vaccination_Brazil %>% 
                     mutate(vaccinated_1st = `1st dose vaccinations (except Johnson & Johnson/Janssen)`) %>% 
                     subset(state %in% c(input$vaccination_state_statistics2)), 
                   x = ~date, 
                   y = ~vaccinated_1st,
                   type = 'scatter',
                   mode = 'lines', 
                   name = 'Butantan/Sinovac; Pfizer/BioNTech; AstraZeneca/Oxford 1st doses',
                   fill = 'tozeroy',
                   fillcolor = 'rgba(168, 216, 234, 0.5)',
                   line = list(width = 0.5) )
    
    fig <- fig %>% add_trace(x = ~date, 
                             y = ~`One dose of the Johnson & Johnson/Janssen vaccinations`,
                             name = 'Johnson&Johnson one doses', 
                             fill = 'tozeroy',
                             fillcolor = 'rgba(255, 212, 96, 0.5)')
    
    fig <- fig %>% layout(title = "1st dose Vaccinated Population by manufacturer",
                          yaxis = list(title = "Population"),
                          xaxis = list(title = "Source: https://github.com/wcota/covid19br"))
    
  })
})


shinyApp(ui = ui,
         server = server)



