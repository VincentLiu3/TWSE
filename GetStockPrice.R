library("httr")
library("RCurl")
library("XML")
library('stringr')
library('quantmod')
library('jsonlite')  

get_stock = function(uid, start_date = "20100101")
{
  if(length(grep(".TWO", uid))>0)
  {
    uid = gsub(".TWO", "", uid)
    
    start_year = as.numeric(substr(start_date, 1, 4)) - 1911
    start_month = as.numeric(substr(start_date, 5, 6))
    end_year = as.numeric(format(Sys.Date(), "%Y")) - 1911
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
        url = paste("http://www.tpex.org.tw/web/stock/aftertrading/daily_trading_info/st43_result.php?l=zh-tw&d=",year,"/",month,"&stkno=",uid,"&_=1486100183545", sep="")
        req = GET(url, encoding='utf8')
        json_file = content(req, 'text', encoding = 'utf8')
        json_file = fromJSON(json_file)
        stock = data.frame(json_file$aaData) 
        if(ncol(stock) == 9)
          stock.all = rbind(stock.all, stock)
      }
    }
    names(stock.all) = c("TDate","Volume","Turnover_value","Open","High","Low","Close","Change","Turnover_num")
    stock.all = stock.all[,c("TDate","Open","High","Low","Close","Volume")]
    
    for(i in c("Open","High","Low","Close","Volume"))
      stock.all[,i] = as.numeric(gsub("[,]","",stock.all[,i]))
    
    stock.all$TDate = gsub("＊", "", stock.all$TDate)
    stock.all$TDate = sapply(1:nrow(stock.all), function(x){
      temp = str_split(stock.all$TDate[x],"/")[[1]]
      paste(as.numeric(temp[1])+1911, temp[2], temp[3],sep="-") 
    })
    stock.all$TDate = as.Date(stock.all$TDate)
    stock.all = xts(stock.all[,-1], order.by=stock.all[,1])
    return(stock.all)
  }
  else if(length(grep(".TW", uid))>0)
  {
    url = "http://www.tse.com.tw/ch/trading/exchange/STOCK_DAY/STOCK_DAYMAIN.php"
    uid = gsub(".TW", "", uid)
  
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
    stock.all = stock.all[,c("TDate","Open","High","Low","Close","Volume")]
    
    for(i in c("Open","High","Low","Close","Volume"))
      stock.all[,i] = as.numeric(gsub("[,]","",stock.all[,i]))
    
    stock.all$TDate = sapply(1:nrow(stock.all), function(x){
      temp = str_split(stock.all$TDate[x],"/")[[1]]
      paste(as.numeric(temp[1])+1911, temp[2], temp[3],sep="-") 
    })
    stock.all$TDate = as.Date(stock.all$TDate)
    stock.all = xts(stock.all[,-1], order.by=stock.all[,1])
    return(stock.all)
  }
  else
  {
    stock.all = getSymbols(uid, auto.assign=F)
    names(stock.all) = c("Open", "High", "Low", "Close", "Volume", "AdjPx")
    
    start_year = as.numeric(substr(start_date, 1, 4))
    end_year = as.numeric(format(Sys.Date(), "%Y"))
    year = paste(as.character(start_year), as.character(end_year), sep = "::")
    return( stock.all[year])
  }
}

output_file = function(stock, file_path)
{
  write.zoo(stock, file_path, sep = ",")
}
