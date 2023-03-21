#!/usr/bin/env python
# coding: utf-8

# # Modern Portfolio Theory 

# In[1]:


using Peccon, Plots, StatsPlots


# ## load in data 

# In[3]:


tickers = ["ADAEUR", "SPY", "DIS"]
data = Peccon.fin_data(tickers)


# ## Calculate Returns and Simulate Portfolios 

# In[6]:


returns = Peccon.calc_returns(data, tickers)

sim_port = Peccon.sim_mpt(returns)


# In[12]:


@df sim_port scatter( :port_std, :exp_return)


# In[14]:


sharp = Peccon.sharp_ratio(sim_port)
sharp[end, :]


# In[ ]:




