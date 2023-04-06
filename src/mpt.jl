using AlphaVantage,
     DataFrames, 
     StatsPlots, 
     Dates, 
     Statistics, 
     Distributions, 
     IterTools, 
     Plots, 
     CSV

#= 
make random allocation on weights to see the trade-off between risk and return 
Next plot all possible allocation to see total impact
In the end find optimal risk return combination  
=# 

""" 
    ret_var(daily_returns)

gives back the expected return of the stock in the dataframe 
"""
function exp_ret(returns)
    names_stock = names(returns)
    exp_returns = DataFrame()
    for i in names_stock
        days = size(returns)[1]
        expected_return = mean(returns[:,i])*days
        exp_returns[:,i] = expected_return
    end 
    return exp_returns
end 

"""
    sim_opt(port_returns)

simulates random portfolio combinations and calculates the expected return and standard deviation of the portfolio


# Examples 
```julia-repl 
julia> port_returns = calc_returns(data, tickers)
julia> sim_mpt(port_returns)
```

"""
function sim_mpt(port_returns, simulations= 5000 )

    names_stock= names(port_returns)
    port = DataFrame(exp_return = Float64[],
                    port_var = Float64[]
                    )
    for i in names_stock
        port[:,"weight_"*i]= Float64[]
    end


    i = 1;

    while i <= simulations
        #set weights 
        weights = rand(size(port_returns)[2])
        total = sum(weights)

        w = weights/total
        Σ = cov(Matrix(port_returns))
        #calculate returns of the portfolio 

        expected_return = mean(port_return)*250*w

        #calculate variance of the profolio 
        σ²= 0
        for i in eachindex(w), j in eachindex(w)
            x = w[i]*w[j]*Σ[i,j]
            σ² +=x 
        end 

        port_var = (σ²*250)

        list = [expected_return, port_var, w]
        #decompose 
        results = collect(Iterators.flatten(list))

        push!(port, results )
        i += 1
    end 

    port[:,:port_std] = .√port[:,:port_var]
    return port
end 


#calculate the sharp ratio 

"""
    sharp_ratio(port_sim)

calculates the sharp ratio of each simulates portfolio 


# Examples 
```julia-repl 
julia> port_sim = sim_mpt(port_returns)
julia> sharp_ratio(port_sim) 
```
"""
function sharp_ratio(port_sim, rf = 0.02)
    port_sim[:, :sharp_ratio] = (port_sim[:,:exp_return] .- rf )./port_sim[: , :port_std]
    return sort!(port_sim, :sharp_ratio)
end 

#utility function σ² - qE(Rₚ)
function utility_mpt(port_sim, q = 0 )

    port_sim[:,:utility] = abs.(port_sim[:,:port_var] - q*port_sim[:,:exp_return])
    return sort!(port_sim,:utility)
end 

