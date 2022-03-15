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

  def move_valid?(player, current_loc, new_loc)
    if player == 1
      x = -1
      y = -2
    else
      x = 1
      y = 2
    end
    if player != @player
      return false
    elsif new_loc[0] == current_loc[0] + x && new_loc[1] == current_loc[1]
      return true
    elsif @moved == false
      if new_loc[0] == current_loc[0] + y && new_loc[1] == current_loc[1]
        return true
      else
        return false
      end
    else
      return false
    end
  end

      
        

end