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
player_value, usable_ace = 4, false
player_value, usable_ace = playerPolicy(player_value, usable_ace)
dealer_value, _, _ = dealerPolicy(dealer_value, false)
reward = calculate_reward(player_value, dealer_value)




println("Player Value: $player_value, Dealer Value: $dealer_value, Reward: $reward")




function train_q_learning(num_episodes::Int, α::Float64, γ::Float64, ϵ::Float64)
    # Initialize Q-table
    state_space = [(p, d, a, b) for p in 0:31, d in 0:31, a in (true, false), b in (true, false)]
    action_space = [0, 1]  # 0: Stick, 1: Hit
    Q = Dict((s, a) => 0.0 for s in state_space, a in action_space)
    for episode in 1:num_episodes
        Player_value = giveCard() + giveCard()
        Dealer_value = giveCard() + giveCard()
        Usable_aceP = false
        Usable_aceD = false
        reward = 0
        is_done= false 

        state = (Player_value, Dealer_value, Usable_aceP, Usable_aceD)
        while !is_done

            if rand() < ϵ
                action = rand(action_space)  # Random action (exploration)
            else
                action_values = [Q[(state, a)] for a in action_space]
                action = action_space[argmax(action_values)]  # Greedy action (exploitation)
            end

            if action == 1 #Hit 
                Player_value, Usable_aceP = playerPolicy(Player_value, Usable_aceP)
                Dealer_value, Usable_aceD = dealerPolicy(Dealer_value, Usable_aceD)
                reward += calculate_reward(Player_value, Dealer_value)
            else 
                Dealer_value, Usable_aceD = dealerPolicy(Dealer_value, Usable_aceD)
                reward += calculate_reward(Player_value, Dealer_value)
                is_done = true
            end
            new_state = (Player_value, Dealer_value, Usable_aceP, Usable_aceD)

            #Q-learner update
            if !is_done 
                Q[(state, action)] += α * (reward + γ* maximum([Q[(new_state, a)] for a in action_space]) - Q[(state, action)])
            else
                Q[(state, action)] += α * (reward - Q[(state, action)])
            end

            state = new_state
        end
    end
    return Q
end

results = train_q_learning(100000, 0.1, 0.9, 0.1)

using Plots

function plot_policy(Q, usable_aceP::Bool, usable_aceD::Bool)
    player_values = 4:31
    dealer_values = 4:31
    action_space = [0, 1]  # 0: Stick, 1: Hit

    policy = zeros(Int, length(player_values), length(dealer_values))

    for (i, p) in enumerate(player_values)
        for (j, d) in enumerate(dealer_values)
            state = (p, d, usable_aceP, usable_aceD)
            qvals = [get(Q, (state, a), 0.0) for a in action_space]
            policy[i, j] = argmax(qvals) - 1  # 0: Stick, 1: Hit
        end
    end

    heatmap(
        dealer_values, player_values, policy;
        xlabel="Dealer Showing", ylabel="Player Sum",
        title="Policy (Usable Ace: $usable_aceP)",
        yticks=player_values, xticks=dealer_values,
        colorbar=true, c=:blues, clims=(0,1)
    )

end
plot_policy(results, true, true)
plot_policy(results, false, false)
plot_policy(results, true, false)
plot_policy(results, false, true)