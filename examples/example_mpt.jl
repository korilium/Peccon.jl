using Peccon, StatsPlots, Statistics, Distributions, IterTools, Plots, DataFrames

Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]



@time begin
data = data_alpha(Tickers, "0VS2G38H6PKP03GX", 1008)
end 


returns = daily_returns(data, Tickers)

@time  begin 
port_sim = sim_mpt(returns,5000,)
end 
@time begin 
@df port_sim scatter(:port_var, :exp_return, 
                    title= "Portfolios return variance tradeoff", 
                    label= "simulated",
                    xlabel="variance", 
                    ylabel="return")
end 
# port_sharp = sharp_ratio(port_sim)

@time begin 
port_opt =  opt_mpt(returns, 0.0:0.02:2.0, 0.00)
end 

@df port_opt scatter!(:port_var, :exp_return, label="optimized")

sharp_ratio(port_opt, 0.02)






# tests 



days = size(returns, 1)
names_stock= names(returns)
n_stocks = size(returns, 2)
port = DataFrame(exp_return = Float64[],
                port_var = Float64[], 
                port_std = Float64[]
                )
    for i in names_stock
        port[:,"weight_"*i]= Float64[]
    end


    i = 1;
    Σ = cov(Matrix(returns))
    while i <= simulations
        #set weights 
        weights = rand(n_stocks)
        total = sum(weights)
        w = weights/total
        
        #calculate returns of the portfolio 
        stock_return = Matrix(returns)*w

        expected_return = mean(stock_return)*days

        #calculate variance of the profolio 
        σ²= 0
        for i in eachindex(w), j in eachindex(w)
            x = w[i]*w[j]*Σ[i,j]
            σ² +=x 
        end 

        port_var = (σ²*days)

        list = [expected_return, port_var, w]
        #decompose 
        results = collect(Iterators.flatten(list))

        push!(port, results )
        i += 1
    end 


#set weights 
weights = rand(n_stocks)
total = sum(weights)
w = weights/total

#calculate returns of the portfolio 
stock_return = Matrix(returns)*w

expected_return = mean(stock_return)*days

#calculate variance of the profolio 
σ²= 0
for i in eachindex(w), j in eachindex(w)
    x = w[i]*w[j]*Σ[i,j]
    σ² +=x 
end 

σ_test = sum(w[i] * w[j] * Σ[i, j] for i in eachindex(w), j in eachindex(w))
σ² 
port_var = (σ²*days)

push!(port, [expected_return, port_var, sqrt(port_var), w...])
i += 1















    port[:,:port_std] = .√port[:,:port_var]
    return port
