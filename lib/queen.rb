class Queen
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 2
      @token = "\u2655"
    else
      @token = "\u265B"
    end
  end

end