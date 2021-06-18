message("I'm in job")

library(quantmod)
library(purrr)

EFTS <- c("ARKK", "CNRG", "CXSE", "ESGV", "ESPO", "FTEC", "QQQ", "SMH", "VT")

efts_data <- map(EFTS, function(x){
  
  message(x)
  
  getSymbols(x, auto.assign = FALSE, from = lubridate::ymd(20180101))
  
})

hc <- highcharter::highchart(type = "stock")
hc <- highcharter::hc_tooltip(hc, valueDecimals = 2)
hc <- highcharter::hc_credits(hc, text = paste("Updated on: ", Sys.time()), enabled = TRUE)
hc <- highcharter::hc_yAxis_multiples(hc, highcharter::create_yaxis(naxis = 2))

hc <- reduce(efts_data, highcharter::hc_add_series, .init = hc, yAxis = 0)
hc <- reduce(efts_data, highcharter::hc_add_series, .init = hc, yAxis = 1, type = "line")

hc

saveRDS(hc, here::here("data-raw/hc.rds"))

rmarkdown::render(here::here("docs/index.Rmd"))
