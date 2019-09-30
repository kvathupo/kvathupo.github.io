library(jsonlite)
library(httr)

#collect data
r <- GET("https://api.iextrading.com/1.0/stock/market/batch",
         query = list(symbols = "aapl,goog,fb,govt", 
                      types = "chart",
                      range = "2y", last = "5")
)

#clean up data
r1 <- content(r)
rappl <- enframe(unlist(r1$AAPL$chart))
rfb <- enframe(unlist(r1$FB$chart))
rgoog <- enframe(unlist(r1$GOOG$chart))
rgovt <- enframe(unlist(r1$GOVT$chart))

rappl_dates <- filter(rappl, name=="date")
rappl_close <- filter(rappl, name=="close")
rfb_close <- filter(rfb, name=="close")
rgoog_close <- filter(rgoog, name=="close")
rgovt_close <- filter(rgovt, name=="close")

df <- data.frame(rappl_dates[2], rappl_close[2], rfb_close[2], rgoog_close[2], rgovt_close[2])
df <- df %>%
  rename(date="value", aapl_close="value.1", fb_close="value.2", goog_close="value.3", govt_close="value.4")

#make monkey picks

df <- df %>%
  mutate(mpick = floor(runif(nrow(df), min=2, max=6))) %>%
  mutate(mpick_val = ifelse(mpick==2, aapl_close,
                            ifelse(mpick==3, fb_close, 
                                   ifelse(mpick==4,goog_close,
                                          ifelse(mpick==5,govt_close, 0))))) %>%
  mutate(mpick_next = floor(runif(nrow(df), min=2, max=6))) %>%
  mutate(mnext_val = ifelse(mpick_next==2, aapl_close,
                            ifelse(mpick_next==3, fb_close, 
                                   ifelse(mpick_next==4,goog_close,
                                          ifelse(mpick_next==5,govt_close, 0))))) %>%
  mutate(day_profit=(as.numeric(mpick_val)-as.numeric(mnext_val)))
sum(df$day_profit)

#plot monkey returns
df %>%
  sample_frac(.1) %>%
  ggplot(mapping=aes(x=date, y=day_profit)) + geom_point()

#function to return dataframe for ticker
iex_dat <- function(tick){
  r <- GET("https://api.iextrading.com/1.0/stock/market/batch",
           query = list(symbols = tick, 
                        types = "chart",
                        range = "2y", last = "5")
  )
  r1 <- content(r)
  rtick <- enframe(unlist(r1[[tick]]$chart))
  rdates <- filter(rtick, name=="date") 
  rclose <- filter(rtick, name=="close") 
  rhigh <- filter(rtick, name=="high") 
  rlow <- filter(rtick, name=="low") 
  rvolume <- filter(rtick, name=="volume") 
  df <- data.frame(rdates[2], rclose[2], rhigh[2], rlow[2], rvolume[2])
  df <- df %>%
    rename(date="value", close="value.1", high="value.2", low="value.3", volume="value.4")
  return(df)
}

test <- iex_dat("AAPL")
