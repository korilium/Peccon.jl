using AlphaVantage,
     DataFrames, 
     StatsPlots, 
     Dates, 
     Statistics, 
     Distributions, 
     IterTools, 
     Plots, 
     CSV,
     Optimization, 
     OptimizationOptimJL

#= 
make random allocation on weights to see the trade-off between risk and return 
Next plot all possible allocation to see total impact
In the end find optimal risk return combination  
=# 

"""
    sim_opt(returns, simulations= 5000, days=252)

simulates random portfolio combinations and calculates the expected return and standard deviation of the portfolio


# Examples 
```julia-repl 
julia> returns = daily_returns(data, tickers)
julia> sim_mpt(returns)
```

"""
function sim_mpt(returns, simulations= 5000 )
    days = size(returns)[1]
    names_stock= names(returns)
    port = DataFrame(exp_return = Float64[],
                    port_var = Float64[]
                    )
    for i in names_stock
        port[:,"weight_"*i]= Float64[]
    end


    i = 1;

    while i <= simulations
        #set weights 
        weights = rand(size(returns)[2])
        total = sum(weights)

        w = weights/total
        Σ = cov(Matrix(returns))
        #calculate returns of the portfolio 
        stock_return = Matrix(returns)*w

        expected_return = mean(stock_return)*days

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
julia> port_sim = sim_mpt(stock_returns)
julia> sharp_ratio(port_sim) 
```
"""
function sharp_ratio(port, rf = 0.02)
    port[:, :sharp_ratio] = (port[:,:exp_return] .- rf )./port[: , :port_std]
    return sort!(port, :sharp_ratio)
end 


"""
    opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.05)

returns the efficient frontier for a portfolio. 

# Examples 
```julia-repl 
julia> port_opt = opt_mpt(returns)
```
"""
function opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.05 )

    # cost function 
    F(w,p) = w'*p[1]*w - p[3] * p[2]'*w
    #constraints 
    cons(res, w, p) = (res .=[w; sum(w)])

    #setting up parameters
    #variance  
    Σ = cov(Matrix(returns))*1260
    #stock returns 
    per_returns = collect(per_return(returns)[1,:])
    #intial weights 
    w0_size = 1/size(returns)[2]
    w0 = repeat([w0_size],size(returns)[2] )


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





