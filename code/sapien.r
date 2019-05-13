library(jsonlite)
library(httr)
library(tidyverse)
library(dplyr)
library(zoo)

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
# For convenience, we also simplify our attribute names

df_aapl <- df_aapl %>%
  full_join(df_aapl_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8)
df_aapl[1,7] <- df_aapl_b[1,2]
df_aapl[1,8] <- df_aapl_b[1,3]

df_cone <- df_cone %>%
  full_join(df_cone_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8)
df_cone[1,7] <- df_cone_b[1,2]
df_cone[1,8] <- df_cone_b[1,3]

df_fb <- df_fb %>%
  full_join(df_fb_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8)
df_fb[1,7] <- df_fb_b[1,2]
df_fb[1,8] <- df_fb_b[1,3]

df_goog <- df_goog %>%
  full_join(df_goog_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8)
df_goog[1,7] <- df_goog_b[1,2]
df_goog[1,8] <- df_goog_b[1,3]

df_vz <- df_vz %>%
  full_join(df_vz_b, by="date") %>%
  dplyr::rename("close"=2, "high"=3, "low"=4, "vol"=5, "change"=6, "book"=7, 
                "outS"=8)
df_vz[1,7] <- df_vz_b[1,2]
df_vz[1,8] <- df_vz_b[1,3]

# Remove extraneous variables from our workspace
rm(df_aapl_b, df_cone_b, df_fb_b, df_goog_b, df_vz_b)

# Remove all but the change and date for df_govt since we only care about
# its change
df_govt <- df_govt %>%
  select(date, change="govt_change")

# Replace NA with last non-NA value
df_aapl$book <- na.locf(df_aapl$book, fromLast = TRUE)
df_aapl$outS <- na.locf(df_aapl$outS, fromLast = TRUE)

df_cone$book <- na.locf(df_cone$book, fromLast = TRUE)
df_cone$outS <- na.locf(df_cone$outS, fromLast = TRUE)

df_fb$book <- na.locf(df_fb$book, fromLast = TRUE)
df_fb$outS <- na.locf(df_fb$outS, fromLast = TRUE)

df_goog$book <- na.locf(df_goog$book, fromLast = TRUE)
df_goog$outS <- na.locf(df_goog$outS, fromLast = TRUE)

df_vz$book <- na.locf(df_vz$book, fromLast = TRUE)
df_vz$outS <- na.locf(df_vz$outS, fromLast = TRUE)