module Peccon

#export the package functions 
export fin_data, 
    daily_returns, 
    sim_mpt, 
    sharp_ratio, 
    opt_mpt, 
    per_ret

include("../src/extract.jl")
include("../src/general.jl")
include("../src/mpt.jl")

end
