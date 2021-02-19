

# State Unemployment Trends Phase II


# Weeks 13 to Week 17

#Note: Month gap between End of Phase 1 (July 12, 2020) & Beginning of Phase 2 (August 19)



library(tidyverse)
source("source.R")



#### Load in Data ####

# Create empty list to store data.frames
df_list <- list()


week_vec2 <- seq(lubridate::ymd("2020-08-31"), 
                 lubridate::ymd("2020-10-26"), 
                 by = "2 weeks")



#Note: This takes awhile
for(i in seq_along(week_vec2)){
  
  n <- i + 12
  
  print(paste('Week:', n))
  
  
  path_i <- paste0("data/input/employ2_week", n, '.xlsx')
  
  # Not sure if this is needed
  week_i <- week_vec2[i]
  
  # Create nested list 
  week_list <- state.abb %>% lapply(function(x) read_state_func(x, week_i, path_i, skip = 6))
  df_list[[i]] <- do.call(rbind, week_list)
  
  
}

df_list %>%  lapply(nrow)


name_vec2
df_list %>% str