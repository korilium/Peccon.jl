using ReinforcementLearning

#still compatability issues with other packages need to reolve thi. Currently not able to work in same environment 

#one dimensional walk tutorial 



#set up environment 

env = RandomWalk1D()

S = state_space(env)


A = action_space(env)


while true
    act!(env, rand(A))
    is_terminated(env) && break
end

state(env)
reward(env)



run(
           RandomPolicy(),
           RandomWalk1D(),
           StopAfterNEpisodes(10),
           TotalRewardPerEpisode()
       )

#setup Q-learner no optimization 


NS = length(S)

NA = length(A)


policy = QBasedPolicy(
           learner = TDLearner(
                   TabularQApproximator(
                       n_state = NS,
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