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
get_returns <- function(df) {
  df <- df %>%
    mutate(r=change/lag(close, 1)) %>%
    mutate(r_excess = r-df_govt$r)
  
}

df_aapl <- get_returns(df_aapl)
df_cone <- get_returns(df_cone)
df_fb <- get_returns(df_fb)
df_goog <- get_returns(df_goog)
df_vz <- get_returns(df_vz)

df_market <- df_market %>%
  mutate(r_excess_market = r_market-df_govt$r)

# Calculate residual return and its standard deviation for each stock

get_vlvr <- function(df) {
  df <- df %>%
    right_join(df_market, by="date") %>%
    select(-r_market)
  # Run the regression for the beta
  df_fit <- lm(r_excess~r_excess_market, 
               filter(df, date<"2017-01-03"))
  # Fit residual return
  beta <- ((broom::tidy(df_fit))["estimate"])[[1, 1]]
  df <- df %>%
    mutate(r_resid=r_excess-(beta*r_excess_market)) %>%
    select(-r_excess_market)

  # Calculate annual standard deviation of residual returns
  # Calculate rolling annual volume and monthly close
  #   Note that we use a window of 252+1
  # Calculate VLVR
  df <- df %>%
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
                   roll_sumr(lag(vol, 21*11), 21)*lag(close, 21*12))/r_resid_sd)) %>%
    select(-r_resid, -r_resid_sd)
}

df_aapl <- get_vlvr(df_aapl)
df_cone <- get_vlvr(df_cone)
df_fb <- get_vlvr(df_fb)
df_goog <- get_vlvr(df_goog)
df_vz <- get_vlvr(df_vz)


get_hilo <- function(df) {
  # Calculate HILO factor

    # Calculate lowest and highest price for past trading month for every
    # trading day

  df$m_high <- df %>%
    select(high) %>%
    rollmax(k = 22, na.pad = TRUE, align = "right")

  df$m_low <- df %>%
    select(low) %>%
    mutate(low=-low) %>%
    rollmax(k = 22, na.pad = TRUE, align = "right") * -1
  
  # Calculate the HILO
  df <- df %>%
    mutate(HILO = log10(m_high/m_low)) %>%
    select(-m_high, -m_low)
}

df_aapl <- get_hilo(df_aapl)
df_cone <- get_hilo(df_cone)
df_fb <- get_hilo(df_fb)
df_goog <- get_hilo(df_goog)
df_vz <- get_hilo(df_vz)

# Calculate RSTR

get_rstr <- function(df) {
  df <- df %>%
     mutate(RSTR_l=
           log10(1+(roll_sumr(change, 21)/lag(close, 21)))+
           log10(1+(roll_sumr(lag(change, 21), 21)/lag(close, 21*2)))+
           log10(1+(roll_sumr(lag(change, 21), 21*2)/lag(close, 21*3)))+
           log10(1+(roll_sumr(lag(change, 21), 21*3)/lag(close, 21*4)))+
           log10(1+(roll_sumr(lag(change, 21), 21*4)/lag(close, 21*5)))+
           log10(1+(roll_sumr(lag(change, 21), 21*5)/lag(close, 21*6)))+
           log10(1+(roll_sumr(lag(change, 21), 21*6)/lag(close, 21*7)))+
           log10(1+(roll_sumr(lag(change, 21), 21*7)/lag(close, 21*8)))+
           log10(1+(roll_sumr(lag(change, 21), 21*8)/lag(close, 21*9)))+
           log10(1+(roll_sumr(lag(change, 21), 21*9)/lag(close, 21*10)))+
           log10(1+(roll_sumr(lag(change, 21), 21*10)/lag(close, 21*11)))+
           log10(1+(roll_sumr(lag(change, 21), 21*11)/lag(close, 21*12)))) %>%
      mutate(RSTR_r=
           log10(1+(roll_sumr(df_govt$change, 21)/lag(df_govt$close, 21)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21)/lag(df_govt$close, 21*2)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*2)/lag(df_govt$close, 21*3)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*3)/lag(df_govt$close, 21*4)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*4)/lag(df_govt$close, 21*5)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*5)/lag(df_govt$close, 21*6)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*6)/lag(df_govt$close, 21*7)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*7)/lag(df_govt$close, 21*8)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*8)/lag(df_govt$close, 21*9)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*9)/lag(df_govt$close, 21*10)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*10)/lag(df_govt$close, 21*11)))+
           log10(1+(roll_sumr(lag(df_govt$change, 21), 21*11)/lag(df_govt$close, 21*12)))) %>%
      mutate(RSTR=RSTR_l-RSTR_r) %>%
      select(-RSTR_l, -RSTR_r) 
}

df_aapl <- get_rstr(df_aapl)
df_cone <- get_rstr(df_cone)
df_fb <- get_rstr(df_fb)
df_goog <- get_rstr(df_goog)
df_vz <- get_rstr(df_vz)


# Calculate LNCAP
get_lncap <- function(df) {
  df <- df %>%
    mutate(LNCAP=log10(outS*lag(close, 1)))
}

df_aapl <- get_lncap(df_aapl)
df_cone <- get_lncap(df_cone)
df_fb <- get_lncap(df_fb)
df_goog <- get_lncap(df_goog)
df_vz <- get_lncap(df_vz)

# Calculate LCAPCB
get_lcapcb <- function(df) {
  df <- df %>%
    mutate(LCAPCB=(log10(outS*lag(close, 1)))^(1/3))
}

df_aapl <- get_lcapcb(df_aapl)
df_cone <- get_lcapcb(df_cone)
df_fb <- get_lcapcb(df_fb)
df_goog <- get_lcapcb(df_goog)
df_vz <- get_lcapcb(df_vz)

# Calculate BTOP
get_btop <- function(df) {
  df <- df %>%
    mutate(BTOP=book/(outS*lag(close, 1)))
}

df_aapl <- get_btop(df_aapl)
df_cone <- get_btop(df_cone)
df_fb <- get_btop(df_fb)
df_goog <- get_btop(df_goog)
df_vz <- get_btop(df_vz)

# Approximate Risk-free rate for the day

r_f <- mean((filter(df_govt, date<"2017-01-03"))$r, na.rm=TRUE)

# Trim data and make amenable to regression (get residual factor values)
trim_dat <- function(df) {
  df <- df %>%
    filter(!is.na(VLVR)) %>%
    mutate(VLVR=VLVR-r_f,
           HILO=HILO-r_f,
           RSTR=RSTR-r_f,
           LNCAP=LNCAP-r_f,
           LCAPCB=LCAPCB-r_f,
           BTOP=BTOP-r_f)
}

df_aapl <- trim_dat(df_aapl)
df_cone <- trim_dat(df_cone)
df_fb <- trim_dat(df_fb)
df_goog <- trim_dat(df_goog)
df_vz <- trim_dat(df_vz)

# Create our training and test sets

train_aapl <- filter(df_aapl, date<"2017-01-03")
test_aapl <- filter(df_aapl, date>="2017-01-03")

train_cone <- filter(df_cone, date<"2017-01-03")
test_cone <- filter(df_cone, date>="2017-01-03")

train_fb <- filter(df_fb, date<"2017-01-03")
test_fb <- filter(df_fb, date>="2017-01-03")

train_goog <- filter(df_goog, date<"2017-01-03")
test_goog <- filter(df_goog, date>="2017-01-03")

train_vz <- filter(df_vz, date<"2017-01-03")
test_vz <- filter(df_vz, date>="2017-01-03")

# Fit the results of our regression on the training data onto
# the test dataset
fit_dat <- function(df) {
  md <- broom::tidy(lm(r~VLVR+HILO+RSTR+LNCAP+LCAPCB+BTOP, data=train_fb))
  df$r_pred <- md[[1,2]]+md[[2,2]]*df$VLVR+
    md[[3,2]]*df$HILO+md[[4,2]]*df$RSTR+
    md[[5,2]]*df$LNCAP+md[[6,2]]*df$LCAPCB+
    md[[7,2]]*df$BTOP
  df
}

test_aapl <- fit_dat(test_aapl)
test_cone <- fit_dat(test_cone)
test_fb <- fit_dat(test_fb)
test_goog <- fit_dat(test_goog)
test_vz <- fit_dat(test_vz)


# Remove extraneous variables
rm(train_aapl, train_cone, train_fb, train_goog, train_vz,
   df_aapl, df_cone, df_fb, df_goog, df_govt, df_vz)

# Prune data
test_aapl <- test_aapl %>%
  select(date, "aapl_c"=close, "aapl_r"=r, "aapl_p"=r_pred)
test_cone <- test_cone %>%
  select(date, "cone_c"=close, "cone_r"=r, "cone_p"=r_pred)
test_fb <- test_fb %>%
  select(date, "fb_c"=close, "fb_r"=r, "fb_p"=r_pred)
test_goog <- test_goog %>%
  select(date, "goog_c"=close, "goog_r"=r, "goog_p"=r_pred)
test_vz <- test_vz %>%
  select(date, "vz_c"=close, "vz_r"=r, "vz_p"=r_pred)

# Create portfolio
pfolio <- test_aapl %>%
  right_join(test_cone, by="date") %>%
  right_join(test_fb, by="date") %>%
  right_join(test_goog, by="date") %>%
  right_join(test_vz, by="date") %>%
  slice(seq(1, nrow(test_cone), by=5))

pfolio$val <- NA
pfolio$val[1] <- 1000000
for (i in seq(1, nrow(pfolio)-1)) {
  max_pred=max(pfolio[[i,4]],
               pfolio[[i,7]],
               pfolio[[i,10]],
               pfolio[[i,13]],
               pfolio[[i,16]])
  # AAPL is the max prediction
  if (max_pred==pfolio[[i,4]]) {
    pfolio$val[i+1]=(pfolio$val[i]/pfolio[[i,2]])*pfolio[[i+1,2]]
  } else if (max_pred==pfolio[[i,7]]) {
    pfolio$val[i+1]=(pfolio$val[i]/pfolio[[i,5]])*pfolio[[i+1,5]]
  } else if (max_pred==pfolio[[i,10]]) {
    pfolio$val[i+1]=(pfolio$val[i]/pfolio[[i,8]])*pfolio[[i+1,8]]
  } else if (max_pred==pfolio[[i,13]]) {
    pfolio$val[i+1]=(pfolio$val[i]/pfolio[[i,11]])*pfolio[[i+1,11]]
  } else if (max_pred==pfolio[[i,16]]) {
    pfolio$val[i+1]=(pfolio$val[i]/pfolio[[i,14]])*pfolio[[i+1,14]]
  }
}