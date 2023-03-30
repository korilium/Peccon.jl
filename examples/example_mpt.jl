using Peccon, StatsPlots


Tickers = ["ADAEUR",  "AMZN", "ING", "VEU", "PICK"]

data= fin_data(Tickers, 250)

returns = calc_returns(data, Tickers)

port_sim = sim_mpt(returns)

@df port_sim scatter(:port_var, :exp_return)

port_opt = sharp_ratio(port_sim)

port_opt[end,:]