# creating your own environment 

using ReinforcementLearning

# create an environment with only a reward in it 
Base.@kwdef mutable struct LotteryEnv <: AbstractEnv 
    reward::Union{Nothing, Int} = nothing
end

# create the action 
struct LotteryAction{a}
    function LotteryAction(a) 
        new{a}()
    end 
end 
RLBase.action_space(env::LotteryEnv) = LotteryAction.([:PowerRich, :MegaHaul, nothing])

# setting up interaction between action and state space 
RLBase.reward(env::LotteryEnv)  = env.reward

RLBase.state(env::LotteryEnv, ::Observation, ::DefaultPlayer) = !isnothing(env.reward) 

RLBase.state_space(env::LotteryEnv) =  [false, true] 

RLBase.is_terminated(env::LotteryEnv) = !isnothing(env.reward)

RLBase.reset!(env::LotteryEnv) = env.reward = nothing


# game logic 
function RLBase.act!(x::LotteryEnv, action)
    if action == LotteryAction(:PowerRich) 
        x.reward= rand() < 0.01 ? 100_000_000 : -10
    elseif action == LotteryAction(:MegaHaul)
        x.reward= rand() < 0.05 ? 1_000_000 : -10 
    elseif action == LotteryAction(nothing) 
        x.reward =  0 
    else 
        @error "unknown action of $action"
    end 
end 

########################
### test environment ###
########################

env = LotteryEnv() 


RLBase.test_runnable!(env)

#test with random policy 
run(RandomPolicy(action_space(env)), env, StopAfterNEpisodes(1000)) 


#create a hook 
hook = TotalRewardPerEpisode() 

run(RandomPolicy(action_space(env)), env, StopAfterNEpisodes(1000), hook)

using Plots

plot(hook.rewards)


#agent 

p = QBasedPolicy(
    learner= TDLearner(
        TabularQApproximator(
            n_state = length(state_space(env)), 
            n_action = length(action_space(env)),
        ), :SARS 
    ), 
    explorer = EpsilonGreedyExplorer(0.1)
) 




wrapped_env = ActionTransformedEnv(
    StateTransformedEnv(
        env;
        state_mapping=s -> s ? 1 : 2,
        state_space_mapping = _ -> Base.OneTo(2)
    );
    action_mapping = i -> action_space(env)[i],
    action_space_mapping = _ -> Base.OneTo(3),
)

plan!(p, wrapped_env)

h = TotalRewardPerEpisode()


run(p, wrapped_env, StopAfterNEpisodes(1_000), h)

plot(h.rewards)
