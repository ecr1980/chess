require 'rainbow'
require './lib/king'
require './lib/queen'
require './lib/bishop'
require './lib/knight'
require './lib/rook'
require './lib/pawn'


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
    puts "      A     B     C     D     E     F     G     H"
    8.times do |x_index|
      if x_index.even?
        color_a = :blue
        color_b = :black
      else
        color_a = :black
        color_b = :blue
      end
      puts "   " + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b)
      puts " #{8-x_index} " + Rainbow("  #{@game_board[x_index][0].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][1].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][2].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][3].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][4].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][5].display} ").bg(color_b) + Rainbow("  #{@game_board[x_index][6].display} ").bg(color_a) + Rainbow("  #{@game_board[x_index][7].display} ").bg(color_b)
      puts "   " + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b) + Rainbow("      ").bg(color_a) + Rainbow("      ").bg(color_b)
    end
  end

  def player_setup
    @game_board[7][0].piece(1, "rook", [7,0])
    @game_board[7][1].piece(1, "knight", [7,1]) 
    @game_board[7][2].piece(1, "bishop", [7,2]) 
    @game_board[7][3].piece(1, "queen", [7,3]) 
    @game_board[7][4].piece(1, "king", [7,4]) 
    @game_board[7][5].piece(1, "bishop", [7,5]) 
    @game_board[7][6].piece(1, "knight", [7,6]) 
    @game_board[7][7].piece(1, "rook", [7,7])  
    @game_board[0][0].piece(2, "rook", [0,0])
    @game_board[0][1].piece(2, "knight", [0,1]) 
    @game_board[0][2].piece(2, "bishop", [0,2]) 
    @game_board[0][3].piece(2, "queen", [0,3]) 
    @game_board[0][4].piece(2, "king", [0,4]) 
    @game_board[0][5].piece(2, "bishop", [0,5]) 
    @game_board[0][6].piece(2, "knight", [0,6]) 
    @game_board[0][7].piece(2, "rook", [0,7])
    8.times do |index|
      @game_board[6][index].piece(1, "pawn", [6,index])
      @game_board[1][index].piece(2, "pawn", [2,index])
    end
  end

  def move(player,current_loc,new_loc)
    move = false
    while move == false
     if @game_board[current_loc[0]][current_loc[1]].move_valid?(player,current_loc,new_loc)
      move = true
     end
    end
    @game_board[new_loc[0]][new_loc[1]] = @game_board[current_loc[0]][current_loc[1]]
    if @game_board[new_loc[0]][new_loc[1]].is_a? Pawn
      @game_board[new_loc[0]][new_loc[1]].moved = true
    end
    @game_board[current_loc[0]][current_loc[1]] = BoardLoc.new
  end


end

class BoardLoc
 attr_accessor :display, :piece
  def initialize()
    @token = nil
    @display = "   "
    @piece = nil
  end

  def piece(player, type, loc)
    case type
    when "pawn"
      @piece = Pawn.new(player, loc)
    when "king"
      @piece = King.new(player, loc)
    when "queen"
      @piece = Queen.new(player, loc)
    when "knight"
      @piece = Knight.new(player, loc)
    when "bishop"
      @piece = Bishop.new(player, loc)
    when "rook"
      @piece = Rook.new(player, loc)
    end
    @token = @piece.token
    @display = " #{@token} "
  end

  def move_valid?(player, current_loc, new_loc)
    @piece.move_valid?(player, current_loc, new_loc)
  end

end

def turn(board)
  puts "Please enter the piece you want to move."
  puts "it doesnt matter, I'm just testing a thing."
  move = gets.chomp
  board.move(1, [7,4], [6,4])
end
  
start = Game_Board.new()
start.display
turn(start)
start.display