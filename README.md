# 上市上櫃股票每日收盤資訊
Taiwan Stock Exchange / OTC API

Data Sources

台灣證券交易所 http://www.tse.com.tw/ch/index.php
櫃買中心 http://www.tpex.org.tw/web/index.php?l=zh-tw
Quantmod https://cran.r-project.org/web/packages/quantmod/index.html

QUICK START 
> source("GetStockPrice.R")

GETTING DATA 抓取歷史資料
> stock = get_stock_price(uid="0050.TW", start_date="201701")

UID Format:
證交所股票加.TW, e.g. "2330.TW"
櫃買中心加.TWO, e.g. "1259.TWO"
美股不用加, e.g. "UA"

OUTPUT FILES 輸出資料
> output_file(stock, "stockinfo.csv")
