using ReinforcementLearning, ReinforcementLearningTrajectories
using Plots

# ╔═╡ 1fcd93f0-4a5c-11eb-252d-9da5bc78b08b
using StatsPlots, Random

# ╔═╡ 1fbc2952-4b1b-11eb-3b65-75c1058a9537
using Flux

# ╔═╡ db64341a-4b1b-11eb-3f7b-f11b26f442f4
using Statistics



env = MultiArmBanditsEnv()

reset!(env)

explorer = EpsilonGreedyExplorer(0.1)

true_reward=0.0
init=0.0
opt= InvDecay(1.0)
agent= Agent(
            policy=QBasedPolicy(
                learner= TabularQApproximator(
                        n_state= length(state_space(env)), 
                        n_action=length(action_space(env)), 
                        init= init, 
                        
                    ),
                explorer=explorer
            ),
            trajectory=VectorSARTTrajectory()
            )
            h1 = CollectBestAction(;best_Action=findmax(env.true_values)[2])
            h2 = TotalRewardPerEpisode(;is_display_on_exit=false)



            t = Trajectory(Traces(a=Int[], b=Bool[]), BatchSampler(3), InsertSampleRatioControler(1.0, 3));
