class Knight
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 2
      @token = "\u2658"
    else
      @token = "\u265E"
    end
  end

end