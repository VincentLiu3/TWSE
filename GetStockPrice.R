library("httr")
require("RCurl")
library("XML")
library('stringr')

url = "http://www.tse.com.tw/ch/trading/exchange/STOCK_DAY/STOCK_DAYMAIN.php"

get_stock_price = function(uid, start_date)
{
  start_year = as.numeric(substr(start_date, 1, 4))
  start_month = as.numeric(substr(start_date, 5, 6))
  end_year = as.numeric(format(Sys.Date(), "%Y"))
  end_month = as.numeric(format(Sys.Date(), "%m"))
  
  stock.all = NULL
  for(year in start_year:end_year)
  {
    if(year == start_year)
      month.list = start_month:12
    else if(year == end_year)
      month.list = 1:end_month
    else
      month.list = 1:12
    
    for(month in month.list)
    {
      result <- postForm(url,
                         download="html",
                         query_year=year,
                         query_month=month,
                         CO_ID=uid,
                         style="post")
      
      result = htmlParse(result, encoding = 'utf8')
      dd = xpathSApply(result, '//tbody/tr/td', xmlValue)
      if(length(dd)!=1 && dd!="查無資料！")
      {
        stock = matrix(dd, ncol = 9, byrow = T)
        stock = data.frame(stock)
        stock.all = rbind(stock.all, stock)
      }
    }
  }
  names(stock.all) = c("TDate","Volume","Turnover_value","Open","High","Low","Close","Change","Turnover_num")
  # Volume=成交股數;Turnover_value=成交金額;Turnover_num=成交筆數
  
  stock.all = stock.all[,c(1:7,9)]
  
  for(i in c(2:8))
    stock.all[,i] = as.numeric(gsub("[,]","",stock.all[,i]))
  
  stock.all$TDate = sapply(1:nrow(stock.all), function(x){
    temp = str_split(stock.all$TDate[x],"/")[[1]]
    paste(as.numeric(temp[1])+1911, temp[2], temp[3],sep="-") 
  })
  stock.all$TDate = as.Date(stock.all$TDate)
  
  return(stock.all)
}
