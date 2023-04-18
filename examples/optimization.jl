f(x) = sin(x[1] + x[2]) + cos(x[1])^2
g(x) = [cos(x[1] + x[2]) - 2*cos(x[1])*sin(x[1]); cos(x[1] + x[2])]

f(x1,x2) = f([x1;x2])

using Plots

xs = range(-3, 1, length = 40)
ys = range(-2, 1, length = 40)

contourf(xs, ys, f, color = :jet)


function optim(f, g, x, α; max_iter=100)
    xs = zeros(length(x), max_iter+1)
    xs[:,1] = x
    for i in 1:max_iter
        x -= α*g(x)
        xs[:,i+1] = x
    end
    return xs
end


## generic nonlinear constraint optimization applied to find efficient frontier of a portfolio 


# using optimization package 
using Optimization, OptimizationMOI, OptimizationOptimJL, Ipopt
using ForwardDiff, ModelingToolkit


f(w, p) = p[1]^2*w[1]^2 +p[2]^2*w[2]^2 + p[1]*p[2]*p[3]*w[1]*w[2] - p[4]*w[1] - p[5]*w[2]

w0 = [0.5,0.5]
_p = [1.0, 2.0, 0.2, 0.08, 0.15]

cons(res, w, p) = (res .= [w[1] + w[2]])


optprob = OptimizationFunction(f, Optimization.AutoForwardDiff(), cons = cons) 
prob = OptimizationProblem(optprob, w0, _p, lcons = [ 1.0], ucons = [1.0])

sol = solve(prob, IPNewton())



using Plots

xs = range( -1, 2, length = 40)
ys = range(-1, 2, length = 40)



#example plot 

f2(w) = 1.0^2*w[1]^2 +2^2*w[2]^2 + 1.0*2.0*0.2*w[1]*w[2] - 0.08*w[1] - 0.15*w[2]
f2(x1, x2) = f2([x1; x2])

contourf(xs, ys, f2, color = :jet)



## check if optimization works  



## use same as in example but set cost function in matrix formation 

## generic nonlinear constraint optimization applied to find efficient frontier of a portfolio 


# using optimization package 
using Optimization, OptimizationMOI, OptimizationOptimJL, Ipopt
using ForwardDiff, ModelingToolkit
using Peccon, DataFrames,  Statistics, Distributions
F(w,p) = w'*p[1]*w - p[3] * p[2]'*w



Tickers = ["VOO", "BSV", "GLD"]

data1 = fin_data(Tickers, "0VS2G38H6PKP03GX", 1260)

returns = Peccon.calc_returns(data1, Tickers)

function per_ret(returns)
days = size(returns)[1]
ann_returns = mapcols(col ->  exp(sum(col))-1, returns)
    return ann_returns
end 


#setting up parameters 
## varaince 
Σ = cov(Matrix(returns))*1260
#returns 
ann_returns = collect(per_ret(returns)[1,:])
w0_size = 1/size(Tickers)[1]
w0 = repeat([w0_size],size(Tickers)[1] )
risk_aversion_1 = 0.1
_p = [Σ, ann_returns, risk_aversion_1]

# initial value of the cost function
F(w0, _p)

#constraints 
cons(res, w, p) = (res .=[w; sum(w)])

#set bounds 
nb_bounds = length(w0) +1 
divers = fill(0.00, nb_bounds-1)
lcons = append!(divers, 1.0)
ucons = fill(1.0, nb_bounds)


risk_aversion = 0.05:0.05:5
names_stock= names(returns)
opt_port = DataFrame(exp_return = Float64[],
                port_var = Float64[], 
                risk_aversion = Float64[],
                )
for i in names_stock
    opt_port[:,"weight_"*i]= Float64[]
end

for i in risk_aversion
    _p = [Σ, ann_returns, i]
    optprob = OptimizationFunction(F, Optimization.AutoForwardDiff(), cons = cons) 
    prob = OptimizationProblem(optprob, w0, _p, lcons = lcons, ucons = ucons)

    sol = solve(prob, IPNewton())

    woptimal = sol.u
    expected_return = mean(Matrix(returns)*woptimal)*1260
    Σ = cov(Matrix(returns))*1260
    var = woptimal'*Σ*woptimal
    list = [expected_return, var, i, woptimal]
    results = collect(Iterators.flatten(list))
    push!(opt_port, results)
end 

opt_port

# what needs to be returned 
## efficient frontiers 
opt_port
## sharp value 
## diversification effect based on constrains 
## days 






#check with simulation 

## simulations 
sim = sim_mpt(returns, 50000, 1260)
using StatsPlots
@df sim scatter(:port_var, :exp_return)
sharp = sharp_ratio(sim)

@df opt_port scatter!(:port_var, :exp_return)





