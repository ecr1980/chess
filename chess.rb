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