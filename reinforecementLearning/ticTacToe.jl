#ticTacToe game adap environemtn

using ReinforcementLearning


# issue with current environemnt 


env = TicTacToeEnv()

state(env)


policy = RandomPolicy()


run(policy, env, )


## remake envionemtn to see where the problem is 


mutable struct TicTacToe2Env <: AbstractEnv 
    board::BitArray{3}
    player::Player 
end

function TicTacToe2Env()
    board = BitArray{3}(under, 3, 3, 3) 
    fill!(board, false) 
    board[:,:,1] .= true
    TicTacToe2Env(board, Player(:Cross))
end 


struct TicTacToe2Info 
    is_terminated::Bool
    winner::Union{Nothing, Symbol}
end 



const TIC_TAC_TOE2_STATE_INFO = Dict{
    TicTacToe2Env, 
    NamedTuple{
        (:index, :is_terminated, :winner), 
        Tuple{Int, Bool, Union{Nothing, Player}},
        }, 
}()


#redefine function to use in enviornment 
Base.hash(env::TicTacToe2Env, h::UInt) = hash(env.board, h)

Base.isequal(a::TicTacToe2Env, b::TicTacToe2Env) = isequal(a.board, b.board) 

Base.to_index(::TicTacToe2Env, player::Player) = Player == Player(:Cross) ? 2 : 3


RLBase.action_space(::TicTacToe2Env, player::Player) = Base.oneTo(9)

RLBase.legal_action_space(env::TicTacToe2Env, player::Player) = findall(legal_action_space_mask2(env))

function legal_action_space_mask2(env::TicTacToe2Env, player::Player)
    if is_win(env, Player(:Cross)) || is_win(env, Player(:Nought))
        falses(9)
    else 
        vec(env.board[:,:,1])
    end 
end 


RLBase.act!(env::TicTacToe2Env, action::Int) = RLBase.act!(env, CartesianIndices((3,3))[action])



function RLBase.act!(env::TicTacToe2Env, action::CartesianIndex{2})
    env.board[action, 1] = false 
    env.board[action, base.to_index(env, current_player(env))] = true 
end 







