using MarketData




# function data_yahoo() to be developed



"""
    data_alpha(Tickers)

extracts the daily price info of multiple stocks from alphavantage and puts them in a vector of dataframes. 

# Examples 
```julia-repl 
julia> data_alpha(["ADAEUR", "SPY"])
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
        asset = DataFrame(time_series_daily( i, outputsize= "full"))
        asset = asset[1:days,:]
        asset[!,"ticker"] .= i 
        push!(portfolio, asset)
    end 
    return portfolio
end 