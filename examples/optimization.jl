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



## check if optimaztion works  

using Peccon, DataFrames,      Statistics, 
Distributions


data = fin_data(["ADAEUR","SPY"], "0VS2G38H6PKP03GX")

returns = Peccon.calc_returns(data, ["ADAEUR", "SPY"])



function exp_ret(returns)
    names_stock = names(returns)
    exp_returns = zeros(0)
    for i in names_stock
        days = size(returns)[1]
        expected_return = mean(returns[:,i])*days
        append!(exp_returns, expected_return )
    end 
    return exp_returns
end 



