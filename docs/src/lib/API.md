# API

## loading in data 
```@docs
data_alpha(Tickers, clientKey,days = 250)
```
## General
### Calculating returns 
```@docs
daily_returns(portfolio, Tickers)
per_return(returns)
```

## Tools
### modern portfolio theory (mpt)
```@docs
sharp_ratio(port_sim, rf = 0.02)
sim_mpt(returns, simulations= 5000 )
opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.0 )
```