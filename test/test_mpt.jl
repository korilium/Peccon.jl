include("../src/extract.jl")
include("../src/general.jl")
include("../src/mpt.jl")

tickers = ["ADAEUR", "SPY", "DIS"]
data = fin_data(tickers, 250)


CSV.write("test/test_data/portfolio", data )

returns_port = calc_returns(data,tickers )



sim_port = sim_mpt(returns_port)

@df sim_port scatter(:port_std, :exp_return)

sharp_ration(sim_port, 0.02)

