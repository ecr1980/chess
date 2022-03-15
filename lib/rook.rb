class Rook
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 2
      @token = "\u2656"
    else
      @token = "\u265C"
    end
  end

  def valid_moves
    valid_moves = Array.new()
    can_move = true
    until can_move == false
      change = 1
      if position[0]+change > 7
        can_move = false
      elsif game_board[(position[0]+change),position[1]].piece == nil
        valid_moves << game_board[(position[0]+change),position[1]]
        change += 1
      elsif game_board[(position[0]+change),position[1]].piece.player != @player
        valid_moves << game_board[(position[0]+change),position[1]]
        change += 8
      else
        can_move = false
      end
    end
    can_move = true
    until can_move == false
      change = -1
      if position[0]+change < 0
        can_move = false
      elsif game_board[(position[0]+change),position[1]].piece == nil
        valid_moves << game_board[(position[0]+change),position[1]]
        change -= 1
      elsif game_board[(position[0]+change),position[1]].piece.player != @player
        valid_moves << game_board[(position[0]+change),position[1]]
        change -= 8
      else
        can_move = false
      end
      can_move = true
    until can_move == false
      change = 1
      if position[0]+change > 7
        can_move = false
      elsif game_board[position[0],(position[1]+change)].piece == nil
        valid_moves << game_board[position[0],(position[1]+change)]
        change += 1
      elsif game_board[position[0],(position[1]+change)].piece.player != @player
        valid_moves << game_board[position[0],(position[1]+change)]
        change += 8
      else
        can_move = false
      end
    end
    can_move = true
    until can_move == false
      change = -1
      if position[0]+change < 0
        can_move = false
      elsif game_board[position[0],(position[1]+change)].piece == nil
        valid_moves << game_board[position[0],(position[1]+change)]
        change -= 1
      elsif game_board[position[0],(position[1]+change)].piece.player != @player
        valid_moves << game_board[position[0],(position[1]+change)]
        change -= 8
      else
        can_move = false
      end
    end



end