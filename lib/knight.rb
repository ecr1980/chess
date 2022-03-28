#require './chess'

class Knight
  attr_accessor :player, :position, :token, :name
  def initialize(player, position)
    @player = player
    @position = position
    @name = "Knight"
    if player == 2
      @token = "\u2658"
    else
      @token = "\u265E"
    end
  end

  def deep_moves(game_board,future_move)
    deep_moves = Array.new()
    original_position = @position
    @position = future_move
    self.valid_moves(game_board).length.times do |index|
      deep_moves << self.valid_moves(game_board)[index]
    end
    @position = original_position
    return deep_moves.compact
  end

  def valid_moves(game_board)
    valid_moves = Array.new()
    can_move = [[position[0]+1,position[1]+2],
                [position[0]+1,position[1]-2],
                [position[0]-1,position[1]+2],
                [position[0]-1,position[1]-2],
                [position[0]+2,position[1]+1],
                [position[0]+2,position[1]-1],
                [position[0]-2,position[1]+1],
                [position[0]-2,position[1]-1]]
    8.times do |index|
      if can_move[index][0] < 8 && can_move[index][0] >= 0
        if can_move[index][1] < 8 && can_move[index][1] >= 0
           if game_board[can_move[index][0]][can_move[index][1]].piece == nil
            valid_moves << can_move[index]
           elsif game_board[can_move[index][0]][can_move[index][1]].piece.player != @player
            valid_moves << can_move[index]
          end
        end
      end
    end
    return valid_moves.compact
  end
end