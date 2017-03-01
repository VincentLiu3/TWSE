# 證交所資料API
Taiwan Stock Exchange / OTC API

#### Data Sources
[台灣證券交易所](http://www.tse.com.tw/ch/index.php)  
[櫃買中心](http://www.tpex.org.tw/web/index.php?l=zh-tw)  
[Quantmod](https://cran.r-project.org/web/packages/quantmod/index.html)  

#### QUICK START 
> source("GetStockPrice.R")

#### GETTING DATA 抓取歷史資料
> stock = get_stock_price(uid="0050.TW", start_date="201701")

*UID Format:*  
證交所股票加".TW", e.g. "2330.TW".  
櫃買中心加".TWO", e.g. "1259.TWO".  
美股不用加, e.g. "UA".    
*Note:*  
直接從證交所及櫃買中心接收資料，改善Quantmod抓取台灣股票資料錯誤。  

#### OUTPUT FILES 輸出資料
> output_file(stock, *file_name*)

#### GETTING QUOTE 抓取及時行情
> ex_ch = get_url("0050.tw", "00632R.tw", "0056.tw")  
> get_stock_quote(ex_ch)

*UID Format:*  
證交所股票加.TW, e.g. "2330.tw".  
櫃買中心加.TWO, e.g. "1259.otc".  

#### Contact  
b01701150@ntu.edu.tw  
Updated 2017/03/01
