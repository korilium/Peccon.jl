# Peccon.jl 

## Introduction

In this julia package you can find all the fin tools that have been developed to optimize investment, spending and income. 
These tools enable you to better anticipate your future financial well-being. 
The library is intended to give you an intuitional feel and a theoretical explanation about theses tools. The library is not intended to give any financial advice. It rather enables you to have the necessary tools to make your own decisions.  

The financial data is extracted by using AlphaVantage. More about this in the following subsection. 


##  AlphaVantage and access to market data 

The Peccon packages uses [AlphaVantage](https://www.alphavantage.co/#about) and [the AlphaVantage.jl package](https://github.com/ellisvalentiner/AlphaVantage.jl) to get stock market data. To get access to the data you need to get an API key. This is obtained by  claiming your API key on [this website](https://www.alphavantage.co/support/#api-key). The only thing required is a legitimate email address. 


!!! note 
    You can have 5 API requests per minute and 500 requests per day for free. 
    If you want to have more get their [premium membership](https://www.alphavantage.co/premium/)



Once you have your API key, it becomes possible to extract financial market data as follows: 

```julia 
julia> Tickers = ["ADAEUR", "SPY"]

julia> fin_data(Tickers, 252, "your_API_key")

```


Before we delve into specific tools, I will dedicate the first part to understanding fundamental concepts like interest rate, inflation and variance. These concepts are needed as they enable you to fully comprehend the basic implications of each tool. Then we delve in the theoretical aspect of each tool to subsequently see the implementation in the Peccon.jl.  Lastly, you can find an API explaining each and every function in Peccon.jl.


