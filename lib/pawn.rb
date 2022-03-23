class Pawn 
  attr_accessor :player, :position, :token, :moved
  def initialize(player, position)
    @player = player
    @position = position
    @moved = false
    if player == 2
      @token = "\u2659"
    else
      @token = "\u265F"
    end
  end

  def valid_moves(game_board)
    if @player == 1
      direction = -1
    else
      direction = 1
    end
    valid_moves = Array.new()
    is_open = false

    if @position[0] + direction < 8 && @position[0] + direction >= 0
      if game_board[@position[0] + direction][@position[1]].piece == nil
        valid_moves << [@position[0] + direction, @position[1]]
        is_open = true
      end

      if @position[1] + 1 < 8
        if game_board[@position[0] + direction][@position[1] + 1].piece && game_board[@position[0] + direction][@position[1] + 1].piece.player != @player
          valid_moves << [@position[0] + direction, @position[1] + 1]
        end
      end

      if @position[1] - 1 >= 0
        if game_board[@position[0] + direction][@position[1] - 1].piece && game_board[@position[0] + direction][@position[1] - 1].piece.player != @player
          valid_moves << [@position[0] + direction, @position[1] - 1]
        end
      end
    end

    if is_open == true && @moved == false
      if game_board[@position[0] + (direction * 2)][@position[1]].piece == nil && @moved == false
        valid_moves << [@position[0] + (direction * 2), @position[1]]
      end
    end
    return valid_moves.compact
  end      

end

