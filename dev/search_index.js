var documenterSearchIndex = {"docs":
[{"location":"man/glossary.html#Glossary","page":"glossary","title":"Glossary","text":"","category":"section"},{"location":"man/glossary.html","page":"glossary","title":"glossary","text":"The glossary is intented to give you an overview of all the financial jargon needed to understand the financial planning tools. ","category":"page"},{"location":"man/glossary.html#Exchange-traded-fund","page":"glossary","title":"Exchange traded fund","text":"","category":"section"},{"location":"man/glossary.html#stock","page":"glossary","title":"stock","text":"","category":"section"},{"location":"man/glossary.html#asset-class","page":"glossary","title":"asset class","text":"","category":"section"},{"location":"lib/API.html#API","page":"API","title":"API","text":"","category":"section"},{"location":"lib/API.html#loading-in-data","page":"API","title":"loading in data","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"data_alpha(Tickers, clientKey,days = 250)","category":"page"},{"location":"lib/API.html#Peccon.data_alpha","page":"API","title":"Peccon.data_alpha","text":"data_alpha(Tickers)\n\nextracts the daily price info of multiple stocks from alphavantage and puts them in a vector of dataframes. \n\nExamples\n\njulia> data_alpha([\"ADAEUR\", \"SPY\"])\n\n\n\n\n\n","category":"function"},{"location":"lib/API.html#General","page":"API","title":"General","text":"","category":"section"},{"location":"lib/API.html#Calculating-returns","page":"API","title":"Calculating returns","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"daily_returns(portfolio, Tickers)\nper_return(returns)","category":"page"},{"location":"lib/API.html#Peccon.daily_returns-Tuple{Any, Any}","page":"API","title":"Peccon.daily_returns","text":"daily_returns(portfolio, Tickers)\n\ncalculates the daily log returns of each stock in a portfolio based on the close price of the day. \n\nExamples\n\njulia> tickers = [\"ADAEUR\", \"SPY\"]\njulia> data = fin_data(tickers)\njulia> calc_returns(data, tickers)\n\n\n\n\n\n","category":"method"},{"location":"lib/API.html#Peccon.per_return-Tuple{Any}","page":"API","title":"Peccon.per_return","text":"per_return(returns)\n\ncalculates the compounded return for a specific time-period from daily log returns \n\n# Examples\n\njulia> tickers = [\"ADAEUR\", \"SPY\"]\njulia> data = fin_data(tickers)\njulia> calc_returns(data, tickers)\njulia> data_alpha([\"ADAEUR\", \"SPY\"])\n\n\n\n\n\n","category":"method"},{"location":"lib/API.html#Tools","page":"API","title":"Tools","text":"","category":"section"},{"location":"lib/API.html#modern-portfolio-theory-(mpt)","page":"API","title":"modern portfolio theory (mpt)","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"sharp_ratio(port_sim, rf = 0.02)\nsim_mpt(returns, simulations= 5000 )\nopt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.0 )","category":"page"},{"location":"lib/API.html#Peccon.sharp_ratio","page":"API","title":"Peccon.sharp_ratio","text":"sharp_ratio(port_sim)\n\ncalculates the sharp ratio of each simulates portfolio \n\nExamples\n\njulia> port_sim = sim_mpt(stock_returns)\njulia> sharp_ratio(port_sim) \n\n\n\n\n\n","category":"function"},{"location":"lib/API.html#Peccon.sim_mpt","page":"API","title":"Peccon.sim_mpt","text":"sim_opt(returns, simulations= 5000, days=252)\n\nsimulates random portfolio combinations and calculates the expected return and standard deviation of the portfolio\n\nExamples\n\njulia> returns = daily_returns(data, tickers)\njulia> sim_mpt(returns)\n\n\n\n\n\n","category":"function"},{"location":"lib/API.html#Peccon.opt_mpt","page":"API","title":"Peccon.opt_mpt","text":"opt_mpt(returns, risk_av_step = 0.0:0.02:2.0, diversification_limit= 0.05)\n\nreturns the efficient frontier for a portfolio. \n\nExamples\n\njulia> port_opt = opt_mpt(returns)\n\n\n\n\n\n","category":"function"},{"location":"man/Theory.html#Theory","page":"theory","title":"Theory","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"In this subsection each financial planning tool is fully explained. ","category":"page"},{"location":"man/Theory.html#Modern-Portfolio-Theory-(MPT)","page":"theory","title":"Modern Portfolio Theory (MPT)","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"Modern Portfolio Theory is all about minimizing the variance of the portfolio while taking into account the return of the portfolio with some risk-preference. The first thing to do, is to calculate the returns of the portfolio and the covariance matrix of the portfolio. ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"The expected return of the portfolio is calculated as follows: ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"E(R_P) = sum_iw_iE(R_i)","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"where R_P is the return of the portfolio, R_i is the return of the asset i and W_i is the weight of asset i in the portfolio. The sum of the weights should be equal to sum_i w_i = 1.   Next, we express the variance of the portfolio as follows : ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"sigma^2_P  = sum_isum_j w_iw_jsigma_isigma_jrho_ij","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"In matrix notation this becomes: ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"sigma^2_P =  wSigma w  ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"Remember, what we want to know is that for a given number of stocks which combinations gives us to lowest variance with the highest return. To achieve this we minimize the variance and take into account our risk-preference P with respect to returns based on some historic data.  We therefore minimize the following cost function: ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"Min(wSigma w - P * ER_p) ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"given the following constraints: ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":" w_1 + w_2 +  + w_n-1 + w_n =1","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":" 0 w_i  1  ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"We solve this optimal design problem using the Interior point Newton algorithm from the Optim.jl package","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"The only parameter is our risk-preference P. For each risk-preference P there is an optimal combination of stock that minimizes our cost function. This creates the efficient frontier ","category":"page"},{"location":"man/Theory.html#The-efficient-frontier","page":"theory","title":"The efficient frontier","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"The upward-sloped portion of the hyperbola is the efficient frontier. It reflects the best expected level of return for its level of risk as you will get the maximum amount of return with the least amount of variance for your portfolio. ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"(Image: risk) ","category":"page"},{"location":"man/Theory.html#Sharp-ratio","page":"theory","title":"Sharp ratio","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"We can use the sharp ratio to see how well the return of the portfolio/asset compensates you for the risk that you take. The sharp ratio does however not take into account all risks involved and has the same limitations as the MPT (see subsection limitations). ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":" S_P = fracER_P - R_bsigma_P ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"where R_b is the return of the baseline \"risk-free\" product. ","category":"page"},{"location":"man/Theory.html#Limitations","page":"theory","title":"Limitations","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"There are three main limitation to this tool. The first limitation is that the MPT is a historical measurement of the portfolio performance. It does not say anything about future performance of the portfolio. As consequence, different macro-economic situations might lead to total different end results for the MPT. The second issue is that the tool is based on the expected return and variance of the portfolio. This captures the risk-return relationship quite well but it does not take into account skewness and tail risk. It therefore gives rise to a reduced volatility and an inflated growth rate for a portfolio. Lastly, the risk measurement is probabilistic in nature. It does not reflect the structural roots of the risks taken. For example, the risk of a stock are off a total different nature then that of a commodity, but MPT still accounts them in the same way. ","category":"page"},{"location":"man/Theory.html#Adaptations","page":"theory","title":"Adaptations","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"The cost function can be altered if the function stays convex. We can therefore adapt our cost function to account for more precise measurements of risk. One of the most popular adaptions is the Post-Modern Portfolio Theory (PMPT). ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"The current tool only implements the MPT. Future work will enable PMPT and other adaptions to be made possible. ","category":"page"},{"location":"man/Theory.html#Recommended-usage","page":"theory","title":"Recommended usage","text":"","category":"section"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"Never use this tool for individual stock picking and never but then also never rely only on the MPT. Always do your due diligence before creating your portfolio and again this is no way or form financial advice. ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"So why should you use this tool and for what purpose? It is highly recommended to use this tool with exchange traded funds (ETF) as these products are already substantially diversified and issue two of the MPT is therefore greatly diminished. Also, the structural risk that certain ETF are exposed is difficult the estimate and the MPT can help you gain insights into which ETF have less or more risk compared to the returns they offer. Lastly, MPT also works better if you invest in all assets classes as each class has risks of a different nature. MPT does not take that into account and you therefore have to de it yourself. You also are less exposed to one particular kind of risk. ","category":"page"},{"location":"man/Theory.html","page":"theory","title":"theory","text":"To know which portfolio weights you should apply, you have to understand your risk preference. If you do not want to take a lot of risk, it is beneficial to look at optimal portfolio's with low values in P. The reverse is true for people who are risk seeking. ","category":"page"},{"location":"man/Theory.html#to-be-developed","page":"theory","title":"to be developed","text":"","category":"section"},{"location":"man/Theory.html#Post-Modern-Portfolio-Theory","page":"theory","title":"Post-Modern Portfolio Theory","text":"","category":"section"},{"location":"man/Theory.html#Sortino-ratio","page":"theory","title":"Sortino ratio","text":"","category":"section"},{"location":"man/Theory.html#Captial-asset-pricing-model-(CAPM)","page":"theory","title":"Captial asset pricing model (CAPM)","text":"","category":"section"},{"location":"man/Theory.html#Optimal-control-of-spending,-saving-and-investment","page":"theory","title":"Optimal control of spending, saving and investment","text":"","category":"section"},{"location":"man/financial_planning_tools.html#Planning-tools","page":"financial planning tools","title":"Planning tools","text":"","category":"section"},{"location":"man/financial_planning_tools.html#Modern-Portfolio-Theory-(MPT)","page":"financial planning tools","title":"Modern Portfolio Theory (MPT)","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"The modern portfolio theory (MPT) is one of the oldest applications in modern finance still used today. The technical implication can be found in the theory subsection.  We will now demonstrate how MPT is implemented in the Peccon package and lastly cover some import limitations and recommendations of the tool. ","category":"page"},{"location":"man/financial_planning_tools.html#Example","page":"financial planning tools","title":"Example","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"First extract the daily price data of all the assets you are considering in your portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"using Peccon\nTickers = [\"IUSA.AS\", \"IBCI.AS\", \"IEMA.AS\", \"WTCH.AS\", \"VWRL.AS\"]; \n# data = data_alpha(Tickers, \"your_api_key\", 252);\ndata= data_alpha(Tickers, \"0VS2G38H6PKP03GX\", 248); # hide\ndata[1][1:5,:]\n","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Then calculated the daily log returns for each asset in the portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Tickers = [\"IUSA.AS\", \"IBCI.AS\", \"IEMA.AS\", \"WTCH.AS\", \"VWRL.AS\"]; # hide\ndata= data_alpha(Tickers, \"0VS2G38H6PKP03GX\", 252); # hide\nreturns = daily_returns(data, Tickers);\nreturns[1:5,:]","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Subsequently, simulate 5000 possible portfolio combinations with the assets in the portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"port_sim = sim_mpt(returns);\nport_sim[1:5,:]\n","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Plot the expected return and variance of each simulated portfolio to visualize the efficient frontier.  ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"using Peccon,Pkg; # hide\nPkg.add(\"StatsPlots\"); nothing # hide\nusing StatsPlots; # hide \n@df port_sim scatter(:port_var, :exp_return)\nsavefig(\"sim_fig.svg\"); nothing # hide ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"(Image: )","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"calculate the efficient frontier of the combinations of stocks. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"port_opt = opt_mpt(returns, 0.0:0.02:2.0, 0.00) ; \nport_opt[1:5,:]","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"In the dataframe the optimal portfolios with their respective risk-aversions are shown. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"subsequently, add the efficient frontier to the simulated plot. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"@df port_opt scatter!(:port_var, :exp_return)\nsavefig(\"opt_fig.svg\"); nothing # hide ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"(Image: )","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Lastly, calculate the sharp ratio to find the portfolio with the optimal  return variation ratio ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"port_sim_sharp = sharp_ratio(port_sim) ; \n@show port_sim_sharp[end,:]\nport_opt_sharp = sharp_ratio(port_sim) ; \nport_opt_sharp[end,:]\n\n","category":"page"},{"location":"man/financial_planning_tools.html#limitations","page":"financial planning tools","title":"limitations","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"There are three main limitation to this tool. The first limitation is that the MPT is a historical measurement of the portfolio performance. It does not say anything about future performance of the portfolio. Different Macro-economic situations might lead to total different end results. The second issue is that the tool is based on the expected return and variance of the portfolio. This captures the risk return relationship quite well but it does not take into account skewness and tail risk. It therefore gives rise to a reduced volatility and an inflated growth rate for a portfolio. Lastly, the risk measurement is probabilistic in nature. It does not reflect the structural roots of the risk. For example, the risk of a stock are off a total different nature then that of a commodity, but to tool will still account for them the same way. ","category":"page"},{"location":"man/financial_planning_tools.html#Recommended-usage","page":"financial planning tools","title":"Recommended usage","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Never use this tool for individual stock picking and never but then also never rely only on the MPT. Always do your own due diligence before creating your portfolio and again this is no way or form financial advice. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"So why should you use this tool and for what purpose? It is highly recommended to use this tool with exchange traded funds (ETF) as these products are already substantially diversified and issue two of the MPT is therefore greatly diminished. Also, the structural risk that certain ETF are exposed is difficult the estimate and the MPT can help you gain insights into which ETF have less or more risk compared to the returns they offer. Lastly, MPT also works better if you invest in all assets classes as each class has risks of a different nature and you are then therefore not fully exposed to one particular kind of risk. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"To know which portfolio weights you should apply, you have to understand your risk preference. If you do not want to take a lot of risk, it is beneficial to look at optimal portfolio's with low values in P. The reverse is true for people who are risk seeking. ","category":"page"},{"location":"index.html#Peccon.jl","page":"setup","title":"Peccon.jl","text":"","category":"section"},{"location":"index.html#Introduction","page":"setup","title":"Introduction","text":"","category":"section"},{"location":"index.html","page":"setup","title":"setup","text":"In this julia package you can find all the fin tools that have been developed to optimize investment, spending and income.  These tools enable you to better anticipate your future financial well-being.  The library is intended to give you an intuitional feel and a theoretical explanation about these tools. The library is not intended to give any financial advice. It rather enables you to have the necessary tools to make your own decisions.  ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"The financial data is extracted by using AlphaVantage. More about this in the following subsection. ","category":"page"},{"location":"index.html#AlphaVantage-and-access-to-market-data","page":"setup","title":"AlphaVantage and access to market data","text":"","category":"section"},{"location":"index.html","page":"setup","title":"setup","text":"The Peccon packages uses AlphaVantage and the AlphaVantage.jl package to get stock market data. To get access to the data you need to get an API key. This is obtained by  claiming your API key on this website. The only thing required is a legitimate email address. ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"note: Note\nYou can have 5 API requests per minute and 500 requests per day for free.  If you want to have more get their premium membership","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"Once you have your API key, it becomes possible to extract financial market data as follows: ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"julia> Tickers = [\"ADAEUR\", \"SPY\"]\n\njulia> data_alpha(Tickers, 252, \"your_API_key\")\n","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"Before we delve into specific tools, I will dedicate the first part to understanding fundamental concepts like interest rate, inflation and variance. These concepts are needed as they enable you to fully comprehend the basic implications of each tool. Then we delve in the theoretical aspect of each tool to subsequently see the implementation in the Peccon.jl.  Lastly, you can find an API explaining each and every function in Peccon.jl.","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Fundamental-Understanding","page":"fundamental understanding","title":"Fundamental Understanding","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In this subsection of the documentation we delve deeper into the main concepts behind financial planning. The general intuition will be given here, while the theoretical aspects of the tools will be discussed in next part. It is highly recommended to at least understand the intuitional part of the fundamentals as this will enable you to better account for the limitations and the context of each tool. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Financial planning is like learning how to drive. Know the traffic rules and start in the parking lot. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Intuition","page":"fundamental understanding","title":"Intuition","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Financial planning has three main area's of focus: income, spending and investment/savings. These three area's are linked with each other: ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: risk)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Income is the money that you earn from your wage. This income is then subdivided into your savings and expenditures depending on your spending behavior. Consequentially, a part of the savings is invested into different kinds of assets. Depending on the risk you take, these assets will return a certain profit or loss. In each subdomain we can optimize choices in a way that benefits your financial well-being. The fundamental context is discussed in the following sections. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Investments","page":"fundamental understanding","title":"Investments","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Investments are important. They are the corner stone of planning your financial well-being. It is however not easy to decide how you should invest your money. A whole industry is build around that question and it becomes even harder when you take into account the ramifications of those decisions. It is therefore paramount to fully understand the options available and the possible caveats. The investment decision is the most difficult one you will make and most of the financial planning tools will therefore revolve around it. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In this subsection, however, a small introduction to the basic concepts in investment is given, starting with risk management and returns. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Risk-Management-and-Returns","page":"fundamental understanding","title":"Risk Management and Returns","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Risks are all about chances of future events, more specifically, chances of negative future events. In finance we always try to manage the negative impacts events might have on our investments. Take for example a coin flip. There are two possible outcomes: heads or tails. Each has a 50% chance of happening. In our example we maybe want to avoid flipping tail because we can lose 50 euros, while we win 50 euro if we get head. We therefore adjust the coin so that the probability of flipping tails will decrease. Adjusting your exposure to risk is what we call risk management. The main goal of risk management is that if the event occurs we can live with the loss. The idea is therefore that you set your own risk appetite (what are you willing to lose?). ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"The general notion about risk with respect to age is that as we grow older we should take less risks as the consequence of a bad event has a larger impact on your financial well-being. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Note that there are two dimensions when talking about risk (see graph): ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"the severity of the loss if the event occurs \nthe probability of the event ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: risk)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"The most precarious risks for an investment are the one's with low probability and high consequence. The main reason for this is that the risks are not observed as much and thus estimating the probability of occurrence is rather difficult. Also, we humans tend to be irrational when dealing with risks. We generally over/underestimate them and are therefore overexposed to them or overprotected from them.","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Returns are always expressed as an percentage of the initial investment and always refer to a certain time period. Returns are coherently linked with risks: The higher the risk the higher the return. You can imagine it as in the following graph.  (Image: risk_return)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"As the risk increases so does the variability of the returns. This is called volatility and it is one of the main measurement of risk. In the stock market we can measure the risk of a stock by analyzing the fluctuations of the daily returns. This risk measurement is however not perfect and a lot of different measurement have been invented to capture the total risk a certain assets has. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In the next subsection we will talk about interest rates which are a kind of return generally discussed with bonds/obligations. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Interest-Rate","page":"fundamental understanding","title":"Interest Rate","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Interest rates are a percentage of an initial capital and are calculated on a time horizon. For example  a yearly interest rate of two percent on an initial capital of 1 000 euro will amount to 20 euro after one year, while a monthly interest rate of four percent for the same capital will return 40 euro per month. It is therefore important to remember two questions when faced with interest rates:","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"On what time horizon is the interest rate calculated on? \nTo which initial capital does the interest rate refer to?","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Inflation","page":"fundamental understanding","title":"Inflation","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Inflation is the devaluation of currency. If today your 1€ can buy you x amount of goods and tomorrow your 1€ can buy x-1 goods then we speak of inflation. Inflation is good for debt and bad for capital . Let's assume you have 1000 euro in debt, 1000 euro in a deposit and you earn 100 euro. know assume that you have 5% inflation such that also your wage increases with 5%. Then your assets and liabilities will change over time as it is depicted on the graph. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: inflation)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"As you can see the initial capital and debt are almost reduced due to the 5% inflation while your wage generated the bulk of your capital. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Income","page":"fundamental understanding","title":"Income","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"To be made ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Spending","page":"fundamental understanding","title":"Spending","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"To be made","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Bibliography","page":"fundamental understanding","title":"Bibliography","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"","category":"page"}]
}
