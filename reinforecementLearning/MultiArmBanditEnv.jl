using ReinforcementLearning, Statistics

env= MultiArmBanditsEnv()

S = state_space(env)

A = action_space(env)

policy = QBasedPolicy(
    learner = TDLearner( 
        TabularQApproximator(
            n_state= S,
            n_action = A 

        ), :SARS  
    ),
    explorer = EpsilonGreedyExplorer(0.3)
)

hook = TotalRewardPerEpisode()
run(policy, env, StopAfterNEpisodes(10), hook)


#check if the policy is learning 

hook= RewardsPerEpisode() 

# add a hook to the environment 
run(policy, env, StopAfterNEpisodes(1000),
    DoEveryNEpisodes(; n=10) do t, policy, env 
        hook = TotalRewardPerEpisode(;is_display_on_exit= false)
        run(policy, env, StopAfterNEpisodes(10), hook)
        println("avg reward at episode $t is: $(mean(hook.rewards))")
    end 
)






env.reward