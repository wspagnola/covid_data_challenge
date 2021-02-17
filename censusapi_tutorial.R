

library(censusapi)
library(tidyverse)

#Vignette
#https://cran.r-project.org/web/packages/censusapi/vignettes/getting-started.html

# Check available apis
apis <- listCensusApis()
View(apis)

#Check metadata for specific apis
# Note: These files are huge!!! 2019 ACS has 35,552 variables
acs_vars <- listCensusMetadata(name = 'acs/acs1', vintage = 2019, type = 'variables')
View(acs_vars)

#Look just at Sex by age variables
# Noticee Regex pattern

acs_vars %>%  filter(str_detect( group, '^B01001')==TRUE) %>%  View()

# In order to actually access tables you will need Census Key

# Add key to your .Renviron
#Sys.setenv(CENSUS_KEY = 'your key')

Sys.setenv(CENSUS_KEY = 'd318c35f8d6c494cab19b38c8fa538ab5b3c36e6')
#You can check that you have the right key in your R environment
#Sys.getenv("CENSUS_KEY")

Sys.getenv("CENSUS_KEY")
# Re-load your .Renviron in order to use key
readRenviron("~/.Renviron")

#Note that this method allows you to use census key without uploading key to github
#.Renviron should be in gitignore file

# name is the API that you are connecting to
# vintage is the year of the specific api
# vars are the variables you are downloading
# You should always add NAME to the vector being passed to vars.  Otherwise you won't be able to identify the regional units unless you've memorized each Census number
# You need to specify region or you will get an error
df <- getCensus(name = 'acs/acs1',
                vars = c('NAME', 'B01001_001E'), 
                vintage = 2019, region = 'state')

#https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html

#  Plot Top Ten Most Populous States
df %>% 
  rename(  total_pop = B01001_001E ) %>% 
  arrange(desc(total_pop)) %>% 
  slice(1:10) %>% 
  mutate(NAME = fct_reorder(NAME, total_pop)) %>% 
  ggplot(aes(x = NAME, y = total_pop)) +
  geom_col(color = 'blue', fill = 'blue') +
  xlab('') +
  ylab('Top Ten Most Populous  States') +
  coord_flip()  +
  theme_bw()


#  Plot Top Ten Least Populous States
df %>% 
  rename(total_pop = B01001_001E) %>% 
  arrange(total_pop) %>% 
  slice(1:10) %>% 
  mutate(NAME = fct_reorder(NAME, desc(total_pop))) %>% 
  ggplot(aes(x = NAME, y = total_pop)) + 
  geom_col(color = 'red', fill = 'red') +
  xlab('') +
  ylab('Top Ten Least Populous  States') +
  coord_flip() +
  theme_bw()
  



