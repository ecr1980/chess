class Game_Piece

  attr_accessor :player, :position

  def initialize(player, position)
    @player = player
    @position = position
  end

end

class Pawn < Game_Piece

end

class King < Game_Piece

end

class Queen < Game_Piece

end

class Bishop < Game_Piece
  
end

class Knight < Game_Piece

end

class Rook < Game_Piece

end

class GameBoard < Game_Piece

end