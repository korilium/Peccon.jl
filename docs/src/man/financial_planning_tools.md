# Planning tools
## Modern Portfolio Theory (MPT) 
The modern portfolio theory (MPT) is one of the oldest applications in modern finance still used today. The technical implication can be found in the theory subsection.  We will now demonstrate how MPT is implemented in the Peccon package and lastly cover some import limitations of the tool. 
### Example 

First extract the daily price data of all the assets you are considering in your portfolio. 
```julia 
 Tickers = ["ADAEUR",  "AMZN", "ING", "VEU", "PICK"]

data= fin_data(Tickers, 250)
5-element Vector{Any}:
 250×10 DataFrame
 Row │ timestamp   open      high      low       close     adjusted_close  vol ⋯
     │ SubStrin…   Float64   Float64   Float64   Float64   Float64         Int ⋯
─────┼──────────────────────────────────────────────────────────────────────────
   1 │ 2023-03-30  0.351717  0.353378  0.345903  0.348672        0.348672   14 ⋯
   2 │ 2023-03-29  0.339719  0.359931  0.338335  0.351717        0.351717  190
   3 │ 2023-03-28  0.318954  0.34175   0.316278  0.339719        0.339719  133
  ⋮  │     ⋮          ⋮         ⋮         ⋮         ⋮            ⋮             ⋱
 249 │ 2022-07-25  0.472525  0.475663  0.437547  0.438562        0.438562  200
 250 │ 2022-07-24  0.477232  0.495413  0.470218  0.472525        0.472525  233
                                                  4 columns and 235 rows omitted
.
.
.


``` 

Then calculated the daily log returns for each assets in the portfolio. 


```julia 
returns = daily_returns(data, Tickers)
250×5 DataFrame
 Row │ ADAEUR       AMZN          ING          VEU          PICK        
     │ Float64      Float64       Float64      Float64      Float64
─────┼──────────────────────────────────────────────────────────────────
   1 │  0.0          0.0           0.0          0.0          0.0
   2 │  0.00869685  -0.0304849    -0.0197009   -0.00838579  -0.0149725
   3 │ -0.0347072    0.00819341   -0.00781593  -0.00460388  -0.0149531
  ⋮  │      ⋮            ⋮             ⋮            ⋮            ⋮
 249 │  0.0159087   -0.0288445    -0.0140781   -0.00787406  -0.00418172
 250 │  0.0745889   -0.00344503   -0.0142792   -0.0103646   -0.0246831
                                                        245 rows omitted
```

Subsequently, simulate 5000 possible portfolio combinations with the assets in the portfolio. 
```julia 
port_sim = sim_mpt(returns)
5000×8 DataFrame
  Row │ exp_return  port_var  weight_ADAEUR  weight_AMZN  weight_ING  weight_VEU  weight_PICK  port_std 
      │ Float64     Float64   Float64        Float64      Float64     Float64     Float64      Float64
──────┼─────────────────────────────────────────────────────────────────────────────────────────────────
    1 │   0.782005  0.371563      0.314956     0.187496    0.106037    0.29146      0.100051   0.60956
    2 │   0.44903   0.127016      0.204426     0.0915665   0.0956426   0.387233     0.221132   0.356393
  ⋮   │     ⋮          ⋮            ⋮             ⋮           ⋮           ⋮            ⋮          ⋮
 4999 │   1.08724   0.779559      0.29427      0.285084    0.156916    0.255411     0.0083186  0.882926
 5000 │   0.631883  0.366295      0.0328957    0.182578    0.451323    0.23108      0.102123   0.605223
                                                                                       4995 rows omitted
```

Plot the expected return and variance of each simulated portfolio to visualize the efficient frontier.  
```@example
Tickers = ["ADAEUR",  "AMZN", "ING", "VEU", "PICK"] #hide
data= fin_data(Tickers, 250) #hide 
returns = daily_returns(data, Tickers) #hide
port_sim = sim_mpt(returns)
@df port_sim scatter(:port_var, :exp_return)
```

Lastly, calculate the sharp ratio to find the portfolio with the optimal  return variation ratio 

```julia 
port_opt = sharp_ratio(port_sim)
5000×9 DataFrame
  Row │ exp_return   port_var   weight_ADAEUR  weight_AMZN  weight_ING   weight_VEU  weight_PICK  port_std  sharp_ratio 
      │ Float64      Float64    Float64        Float64      Float64      Float64     Float64      Float64   Float64
──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 0.000978628  0.0728112      0.0432636   0.00380148  0.538456      0.382372     0.0321063  0.269835  -0.0704925
    2 │ 0.0224071    0.0916218      0.0918305   0.0123358   0.671231      0.105515     0.119087   0.302691   0.00795236
  ⋮   │      ⋮           ⋮            ⋮             ⋮            ⋮           ⋮            ⋮          ⋮           ⋮
 4999 │ 0.75761      0.309236       0.412322    0.159658    0.000185982   0.097781     0.330053   0.55609    1.32642
 5000 │ 0.735419     0.290243       0.422292    0.150836    0.00973458    0.0215554    0.395581   0.538742   1.32794
                                                                                                       4995 rows omitted

julia> port_opt[end,:]
DataFrameRow
  Row │ exp_return  port_var  weight_ADAEUR  weight_AMZN  weight_ING  weight_VEU  weight_PICK  port_std  sharp_ratio 
      │ Float64     Float64   Float64        Float64      Float64     Float64     Float64      Float64   Float64
──────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────
 5000 │   0.735419  0.290243       0.422292     0.150836  0.00973458   0.0215554     0.395581  0.538742      1.32794
```

### limitations 

* based on expected values 
    * not capture the skewed distribution of risk and return , gives rise to reduced volatility and inflated growth of return 
* historical measurement 
    * future might not be the same as the past 
* risk measurement is probabilistic in nature, not structural. 
