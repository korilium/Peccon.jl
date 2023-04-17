# API

## loading in data 
```@docs
fin_data(Tickers, clientKey,days = 250)
```
## General
### Calculating returns 
```@docs
daily_returns(portfolio, Tickers)
per_return(returns)
```
## modern portfolio theory
```@docs
sharp_ratio(port_sim, rf = 0.02)
sim_mpt(returns, simulations= 5000 )
opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.05 )
```