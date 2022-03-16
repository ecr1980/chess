class Rook
  attr_accessor :player, :position, :token, :moved
  def initialize(player, position)
    @player = player
    @position = position
    @moved = false
    if player == 2
      @token = "\u2656"
    else
      @token = "\u265C"
    end
  end

  def valid_moves(game_board)
    valid_moves = Array.new()

    can_move = true
    change = 1
    until can_move == false do
      if position[0] + change > 7
        can_move = false
      elsif game_board[position[0] + change][position[1]].piece == nil
        valid_moves << [position[0] + change,position[1]]
        change += 1
      elsif game_board[position[0] + change][position[1]].piece.player != @player
        valid_moves << [position[0] + change,position[1]]
        change += 8
      else
        can_move = false
      end
    end

    can_move = true
    change = -1
    until can_move == false do
      if position[0] + change < 0
        can_move = false
      elsif game_board[position[0] + change][position[1]].piece == nil
        valid_moves << [position[0] + change,position[1]]
        change -= 1
      elsif game_board[position[0] + change][position[1]].piece.player != @player
        valid_moves << [position[0] + change,position[1]]
        change -= 8
      else
        can_move = false
      end
    end

    can_move = true
    change = 1
    until can_move == false do
      if position[1] + change > 7
        can_move = false
      elsif game_board[position[0]][position[1] + change].piece == nil
        valid_moves << [position[0],position[1] + change]
        change += 1
      elsif game_board[position[0]][position[1] + change].piece.player != @player
        valid_moves << [position[0],position[1] + change]
        change += 8
      else
        can_move = false
      end
    end

    can_move = true
    change = -1
    until can_move == false do
      if position[1]+change < 0
        can_move = false
      elsif game_board[position[0]][position[1] + change].piece == nil
        valid_moves << [position[0],position[1] + change]
        change -= 1
      elsif game_board[position[0]][position[1] + change].piece.player != @player
        valid_moves << [position[0],position[1] + change]
        change -= 8
      else
        can_move = false
      end
    end
    return valid_moves
  end



end