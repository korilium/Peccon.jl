module Peccon

#export the package functions to call them
export data_alpha, 
    daily_returns, 
    sim_mpt, 
    sharp_ratio, 
    opt_mpt, 
    per_return, 
    simulate_stocks_GBM, 
    simulate_stocks_Heston, 
    simulate_stocks_Merton

include("../src/extract.jl")
include("../src/simulate.jl")
include("../src/general.jl")
include("../src/mpt.jl")


end
