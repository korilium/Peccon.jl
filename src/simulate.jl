using Random, DataFrames, Peccon




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
    for (s0, μ, σ, name ) in zip(S0, M, θ, NAME)

        ΔW = sqrt(dt) * randn(n)

        # Preallocate stock price vector
        S = zeros(n+1)
        S[1] = s0[1]

        # Simulate the stock price path
        for t in 2:length(time)
            S[t] = S[t-1] * exp((μ[1] - 0.5*σ[1]^2)*dt + σ[1]*ΔW[t-1])
        end

        # Create a DataFrame for better handling and plotting
        df = DataFrame(Time = time, close = S)
        push!(df_tot, df)
    end 


    return daily_returns(df_tot, NAME)
end 

