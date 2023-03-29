
"""
    fin_data('ADAEUR')

extracts the daily price of a stock

"""
function fin_data(Tickers,days = 250, clientKey = "0VS2G38H6PKP03GX" )

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