




# Just thought it be easier to rename  these
name_vec1 <- c('Total', 'age18_24', 'age25_39', 'age40_54', 'age55_64', 'age_over65',
               'sex_male', 'sex_female', 
               'race_latino', 'race_white', 'race_black', 'race_asian', 'race_multi',
               'ed_less_than_hs', 'ed_hs', 'ed_some_college','ed_college',
               'marital_married', 'marital_widow', 'marital_divorce', 'marital_never','marital_nonresp',
               'child_yes', 'child_no', 
               'health5', 'health4', 'health3', 'health2', 'health1', 'health_missing',
               'inc_less_than_25k', 'inc25_35k', 'inc35_50k', 'inc50_75k', 'inc75_100k',
               'inc100_150k', 'inc150_200k', 'inc_over200k', 'inc_nonresp')


name_vec2 <- c('Total', 'age18_24', 'age25_39', 'age40_54', 'age55_64', 'age_over65',
               'sex_male', 'sex_female', 
               'race_latino', 'race_white', 'race_black', 'race_asian', 'race_multi',
               'ed_less_than_hs', 'ed_hs', 'ed_some_college','ed_college',
               'marital_married', 'marital_widow', 'marital_divorce', 'marital_never','marital_nonresp',
               'house1', 'house2', 'house3', 'house4', 'house5', 'house6', 'house7_or_more',
               'child_yes', 'child_no', 
               'health5', 'health4', 'health3', 'health2', 'health1', 'health_missing',
               'inc_less_than_25k', 'inc25_35k', 'inc35_50k', 'inc50_75k', 'inc75_100k',
               'inc100_150k', 'inc150_200k', 'inc_over200k', 'inc_nonresp',
               'spend_inc', 'spend_credit', 'spend_savings', 'spend_borrow',
               'spend_ui', 'spend_stimulus', 'spend_deferred', 'spend_nonresp')



#Function for reading in State sheets
read_state_func <- function(state, file = path, week = week_i) {
  
  
  df <- suppressMessages(readxl::read_excel(path,
                                            sheet = state,
                                            skip = 5,
                                            na = '-')) %>%
    mutate(week = i,
           date = week_i,
           state = state)
  
  names(df)[2] <- 'Total'
  df <- df %>%  filter(!is.na(df$Total))
  
  return(df)
}  
