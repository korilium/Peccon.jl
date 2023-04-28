""" 
    daily_returns(portfolio, Tickers)

calculates the daily log returns of each stock in a portfolio based on the close price of the day. 

# Examples 
```julia-repl 
julia> tickers = ["ADAEUR", "SPY"]
julia> data = fin_data(tickers)
julia> calc_returns(data, tickers)
```

"""
function daily_returns(portfolio, Tickers)
    #calculate returns for each stock 
    for x in portfolio 
        price = x[!,"adjusted_close"]
        returns = zeros(0)

        for i=1:(length(price)-1)
            r = log(price[i]/price[i+1])
            append!(returns, r)
        end 
        #add null in the beginning of each column 
        prepend!(returns, 0) 
        x[!,"returns"] = returns # add to dataframe
    end

    #add all returns into one dataset 
    port_returns = DataFrame()
    for (x,y) in zip(portfolio, Tickers)
        port_returns[!,y] = x[!,"returns"]
    end 
    return port_returns
end 



#per returns 


"""
    per_return(returns)

calculates the compounded return for a specific time-period from daily log returns 


    # Examples 
```julia-repl
julia> tickers = ["ADAEUR", "SPY"]
julia> data = fin_data(tickers)
julia> calc_returns(data, tickers)
julia> data_alpha(["ADAEUR", "SPY"])
```
"""
function per_return(returns)
    days = size(returns)[1]
    ann_returns = mapcols(col ->  exp(sum(col))-1, returns)
        return ann_returns
    end 