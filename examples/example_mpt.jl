using Peccon, StatsPlots

Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]


data1 = data_alpha(Tickers, "0VS2G38H6PKP03GX", 248)

returns = daily_returns(data1, Tickers)


port_sim = sim_mpt(returns,5000)
@df port_sim scatter(:port_var, :exp_return)

# port_sharp = sharp_ratio(port_sim)

port_opt =  opt_mpt(returns, 0.0:0.02:2.0, 0.00)


@df port_opt scatter!(:port_var, :exp_return)

sharp_ratio(port_opt, 0.02)



