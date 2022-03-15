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

end