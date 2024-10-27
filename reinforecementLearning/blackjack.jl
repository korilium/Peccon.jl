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


#dealers policy 
function dealerPolicy(current_value::Int, usable_ace, end_game::Bool=false) 
    if current_value > 21
        if usable_ace ==true
            current_value -= 10
            usable_ace = false 
        else 
            return current_value, usable_ace, true
        end 
    end 

    if current_value >= 17
        return current_value, usable_ace, true
    else
        card = giveCard()
        if card == 1
            if current_value <= 10
                return current_value +11, true, false
            else 
                return current_value +1, true, false 
            end 
        else
            return current_value + card, usable_ace, false 
        end 
    end 
end 

#check if policy works properly
dealer_value, ace, end_game = dealerPolicy(dealer_value,ace)
 ace = false
dealer_value = 0

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

#check if policy works properly 
player_value, ace = playerPolicy(player_value, ace)
ace = false 
player_value =0 


function giveCredit(start, player_value::Int,player_state_value,  dealer_value::Int, dealer_state_value)
    if start == true
        player_win = 0
        player_draw = 0
        player_state_value = []
        dealer_state_value = []
    else
        if player_value > 21
            if dealer_value >= 21
                # Draw
                player_draw += 1
            end
        elseif dealer_value > 21
            # Player wins
            push!(player_state_value, 1) 
        elseif player_value > dealer_value
            # Player wins
            push!(player_state_value, 1) 
        elseif player_value < dealer_value
            # No change to player_win or player_draw
        else
            # Draw
            push!(player_state_value, 0) 
        end
    end

    return player_state_value
end

giveCredit(false, 19,[],  17,[])


#make a simulation 

dealer_value = 0 
player_value = 0 
show_card = 0 


#dealers turn 
dealer_value = giveCard()
show_card = dealer_value 
dealer_value += giveCard()

# players turn 
usable_ace = false 


player_value = playerPolicy(player_value, false)[1]
player_value = playerPolicy(player_value, false)[1]




########################################
##### implement blackjack in julia #####
######################################## 

using ReinforcementLearning

Base.@kwdef mutable struct BlackjackEnv 
    reward::Union{Nothing, Int} = nothing
end



RLBase.action_space(env::BlackjackEnv) = [giveCard(), 0]

# setting up interaction between action and state space 
RLBase.reward(env::BlackjackEnv)  = env.reward

RLBase.state(env::BlackjackEnv, ::Observation, ::DefaultPlayer) = !isnothing(env.reward) 

RLBase.state_space(env::BlackjackEnv) =   [false, true, []]

RLBase.is_terminated(env::BlackjackEnv) = !isnothing(env.reward)

RLBase.reset!(env::BlackjackEnv) = env.reward = nothing
