
using ReinforcementLearning

########################
### helper functions ###
########################

function giveCard() 
    c_list = vcat(collect(1:11), [10, 10, 10])
    return rand(c_list)
end 

#############################
### setup the environment ###
#############################

Base.@kwdef mutable struct BlackjackEnv <: AbstractEnv
    player_value::Int = 0 
    dealer_value::Int = 0 
    usable_acePlayer::Bool = false
    usable_aceDealer::Bool = false 
    reward::Union{Nothing, Int} = nothing
    is_done::Bool = false
end 

RLBase.state(env::BlackjackEnv, ::Observation, ::DefaultPlayer) = (env.player_value, env.dealer_value, env.usable_acePlayer, env.usable_aceDealer)
RLBase.reward(env::BlackjackEnv) = env.reward
RLBase.is_terminated(env::BlackjackEnv) = env.is_done

RLBase.action_space(env::BlackjackEnv) = [1, 0]
RLBase.state_space(env::BlackjackEnv) = [(p, d, a, b) for p in 1:31, d in 1:31, a in [true, false], b in [true, false]]

function RLBase.reset!(env::BlackjackEnv)
    env.player_value = giveCard() + giveCard()
    env.dealer_value = giveCard() + giveCard()
    env.usable_acePlayer = false
    env.usable_aceDealer = false
    env.reward = nothing
    env.is_done = false
end

BlackjackEnv()

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



# Flattening function: Maps multidimensional state to one-dimensional index
function flatten_state(state)
    p, d, ua, uad = state
    index = p 
    return index
end






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
        state = Tuple{Int64, Int64, Bool, Bool } => (),
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
env = BlackjackEnv()

# Experiment: Training the agent on the Blackjack environment
hook = TotalRewardPerEpisode()  # Collect the total reward per episode
experiment = Experiment(
    agent,
    env,
    StopAfterNEpisodes(10_000),  # Stop after 10,000 episodes
    hook
)




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