
function calc_returns(portfolio, Tickers)
    #calculate returns for each stock 
    for x in portfolio 
        price = x[!,"close"]
        returns = zeros(0)

        for i=2:length(price) 
            r = log(price[i]/price[i-1])
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