# TWSE-Stock-Price
Taiwan Stock Exchange Stock Price API

INTRODUCTION
If you use yahoo's API to get stock prices of TWSE (e.g. quantmod), you probably will get the wrong data. This .R program can help you get the correct stock price and volumn.

GETTING DATA
> source("GetStockPrice.R")

> get_stock_price(uid="0050", start_date="201701")


