

# Explre tidycense

library(tidycensus)


#### Getting API Key ####

#Note: These steps are in https://cran.r-project.org/web/packages/tidycensus/tidycensus.pdf

# Can use this code to store 
#census_api_key(key = 'key', overwrite = TRUE, install = TRUE)

# Allow you to use key without restarting
#readRenviron("~/.Renviron")

# Can use this code 
#Sys.getenv("CENSUS_API_KEY")

#### Search for Variables ####

# Search for variables from 2019 American Community Cense

library(tidyverse)
var_list <- load_variables(2019, "acs5") 

#write_csv(var_list,'data/acs_variables.csv')




#### Loading Data ####

state_pop <- get_acs(geography = 'state', variables = 'B01001_001', year = 2019 ) 

state_pop %>% 
  arrange(estimate) %>% 
  mutate(NAME = fct_reorder(NAME, desc(estimate))) %>% 
  slice(1:10) %>% 
  ggplot(aes(x=NAME, y = estimate)) +
  geom_col() +
  coord_flip() +
  ggtitle('Ten Least Most Populous States')

state_pop %>% 
  arrange(desc(estimate)) %>% 
  mutate(NAME = fct_reorder(NAME, estimate)) %>% 
  slice(1:10) %>% 
  ggplot(aes(x=NAME, y = estimate)) +
  geom_col() +
  coord_flip() +
  ggtitle("Ten Most Populous States")


sort

?order_by
