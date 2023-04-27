# Theory
In this subsection each financial planning tool is fully explained. 
## Modern Portfolio Theory (MPT)

Modern Portfolio Theory is all about minimizing the variance of the portfolio while taking into account the return with some risk-preference. We therefore need to calculate first the returns of each stock and the covariance matrix of the portfolio. 


The variance of the portfolio can be expressed as follows : 

``\sigma^2_P  = \sum_i\sum_j w_iw_j\sigma_i\sigma_j\rho_{ij}``

$w_i$ is the weight of asset $i$ in the portfolio such that  $\sum_i w_i = 1$

in matrix notation becomes 

``\sigma^2_P =  w'\Sigma w  `` 

Then,  the expected return of the portfolio is calculated: ``E(R_P) = \sum_iw_iE(R_i)``

where $R_P$ is the return on the portfolio, $R_i$ is the return on the asset $i$. 

What we want to know is that for a given number of stocks which combinations is the most preferential. To achieve this we minimize the variance and take into account our risk-preference $P$ with respect to returns *based on some historic data*. 
We therefore minimize the following cost function: 

`` Min(w'\Sigma w - P * E[R_p]) $$ 

given the following constraints: 

`` w_1 + w_2 + ... + w_{n-1} + w_{n} =1  ``

`` 0> w_i > 1  ``

We solve this optimal design problem using the [Interior point Newton algorithm](https://en.wikipedia.org/wiki/Interior-point_method) from the [Optim.jl package](https://julianlsolvers.github.io/Optim.jl/stable/#)

The only parameter is our risk-preference $P$. For each risk-preference $P$ there is an optimal combination of stock that minimizes our cost function. This creates the efficient frontier 

### The efficient frontier 
The upward sloped portion of the hyperbola is the efficient frontier as you will get the maximum amount of return with the least amount of variance for your portfolio. 

![risk](images/efficient_frontier.png)




### Sharp ratio 

`` S_P = \frac{E[R_P - R_{f}]}{\sigma_P} `` 
### Limitations 

### Adaptations 

#### Post-Modern Portfolio Theory (PMPT)

##### Sortino ratio 


## Captial asset pricing model (CAPM) 

### adaptations 





