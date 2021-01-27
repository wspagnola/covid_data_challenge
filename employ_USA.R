


library(tidyverse)
source("source.R")



#### Load in Data ####

# Create empty list to store data.frames
df_list <- list()

#Create sequence of dates for Phase 1; Note that each date is end date of survey administration period
week_vec <- seq(lubridate::ymd("2020-05-04"), lubridate::ymd("2020-07-21"), by = "week")


for (i in 1:12){
  
  path <- paste0("data/input/employ2_week", i, '.xlsx')
  df_list[[i]] <- readxl::read_xlsx(path, sheet = 'US', skip = 5, na = '-') %>% 
                    mutate(week = i,
                           date = week_vec[i]) %>% 
                    filter(!is.na(Government))
    

}


#### Explore Datasets ####

# Note More rows starting week 7 

# df_list %>%  sapply(nrow)
# length(name_vec2)
# 
# df_list[[7]][, 1] %>%  View
# df_list[[7]][53, 1]



#### Recode Values in First column ####

df_list[1:6] <- df_list[1:6] %>%  
    lapply(function(df) {df[, 1] <- name_vec1
                              return(df)
    
  })

# These survey weeks have columns for household size and spendings
df_list[7:12] <- df_list[7:12] %>%  
  lapply(function(df) {df[, 1] <- name_vec2
  return(df)
  
})


#### Bind datasets from list into one master file ####

df <- do.call( rbind, df_list)


#### Clean data frame ####

names(df)[c(1,2,9, 10)] <- c('name', 'Total', 'Unemploy', 'Nonresp')




#### Invert Column Names and Group Column

# Not sure which format is better df, df_long, or df_t

# Not sure if Total, Nonresp and Unemploy should be in same table for df_t

# Not sure if Total row needed at all (Constant across weeks)

# Convert to Long
df_long <- df %>%  
  pivot_longer(cols = - c(name, week, date), names_to = 'employ_sector' )  


# Convert to wide with rows as employment sector by date  and columns subgroups
df_t <- df_long %>% 
          pivot_wider(id = c(employ_sector, week,date ))

write.csv(df_t, 'data/output/employ_USA.csv')

#### Old Code ####

# 
# df <- readxl::read_xlsx("data/employ2_week1.xlsx", sheet = 'US', skip = 5) %>% 
#   filter(!is.na(Government))