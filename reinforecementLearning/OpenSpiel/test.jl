using OpenSpiel

game= load_game("crazy_eights")
game= load_game("colored_trails")
game= load_game("coin_game")
game= load_game("bridge")

game= load_game("tic_tac_toe")


game= load_game("kuhn_poker")


game = load_game("blackjack")
game= load_game("hearts")


#start playing blackjack game 

game= load_game("blackjack")

game.new_initial_state()

State = new_initial_state(game)




#test run 



function run_once(name)
    game = load_game(name)
    state = new_initial_state(game)
    println("Initial state of game[$(name)] is:\n$(state)")

    while !is_terminal(state)
        if is_chance_node(state)
            outcomes_with_probs = chance_outcomes(state)
            println("Chance node, got $(length(outcomes_with_probs)) outcomes")
            actions, probs = zip(outcomes_with_probs...)
            action = actions[sample(weights(collect(probs)))]
            println("Sampled outcome: $(action_to_string(state, action))")
            apply_action(state, action)
        elseif is_simultaneous_node(state)
            chosen_actions = [rand(legal_actions(state, pid-1)) for pid in 1:num_players(game)]  # in Julia, indices start at 1
            println("Chosen actions: $([action_to_string(state, pid-1, action) for (pid, action) in enumerate(chosen_actions)])")
            apply_action(state, chosen_actions)
        else
            action = rand(legal_actions(state))
            println("Player $(current_player(state)) randomly sampled action: $(action_to_string(state, action))")
            apply_action(state, action)
        end
        println(state)
    end
    rts = returns(state)
    for pid in 1:num_players(game)
        println("Utility for player $(pid-1) is $(rts[pid])")
    end
end


run_once("tic_tac_toe")