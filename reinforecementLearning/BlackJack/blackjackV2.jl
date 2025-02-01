
using ReinforcementLearning

########################
### helper functions ###
########################

#gives card to the players 
function giveCard() 
    c_list = vcat(collect(1:11), [10, 10, 10])
    return rand(c_list)
end 


# flattens the multidimensional state space into a one dimensional space 
function flattenStateSpace(state)
    p, d, uap, uad = state 
    index = p * 31 * 2 * 2 + d * 2 * 2 + uap * 2 + uad +1  
    return index
end 

#example 
state = (0, 0, false, false)
player_range = 31
dealer_range = 31
flattened_index = flattenStateSpace(state)
println(flattened_index)


# unflattens the one dimensional state space into a multidimensional space

#############################
### setup the environment ###
#############################

Base.@kwdef mutable struct BlackjackEnv <: AbstractEnv
    player_value::Int = 0 
    dealer_value::Int = 0 
    usable_acePlayer::Bool = false
    usable_aceDealer::Bool = false 
    reward::Union{Nothing, Int} = 0
    is_done::Bool = false
end 

RLBase.reward(env::BlackjackEnv) = env.reward
RLBase.state(env::BlackjackEnv, ::Observation, ::DefaultPlayer) = flattenStateSpace((env.player_value, env.dealer_value, env.usable_acePlayer, env.usable_aceDealer))
RLBase.reward(env::BlackjackEnv) = env.reward
RLBase.is_terminated(env::BlackjackEnv) = env.is_done

RLBase.action_space(env::BlackjackEnv) = [1, 0]

#create state space 

state = [(p, d, a, b) for p in 0:31, d in 0:31, a in [true, false], b in [true, false]]
range = 31 
# convert state space to one dimensional space and link to environment
RLBase.state_space(env::BlackjackEnv) = [flattenStateSpace(s) for s in state]

function RLBase.reset!(env::BlackjackEnv)
    env.player_value = giveCard() + giveCard()
    env.dealer_value = giveCard() + giveCard()
    env.usable_acePlayer = false
    env.usable_aceDealer = false
    env.reward = 0
    env.is_done = false
end

env = BlackjackEnv()

fieldnames(typeof(env))
#########################
### rules of the game ###
#########################

function step!(env::BlackjackEnv, action::Int)
    # when player decides to play 
    if action == 1  # Hit
        card = giveCard()
        if card == 1
            if env.player_value <= 10
                env.player_value += 11
                env.usable_acePlayer = true
            else
                env.player_value += 1
            end
        else
            env.player_value += card
        end
        if env.player_value > 21 && env.usable_acePlayer
            env.player_value -= 10
            env.usable_acePlayer = false
        end
        # when value of player is higher than 21 
        if env.player_value > 21
            env.reward = -1
            env.is_done = true
        end
    # dealer plays
        while env.dealer_value < 17
            card = giveCard()
            if card == 1 && env.dealer_value <= 10 
                env.dealer_value += 11
                env.usable_aceDealer = true 
            else 
                env.dealer_value += card
            end 
            if env.dealer_value > 21 && env.usable_aceDealer
                env.dealer_value -= 10
                env.usable_aceDealer = false
            end
        end 
    # when player does not decide to play   
    elseif action == 0
        while env.dealer_value < 17
            card = giveCard()
            if card == 1 && env.dealer_value <= 10 
                env.dealer_value += 11
                env.usable_aceDealer = true 
            else 
                env.dealer_value += card
            end 
            if env.dealer_value > 21 && env.usable_aceDealer
                env.dealer_value -= 10
                env.usable_aceDealer = false
            end
        end 
        if env.dealer_value > 21 || env.player_value > env.dealer_value
            env.reward = 1
        else
            env.reward = -1 
        end 
        env.is_done = true
    end
    return env
end 

#########################
### Q-learning setup  ###
#########################


#flatten state_space 

possibleCardsDealer = size(RLBase.state_space(BlackjackEnv()))[1]
possibleCardsPlayer = size(RLBase.state_space(BlackjackEnv()))[2]
aceDealer = size(RLBase.state_space(BlackjackEnv()))[3]
acePlayer = size(RLBase.state_space(BlackjackEnv()))[4]




approximator = TabularQApproximator(
    n_state = length(RLBase.state_space(BlackjackEnv())),
    n_action = length(RLBase.action_space(BlackjackEnv()))
)





learner = TDLearner( approximator, :SARS)


# Define the policy using Q-learning and epsilon-greedy exploration
policy = QBasedPolicy(learner, EpsilonGreedyExplorer(0.1))

# Define the trajectory
# Define the trajectory
trajectory = Trajectory(
    ElasticArraySARTSTraces(;
        state = Int64=> (),
        action = Int64 => (),
        reward = Float64 => (),
        terminal = Bool => (),
    ),
    DummySampler(),
    InsertSampleRatioController(),
)
# Define the agent using the policy and explorer
agent = Agent( policy, trajectory)

# Define the experiment setup
env = BlackjackEnv(player_value = 0, dealer_value = 0, usable_acePlayer = false)



# Experiment: Training the agent on the Blackjack environment
hook = TotalRewardPerEpisode()  # Collect the total reward per episode
experiment = Experiment(
    agent,
    env,
    StopAfterNEpisodes(10_000),  # Stop after 10,000 episodes
    hook
)


function RLBase.act!(env::BlackjackEnv, action::Int, player::DefaultPlayer)
    # Apply the action to the environment
    step!(env, action)
    
    # Get the current flattened state
    state = RLBase.state(env, Observation(), player)
    
    # Return the current state, reward, and termination status
    return state, env.reward, env.is_done
end

# Run the training
run(experiment)

















agent = QLearner(
    policy = EpsilonGreedyExplorer(ϵ = 0.1),
    approximator = TabularApproximator(
        table = QTable(state_space(BlackjackEnv(0, 0, false, nothing, false)), action_space(BlackjackEnv(0, 0, false, nothing, false))),
        optimizer = SGD(η = 0.1)
    ),
    γ = 0.99  # Discount factor
)
agent = Agent(
    policy = QBasedPolicy(
        learner = QLearner(
            approximator = DictApproximator(
                state_action_dict = Dict(
                    ((s, a) => 0.0) for s in RLBase.state_space(BlackjackEnv()),  
                                        a in RLBase.action_space(BlackjackEnv())
                )
            )
        ),
        explorer = EpsilonGreedyExplorer(ϵ=0.1)
    )
)