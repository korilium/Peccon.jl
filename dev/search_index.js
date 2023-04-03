var documenterSearchIndex = {"docs":
[{"location":"lib/API.html#API","page":"API","title":"API","text":"","category":"section"},{"location":"lib/API.html#loading-in-data","page":"API","title":"loading in data","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"fin_data(Tickers, clientKey,days = 250)","category":"page"},{"location":"lib/API.html#Peccon.fin_data","page":"API","title":"Peccon.fin_data","text":"fin_data(Tickers)\n\nextracts the daily price info of multiple stocks and puts them in a vector of dataframes. \n\nExamples\n\njulia> fin_data([\"ADAEUR\", \"SPY\"])\n\n\n\n\n\n","category":"function"},{"location":"lib/API.html#calculating-returns","page":"API","title":"calculating returns","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"calc_returns(portfolio, Tickers)","category":"page"},{"location":"lib/API.html#Peccon.calc_returns-Tuple{Any, Any}","page":"API","title":"Peccon.calc_returns","text":"calc_returns(portfolio, Tickers)\n\ncalculates the daily log returns of each stock in a portfolio based on the close price of the day. \n\nExamples\n\njulia> tickers = [\"ADAEUR\", \"SPY\"]\njulia> data = fin_data(tickers)\njulia> calc_returns(data, tickers)\n\n\n\n\n\n","category":"method"},{"location":"lib/API.html#modern-portfolio-theory","page":"API","title":"modern portfolio theory","text":"","category":"section"},{"location":"lib/API.html","page":"API","title":"API","text":"sharp_ratio(port_sim, rf = 0.02)\nsim_mpt(port_returns, simulations= 5000 )","category":"page"},{"location":"lib/API.html#Peccon.sharp_ratio","page":"API","title":"Peccon.sharp_ratio","text":"sharp_ratio(port_sim)\n\ncalculates the sharp ratio of each simulates portfolio \n\nExamples\n\njulia> port_sim = sim_mpt(port_returns)\njulia> sharp_ratio(port_sim) \n\n\n\n\n\n","category":"function"},{"location":"lib/API.html#Peccon.sim_mpt","page":"API","title":"Peccon.sim_mpt","text":"sim_opt(port_returns)\n\nsimulates random portfolio combinations and calculates the expected return and standard deviation of the portfolio\n\nExamples\n\njulia> port_returns = calc_returns(data, tickers)\njulia> sim_mpt(port_returns)\n\n\n\n\n\n","category":"function"},{"location":"man/Theory.html#Theory","page":"theory","title":"Theory","text":"","category":"section"},{"location":"man/Theory.html#Modern-Portfolio-Theory","page":"theory","title":"Modern Portfolio Theory","text":"","category":"section"},{"location":"man/financial_planning_tools.html#Planning-tools","page":"financial planning tools","title":"Planning tools","text":"","category":"section"},{"location":"man/financial_planning_tools.html#Modern-Portfolio-Theory-(MPT)","page":"financial planning tools","title":"Modern Portfolio Theory (MPT)","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"The modern portfolio theory (MPT) is one of the oldest applications in modern finance still used today. The technical implication can be found in the theory subsection.  We will now demonstrate how MPT is implemented in the Peccon package and lastly cover some import limitations of the tool. ","category":"page"},{"location":"man/financial_planning_tools.html#Example","page":"financial planning tools","title":"Example","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"First extract the daily price data of all the assets you are considering in your portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"julia> Tickers = [\"ADAEUR\",  \"AMZN\", \"ING\", \"VEU\", \"PICK\"]\n\njulia> data= fin_data(Tickers, 250)\n5-element Vector{Any}:\n 250×10 DataFrame\n Row │ timestamp   open      high      low       close     adjusted_close  vol ⋯\n     │ SubStrin…   Float64   Float64   Float64   Float64   Float64         Int ⋯\n─────┼──────────────────────────────────────────────────────────────────────────\n   1 │ 2023-03-30  0.351717  0.353378  0.345903  0.348672        0.348672   14 ⋯\n   2 │ 2023-03-29  0.339719  0.359931  0.338335  0.351717        0.351717  190\n   3 │ 2023-03-28  0.318954  0.34175   0.316278  0.339719        0.339719  133\n  ⋮  │     ⋮          ⋮         ⋮         ⋮         ⋮            ⋮             ⋱\n 249 │ 2022-07-25  0.472525  0.475663  0.437547  0.438562        0.438562  200\n 250 │ 2022-07-24  0.477232  0.495413  0.470218  0.472525        0.472525  233\n                                                  4 columns and 235 rows omitted\n.\n.\n.\n\n 250×10 DataFrame\n Row │ timestamp   open     high     low      close    adjusted_close  volume  ⋯\n     │ SubStrin…   Float64  Float64  Float64  Float64  Float64         Int64   ⋯\n─────┼──────────────────────────────────────────────────────────────────────────\n   1 │ 2023-03-29    41.67  41.879   41.4675    41.72         41.72     115378 ⋯\n   2 │ 2023-03-28    40.77  41.34    40.77      41.1          41.1     1023316\n   3 │ 2023-03-27    40.49  40.69    40.1       40.49         40.49     267293\n  ⋮  │     ⋮          ⋮        ⋮        ⋮        ⋮           ⋮            ⋮    ⋱\n 249 │ 2022-04-01    51.54  52.5     51.54      52.5          49.1929   457984\n 250 │ 2022-03-31    51.91  51.91    51.125     51.22         47.9935   413616\n                                                  3 columns and 235 rows omitted\n\n","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Then calculated the daily log returns for each assets in the portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"julia> returns = calc_returns(data, Tickers)\n250×5 DataFrame\n Row │ ADAEUR       AMZN          ING          VEU          PICK        \n     │ Float64      Float64       Float64      Float64      Float64\n─────┼──────────────────────────────────────────────────────────────────\n   1 │  0.0          0.0           0.0          0.0          0.0\n   2 │  0.00869685  -0.0304849    -0.0197009   -0.00838579  -0.0149725\n   3 │ -0.0347072    0.00819341   -0.00781593  -0.00460388  -0.0149531\n  ⋮  │      ⋮            ⋮             ⋮            ⋮            ⋮\n 249 │  0.0159087   -0.0288445    -0.0140781   -0.00787406  -0.00418172\n 250 │  0.0745889   -0.00344503   -0.0142792   -0.0103646   -0.0246831\n                                                        245 rows omitted","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Subsequently, simulate 5000 possible portfolio combinations with the assets in the portfolio. ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"port_sim = sim_mpt(returns)\n5000×8 DataFrame\n  Row │ exp_return  port_var  weight_ADAEUR  weight_AMZN  weight_ING  weight_VEU  weight_PICK  port_std \n      │ Float64     Float64   Float64        Float64      Float64     Float64     Float64      Float64\n──────┼─────────────────────────────────────────────────────────────────────────────────────────────────\n    1 │   0.782005  0.371563      0.314956     0.187496    0.106037    0.29146      0.100051   0.60956\n    2 │   0.44903   0.127016      0.204426     0.0915665   0.0956426   0.387233     0.221132   0.356393\n    3 │   0.752467  0.354838      0.22694      0.182917    0.165517    0.173968     0.250658   0.595682\n  ⋮   │     ⋮          ⋮            ⋮             ⋮           ⋮           ⋮            ⋮          ⋮\n 4999 │   1.08724   0.779559      0.29427      0.285084    0.156916    0.255411     0.0083186  0.882926\n 5000 │   0.631883  0.366295      0.0328957    0.182578    0.451323    0.23108      0.102123   0.605223\n                                                                                       4995 rows omitted","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Plot the expected return and variance of each simulated portfolio to visualize the efficient frontier.  ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"@df port_sim scatter(:port_var, :exp_return)","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"Lastly, calculate the sharp ratio to find the portfolio with the optimal  return variation ratio ","category":"page"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"port_opt = sharp_ratio(port_sim)\n5000×9 DataFrame\n  Row │ exp_return   port_var   weight_ADAEUR  weight_AMZN  weight_ING   weight_VEU  weight_PICK  port_std  sharp_ratio \n      │ Float64      Float64    Float64        Float64      Float64      Float64     Float64      Float64   Float64\n──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n    1 │ 0.000978628  0.0728112      0.0432636   0.00380148  0.538456      0.382372     0.0321063  0.269835  -0.0704925\n    2 │ 0.0224071    0.0916218      0.0918305   0.0123358   0.671231      0.105515     0.119087   0.302691   0.00795236\n    3 │ 0.0278418    0.104237       0.0287333   0.0190882   0.71372       0.0756757    0.162782   0.322858   0.0242887\n  ⋮   │      ⋮           ⋮            ⋮             ⋮            ⋮           ⋮            ⋮          ⋮           ⋮\n 4999 │ 0.75761      0.309236       0.412322    0.159658    0.000185982   0.097781     0.330053   0.55609    1.32642\n 5000 │ 0.735419     0.290243       0.422292    0.150836    0.00973458    0.0215554    0.395581   0.538742   1.32794\n                                                                                                       4995 rows omitted\n\njulia> port_opt[end,:]\nDataFrameRow\n  Row │ exp_return  port_var  weight_ADAEUR  weight_AMZN  weight_ING  weight_VEU  weight_PICK  port_std  sharp_ratio \n      │ Float64     Float64   Float64        Float64      Float64     Float64     Float64      Float64   Float64\n──────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────\n 5000 │   0.735419  0.290243       0.422292     0.150836  0.00973458   0.0215554     0.395581  0.538742      1.32794","category":"page"},{"location":"man/financial_planning_tools.html#limitations","page":"financial planning tools","title":"limitations","text":"","category":"section"},{"location":"man/financial_planning_tools.html","page":"financial planning tools","title":"financial planning tools","text":"based on expected values \nnot capture the skewed distribution of risk and return , gives rise to reduced volatility and inflated growth of return \nhistorical measurement \nfuture might not be the same as the past \nrisk measurement is probabilistic in nature, not structural. ","category":"page"},{"location":"index.html#Peccon.jl","page":"setup","title":"Peccon.jl","text":"","category":"section"},{"location":"index.html#Introduction","page":"setup","title":"Introduction","text":"","category":"section"},{"location":"index.html","page":"setup","title":"setup","text":"In this julia package you can find all the fin tools that have been developed to optimize investment, spending and income.  These tools enable you to better anticipate your future financial well-being.  The library is intended to give you an intuitional feel and a theoretical explanation about theses tools. This book is not intended to give any financial advice. It rather enables you to have the necessary tools to make your own decisions.  ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"The financial data is extracted by using AlphaVantage. More about this in the following subsection. ","category":"page"},{"location":"index.html#AlphaVantage-and-access-to-market-data","page":"setup","title":"AlphaVantage and access to market data","text":"","category":"section"},{"location":"index.html","page":"setup","title":"setup","text":"The Peccon packages uses AlphaVantage and the AlphaVantage.jl package to get stock market data. To get access to the data you need to get an API key. This is obtained by  claiming your API key on this website. The only thing required is a legitimate email address. ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"note: Note\nYou can have 5 API requests per minute and 500 requests per day for free.  If you want to have more get their premium membership","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"Once you have your API key, it becomes possible to extract financial market data as follows: ","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"julia> Tickers = [\"ADAEUR\", \"SPY\"]\n\njulia> fin_data(Tickers, 250, \"your_API_key\")\n","category":"page"},{"location":"index.html","page":"setup","title":"setup","text":"Before we delve into specific tools, I will dedicate the first chapter to understanding practical concepts like interest rate, inflation and variance. These concepts are needed as they enable you to fully comprehend the basic implications of each tool. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Fundamental-Understanding","page":"fundamental understanding","title":"Fundamental Understanding","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In this subsection of the book we delve deeper into the main concepts behind financial planning. The general intuition will be given in the first part of this section, while in the last section the theoretical aspects will be discussed. It is highly recommended to at least understand the intuitional part of the fundamentals as this will enable you to better account for the limitations and the context of each tool. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Financial planning is like learning how to drive. Know the traffic rules and start in the parking lot. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Intuition","page":"fundamental understanding","title":"Intuition","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Financial planning has three main area's of focus: income, spending and investment/savings. These three area's are linked with each other: ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: risk)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Income is the money that you earn from you wage. This income is then subdivided in your savings and expenditures depending on your spending behavior. Consequentially, a part of the savings is invested into different kinds of assets. Depending on the risk you take, these assets will return a certain profit or loss. In each subdomain we can optimize choices in a way that benefits your financial well-being. The fundamental context around these area's will be explained in the following sections. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Investments","page":"fundamental understanding","title":"Investments","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Investments are important. They are the corner stone of planning your financial well-being. It is however not easy to decide on what you should invest in exactly. A whole industry is build around that question and it becomes even harder when you take into account the ramifications of those decisions. It is therefore paramount to fully understand the options available and the possible caveats. The investment decision is the most difficult one you will make and most of the financial planning tools will therefore revolve around it. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In this subsection, however, a small introduction to the basic concepts in investment is given. For a more in depth discussion see the technical explanation.    ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Risk-Management-and-Returns","page":"fundamental understanding","title":"Risk Management and Returns","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Risks are all about chances of future events, more specifically, chances of negative future events. In finance we always try to manage the negative impacts events might have on our investments. Take for example a coin flip. There are two possible outcomes: heads or tails. Each has a 50% chance of happening. In our example we maybe want to avoid flipping tail because we can lose 50 euros, while we win 50 euro if we get head. We therefore adjust the coin so that the probability of flipping tails will decrease. Adjusting your exposure to risk is what we call risk management. **The main goal of risk management is that if the event occurs we can live with the loss. ** The idea is therefore that you set your own risk appetite (what are you willing to lose?). ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"The general notion about risk with respect to age is that as we grow older we should take less risks as the consequence of a bad event has a larger impact on your financial well-being. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Note that there are two dimensions when talking about risk (see graph): ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"the severity of the loss if the event occurs \nthe probability of the event ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: risk)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"The most precarious risks for an investment are the one's with low probability and high consequence. The main reason for this is that the risks are not observed as much and thus estimating the probability of occurrence is rather difficult. Also, we humans tend to be irrational when dealing with risks. We generally over/underestimate them and are therefore overexposed to them or overprotected from them.","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Returns are always expressed as an percentage of the initial investment and always refer to a certain time period. Returns are coherently linked with risks: The higher the risk the higher the return. You can imagine it as in the following graph.  (Image: risk_return)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"As the risk increases so does the variability of the returns. This is called volatility and it is the main measurement of risk. In the stock market we can measure the risk of a stock by analyzing the fluctuations of the daily returns. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"In the next subsection we will talk about interest rates which are a kind of return generally discussed with bonds/obligations. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Interest-Rate","page":"fundamental understanding","title":"Interest Rate","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Interest rates are a percentage of an initial capital and are calculated on a time horizon. For example  a yearly interest rate of two percent on an initial capital of 1 000 euro will amount to 20 euro after one year, while a monthly interest rate of four percent for the same capital will return 40 euro per month. It is therefore important to remember two questions when faced with interest rates:","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"On what time horizon is the interest rate calculated on? \nTo which initial capital does the interest rate refer to?","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Inflation","page":"fundamental understanding","title":"Inflation","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"Inflation is the devaluation of currency. If today your 1€ can buy you x amount of goods and tomorrow your 1€ can buy x-1 goods then we speak of inflation. Inflation is good for debt and bad for capital . Let's assume you have 1000 euro in debt, 1000 euro in a deposit and you earn 100 euro. know assume that you have 5% inflation such that also your wage increases with 5%. Then your assets and liabilities will change over time as it is depicted on the graph. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"(Image: inflation)","category":"page"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"As you can see the initial capital and debt are almost reduced due to the 5% inflation while your wage generated the bulk of your capital. ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Income","page":"fundamental understanding","title":"Income","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"To be made ","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Spending","page":"fundamental understanding","title":"Spending","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"To be made","category":"page"},{"location":"man/fundamental_understanding_intuition.html#Bibliography","page":"fundamental understanding","title":"Bibliography","text":"","category":"section"},{"location":"man/fundamental_understanding_intuition.html","page":"fundamental understanding","title":"fundamental understanding","text":"","category":"page"}]
}
