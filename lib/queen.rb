class Queen
  attr_accessor :player, :position, :token, :name
  def initialize(player, position)
    @player = player
    @position = position
    @name = "Queen"
    if player == 2
      @token = "\u2655"
    else
      @token = "\u265B"
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

    #diag both up
    can_move = true
    change = 1
    until can_move == false do
      if position[0] + change > 7 || position[1] + change > 7
        can_move = false
      elsif game_board[position[0] + change][position[1] + change].piece == nil
        valid_moves << [position[0] + change,position[1] + change]
        change += 1
      elsif game_board[position[0] + change][position[1] + change].piece.player != @player
        valid_moves << [position[0] + change,position[1] + change]
        change += 8
      else
        can_move = false
      end
    end

    #diag both down
    can_move = true
    change = -1
    until can_move == false do
      if position[0] + change < 0 || position[1] + change < 0
        can_move = false
      elsif game_board[position[0] + change][position[1] + change].piece == nil
        valid_moves << [position[0] + change,position[1] + change]
        change -= 1
      elsif game_board[position[0] + change][position[1] + change].piece.player != @player
        valid_moves << [position[0] + change,position[1] + change]
        change -= 8
      else
        can_move = false
      end
    end

    #diag up/left
    can_move = true
    change = 1
    until can_move == false do
      if position[1] + change > 7 || position[0] - change < 0
        can_move = false
      elsif game_board[position[0] - change][position[1] + change].piece == nil
        valid_moves << [position[0] - change,position[1] + change]
        change += 1
      elsif game_board[position[0] - change][position[1] + change].piece.player != @player
        valid_moves << [position[0] - change,position[1] + change]
        change += 8
      else
        can_move = false
      end
    end

    #diag up/right
    can_move = true
    change = -1
    until can_move == false do
      if position[1]+change < 0 || position[0] - change > 7
        can_move = false
      elsif game_board[position[0] - change][position[1] + change].piece == nil
        valid_moves << [position[0] - change,position[1] + change]
        change -= 1
      elsif game_board[position[0] - change][position[1] + change].piece.player != @player
        valid_moves << [position[0] - change,position[1] + change]
        change -= 8
      else
        can_move = false
      end
    end

    #diag
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
      if position[1] + change < 0
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

    return valid_moves.compact
  end

end