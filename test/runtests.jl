using Peccon
using Test, 
    CSV, 
    DataFrames

const dir = joinpath(dirname(pathof(Peccon)), "..", "test", "test_data")

### create some test to check if the functions work properly 


# load in test data 
Tickers = ["VOO", "BSV", "GLD"]
data1 = fin_data(Tickers, "0VS2G38H6PKP03GX", 1260)




@testset "general" begin 
    returns = daily_returns(data1, Tickers)

    ##### checks for daily_returns  #####
    # check for missing values 
    @test any(ismissing.(eachrow(returns))) == false
    # check for unreasonable  outliers
    @test returns[partialsortperm(returns.VOO, 1:1, rev=true),:VOO][1] < 0.5
    @test returns[partialsortperm(returns.VOO, 1:1, rev=true),:BSV][1] < 0.5
    @test returns[partialsortperm(returns.VOO, 1:1, rev=true),:GLD][1] < 0.5
end 


@testset "mpt" begin
    returns = daily_returns(data1, Tickers)
    sim_port = sim_mpt(returns)

    ##### check for sim_mpt ##### 
    # check whether the weights sum to one 
    @test all(sum(eachcol(select(sim_port, r"weight"))) .≈ 1)
    #check whether the standard deviation is not negative 
    @test all(sim_port.port_std .> 0)
    # @df sim_port scatter(:port_std, :exp_return)


    sharp = sharp_ratio(sim_port, 0.02)

    ##### sharp_ratio ##### +
    # # check if it is the largest sharp ratio 
    @test all(sharp[end,:sharp_ratio] .≥ sharp[:,:sharp_ratio])
    # # check if the best sharp ratio has indeed the highest return for the lowest variance 
    @test all(sharp[end,:exp_return] .>  sharp[sharp[end,:port_std] .> sharp[:,:port_std], :exp_return])
end

