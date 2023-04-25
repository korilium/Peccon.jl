using MarketData




# function data_yahoo()


# #parameters 
# start_per = DateTime(2021,1,1)
# end_per = DateTime(2023,1,1)
# int = "1d"

# portfolio = [] 
# test = yahoo("IUSA", YahooOpt(period1 = start_per, period2= end_per, interval=int ))



# for i in Tickers 
#     yahoo(i, YahooOpt(period1 = start_per, period2= end_per, interval=int ))
# end 


"""
    fin_data(Tickers)

extracts the daily price info of multiple stocks from alphavantage and puts them in a vector of dataframes. 

# Examples 
```julia-repl 
julia> fin_data(["ADAEUR", "SPY"])
```

"""
function data_alpha(Tickers,clientKey, days = 248 )

    #extract the data 
    client = AlphaVantage.GLOBAL[]
    client.key = clientKey
    AlphaVantage.GLOBAL[]
    portfolio = []
    days= days
    for i in Tickers 
        asset = DataFrame(time_series_daily_adjusted( i, outputsize= "full"))
        asset = asset[1:days,:]
        asset[!,"ticker"] .= i 
        push!(portfolio, asset)
    end 
    return portfolio
end 