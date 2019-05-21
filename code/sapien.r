library(jsonlite)
library(httr)
library(tidyverse)
library(dplyr)
library(zoo)
library(RcppRoll)

# Read price data from CSV files
df_aapl <- read_csv("./data/aapl.csv", col_names=
                      c("date", 
                        "aapl_close", 
                        "aapl_high",
                        "aapl_low",
                        "aapl_vol",
                        "aapl_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)
                      

df_cone <- read_csv("./data/cone.csv", col_names=
                      c("date", 
                        "cone_close", 
                        "cone_high",
                        "cone_low",
                        "cone_vol",
                        "cone_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)

df_fb <- read_csv("./data/fb.csv", col_names=
                      c("date", 
                        "fb_close", 
                        "fb_high",
                        "fb_low",
                        "fb_vol",
                        "fb_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)

df_goog <- read_csv("./data/goog.csv", col_names=
                      c("date", 
                        "goog_close", 
                        "goog_high",
                        "goog_low",
                        "goog_vol",
                        "goog_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)

df_govt <- read_csv("./data/govt.csv", col_names=
                      c("date", 
                        "govt_close", 
                        "govt_high",
                        "govt_low",
                        "govt_vol",
                        "govt_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)

df_vz <- read_csv("./data/vz.csv", col_names=
                      c("date", 
                        "vz_close", 
                        "vz_high",
                        "vz_low",
                        "vz_vol",
                        "vz_change"), col_types=
                      list(col_date(format="%Y-%m-%d"),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double(),
                           col_double()), skip=1)

# Read balance sheet data from CSVs
df_aapl_b <- read_csv("./data/AAPL_bsheet.csv", col_names=
                      c("date", 
                        "aapl_book", 
                        "aapl_outS"), col_types=
                      list(col_date(format="%m/%d/%Y"),
                           col_double(),
                           col_guess()), skip=1)

df_cone_b <- read_csv("./data/CONE_bsheet.csv", col_names=
                      c("date", 
                        "cone_book",
                        "cone_outS"), col_types=
                      list(col_date(format="%m/%d/%Y"),
                           col_guess(),
                           col_guess()), skip=1)

df_fb_b <- read_csv("./data/FB_bsheet.csv", col_names=
                      c("date", 
                        "fb_book", 
                        "fb_outS"), col_types=
                      list(col_date(format="%m/%d/%Y"),
                           col_guess(),
                           col_guess()), skip=1)

df_goog_b <- read_csv("./data/GOOG_bsheet.csv", col_names=
                      c("date", 
                        "goog_book", 
                        "goog_outS"), col_types=
                      list(col_date(format="%m/%d/%Y"),
                           col_guess(),
                           col_guess()), skip=1)

df_vz_b <- read_csv("./data/VZ_bsheet.csv", col_names=
                      c("date", 
                        "vz_book", 
                        "vz_outS"), col_types=
                      list(col_date(format="%m/%d/%Y"),
                           col_guess(),
                           col_guess()), skip=1)

# Joining our data into a single dateframe and adding the earliest book
# and outstanding shares data from the balance sheet dataframes
# For convenience, we also simplify our attribute names.
# Lastly, we sort by ascending date

df_aapl <- df_aapl %>%
  full_join(df_aapl_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8) %>%
  arrange(date)

df_cone <- df_cone %>%
  full_join(df_cone_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8) %>%
  arrange(date)

df_fb <- df_fb %>%
  full_join(df_fb_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8) %>%
  arrange(date)

df_goog <- df_goog %>%
  full_join(df_goog_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8) %>%
  arrange(date)

df_vz <- df_vz %>%
  full_join(df_vz_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8) %>%
  arrange(date)

# Remove extraneous variables from our workspace
rm(df_aapl_b, df_cone_b, df_fb_b, df_goog_b, df_vz_b)

# Remove all but the change and date for df_govt since we only care about
# its change
df_govt <- df_govt %>%
  select(date, change="govt_change", close="govt_close")

# Replace NA values in the "Book" and "Outstanding Shares" attributes
# with last non-NA value
df_aapl$book <- na.locf(df_aapl$book)
df_aapl$outS <- na.locf(df_aapl$outS)

df_cone$book <- na.locf(df_cone$book)
df_cone$outS <- na.locf(df_cone$outS)

df_fb$book <- na.locf(df_fb$book)
df_fb$outS <- na.locf(df_fb$outS)

df_goog$book <- na.locf(df_goog$book)
df_goog$outS <- na.locf(df_goog$outS)

df_vz$book <- na.locf(df_vz$book)
df_vz$outS <- na.locf(df_vz$outS)

# Since earning reports don't always correspond to trading days, remove
# dates that aren't trading days
df_aapl <- filter(df_aapl, !is.na(close))

df_cone <- filter(df_cone, !is.na(close))

df_fb <- filter(df_fb, !is.na(close))

df_goog <- filter(df_goog, !is.na(close))

df_vz <- filter(df_vz, !is.na(close))

# Calculate our factors
  # Calculate market portfolio of returns and date
df_market <- df_aapl %>%
  select(date, cl_aapl=close, ch_aapl=change) %>%
  right_join(df_cone, by="date") %>%
  select(date, cl_aapl, ch_aapl, 
         cl_cone=close, ch_cone=change) %>%
  right_join(df_fb, by="date") %>%
  select(date, cl_aapl, ch_aapl,
         cl_cone, ch_cone,
         cl_fb=close, ch_fb=change) %>%
  right_join(df_goog, by="date") %>%
  select(date, cl_aapl, ch_aapl,
         cl_cone, ch_cone,
         cl_fb, ch_fb,
         cl_goog=close, ch_goog=change) %>%
  right_join(df_vz, by="date") %>%
  select(date, cl_aapl, ch_aapl,
         cl_cone, ch_cone,
         cl_fb, ch_fb,
         cl_goog, ch_goog,
         cl_vz=close, ch_vz=change) 

df_market <- df_market %>%
  mutate(cl_market=cl_aapl+cl_cone+cl_fb+cl_goog+cl_vz) %>%
  mutate(w_aapl=cl_aapl/cl_market, 
         w_cone=cl_cone/cl_market,
         w_fb=cl_fb/cl_market,
         w_goog=cl_goog/cl_market,
         w_vz=cl_vz/cl_market) %>%
  mutate(ch_market=w_aapl*ch_aapl+
           w_cone*ch_cone+
           w_fb*ch_fb+
           w_goog*ch_goog+
           w_vz*ch_vz) %>%
  mutate(r_market=ch_market/lag(cl_market, 1)) %>%
  select(date, r_market)

# Calculate the daily returns on our risk-free rate (govt)
df_govt <- df_govt %>%
  mutate(r=change/lag(close, 1))

# Calculate the return and excess return for each asset, 
# including the market portfolio
df_aapl <- df_aapl %>%
  mutate(r=change/lag(close, 1)) %>%
  mutate(r_excess = r-df_govt$r)

df_cone <- df_cone %>%
  mutate(r=change/lag(close, 1)) %>%
  mutate(r_excess = r-df_govt$r)

df_fb <- df_fb %>%
  mutate(r=change/lag(close, 1)) %>%
  mutate(r_excess = r-df_govt$r)

df_goog <- df_goog %>%
  mutate(r=change/lag(close, 1)) %>%
  mutate(r_excess = r-df_govt$r)

df_vz <- df_vz %>%
  mutate(r=change/lag(close, 1)) %>%
  mutate(r_excess = r-df_govt$r)

df_market <- df_market %>%
  mutate(r_excess_market = r_market-df_govt$r)

# Calculate residual return and its standard deviation for each stock

df_aapl <- df_aapl %>%
  right_join(df_market, by="date") %>%
  select(-r_market)
# Run the regression for the beta
aapl_fit <- lm(r_excess~r_excess_market, 
               filter(df_aapl, date<"2017-01-03"))
# Fit residual return
beta <- ((broom::tidy(aapl_fit))["estimate"])[[1, 1]]
df_aapl <- df_aapl %>%
  mutate(r_resid=r_excess-(beta*r_excess_market)) %>%
  select(-r_excess_market)

# Calculate annual standard deviation of residual returns
# Calculate rolling annual volume and monthly close
#   Note that we use a window of 252+1
ta <- df_aapl %>%
  mutate(r_resid_sd=roll_sdr(r_resid, n=253, fill=NA)) %>%
  mutate(VLVR=log10((roll_sumr(vol, 21)*lag(close, 21)+
                 roll_sumr(lag(vol, 21), 21)*lag(close, 21*2)+
                 roll_sumr(lag(vol, 21*2), 21)*lag(close, 21*3)+
                 roll_sumr(lag(vol, 21*3), 21)*lag(close, 21*4)+
                 roll_sumr(lag(vol, 21*4), 21)*lag(close, 21*5)+
                 roll_sumr(lag(vol, 21*5), 21)*lag(close, 21*6)+
                 roll_sumr(lag(vol, 21*6), 21)*lag(close, 21*7)+
                 roll_sumr(lag(vol, 21*7), 21)*lag(close, 21*8)+
                 roll_sumr(lag(vol, 21*8), 21)*lag(close, 21*9)+
                 roll_sumr(lag(vol, 21*9), 21)*lag(close, 21*10)+
                 roll_sumr(lag(vol, 21*10), 21)*lag(close, 21*11)+
                 roll_sumr(lag(vol, 21*11), 21)*lag(close, 21*12))/r_resid_sd))
  
  
 # mutate(vol_a=roll_sumr(vol, n=253))









# Calculate HILO factor

  # Calculate lowest and highest price for past trading month for every
# trading day

df_aapl$m_high <- df_aapl %>%
  select(high) %>%
  rollmax(k = 22, na.pad = TRUE, align = "right")

df_aapl$m_low <- df_aapl %>%
  select(low) %>%
  mutate(low=-low) %>%
  rollmax(k = 22, na.pad = TRUE, align = "right") * -1
  
  # Calculate the HILO
df_aapl <- df_aapl %>%
  mutate(hilo = log10(m_high/m_low)) %>%
  select(c(1, 2, 4, 5, 6, 7, 8, 11))

# Calculate RSTR factor

y_sum <- vector()
d_change <- vector()
d_change_rf <- vector()
prev_close <- vector()
prev_close_rf <- vector()
d_ret <- vector()
d_ret_rf <- vector()
m_ret <- vector()
m_ret_rf <- vector()
rstr <- vector()
# Note that 12*21 = 252
for (i in seq(1, nrow(df_aapl)-252-1)) {
  # Calculate daily returns for the past year
  d_change <- select(slice(df_aapl, (i+1):(i+252+1)), change)
  d_change_rf <- select(slice(df_govt, (i+1):(i+252+1)), change)
  prev_close <- select(slice(df_aapl, i:(i+252)), close)
  prev_close_rf <- select(slice(df_govt, i:(i+252)), close)
  d_ret <- d_change/prev_close
  d_ret_rf <- d_change_rf/prev_close_rf
  # Divide the year into 12 months and calculate the total return for each 
  # month
  for (j in seq(0, 11)) {
    m_ret[(j+1)] <- log10( 1+ sum(slice(d_ret, 
                                        (j*21 + 1):(j*21 + 1 + 21))))
    m_ret_rf[(j+1)] <- log10( 1+ sum(slice(d_ret_rf, 
                                           (j*21 + 1):(j*21 + 1 + 21))))
  }
  rstr[i+252+1] <- sum(m_ret) - sum(m_ret_rf)
}
df_aapl$rstr <- rstr