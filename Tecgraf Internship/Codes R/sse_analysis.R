### DESCRIPTIVE TABLES - SBPO ARTICLE ###

###INSTALL PACKAGES###
library(tidyverse)
library(rio)
library(here)
library(flextable)
library(officer)



###IMPORT DATA###


sse_analysis_00 = import('sse_analysis_00.csv')%>%
  select(-c("V1"))%>%
  mutate(sse_all = round(as.numeric(sse_all),digits = 3),
         sse_cluster = round(as.numeric(sse_cluster),digits = 3),
         col = case_when(
           ratio < -10 ~ 1,
           ratio <   0 ~ 2,
           ratio <  40 ~ 3,
           TRUE ~ 4),
         ratio = scales::percent(round(as.numeric(ratio),digits = 0)/100))


sse_analysis_01 = import('sse_analysis_01.csv')%>%
  select(-c("V1"))%>%
  mutate(sse_all = round(as.numeric(sse_all),digits = 3),
         sse_cluster = round(as.numeric(sse_cluster),digits = 3),
         col = case_when(
           ratio < -10 ~ 1,
           ratio <   0 ~ 2,
           ratio <  40 ~ 3,
           TRUE ~ 4),
         ratio = scales::percent(round(as.numeric(ratio),digits = 0)/100))


###SEE ANALYSIS 00###  

## Layout
border_style = officer::fp_border(color="black", width=1)
col = sse_analysis$col
colours = c(rgb(1.0,0.4,0.4),
            rgb(1.0,0.6,0.6),
            rgb(0.7,1.0,0.7),
            rgb(0.5,1.0,0.5))

## Flextable
sse_analysis_00 = sse_analysis_00 %>%
  select(-c("col"))%>%
  flextable()%>%
  add_header_row(
    top = TRUE,
    values = c("STATES",
               "SSE WITHOUT \n CLUSTERS",
               "SSE WITH \n CLUSTERS",
               "VARIATION (%)"))%>%
  set_header_labels(
    state = "",
    sse_all = "",
    sse_cluster = "",
    ratio = "")

sse_analysis_00 = sse_analysis_00%>% 
  border_remove()%>%
  theme_booktabs()%>%
  #hline(part = 'body', i = 27, border = border_style)%>%
  vline(part = "all", j = 1, border = border_style)%>% 
  vline(part = "all", j = 2, border = border_style)%>%
  vline(part = "all", j = 3, border = border_style)%>%
  align(align = 'center', j = c(1:4), part = 'all')%>%
  bg(part = "body", bg = "gray95")%>%
  fontsize(i = 1, size = 12, part = "header")%>%   
  bold(i = 1, bold = TRUE, part = "header")%>%
  #bold(i = 28,bold = TRUE, part = 'body')%>%
  bg(j= 4, i = 1, part = "body", bg = colours[col[1]])%>%
  bg(j= 4, i = 2, part = "body", bg = colours[col[2]])%>%
  bg(j= 4, i = 3, part = "body", bg = colours[col[3]])%>%
  bg(j= 4, i = 4, part = "body", bg = colours[col[4]])%>%
  bg(j= 4, i = 5, part = "body", bg = colours[col[5]])%>%
  bg(j= 4, i = 6, part = "body", bg = colours[col[6]])%>%
  bg(j= 4, i = 7, part = "body", bg = colours[col[7]])%>%
  bg(j= 4, i = 8, part = "body", bg = colours[col[8]])%>%
  bg(j= 4, i = 9, part = "body", bg = colours[col[9]])%>%
  bg(j= 4, i = 10, part = "body", bg = colours[col[10]])%>%
  bg(j= 4, i = 11, part = "body", bg = colours[col[11]])%>%
  bg(j= 4, i = 12, part = "body", bg = colours[col[12]])%>%
  bg(j= 4, i = 13, part = "body", bg = colours[col[13]])%>%
  bg(j= 4, i = 14, part = "body", bg = colours[col[14]])

sse_analysis_00 %>% autofit()



###SEE ANALYSIS 01###

## Layout
border_style = officer::fp_border(color="black", width=1)
col = sse_analysis_2$col
colours = c(rgb(1.0,0.4,0.4),
            rgb(1.0,0.6,0.6),
            rgb(0.7,1.0,0.7),
            rgb(0.5,1.0,0.5))

## Flextable
sse_analysis_01 = sse_analysis_01 %>%
  select(-c("col"))%>%
  flextable()%>%
  add_header_row(
    top = TRUE,
    values = c("STATES",
               "SSE WITHOUT \n CLUSTERS",
               "SSE WITH \n CLUSTERS",
               "VARIATION (%)"))%>%
  set_header_labels(
    state = "",
    sse_all = "",
    sse_cluster = "",
    ratio = "")

sse_analysis_01 = sse_analysis_01%>% 
  border_remove()%>%
  theme_booktabs()%>%
  vline(part = "all", j = 1, border = border_style)%>% 
  vline(part = "all", j = 2, border = border_style)%>%
  vline(part = "all", j = 3, border = border_style)%>%
  align(align = 'center', j = c(1:4), part = 'all')%>%
  bg(part = "body", bg = "gray95")%>%
  fontsize(i = 1, size = 12, part = "header")%>%   
  bold(i = 1, bold = TRUE, part = "header")%>%
  bold(i = 14,bold = TRUE, part = 'body')%>%
  bg(j= 4, i = 1, part = "body", bg = colours[col[1]])%>%
  bg(j= 4, i = 2, part = "body", bg = colours[col[2]])%>%
  bg(j= 4, i = 3, part = "body", bg = colours[col[3]])%>%
  bg(j= 4, i = 4, part = "body", bg = colours[col[4]])%>%
  bg(j= 4, i = 5, part = "body", bg = colours[col[5]])%>%
  bg(j= 4, i = 6, part = "body", bg = colours[col[6]])%>%
  bg(j= 4, i = 7, part = "body", bg = colours[col[7]])%>%
  bg(j= 4, i = 8, part = "body", bg = colours[col[8]])%>%
  bg(j= 4, i = 9, part = "body", bg = colours[col[9]])%>%
  bg(j= 4, i = 10, part = "body", bg = colours[col[10]])%>%
  bg(j= 4, i = 11, part = "body", bg = colours[col[11]])%>%
  bg(j= 4, i = 12, part = "body", bg = colours[col[12]])%>%
  bg(j= 4, i = 13, part = "body", bg = colours[col[13]])%>%
  bg(j= 4, i = 14, part = "body", bg = colours[col[14]])

sse_analysis_01 %>% autofit()
