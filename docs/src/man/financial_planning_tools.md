# Planning tools
## Modern Portfolio Theory (MPT) 
The modern portfolio theory (MPT) is one of the oldest applications in modern finance still used today. The technical implication can be found in the theory subsection.  We will now demonstrate how MPT is implemented in the Peccon package and lastly cover some import limitations and recommendations of the tool. 
### Example 

First extract the daily price data of all the assets you are considering in your portfolio. 
```@example mpt
using Peccon
Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]; 
# data = data_alpha(Tickers, "your_api_key", 252);
data= data_alpha(Tickers, "0VS2G38H6PKP03GX", 248); # hide
data[1][1:10,:]

``` 

Then calculated the daily log returns for each asset in the portfolio. 


```@example mpt
Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]; # hide
data= data_alpha(Tickers, "0VS2G38H6PKP03GX", 252); # hide
returns = daily_returns(data, Tickers);
returns[1:10,:]
```

Subsequently, simulate 5000 possible portfolio combinations with the assets in the portfolio. 
```@example mpt 
port_sim = sim_mpt(returns);
port_sim[1:10,:]

```

Plot the expected return and variance of each simulated portfolio to visualize the efficient frontier.  
```@example mpt 
using Peccon,Pkg; # hide
Pkg.add("StatsPlots"); # hide
using StatsPlots; # hide 
@df port_sim scatter(:port_var, :exp_return)
savefig("sim_fig.svg"); nothing # hide 
``` 
![](sim_fig.svg)

calculate the efficient frontier of the combinations of stocks. 

```@example mpt
port_opt = opt_mpt(returns, 0.0:0.02:2.0, 0.00) ; 
port_opt
```
In the dataframe the optimal portfolios with their respective risk-aversions are shown. 


subsequently, add the efficient frontier to the simulated plot. 

```@example mpt
@df port_opt scatter!(:port_var, :exp_return)
savefig("opt_fig.svg"); # hide 
``` 
![](opt_fig.svg)

Lastly, calculate the sharp ratio to find the portfolio with the optimal  return variation ratio 

```@example mpt 
port_sim_sharp = sharp_ratio(port_sim) ; 
@show port_sim_sharp[end,:]
port_opt_sharp = sharp_ratio(port_sim) ; 
port_opt_sharp[end,:]


```

### limitations 

There are three main limitation to this tool. The first limitation is that the MPT is a historical measurement of the portfolio performance. It does not say anything about future performance of the portfolio. Different Macro-economic situations might lead to total different end results. The second issue is that the tool is based on the expected return and variance of the portfolio. This captures the risk return relationship quite well but it does not take into account [skewness](https://en.wikipedia.org/wiki/Skewness) and [tail risk](https://en.wikipedia.org/wiki/Tail_risk). It therefore gives rise to a reduced volatility and an inflated growth rate for a portfolio. Lastly, the risk measurement is probabilistic in nature. It does not reflect the structural roots of the risk. For example, the risk of a stock are off a total different nature then that of a commodity, but to tool will still account for them the same way. 


### Recommended usage
Never use this tool for individual stock picking and never but then also never rely *only* on the MPT. Always do your own due diligence before creating your portfolio and again this is no way or form financial advice. 

So why should you use this tool and for what purpose? It is highly recommended to use this tool with exchange traded funds (ETF) as these products are already substantially diversified and issue two of the MPT is therefore greatly diminished. Also, the structural risk that certain ETF are exposed is difficult the estimate and the MPT can help you gain insights into which ETF have less or more risk compared to the returns they offer. Lastly, MPT also works better if you invest in all assets classes as each class has risks of a different nature and you are then therefore not fully exposed to one particular kind of risk. 

To know which portfolio weights you should apply, you have to understand your risk preference. If you do not want to take a lot of risk, it is beneficial to look at optimal portfolio's with low values in $P$. The reverse is true for people who are risk seeking. 
