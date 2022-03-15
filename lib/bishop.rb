class Bishop
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 2
      @token = "\u2657"
    else
      @token = "\u265D"
    end
  end
  
end