using Peccon
using Test, CSV



### create some test to check if the functions work properly 
@testset "Peccon.jl" begin
    # load in test data 
    test_ada = DataFrame(CSV.File("test/test_data/ADAEUR.csv"))
    test_spy = DataFrame(CSV.File("test/test_data/SPY.csv"))
    test_dis = DataFrame(CSV.File("test/test_data/DIS.csv"))
    test_port  = [test_ada, test_spy, test_dis]
    tickers = ["ADAEUR", "SPY", "DIS"]

    ##### checks for calc_returns  #####
    returns_port = Peccon.calc_returns(test_port,tickers )

    # check for missing values 
    @test any(ismissing.(eachrow(returns_port))) == false
    # check for unreasonable  outliers
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:ADAEUR][1] < 0.5
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:SPY][1] < 0.5
    @test returns_port[partialsortperm(returns_port.ADAEUR, 1:1, rev=true),:DIS][1] < 0.5


    ##### check for sim_mpt ##### 
    sim_port = Peccon.sim_mpt(returns_port)

    # check whether the weights sum to one 
    @test all(sum(eachcol(select(sim_port, r"weight"))) .≈ 1)
    #check whether the standard deviation is not negative 
    @test all(sim_port.port_std .> 0)
    # @df sim_port scatter(:port_std, :exp_return)

    ##### sharp_ratio ##### 
    sharp = Peccon.sharp_ratio(sim_port, 0.02)
    # check if it is the largest sharp ratio 
    @test all(sharp[end,:sharp_ratio] .≥ sharp[:,:sharp_ratio])
    # check if the best sharp ratio has indeed the highest return for the lowest variance 
    @test all(sharp[end,:exp_return] .>  sharp[sharp[end,:port_std] .> sharp[:,:port_std], :exp_return])
end



