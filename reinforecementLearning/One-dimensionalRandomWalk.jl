using ReinforcementLearning


env = RandomWalk1D()


S = state_space(env)

s = state(env)

A = action_space(env)

is_terminated(env)

while true
    act!(env, rand(A))
    is_terminated(env) && break
end 

state(env)

# use random policy on eneviornment 
run(
    RandomPolicy(), 
    RandomWalk1D(), 
    StopAfterNEpisodes(10), 
    TotalRewardPerEpisode()
)


#QBasedLearner 

NS = length(S)
NA = length(A)

policy = QBasedPolicy(
    learner = TDLearner(
        TabularQApproximator(
            n_state= NS,
            n_action = NA,
        ),
        :SARS
    ), 
    explorer = EpsilonGreedyExplorer(0.1)
)



run(
    policy, 
    RandomWalk1D(), 
    StopAfterNEpisodes(10), 
    TotalRewardPerEpisode()
)


# learn the policy 

using ReinforcementLearningTrajectories

trajectory =Trajectory(
    ElasticArraySARTSATraces(;
    state = Int64 => (), 
    action = Int64 => (), 
    reward = Float64 => (), 
    terminal = Bool => (),
    ),
    DummySampler(), 
    InsertSampleRatioController(),
)

agent = Agent(
    policy = RandomPolicy(),
    trajectory = trajectory
)


run(agent, env, StopAfterNEpisodes(10), TotalRewardPerEpisode())