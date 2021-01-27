


library(tidyverse)
source("source.R")



#### Load in Data ####

# Create empty list to store data.frames
df_list <- list()

#Note: will need to change to argument in seq function and vector in for loop after we add files from later Phases

#Create sequence of dates for Phase 1; Note that each date is end date of survey administration period
week_vec <- seq(lubridate::ymd("2020-05-04"), lubridate::ymd("2020-07-21"), by = "week")


#Note: This takes awhile
for(i in seq_along(week_vec)){
  
  print(paste('Week:', i))
  
  
  path <- paste0("data/input/employ2_week", i, '.xlsx')
  week_i <- week_vec[i]
      
  # Create nested list 
  week_list <- state.abb %>% lapply(read_state_func)
  df_list[[i]] <- do.call(rbind, week_list)
  

}

df_list %>% str


df_list[[1]][, 1] %>% table




#### Recode Values in First column ####

# Note: use factors instead

# df_list[1:6] <- df_list[1:6] %>%  
#   lapply(function(df) {df[, 1] <- name_vec1
#   return(df)
#   
#   })

# These survey weeks have columns for household size and spendings
# df_list[7:12] <- df_list[7:12] %>%  
#   lapply(function(df) {df[, 1] <- name_vec2
#   return(df)
#   
#   })


#### Bind datasets from list into one master file ####

# df <- do.call( rbind, df_list)


#### Clean data frame ####

# names(df)
# 
# names(df)[c(1, 9, 10)] <- c('name', 'Unemployed', 'Nonresp')
# 



#### Invert Column Names and Group Column

# Not sure which format is better df, df_long, or df_t

# Not sure if Total, Nonresp and Unemploy should be in same table for df_t

# Not sure if Total row needed at all (Constant across weeks)

# Convert to Long
# df_long <- df %>%  
#             pivot_longer(cols = - c(name, week, date), names_to = 'employ_sector' )  


# Convert to wide with rows as employment sector by date  and columns subgroups
# df_t <- df_long %>% 
#             pivot_wider(id = c(employ_sector, week,date ))
# 
# write.csv(df_t, 'data/output/employ_states.csv')
# 
# 

