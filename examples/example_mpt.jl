using Peccon, StatsPlots


#################
### real data ###
#################

Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]


data1 = data_alpha(Tickers, "0VS2G38H6PKP03GX", 248)

returns = daily_returns(data1, Tickers)


port_sim = sim_mpt(returns,5000)
@df port_sim scatter(:port_var, :exp_return)

# port_sharp = sharp_ratio(port_sim)

port_opt =  opt_mpt(returns, 0.0:0.01:2.0, 0.00)


@df port_opt scatter!(:port_var, :exp_return)

sharp_ratio(port_opt, 0.02)


#######################
### simulated data  ###
#######################


# GBM #

# Parameters
S0 = [100.0, 20.0, 50.0, 60.0]         # Initial stock price
M = [0.05, 0.07, 0.065, 0.06]           # Drift (annual rate of return)
θ = [0.2, 0.35, 0.27, 0.23]            # Volatility (annual standard deviation)
NAME = ["1", "2", "3", "4"]            #name of the stock 


T = 1.0            # Time horizon (1 year)
n = 252            # Number of time steps (trading days in a year)


returns = simulate_stocks_GBM(S0, M, θ, NAME, T, n)


port_sim = sim_mpt(returns,5000)
@df port_sim scatter(:port_var, :exp_return)

port_opt =  opt_mpt(returns, 0.0:0.01:2.0, 0.00)
@df port_opt scatter!(:port_var, :exp_return)


sharp_ratio(port_opt, 0.02)



# Heston model # 

# parameters 
# Parameters
NAME = ["stock1", "stock2", "stock3", "stock4"]
S0 = [100.0, 50.0, 20.0, 90.0]                  # Initial stock price
V0 = [0.04,0.02,0.03,0.6]                       # Initial variance (volatility squared)
M = [0.05,0.03,0.04,0.09]                       # Drift (annual rate of return)
K = [2.0, 2.0, 2.0, 2.0]                        # Rate of mean reversion
Vol = [0.04,0.01,0.02,0.7]                      # Long-term mean of the variance
VolVol = [0.2,0.005,0.01,0.03]                  # Volatility of the variance
Ρ = [-0.7, -0.5, -0.6, -0.9]                    # Correlation between the two Brownian motions
T = 1.0                                         # Time horizon (1 year)
n = 252                                         # Number of time steps (trading days in a year)

returns  = Peccon.simulate_stocks_Heston(NAME, S0, V0, M, K, Vol, VolVol, Ρ, T, n)


port_sim = sim_mpt(returns,5000)
@df port_sim scatter(:port_var, :exp_return)

port_opt =  opt_mpt(returns, 0.0:0.01:2.0, 0.00)
@df port_opt scatter!(:port_var, :exp_return)


sharp_ratio(port_opt, 0.02)




# Merton Model # 

NAME = ["stock1", "stock2", "stock3", "stock4"]
S0 = [100.0, 50.0, 20.0, 90.0]                  # Initial stock price
M = [0.05,0.03,0.04,0.09]                       # Drift (annual rate of return)
Vol = [0.2,0.02,0.03,0.6]                       # Initial variance (volatility squared)
Int = [1,.15,.23,0.6]                           # jump intensity 
M_jump = [5, 0.001, 0.0015, 0.1]                # Average jump size  
Vol_jump = [0.2, 0.05, 0.075, 0.9]              # Jump size volatility
T = 1.0                                         # Time horizon (1 year)
n = 252                                         # Number of time steps (trading days in a year)


returns = Peccon.simulate_stocks_Merton(NAME, S0, M, Vol, Int, M_jump, Vol_jump, T, n)


port_sim = sim_mpt(returns,5000)
@df port_sim scatter(:port_var, :exp_return)

port_opt =  opt_mpt(returns, 0.0:0.01:2.0, 0.00)
@df port_opt scatter!(:port_var, :exp_return)


sharp_ratio(port_opt, 0.02)