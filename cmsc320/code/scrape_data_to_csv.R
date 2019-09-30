##
# Scrapes JSON data from IEX for each of our tickers.
# The dataframes of stock data are then written to CSV files for data analysis
#
# This was ran once on 05/11/2019 to extract data

library(jsonlite)
library(httr)
library(tidyverse)

################################################################################
# Functions
################################################################################

## 
# Returns a dataframe of date, close, high, low, and volume
# 
# @param: tick
#         String, the stock ticker whose data we want
# @param: range
#         String, the range of data. We will use "5y"
#
# @author: Jared Gill
iex_chart <- function(tick, range){
  # Make REST call
  r <- GET("https://api.iextrading.com/1.0/stock/market/batch",
           query = list(symbols = tick, 
                        types = "chart",
                        range = range, last = "5")
  )
  
  # Remove formatting
  r1 <- content(r)
  rtick <- enframe(unlist(r1[[tick]]$chart))
  
  # Extract data
  rdates <- filter(rtick, name=="date") 
  rclose <- filter(rtick, name=="close") 
  rhigh <- filter(rtick, name=="high") 
  rlow <- filter(rtick, name=="low") 
  rvolume <- filter(rtick, name=="volume") 
  rchange <- filter(rtick, name=="change")
  
  # Make data frame
  df <- data.frame(rdates[2], rclose[2], rhigh[2], rlow[2], rvolume[2], 
                   rchange[2])
  
  # Rename columns
  df <- df %>%
    rename(date="value", close="value.1", high="value.2", low="value.3",
           volume="value.4", change="value.5")
  return(df)
}

################################################################################
# Main
################################################################################

# Convert data to dataframes
df_aapl <- iex_chart("AAPL", "5y")
df_cone <- iex_chart("CONE", "5y")
df_fb <- iex_chart("FB", "5y")
df_goog <- iex_chart("GOOG", "5y")
df_govt <- iex_chart("GOVT", "5y")
df_vz <- iex_chart("VZ", "5y")

# Write to CSVs
write_csv(df_aapl, "aapl.csv")
write_csv(df_cone, "cone.csv")
write_csv(df_fb, "fb.csv")
write_csv(df_goog, "goog.csv")
write_csv(df_govt, "govt.csv")
write_csv(df_vz, "vz.csv")