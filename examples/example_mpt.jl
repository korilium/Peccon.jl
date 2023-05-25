using Peccon, StatsPlots, Statistics, Distributions, IterTools, Plots

Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]


data = data_alpha(Tickers, "0VS2G38H6PKP03GX", 1008)

stock_price = data[1][:, :close]

X = [float(1)]
for (i, j) in partition(stock_price, 2,1)
    x = float(i/j)
    append!(X,x )
end

histogram(X)


fit_mle(Normal, X)
fit_mle(LogNormal, X)


Y = rand(Normal( 1.0003283948,0.0113292031), 1007)

Z = rand(LogNormal(0.0002637643, 0.01139101567), 1007)

histogram(Y)
histogram(Z)
qqplot(X,Y)
qqplot!(X,Z)



returns = daily_returns(data, Tickers)




port_sim = sim_mpt(returns,5000,)
@df port_sim scatter(:port_var, :exp_return, 
                    title= "Portfolios return variance tradeoff", 
                    label= "simulated",
                    xlabel="variance", 
                    ylabel="return")

# port_sharp = sharp_ratio(port_sim)

port_opt =  opt_mpt(returns, 0.0:0.02:2.0, 0.00)


@df port_opt scatter!(:port_var, :exp_return, label="optimized")

sharp_ratio(port_opt, 0.02)



