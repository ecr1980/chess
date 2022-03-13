require 'rainbow'

class Game_Piece

  attr_accessor :player, :position

  def initialize(player, position)
    @player = player
    @position = position
  end

  def move(new_position)
    unless check_move(@position, new_position)
      return false
    end
    take_piece?(new_position)
    @position = new_position
  end

end

class Pawn 
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2659"
    else
      token = "\u265F"
    end
  end

end

class King < Game_Piece
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2654"
    else
      token = "\u265A"
    end
  end

end

class Queen < Game_Piece
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2655"
    else
      token = "\u265B"
    end
  end

end

class Bishop < Game_Piece
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2657"
    else
      token = "\u265D"
    end
  end
  
end

class Knight < Game_Piece
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2658"
    else
      token = "\u265E"
    end
  end

end

class Rook < Game_Piece
  attr_accessor :player, :position, :token
  def initialize(player, position)
    @player = player
    @position = position
    if player == 1
      token = "\u2656"
    else
      token = "\u265C"
    end
  end

end

class Game_Board

  def initialize
    @game_board = Array.new(8) { Array.new(8)}
    board_color = 1
    8.times do |x_index|
      8.times do |y_index|
        @game_board[x_index][y_index] = BoardLoc.new()
        board_color += 1
      end
    end
    player_setup()
  end

  def display
    8.times do |x_index|
      if x_index.even?
        color_a = :white
        color_b = :black
      else
        color_a = :black
        color_b = :white
      end
      puts " " + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b)
      puts " " + Rainbow("  #{@game_board[x_index][0].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][1].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][2].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][3].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][4].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][5].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][6].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][7].display} ").bg(color_b)
      puts " " + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b)
    end
  end

  def player_setup

end

class BoardLoc
 attr_accessor :display, :piece
  def initialize()
    @token = " "
    @display = " #{@token} "
    @piece = nil
  end
end

start = Game_Board.new()
start.display