using Peccon
using Test

@testset "Peccon.jl" begin
### create some test to check if the functions work properly 
    test_data = DataFrame(CSV.File("test/test_data/portfolio"))
    tickers = ["ADAEUR", "SPY", "DIS"]


    ## checks for calc_returns 
    returns_port = calc_returns(data,tickers )
    # check for missing values 
    @test any(ismissing.(eachrow(returns_port))) == false
    # check for outliers
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:ADAEUR][1] < 0.5
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:SPY][1] < 0.5
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:DIS][1] < 0.5


    ## check for sim_mpt
    sim_port = sim_mpt(returns_port)

    # @df sim_port scatter(:port_std, :exp_return)

    # sharp_ration(sim_port, 0.02)
end

sim_port = sim_mpt(returns_port)
