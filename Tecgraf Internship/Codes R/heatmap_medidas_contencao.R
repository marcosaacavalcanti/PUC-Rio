###INSTALL PACKAGES###
pacman::p_load(tidyverse,
               rio,
               here,
               zoo)

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
tabela_oxford = dbGetQuery(conn,'SELECT data,
                           uf,
                           c1_school_closing,
                           c2_workplace_closing,
                           c3_cancel,
                           c4_restrictions_on_gatherings,
                           c5_close_public_transport,
                           c6_stay_at_home_requirements,
                           c7_restrictions_on_internal_movement,
                           c8_international_travel_controls,
                           h1_public_information_campaigns,
                           h6_facial_coverings
                           FROM tabela_oxford_measures')


###DATA MANAGEMENT###
df = tabela_oxford %>%
  filter(uf == "AC",
         data >= '2021-01-01',
         data <= '2021-12-31')%>%
  rename('C1' = 'c1_school_closing',
         'C2' = 'c2_workplace_closing',
         'C3' = 'c3_cancel',
         'C4' = 'c4_restrictions_on_gatherings',
         'C5' = 'c5_close_public_transport',
         'C6' = 'c6_stay_at_home_requirements',
         'C7' = 'c7_restrictions_on_internal_movement',
         'C8' = 'c8_international_travel_controls',
         'H1' = 'h1_public_information_campaigns',
         'H6' = 'h6_facial_coverings')%>%
  pivot_longer(!c(data,uf))%>%
  mutate(value = na.fill(value,0),
         dia = lubridate::day(data),
         mes = lubridate::month(data, abbr = TRUE, label = TRUE))

###THE PLOT###
ggplot(data = df, aes(dia, name, fill = value)) + 
  geom_tile(colour = "white") + 
  facet_grid(~ mes) +
  scale_fill_gradient(low = "green", high = "red") +
  theme_minimal() +
  theme(legend.title = element_text(size=12, face="bold"),
    legend.text  = element_text(size=10, face="bold"),
    legend.key.height = grid::unit(1,"cm"),           
    legend.key.width  = grid::unit(0.6,"cm"),        
    axis.text.x = element_text(size=5, face = "bold"),            
    axis.text.y = element_text(vjust = 0.4, face = "bold"),            
    axis.ticks = element_line(size=0.4),               
    axis.title = element_text(size=12, face="bold"),
    plot.title = element_text(hjust=0,size=14,face="bold"),  
    plot.caption = element_text(hjust = 0, face = "italic"),
    panel.spacing.x = unit(-1, "lines")) +
  labs(x = "Days", y = "Measures", fill = "Values",
    title = "Oxford Measures Heatmap",
    subtitle = "Acre - 2021")
