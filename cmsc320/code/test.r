# API Key:
# QUKSG1N9U1GU2PTG
library(jsonlite)
library(httr)
library(tidyverse)


r <- GET("https://api.iextrading.com/1.0/stock/market/batch",
           query = list(symbols = "GOOG", 
                        types = "chart",
                        range = "5y", last = "5"))
  r1 <- content(r)
  rtick <- enframe(unlist(r1[["GOOG"]]$chart))
  rdates <- filter(rtick, name=="date") 
  rclose <- filter(rtick, name=="close") 
  rhigh <- filter(rtick, name=="high") 
  rlow <- filter(rtick, name=="low") 
  rvolume <- filter(rtick, name=="volume") 
  df <- data.frame(rdates[2], rclose[2], rhigh[2], rlow[2], rvolume[2])
  df <- df %>%
    rename(date="value", close="value.1", high="value.2", low="value.3", 
           volume="value.4")