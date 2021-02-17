
# Program Function: Process Phase 1 State Data 
#Note: State Data is Much messier 

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



#### Explore Measures  ####
measure_list <- df_list %>%  
                  lapply('[[', 1) %>% 
                  lapply(unique)
  

df_list %>%  lapply(nrow)
# Note: Week 2 Does not have Non-Response/Missing for Health & income


#### Weeks 1, 3-6 ####

df_list[c(1,3:6)] <-df_list[c(1,3:6)] %>%  
  lapply(function(df) {df$measures <- rep(name_vec1, 50)
  return(df)
  })

#### Week 2 Data ####

# Find which States are missing rows 
df2_nrow <- df_list[[2]] %>%  group_split(state) %>% vapply(nrow, FUN.VALUE = numeric(1))
df2_nrow 

# Need to Order States by Abbreviation rather than State Name
state_abb_list <- df_list[[2]]$state %>%  unique %>%  sort

#Create vector of states with only 38 rows: Nevada and Vermont
state_miss_row <- state_abb_list[df2_nrow == 38]
state_miss_row

#Number of States with 39 rows
nomiss_len <- 50 - length(state_miss_row) 

#Create empty column
df_list[[2]]$measures <- ''

#Create indices for states missing and not-missing rows
nomiss_idx <- which(df_list[[2]]$state %in% state_miss_row == FALSE)
miss_idx <- which(df_list[[2]]$state %in% state_miss_row)
  
# Add measures for states without missing rows
df_list[[2]][nomiss_idx, ]$measures <-rep(name_vec1, nomiss_len) 


df_list[[2]][miss_idx,]$measures <- rep(name_vec1a, 2)


#### Weeks 7 - 12  #####



# These survey weeks have columns for household size and spendings
df_list[7:12] <- df_list[7:12] %>%  
  lapply(function(df) {df$measures <- rep(name_vec2, 50)
  return(df)
  
  })

# Check ncol
df_list %>%  vapply(ncol, FUN.VALUE = numeric(1))

#### Bind datasets from list into one master file ####



df <- do.call( rbind, df_list)




#### Clean data frame ####

names(df)[c(1,2,9, 10)] <- c('name', 'Total', 'Unemploy', 'Nonresp')

# Check that name and measures align
# FIX!!!!!
# SHould  only be 39 rows
df %>% 
  distinct(name, measures) %>% 
  View

#### Tranpose Column Names and Group Column  ####

# Not sure which format is better df, df_long, or df_t
# Not sure if Total, Nonresp and Unemploy should be in same table for df_t
# Not sure if Total row needed at all (Constant across weeks)

# Convert to Long
df_long <- df %>%
            select(-name) %>% 
            pivot_longer(cols = - c(measures, week, date, state), names_to = 'employ_sector' )
df_long %>%  glimpse




# Convert to wide with rows as employment sector by date  and columns subgroups
df_t <- df_long %>%
            pivot_wider(id = c(employ_sector, week,date, state ), 
                        names_from = measures,
                        values_from =  value)

df_t %>% glimpse

# write.csv(df_t, 'data/output/employ_states.csv')
# 
# 


#### Plots ####

sub_states <- c('PA', 'NY', 'CA', 'FL')

df_long %>% 
  filter(state %in% sub_states, employ_sector == 'Unemploy', measures == 'age18_24') %>% 
  ggplot(aes(x = date, y = value / 1e3)) +
  geom_line() +
  geom_point() +
  ylab('NumberUnemployed (in Thousands)') +
  facet_wrap(~state, ncol = 1)
