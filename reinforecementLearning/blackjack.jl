using ReinforcementLearning


# Base.@kwdef mutuable struct BlackjackEnv <: AbstractEnv
#     reward::Union{Nothing, Int} = nothing 
# end 

# setting up interaction between action and state space 


#blackjack game without ReinforcementLearning package 


# RL.Base.rest!(env::BlackjackEnv) = env.reward = nothing
# RL.Base.state(env::BlackjackEnv, ::Observation, ::DefaultPlayer) = !isnothing(env.reward)





#create initial statments 

player_state_value = [] 
player_states = []
player_win = 0 
player_draw = 0 
ace = false


#game logic for blackjack 

#drawing a card in blackjack 

function giveCard() 
    c_list = vcat(collect(1:11),   [10, 10,10])
    return rand(c_list)
end 




#improved dealerPolicy 
function dealerPolicy(current_value::Int, usable_ace::Bool)
    while current_value < 17
        card = giveCard()
        if card == 1 && current_value <= 10
            current_value += 11
            usable_ace = true
        else
            current_value += card
        end
        if current_value > 21 && usable_ace
            current_value -= 10
            usable_ace = false
        end
    end
    return current_value, usable_ace, current_value >= 17
end


#players policy 

function playerPolicy(current_value::Int, usable_ace, end_game=false)
    card = giveCard()
    if current_value > 21
        if usable_ace == true
            current_value -= 10
            usable_ace = false 
        else 
            return current_value, usable_ace
        end 
    end 

    if current_value >= 20 
        return current_value, usable_ace

    else
        if card == 1
            if current_value <= 10
                return current_value +11, true
            else
                return current_value +1, true
            end 
        else
            return current_value + card, usable_ace
        end
    end 
end 




function calculate_reward(player_value::Int, dealer_value::Int)
    if player_value > 21
        return -1 # Player busts
    elseif dealer_value > 21 || player_value > dealer_value
        return 1  # Player wins
    elseif player_value == dealer_value
        return 0  # Draw
    else
        return -1 # Dealer wins
    end
end




dealer_value = giveCard() + giveCard()
player_value, usable_ace = giveCard() + giveCard(), false
player_value, usable_ace = playerPolicy(player_value, usable_ace)
dealer_value, _, _ = dealerPolicy(dealer_value, false)
reward = calculate_reward(player_value, dealer_value)
println("Player Value: $player_value, Dealer Value: $dealer_value, Reward: $reward")


########################################
##### implement blackjack in julia #####
######################################## 

using ReinforcementLearning


Base.@kwdef mutable struct BlackjackEnv <:AbstractEnv
    player_value::Int 
    dealer_value::Int 
    usable_ace::Bool 
    reward::Union{Nothing, Int} = nothing
end 

RLBase.action_space(env::BlackjackEnv) = [1, 0]

function RLBase.state(env::BlackjackEnv, ::Observation, ::DefaultPlayer)
    return (env.player_value, env.dealer_value, env.usable_ace)
end 

RLBase.reward(env::BlackjackEnv) = env.reward

function RLBase.is_terminated(env::BlackjackEnv)
    return !isnothing(env.reward)
end 


RLBase.state_space(env::BlackjackEnv) = [(player_value, dealer_value, usable_ace) for player_value in 1:21, dealer_value in 1:21, usable_ace in [true, false]]

function dealerPolicy(current_value::Int, usable_ace::Bool)
    while current_value < 17
        card = giveCard()
        if card == 1 && current_value <= 10
            current_value += 11
            usable_ace = true
        else
            current_value += card
        end
        if current_value > 21 && usable_ace
            current_value -= 10
            usable_ace = false
        end
    end
    return current_value, usable_ace, current_value >= 17
end

function playerPolicy(current_value::Int, usable_ace::Bool)
    card = giveCard()
    if current_value > 21
        if usable_ace == true
            current_value -= 10
            usable_ace = false 
        else 
            return current_value, usable_ace
        end 
    end

    if current_value >= 20
        return current_value, usable_ace
    else
        if card == 1
            if current_value <= 10
                return current_value + 11, true
            else
                return current_value + 1, true
            end
        else
            return current_value + card, usable_ace
        end
    end
end

RLBase.reset!(env::BlackjackEnv) = begin
    env.player_value = 0
    env.dealer_value = giveCard() + giveCard()
    env.usable_ace = false
    env.reward = nothing
end

function calculate_reward(player_value::Int, dealer_value::Int)
    if player_value > 21
        return -1  # Player busts
    elseif dealer_value > 21 || player_value > dealer_value
        return 1  # Player wins
    elseif player_value == dealer_value
        return 0  # Draw
    else
        return -1  # Dealer wins
    end
end

function step!(env::BlackjackEnv, action::Int)
    if action == 1  # Hit
        card = giveCard()
        env.player_value += card
        if env.player_value > 21
            env.reward = -1
            return env, env.reward
        end
    elseif action == 0  # Stand
        env.dealer_value, env.usable_ace, _ = dealerPolicy(env.dealer_value, env.usable_ace)
        env.reward = calculate_reward(env.player_value, env.dealer_value)
        return env, env.reward
    end
    return env, nothing
end

env = BlackjackEnv(player_value = 0, dealer_value = 0, usable_ace = false)






######################################
### simulations with greedy policy ###
######################################


# Run a simple simulation
RLBase.reset!(env)
action = 1  # First action: hit
env, reward = step!(env, action)
println("State after action: ", RLBase.state(env, Observation(), DefaultPlayer()))
println("Reward: $reward")

# Player chooses to stand
action = 0
env, reward = step!(env, action)


# Run multiple simulations
function run_simulations(num_simulations::Int)
    env = BlackjackEnv(player_value = 0, dealer_value = 0, usable_ace = false)
    total_reward = 0

    for i in 1:num_simulations
        RLBase.reset!(env)
        println("Simulation $i:")

        while !RLBase.is_terminated(env)
            # Define a simple policy: hit if player value < 20, otherwise stand
            action = env.player_value < 20 ? 1 : 0
            step!(env, action)
            println("Player value: $(env.player_value), Dealer value: $(env.dealer_value)")
        end

        println("Final Reward: $(RLBase.reward(env))\n")
        total_reward += RLBase.reward(env)
    end

    println("Total Reward after $num_simulations simulations: $total_reward")
    return total_reward
end

# Run 3 simulations
run_simulations(100)



# Define Q-Learning agent
function train_q_learning(env::BlackjackEnv, num_episodes::Int, α::Float64, γ::Float64, ϵ::Float64)
    # Initialize Q-table

    # Define state and action spaces
    state_Space = [(p, d, a) for p in 0:31, d in 0:31, a in [1, 0]]  # Player value, dealer value, usable ace
    action_Space = [0, 1]  # 0 = stand, 1 = hit
    Q = Dict((s, a) => 0.0 for s in state_Space, a in action_Space)

    # Training loop
    for episode in 1:num_episodes
        RLBase.reset!(env)
        state = RLBase.state(env, Observation(), DefaultPlayer())

        while !RLBase.is_terminated(env)
            # Choose action using epsilon-greedy
            if rand() < ϵ
                action = rand(action_Space)
            else
                action_values = [Q[(state, a)] for a in action_Space]
                action = action_Space[argmax(action_values)]
            end

            # Take action and observe next state and reward
            step!(env, action)
            next_state = RLBase.state(env, Observation(), DefaultPlayer())
            reward = RLBase.reward(env)

            # Update Q-value using Q-learning formula
            if !RLBase.is_terminated(env)
                Q[(state, action)] += α * (reward + γ * maximum([Q[(next_state, a)] for a in action_Space]) - Q[(state, action)])
            else
                Q[(state, action)] += α * (reward - Q[(state, action)])
            end

            state = next_state
        end
    end

    return Q
end



# Train the Q-learning agent
env = BlackjackEnv(player_value = 0, dealer_value = 0, usable_ace = false)
Q = train_q_learning(env, 10000, 0.1, 0.9, 0.1)

RLBase.state_space(env)



state_Space = RLBase.state_space(env)
action_Space = RLBase.action_space(env)
Q = Dict((s, a) => 0.0 for s in state_space, a in action_space)



# Define state and action spaces
state_Space = [(p, d, a) for p in 1:31, d in 1:31, a in [true, false]]  # Player value, dealer value, usable ace
action_Space = [0, 1]  # 0 = stand, 1 = hit

# Initialize Q-table
Q = Dict((state, action) => 0.0 for state in state_Space, action in action_Space)