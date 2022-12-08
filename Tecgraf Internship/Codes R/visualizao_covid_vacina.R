
library(ggplot2)
library(viridis)
library(lubridate)

dados_brutos = readr::read_csv("https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv")

dados = dados_brutos %>% 
  group_by(state) %>% 
  mutate(new = deaths_per_100k_inhabitants - lag(deaths_per_100k_inhabitants),
         new_norm = new / max(new, na.rm = T)) %>% 
  select(state, date, new_norm, new) %>% 
  filter(state != "TOTAL")

dados %>% 
  ggplot(aes(x = date, y = new_norm, group = state)) +
  geom_line() +
  facet_wrap(~state)

dados %>% 
  ggplot(aes(date, state, fill = new_norm)) +
  geom_tile() + 
  scale_fill_viridis(option="magma", direction = -1) +
  geom_vline(xintercept = date("2021-01-17"), size = 1) +
  labs(title = "Deaths per 100k inhabitants in Brazilian states") +
  theme_minimal() +
  theme(axis.title = element_blank(),
        legend.position = "bottom")

library(ggplot2) # ggplot() for plotting
library(dplyr) # data reformatting
library(tidyr) # data reformatting
library(stringr) # string manipulation

dados %>% 
  mutate(ano_mes = format(as.Date(date), "%Y-%m")) %>% 
  group_by(state, ano_mes) %>% 
  summarise(new = sum(new)) %>% 
  group_by(state) %>% 
  mutate(new_norm = new / max(new, na.rm = T)) %>% 
  filter(ano_mes != "2020-02",
         ano_mes != "2020-03",
         ano_mes != "2021-12") -> dados_rev

textcol <- "grey40"

ggplot(dados_rev,aes(x=ano_mes,y=state,fill=new_norm))+
  geom_tile(colour="white",size=0.2)+
  geom_vline(xintercept = c("2021-01"), size = 1, linetype = "dashed", color = "grey30") +
  # guides(fill=guide_legend(title="Deaths per\n100,000 people"))+
  labs(x="",y="",title="Deaths of COVID-19 in the BR")+
  scale_y_discrete(expand=c(0,0))+
  scale_x_discrete(expand=c(0,0),breaks=unique(dados_rev$ano_mes))+
  scale_fill_viridis(option="magma", direction = -1,na.value = "grey90") +
  theme_minimal(base_size=10)+
  theme(legend.position="none",legend.direction="vertical",
        legend.title=element_text(colour=textcol),
        legend.margin=margin(grid::unit(0,"cm")),
        legend.text=element_text(colour=textcol,size=7,face="bold"),
        legend.key.height=grid::unit(0.8,"cm"),
        legend.key.width=grid::unit(0.2,"cm"),
        axis.text.x=element_text(size=6,colour=textcol),
        axis.text.y=element_text(vjust=0.2,colour=textcol),
        axis.ticks=element_line(size=0.4),
        plot.background=element_blank(),
        panel.grid = element_blank(),
        panel.border=element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        plot.margin=margin(0.7,0.4,0.1,0.2,"cm"),
        plot.title=element_text(colour=textcol,hjust=0,size=14,face="bold"))
