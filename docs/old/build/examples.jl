using PlotlyJS, Plots



capital = [5000.0 ]
debt = [-10000.0]
income = [100.0]
capital_income = [100.0] 

for i in 1:40
    new_capital = capital[1] /(1.05^i)
    new_debt = debt[1] /(1.05^i)
    new_income = income[1] *(1.05^i) 
    new_capital_income = capital_income[end] + new_income
    append!(capital, new_capital)
    append!(debt, new_debt)
    append!(capital_income, new_capital_income)
end 


total_capital = capital + debt + capital_income

plot(capital ,label="initial capital", fill=true, fillalpha= 0.3,formatter=:plain )


plot!(debt, label="debt",  fill=true, fillalpha= 0.3 )
plot!(capital_income, label="capital from income")
plot!(total_capital, label="wealth")


Plots.savefig("docs/build/images/plot_inflation_explained")