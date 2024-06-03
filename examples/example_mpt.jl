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

