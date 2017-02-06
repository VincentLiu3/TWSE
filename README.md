# 上市上櫃股票每日收盤資訊
Taiwan Stock Exchange Stock Price API

Data Source 
證交所上市公司每日收盤成交資料 http://www.tse.com.tw/ch/trading/exchange/STOCK_DAY/STOCK_DAYMAIN.php

START 
> source("GetStockPrice.R")

GETTING DATA 抓取歷史資料
> get_stock_price(uid="0050", start_date="201701")


