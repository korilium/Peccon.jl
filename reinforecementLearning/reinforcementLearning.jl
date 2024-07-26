using ReinforcementLearning

#still compatability issues with other packages need to reolve thi. Currently not able to work in same environment 


# Monte Carlo Trre search: A Tutorial The LotteryEnv 

#setup env 
Base.@kwdef mutable struct LotteryEnv <: AbstractEnv 
    reward::Union{Nothing, Int} = nothing
end

Main.LotteryEnv

# interface
struct LotteryAction{a}
    function LotteryAction(a)
        new{a}() 
    end 
end 

RLBase.action_space(env::LotteryEnv) = LotteryAction.([:PowerRich, :MegaHaul, nothing]) # set actions 
RLBase.reward(env::LotteryEnv) = env.reward   #set reward 
RLBase.state(env::LotteryEnv, ::Observation,::DefaultPlayer) = !isnothing(env.reward) # set state of the game 
RLBase.state_space(env::LotteryEnv) = [false, true] # define current state space set 
RLBase.is_terminated(env::LotteryEnv) = !isnothing(env.reward) # define stop 
RLBase.reset!(env::LotteryEnv) = env.reward = nothing  # define reset 

# game logic 


function RLBase.act!(x::LotteryEnv, action)
    if action == LotteryAction(:PowerRich)
        x.reward = rand() < 0.01 ? 100_000_000 : -10 
    elseif action == LotteryAction(:MegaHaul)
        x.reward = rand() < 0.05 ? 1_000_000 : -10 
    elseif action == LotteryAction(nothing)
        x.reward = 0 
    else 
        @error "unkown action of $action"
    end 

end 




# test 

env = LotteryEnv()


RLBase.test_runnable!(env)

# random policy 

# random policy will select a random action 

run(RandomPolicy(action_space(env)), env, StopAfterNEpisodes(1_000))

#add hook 


hook = TotalRewardPerEpisode() 


run(RandomPolicy(action_space(env)), env, StopAfterNEpisodes(1_000), hook)


#visualize hook 

using Plots 

plot(hook.rewards)

#############
# chapter 2 #
#############

q = 0 
N = 0 


while N != 50 
    N = N +1
     


end 


##########################
# k-armed bandit problem #
##########################


