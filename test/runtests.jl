using Peccon
using Test, 
    CSV, 
    DataFrames

# const dir = joinpath(dirname(pathof(Peccon)), "..", "test", "test_data")

### create some test to check if the functions work properly 


# load in test data 
Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]
data1 = data_alpha(Tickers, "0VS2G38H6PKP03GX", 1260)
returns = daily_returns(data1, Tickers)
period_returns = per_return(returns)



@testset "general" begin 

    ##### checks for daily_returns  #####
    # check for missing values 
    @test any(ismissing.(eachrow(returns))) == false
    # check for unreasonable  outliers
    @test returns[partialsortperm(returns[:,"IUSA.AS"], 1:1, rev=true),"IUSA.AS"][1] < 0.5
    @test returns[partialsortperm(returns[:,"IBCI.AS"], 1:1, rev=true),"IBCI.AS"][1] < 0.5
    @test returns[partialsortperm(returns[:,"IEMA.AS"], 1:1, rev=true),"IEMA.AS"][1] < 0.5
    @test returns[partialsortperm(returns[:,"WTCH.AS"], 1:1, rev=true),"WTCH.AS"][1] < 0.5
    @test returns[partialsortperm(returns[:,"VWRL.AS"], 1:1, rev=true),"VWRL.AS"][1] < 0.5

    # test whether the peiod return is greater then the daily return (this is the case if taken over long period)
    @test period_returns[:,"IUSA.AS"][1] > returns[1,"IUSA.AS"]

end 


@testset "mpt" begin
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


    opt_port =  opt_mpt(returns, 0.0:0.02:2.0, 0.00)

    ##### opt_mpt #####
    @testset "efficient frontier"  for x in eachrow(opt_port)
        filter = x[:port_var].> sim_port[:,:port_var]  # filter on varaince, take no simulation with higher variance 
        sel_port = sim_port[filter,[:exp_return, :port_var]] 
        #round to three digits after comma as the 
        sel_port[:,:exp_return] = round.(sel_port[:, :exp_return], digits = 3 )
        @test all(x[:exp_return] .> sel_port[:,:exp_return])
    end
end



