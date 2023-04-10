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

gives back the expected return and variance of the stock in the dataframe 
"""
function exp_ret(returns)
    names_stock = names(port_stock)
    exp_returns = DataFrame()
    for i in names_stock
        days = size(returns)[1]
        expected_return = mean(returns[:,i])*days
        exp_returns[:,i] = expected_return
    end 
    return
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
function sim_mpt(port_returns, simulations= 5000, days=252 )

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
        port_return = Matrix(port_returns)*w

        expected_return = mean(port_return)*days

        #calculate variance of the profolio 
        σ²= 0
        for i in eachindex(w), j in eachindex(w)
            x = w[i]*w[j]*Σ[i,j]
            σ² +=x 
        end 

        port_var = (σ²*days)

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











using Optimization,  OptimizationOptimJL






function opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.05 )


    # cost function 
    F(w,p) = w'*p[1]*w - p[3] * p[2]'*w
    #constraints 
    cons(res, w, p) = (res .=[w; sum(w)])


        #setting up parameters
    #variance  
    Σ = cov(Matrix(returns))*1260
    #stock returns 
    per_returns = collect(per_ret(returns)[1,:])
    #intial weights 
    w0_size = 1/size(Tickers)[1]
    w0 = repeat([w0_size],size(Tickers)[1] )



    #set bounds 
    nb_bounds = length(w0) +1 
    divers = fill(diversification_limit, nb_bounds-1)
    lcons = append!(divers, 1.0)
    ucons = fill(1.0, nb_bounds)






    #create dataframe 
    names_stock= names(returns)
    opt_port = DataFrame(exp_return = Float64[],
                    port_var = Float64[], 
                    risk_aversion = Float64[],
                    )
    for i in names_stock
        opt_port[:,"weight_"*i]= Float64[]
    end



    for i in risk_av_step 
        _p = [Σ, per_returns, i]
        optprob = OptimizationFunction(F, Optimization.AutoForwardDiff(), cons = cons) 
        prob = OptimizationProblem(optprob, w0, _p, lcons = lcons, ucons = ucons)

        sol = solve(prob, IPNewton())

        woptimal = sol.u
        expected_return = mean(Matrix(returns)*woptimal)*1260
        Σ = cov(Matrix(returns))*1260
        var = woptimal'*Σ*woptimal
        list = [expected_return, var, i, woptimal]
        results = collect(Iterators.flatten(list))
        push!(opt_port, results)
    end 
    return opt_port
end 





