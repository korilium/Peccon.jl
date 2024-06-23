using Random, DataFrames, Peccon, StatsPlots


"""
    returns = simulate_stocks_GBM(S0, M, θ, NAME, T, n)

simulates stocks using geometric brownian motion 


#Examples
```julia-repl
julia> S0 = [100.0, 20.0, 50.0, 60.0]        # Initial stock price
julia> M = [0.05, 0.07, 0.065, 0.06]         # Drift (annual rate of return)
julia> θ = [0.2, 0.35, 0.27, 0.23]           # Volatility (annual standard deviation)
julia> NAME = ["1", "2", "3", "4"]           # name of the stock 
julia> T = 1.0                               # Time horizon (1 year)
julia> n = 252                               # Number of time steps (trading days in a year)
julia> returns = simulate_stocks_GBM(S0, M, θ, NAME, T, n)
```

"""
function simulate_stocks_GBM(S0, M, θ, NAME, T, n )
    
    dt = T/n   # Time step
    # Time vector
    time = collect(0:dt:T)

    # Generate random increments (normally distributed)
    # Random.seed!(123)  # For reproducibility

    df_tot = []
    #loop through each stock 
    for (s0, μ, σ) in zip(S0, M, θ)

        ΔW = sqrt(dt) * randn(n)

        # Preallocate stock price vector
        S = zeros(n+1)
        S[1] = s0[1]

        # Simulate the stock price path
        for t in 2:length(time)
            S[t] = S[t-1] * exp((μ[1] - 0.5*σ[1]^2)*dt + σ[1]*ΔW[t-1])          #stock process
        end

        # Create a DataFrame for better handling and plotting
        df = DataFrame(Time = time, close = S)
        push!(df_tot, df)
    end 


    return daily_returns(df_tot, NAME)
end 


### heston model 


"""
    returns  = simulate_stocks_Heston(NAME, S0, V0, M, K, Vol, VolVol, Ρ, T, n)

simulates stocks using Heston model. 


#Examples
```julia-repl
julia> NAME = ["stock1", "stock2", "stock3", "stock4"]
julia> S0 = [100.0, 50.0, 20.0, 90.0]                  # Initial stock price
julia> V0 = [0.04,0.02,0.03,0.6]                       # Initial variance (volatility squared)
julia> M = [0.05,0.03,0.04,0.09]                       # Drift (annual rate of return)
julia> K = [2.0, 2.0, 2.0, 2.0]                        # Rate of mean reversion
julia> Vol = [0.04,0.01,0.02,0.7]                      # Long-term mean of the variance
julia> VolVol = [0.2,0.005,0.01,0.03]                  # Volatility of the variance
julia> Ρ = [-0.7, -0.5, -0.6, -0.9]                    # Correlation between the two Brownian motions
julia> T = 1.0                                         # Time horizon (1 year)
julia>n = 252                                          # Number of time steps (trading days in a year)
julia> 
julia> returns  = simulate_stocks_Heston(NAME, S0, V0, M, K, Vol, VolVol, Ρ, T, n)
```
"""
function simulate_stocks_Heston(NAME, S0, V0, M, K, Vol, VolVol, Ρ, T, n)
    # Time vector
    dt = T / n
    time = collect(0:dt:T)
    df_tot = []


    for (s0, v0, μ, κ, σ, θ, ρ) in zip(S0, V0, M, K, Vol, VolVol, Ρ)

        # Generate random increments
        # Random.seed!(123) # For reproducibility
        Z1 = randn(n)
        Z2 = randn(n)
        ΔW_S = sqrt(dt) .* Z1
        ΔW_V = sqrt(dt) .* (ρ .* Z1 .+ sqrt(1 - ρ^2) .* Z2)

        # Preallocate price and variance vectors
        S = zeros(n + 1)
        V = zeros(n + 1)
        S[1] = s0
        V[1] = v0

        # Simulate the paths
        for t in 2:length(time)
            V[t] = max(V[t-1] + κ * (θ - V[t-1]) * dt + σ * sqrt(V[t-1]) * ΔW_V[t-1], 0) # variance proces
            S[t] = S[t-1] * exp((μ - 0.5 * V[t-1]) * dt + sqrt(V[t-1]) * ΔW_S[t-1])      # stock proces 
        end

        df = DataFrame(Time = time, close = S, Variance = V)
        push!(df_tot, df)

    end 

    return daily_returns(df_tot, NAME)
end 



### Merton model 

"""
    returns = simulate_stocks_Merton(NAME, S0, M, Vol, Int, M_jump, Vol_jump, T, n)

simulate stocks using Merton model. 

#Examples
```julia-repl
julia> NAME = ["stock1", "stock2", "stock3", "stock4"]
julia> S0 = [100.0, 50.0, 20.0, 90.0]                  # Initial stock price
julia> M = [0.05,0.03,0.04,0.09]                       # Drift (annual rate of return)
julia> Vol = [0.2,0.02,0.03,0.6]                       # Initial variance (volatility squared)
julia> Int = [1,.15,.23,0.6]                           # jump intensity 
julia> M_jump = [1, 0.001, 0.0015, 0.1]                # Average jump size  
julia> Vol_jump = [0.3, 0.05, 0.075, 0.9]              # Jump size volatility
julia> T = 1.0                                         # Time horizon (1 year)
julia> n = 252                                         # Number of time steps (trading days in a year)
julia> 
julia> returns = simulate_stocks_Merton(NAME, S0, M, Vol, Int, M_jump, Vol_jump, T, n)
```
"""
function simulate_stocks_Merton(NAME, S0, M, Vol, Int, M_jump, Vol_jump, T, n )
    # Time vector
    dt = T / n
    time = collect(0:dt:T)

    df_tot = []

    # Generate random increments

    for (s0, μ, σ, λ, μ_jump, σ_jump )  in zip(S0, M, Vol, Int, M_jump, Vol_jump)

        #define brownian motion and setup jump proces 
        ΔW = sqrt(dt) * randn(n)                                # brownian motion  

        k = 0.5* σ_jump^2                                       # drift component due to jump process 
        J = rand(Poisson( λ*dt), n)                             # number of jumps in timeframe 
        Z_jump = μ_jump .* rand(Normal(0,σ_jump), n)            # jump size * variance normal (zero mean)
        jumps = J .* Z_jump                                     # jumps 

        # Preallocate stock price vector
        S = zeros(n + 1)
        S[1] = s0

        # Simulate the stock price path 
        for t in 2:length(time)
            S[t] = S[t-1] * exp((Μ[1] - 0.5 * Vol[1]^2 - Int[1]*k ) * dt + σ * ΔW[t-1] + jumps[t-1]) # stock process 
        end

        df = DataFrame(Time = time, close = S)
        push!(df_tot, df)

    end 

    return daily_returns(df_tot, NAME)

end 


