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
     OptimizationOptimJL, 
     LinearAlgebra

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
    days = size(returns, 1)
    names_stock= names(returns)
    n_stocks = size(returns, 2)
    port = DataFrame(exp_return = Float64[],
                    port_var = Float64[], 
                    port_std = Float64[]
                    )
    for i in names_stock
        port[:,"weight_"*i]= Float64[]
    end

    i = 1;
    Σ = cov(Matrix(returns))
    while i <= simulations
        #set weights 
        weights = rand(n_stocks)
        total = sum(weights)
        w = weights/total

        #calculate returns of the portfolio 
        stock_return = Matrix(returns)*w
        expected_return = mean(stock_return)*days
        #old way of calculate variance of the profolio 
        # σ²= 0
        # for i in eachindex(w), j in eachindex(w)
        #     x = w[i]*w[j]*Σ[i,j]
        #     σ² +=x 
        # end 

        σ² = sum(w[i] * w[j] * Σ[i, j] for i in eachindex(w), j in eachindex(w))
        port_var = σ²*days

        push!(port, [expected_return, port_var, sqrt(port_var), w...])
        i += 1
    end 

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
function opt_mpt(returns::DataFrame, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.0   )

    # cost function 
    F(w,p) = w'*p[1]*w - p[3] * p[2]'*w
    #constraints 
    cons(res, w, p) = (res .=[w; sum(w)])

    #setting up parameters
    #days 
    days= size(returns)[1]
    #variance and mean returns 
    Σ = cov(Matrix(returns))*days
    per_returns = mean(Matrix(returns), dims=1)[:]*days
    #initial weights 
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
        expected_return = dot(per_returns, woptimal)
        var = woptimal'*Σ*woptimal
        list = [expected_return, var, i, woptimal]
        results = collect(Iterators.flatten(list))
        push!(opt_port, results)
    end 
    opt_port[:,:port_std] = sqrt.(opt_port[:,:port_var])
    return opt_port
end 





