#------- -- - ---- --- - ----- --- ---- - ---- - -- - --- - -- - - -- - -- - -
## Phase 1: Data Acquisition & Initial Setup----------------- -- - -- -- ---
#------- -- - ---- --- - ----- --- ---- - ---- - -- - --- - -- - - -- - -- -


#install packages for data fetching, manipulation, time series, and plotting
install.packages(c("quantmod", "tidyverse", "timetk", "forecast", "anomalize", "plotly"))

# Load the libraries
library(quantmod)   # downloading financial data
library(tidyverse)  # data manipulation (dplyr) and plotting (ggplot2)
library(timetk)     # easily converting time-series objects to data frames
library(anomalize)  # For interactive plots
library(forecast)   # For forecasting (for Phase 5)
library(tseries)    # For statistical tests (for Phase 5)
# Define the stock ticker symbol for BlackRock Company
ticker <- "BLK"

# Define the start and end dates for our data
start_date <- "2015-01-01"
end_date <- Sys.Date()     #gets today's date

# Download the data from Yahoo Finance
getSymbols(ticker, 
           src = "yahoo", 
           from = start_date, 
           to = end_date)

# first 6 rows of the data
head(BLK)
# last 6 rows of the data
tail(BLK)

# structure of the object(an xts object)
str(BLK)
# statistical summary
summary(BLK)

# Convert the 'BLK' xts object to a modern data frame(tibble)
# rename_index = "Date" will take the time-series index and turn it into a column named "Date"
blk_tibble <- tk_tbl(BLK, rename_index = "Date")

# Notice the annoying BLK.prefix on every column name, now we are going to remove it
# We use the pipe (%>%) operator to pass our data from one function to the next
blk_tibble_clean <- blk_tibble %>%
  rename_with(~gsub("BLK.", "", .x, fixed = TRUE))
# function (~_gsub(...)) finds "BLK." and replaces it with "" (nothing)

## FINAL INSPECTION
# first few rows of our clean dataframe
head(blk_tibble_clean)
# Check the new column names
names(blk_tibble_clean)

#saving our progress to a csv because we dont want to download the data everytime
# Checks if a directory named 'data' exists, then create it
if (!dir.exists("data")) {
  dir.create("data")
}

# Save the 'blk_tibble_clean' data frame into the 'data' folder
write.csv(blk_tibble_clean, "data/BLK_data_clean.csv", row.names = FALSE)



#-- - -- - -- -- - -- - - -- - - - -- -- -- -- -- - -- - - - ------------- --
## Phase 2: Exploratory Data Analysis (EDA)-- -- -- - -- - - - ------------
#-- - -- - -- -- - -- - - -- - - - -- -- -- -- -- - -- - - - ------------- -- 

library(tidyverse)  # For data manipulation(dplyr) and plotting(ggplot2)
library(timetk)     # For time series functions
library(plotly)     # For interactive plots

# Read the data we saved in Phase 1
blk_tibble_clean <- read.csv("data/BLK_data_clean.csv")

# Use the mutate() function from dplyr to change Date column
# as.Date() is function that converts text to a Date
blk_tibble_clean <- blk_tibble_clean %>%
  mutate(Date = as.Date(Date))

# Check structure to confirm
str(blk_tibble_clean)

# Check missing values
# count the number of NAs in each column
colSums(is.na(blk_tibble_clean))

#Visualization 1 - The "Big Picture" (Price Over Time)
# Create our first plot using ggplot2
p1 <- ggplot(blk_tibble_clean, aes(x = Date, y = Adjusted)) +
  geom_line(color = "blue", linewidth = 0.5) +
  labs(title = "BlackRock (BLK) Adjusted Close Price (2015-Present)",
       subtitle = "Data sourced from Yahoo Finance",
       y = "Adjusted Close Price ($)",
       x = "Year") +
  theme_minimal()
# view the plot
p1

# Visualization 2 - Trading Volume (Market Activity)
# Let's see how many shares were traded each day
# We will make a bar chart (geom_col) for the Volume
p2 <- ggplot(blk_tibble_clean, aes(x = Date, y = Volume)) +
  geom_col(fill = "#0072B2") + # A nice shade of blue
  labs(title = "BlackRock (BLK) Trading Volume",
       y = "Shares Traded",
       x = "Year") +
  theme_minimal()

# View the plot
p2


#Visualization 3 - Moving Averages (Identifying the Trend)
# We will add new columns to our data frame
blk_with_ma <- blk_tibble_clean %>%
  mutate(
    MA_50 = slidify_vec(.x = Adjusted, .f = mean, .period = 50, .align = "right", .na_rm = TRUE),
    MA_200 = slidify_vec(.x = Adjusted, .f = mean, .period = 200, .align = "right", .na_rm = TRUE)
  )

p3 <- blk_with_ma %>%
  
  # We only select the columns we need for plotting
  select(Date, Adjusted, MA_50, MA_200) %>%
  
  # We "gather" the three price columns into one "Metric" column and one "Price" column
  pivot_longer(cols = c(Adjusted, MA_50, MA_200), 
               names_to = "Metric", 
               values_to = "Price") %>%
  
  # We add !is.na(Price) to remove any NAs (like the first 199 for MA_200)
  filter(Date >= (min(Date) + days(200)) & !is.na(Price)) %>%
  
  # Now, the fully prepared and filtered data is passed to ggplot
  ggplot(aes(x = Date, y = Price, color = Metric)) +
  geom_line(linewidth = 0.7) +
  labs(title = "BlackRock (BLK) Price vs. 50-Day & 200-Day Moving Averages",
       y = "Price ($)",
       x = "Year",
       color = "Metric") +
  theme_minimal()

# view the plot
p3


#----------- -- - ------------ --------- --------------- - ------------- -- -
## Phase 3: Data Transformation and Feature Engineering-- -- -- - -- - -- - 
#-- - -- - -- -- - -- - - -- - - - -- -- -- -- -- - -- - - - ------------ - 


library(tidyverse)  # For data manipulation(dplyr) and plotting(ggplot2)
library(timetk)     # For time series functions
library(plotly)     # For interactive plots

# Read the data that we saved in Phase 1
blk_tibble_clean <- read.csv("data/BLK_data_clean.csv")

str(blk_tibble_clean)
# when we read the csv file, the date column is not considering date as date format, 
# so we will transform it now.

# mutate() function from dplyr to change the Date column
# as.Date() function for converting text to a Date
blk_tibble_clean <- blk_tibble_clean %>%
  mutate(Date = as.Date(Date))

# check the structure to confirm
str(blk_tibble_clean)   #now it is in date format

# We will add new columns to our data frame
blk_transformed <- blk_tibble_clean %>%
  # Ensure data is sorted by Date, otherwise 'lag' will be wrong!
  arrange(Date) %>%
  # Create new columns
  mutate(
    # 1. Simple Percent Return
    # Formula: (Today's Price - Yesterday's Price) / Yesterday's Price
    Daily_Return_Pct = (Adjusted - lag(Adjusted)) / lag(Adjusted),
    # 2. Log Return (this is what we'll use)
    # Formula: log(Today's Price / Yesterday's Price)
    Daily_Return_Log = log(Adjusted / lag(Adjusted))
  )

# first few rows of our new data frame
head(blk_transformed)

# Cleaning NA Values
# Use drop_na() to remove any rows that have an NA value
# Since we only created NAs in the return columns, this will
# neatly remove just the first row.
blk_transformed_clean <- blk_transformed %>%
  drop_na()

# Check the first few rows again. The NA row should be gone.
head(blk_transformed_clean)

# Plot the Daily Log Returns over time
p4 <- ggplot(blk_transformed_clean, aes(x = Date, y = Daily_Return_Log)) +
  geom_line(color = "darkred", linewidth = 0.3) +
  labs(title = "BlackRock (BLK) Daily Log Returns (2015-Present)",
       subtitle = "Shows daily volatility and potential anomalies",
       y = "Daily Log Return",
       x = "Year") +
  theme_minimal()

p4

# Create histogram with a density overlay
p5 <- ggplot(blk_transformed_clean, aes(x = Daily_Return_Log)) +
  
  geom_histogram(aes(y = after_stat(density)), bins = 100, fill = "lightblue", alpha = 0.7) +
  
  geom_density(color = "blue", linewidth = 1) +
  
  labs(title = "Distribution of BlackRock's Daily Log Returns",
       subtitle = "Shows the frequency of different return percentages",
       x = "Daily Log Return",
       y = "Density") +
  theme_minimal()

# View the plot
p5

# Save the 'blk_transformed_clean' data frame to our 'data' folder
write.csv(blk_transformed_clean, "data/BLK_data_transformed.csv", row.names = FALSE)


#-- - -- - -- --------------------- -- - -- - - - ------------- -- --- -- - -- 
## Phase 4: Anomaly Detection-- -- -- - -- - - - ------------- -- ---- - ---- - 
#-- - -- - -- -- - -- - - -- - - - -- - - ------------- -- --- - - -- - ---- - 


install.packages("anomalize")
install.packages("timetk")
install.packages("tidyverse")

library(tidyverse)  # For data manipulation (dplyr)
library(timetk)     # For time series functions
library(anomalize)  # The main package for this phase
library(plotly)     # To make our final plot interactive

# Read the data we saved in Phase 3
blk_data_from_csv <- read.csv("data/BLK_data_transformed.csv")

# Convert the 'Date' column back to a Date object
# because everytime we read and load a file, the date is considered as text automatically
blk_transformed_clean <- blk_data_from_csv %>%
  mutate(Date = as.Date(Date)) %>%
  as_tibble()          


class(blk_transformed_clean)

# applying the anomaly detection workflow

blk_anomalies <- blk_transformed_clean %>%
  # 1. Decompose the time series (target is our Log Returns)
  # This function is smart enough to find the 'Date' column in a tibble
  time_decompose(target = Daily_Return_Log, 
                 frequency = "auto", 
                 trend = "auto",
                 merge = TRUE) %>%
  # 2. Find anomalies in the 'remainder'
  anomalize(target = remainder, 
            method = "gesd", 
            alpha = 0.05) %>%
  # 3. Re-compose the results
  time_recompose()

head(blk_anomalies)

#Visualiza the Anomalies
p6 <- blk_anomalies %>%
  plot_anomalies(time_recomposed = TRUE) +
  labs(title = "BlackRock (BLK) Daily Log Return Anomalies",
       subtitle = "Red dots are statistical outliers (95% confidence)")
# view the plot
p6


anomalous_days <- blk_anomalies %>%
  filter(anomaly == 'Yes') %>%
  select(Date, observed, remainder, anomaly) # Select only the key columns

# Print the list to console
# show up to 50 anomalies
print(anomalous_days, n = 50)


#---------------------------------- -- - -- - - - ------------- - - -- 
## Phase 5: Time Series Forecasting (ARIMA/SARIMA Modeling) ---------- ---- - 
#-- - -- - -- -- - -- - - -- - - - --  ------------- -- --- - - -- - ---- - 


install.packages("forecast")
install.packages("tseries")

library(tidyverse)  # For data manipulation
library(timetk)     # For time series functions
library(forecast)   # The main package for ARIMA models
library(tseries)    # For the stationarity test
library(plotly)     # To plot our final forecast

# Load the data we saved in Phase 1
blk_tibble_clean <- read.csv("data/BLK_data_clean.csv")

# Prepare the data
blk_tibble_clean <- blk_tibble_clean %>%
  # Convert the 'Date' column from text to a real Date object
  mutate(Date = as.Date(Date)) %>%
  # Make sure data is in correct chronological order
  arrange(Date)

#create a timeseries object

min_date <- min(blk_tibble_clean$Date)
start_year <- lubridate::year(min_date)
start_day_of_year <- lubridate::yday(min_date)

blk_ts <- ts(blk_tibble_clean$Adjusted, 
             start = c(start_year, start_day_of_year), 
             frequency = 252)

# Plot to confirm
autoplot(blk_ts) +
  labs(title = "BlackRock Adjusted Close Price (Time Series Object)",
       y = "Price ($)")

# Run ADF test on our time series
print(adf.test(blk_ts))

## Build the ARIMA MODEL
# This automatically finds the best ARIMA or SARIMA model.

arima_model <- auto.arima(blk_ts, 
                          seasonal = TRUE, 
                          stepwise = TRUE, 
                          trace = TRUE)

#summary of the best model it found
summary(arima_model)

# Check residuals(white noise i.e Randomness)
# statistical checks on the residuals
checkresiduals(arima_model)

#create forecast plot
# 'h = 252' means we want to forecast 252 periods (days) into the future
blk_forecast <- forecast(arima_model, h = 252)

# Plot the forecast
# plots the original data, the fitted model, and the future forecast
autoplot(blk_forecast) +
  labs(title = "BlackRock (BLK) Price Forecast (Next 252 Days)",
       subtitle = "Forecast from auto.arima() model",
       y = "Adjusted Close Price ($)",
       x = "Year") +
  theme_minimal()
