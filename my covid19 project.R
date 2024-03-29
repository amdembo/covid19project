# A pneumonia of unknown cause detected in Wuhan, China was first internationally reported from China on 31 December 2019. Today we know this virus as COVID-19, or more casually, as Coronavirus. Since then, the world has been engaged in the fight against this pandemic. Several measures have therefore been taken to "flatten the curve". We have consequently experienced social distancing and many people have passed away as well.
# Our goal in this project is to provide an answer to this question: Which countries have had the highest number of positive cases against the number of tests?
library(readr)
# Importing our dataset 
covid_df <- read.csv("covid19 dataset.csv")
# How much data do we have?
dim(covid_df)
# Storing the Column Names in a variable
vector_cols <- colnames(covid_df)
#Display the vector_cols
vector_cols
head(covid_df)
library(tibble) 
glimpse(covid_df)

library(dplyr)
# Filter the "All States" Province states and remove the `Province_State` column
covid_df_all_states <- covid_df %>% 
  filter(Province_State == "All States") %>% 
  select(-Province_State)

# Selecting the columns with cumulative numbers
covid_df_all_states_daily <- covid_df_all_states %>% 
  select(Date, Country_Region, active, hospitalizedCurr, daily_tested, daily_positive)
head(covid_df_all_states_daily)

## Summarizing the data based on the `Country_Region` column.

covid_df_all_states_daily_sum <- covid_df_all_states_daily %>% 
  group_by(Country_Region) %>% 
  summarise(tested = sum(daily_tested), 
            positive = sum(daily_positive),
            active = sum(active),
            hospitalized = sum(hospitalizedCurr)) %>% 
  arrange(desc(tested)) #this is equivalent to `arrange(-tested)`
covid_df_all_states_daily_sum

## Taking the top 10 

covid_top_10 <- head(covid_df_all_states_daily_sum, 10)
covid_top_10

## Getting vectors 

countries <- covid_top_10$Country_Region
tested_cases <- covid_top_10$tested
positive_cases <- covid_top_10$positive
active_cases <- covid_top_10$active
hospitalized_cases <- covid_top_10$hospitalized


## Naming vectors

names(positive_cases) <- countries
names(tested_cases) <- countries
names(active_cases) <- countries
names(hospitalized_cases) <- countries


## Identifying

positive_cases
sum(positive_cases)
mean(positive_cases)
positive_cases/sum(positive_cases)

positive_cases/tested_cases


## Conclusion 

positive_tested_top_3 <- c("United Kingdom" = 0.11, "United States" = 0.10, "Turkey" = 0.08)

# Creating vectors 
united_kingdom <- c(0.11, 1473672, 166909, 0, 0)
united_states <- c(0.10, 17282363, 1877179, 0, 0)
turkey <- c(0.08, 2031192, 163941, 2980960, 0)
# Creating the matrix covid_mat
covid_mat <- rbind(united_kingdom, united_states, turkey)

# Naming columns
colnames(covid_mat) <- c("Ratio", "tested", "positive", "active", "hospitalized")
#d Displaying the matrix
covid_mat

# Putting all together

question <- "Which countries have had the highest number of positive cases against the number of tests?"
answer <- c("Positive tested cases" = positive_tested_top_3)
datasets <- list(
  original = covid_df,
  allstates = covid_df_all_states,
  daily = covid_df_all_states_daily,
  top_10 = covid_top_10
)
matrices <- list(covid_mat)
vectors <- list(vector_cols, countries)
data_structure_list <- list("dataframe" = datasets, "matrix" = matrices, "vector" = vectors)
covid_analysis_list <- list(question, answer, data_structure_list)
covid_analysis_list[[2]]
