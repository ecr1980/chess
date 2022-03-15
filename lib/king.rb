class King
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 2
      @token = "\u2654"
    else
      @token = "\u265A"
    end
  end

  def move_valid?(player, current_loc, new_loc)
    if player != @player
      return false
    else
      if current_loc[0] == new_loc[0] && current_loc[1] +1 == new_loc[1]
        return true
      elsif current_loc[0] == new_loc[0] && current_loc[1] -1 == new_loc[1]
        return true
      elsif current_loc[0]+1 == new_loc[0] && current_loc[1] +1 == new_loc[1]
        return true
      elsif current_loc[0]+1 == new_loc[0] && current_loc[1] -1 == new_loc[1]
        return true
      elsif current_loc[0]-1 == new_loc[0] && current_loc[1] +1 == new_loc[1]
        return true
      elsif current_loc[0]-1 == new_loc[0] && current_loc[1] -1 == new_loc[1]
        return true
      elsif current_loc[0]+1 == new_loc[0] && current_loc[1] == new_loc[1]
        return true
      elsif current_loc[0]-1 == new_loc[0] && current_loc[1] == new_loc[1]
        return true
      else
        return false
      end
    end
  end

end