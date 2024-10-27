using ReinforcementLearning

env= RockPaperScissorsEnv()

policy = RandomPolicy()


run(policy, env, StopAfterNEpisodes(10))

hook= RewardsPerEpisode()

# add a hook to the environment 
run(policy, env, StopAfterNEpisodes(10),hook )





