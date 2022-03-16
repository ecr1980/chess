class King
  attr_accessor :player, :position, :token. :moved
  def initialize(player, position)
    @player = player
    @position = position
    @moved = false
    if player == 2
      @token = "\u2654"
    else
      @token = "\u265A"
    end
  end

  def valid_moves(game_board)
    valid_moves = Array.new()
    check_array = [[@position[0] - 1,@position[1]+1],
                   [@position[0],@position[1]+1],
                   [@position[0] + 1,@position[1]+1],
                   [@position[0] - 1,@position[1]],
                   [@position[0] + 1,@position[1]],
                   [@position[0] - 1,@position[1]-1],
                   [@position[0],@position[1]-1],
                   [@position[0] + 1,@position[1]-1]]

    8.times do |index|
      if check_array[index][0] >= 0 && check_array[index][1] >=0
        if check_array[index][0] < 8 && check_array[index][1] < 8
          if game_board[check_array[index][0]][check_array[index][1]].piece == nil
            valid_moves << check_array[index]
          elsif game_board[check_array[index][0]][check_array[index][1]].piece.player != @player
            valid_moves << check_array[index]
          end
        end
      end
    end
    return valid_moves
  end

end