library(jsonlite)
library(httr)
library(tidyverse)

r <- GET("https://api.iextrading.com/1.0/stock/market/batch", 
         query = list(symbols = "aapl,fb", types = "quote,news,chart", 
         range = "1m", last = "5")
)


r1 <- content(r)
r2 <- enframe(unlist(r1$AAPL$chart))
r2_dates <- filter(r2, name=="date")
r2_close <- filter(r2, name=="close")

df <- data.frame(dates = r2_dates[2], close = r2_close[2])


