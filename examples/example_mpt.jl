using Peccon, StatsPlots, AlphaVantage, DataFrames


Tickers = ["IUSA",  "IEMA", "WTCH", "VWRL"]

data1 = fin_data(Tickers, "0VS2G38H6PKP03GX", 240)

returns = daily_returns(data1, Tickers)
port_sim = sim_mpt(returns,5000,1260)

@df port_sim scatter(:port_var, :exp_return)

# port_sharp = sharp_ratio(port_sim)

port_opt =  opt_mpt(returns, 0.0:0.02:2.0, 0.00 )

@df port_opt scatter!(:port_var, :exp_return)


sharp = sharp_ratio(port_sim)


all(sharp[end,:exp_return] .>  sharp[sharp[end,:port_std] .> sharp[:,:port_std], :exp_return])

@df test scatter!(:port_var, :exp_return)


df = time_series_daily_adjusted( "VWRL", outputsize= "full")