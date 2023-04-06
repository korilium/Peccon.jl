# API

## loading in data 
```@docs
fin_data(Tickers, clientKey,days = 250)
```
## calculating returns 
```@docs
calc_returns(portfolio, Tickers)
```
## modern portfolio theory
```@docs
sharp_ratio(port_sim, rf = 0.02)
sim_mpt(port_returns, simulations= 5000 )
```