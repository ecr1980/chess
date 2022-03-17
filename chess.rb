require 'rainbow'
require './lib/king'
require './lib/queen'
require './lib/bishop'
require './lib/knight'
require './lib/rook'
require './lib/pawn'
#require './lib/ai'


class Game_Board

  attr_accessor :game_board

  def initialize(selection)
    @selection = selection
    @game_board = Array.new(8) { Array.new(8)}
    board_color = 1
  #  2.times do |index|
    #  if @selection[index] == 'ai'
     #   @selection[index] = AI.new(index + 1)
    #  end
   # end
    8.times do |x_index|
      8.times do |y_index|
        @game_board[x_index][y_index] = BoardLoc.new()
        board_color += 1
      end
    end
    player_setup()
  end

  def display
    puts "#{@player_1_captured_nobals.join(' ')}"
    puts "#{@player_1_captured_pawns.join(' ')}"
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
    puts "#{@player_2_captured_nobals.join(' ')}"
    puts "#{@player_2_captured_pawns.join(' ')}"


  end

  def player_setup
    #The player_x_pieces array are to keep track of what pieces there are.
    @player_1_pieces = [[7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7]]
    @player_2_pieces = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]]
    @p_1_king = [7,4]
    @p_2_king = [0,4]
    @player_1_captured_nobals = Array.new()
    @player_2_captured_nobals = Array.new()
    @player_1_captured_pawns = Array.new()
    @player_2_captured_pawns = Array.new()
    8.times do |index|
      @game_board[6][index].new_piece(1, "pawn", [6,index])
      @game_board[1][index].new_piece(2, "pawn", [1,index])
    end
    @game_board[7][0].new_piece(1, "rook", [7,0])
    @game_board[7][1].new_piece(1, "knight", [7,1]) 
    @game_board[7][2].new_piece(1, "bishop", [7,2]) 
    @game_board[7][3].new_piece(1, "queen", [7,3]) 
    @game_board[7][4].new_piece(1, "king", [7,4]) 
    @game_board[7][5].new_piece(1, "bishop", [7,5]) 
    @game_board[7][6].new_piece(1, "knight", [7,6])
    @game_board[7][7].new_piece(1, "rook", [7,7])  
    @game_board[0][0].new_piece(2, "rook", [0,0])
    @game_board[0][1].new_piece(2, "knight", [0,1])
    @game_board[0][2].new_piece(2, "bishop", [0,2]) 
    @game_board[0][3].new_piece(2, "queen", [0,3])
    @game_board[0][4].new_piece(2, "king", [0,4]) 
    @game_board[0][5].new_piece(2, "bishop", [0,5]) 
    @game_board[0][6].new_piece(2, "knight", [0,6]) 
    @game_board[0][7].new_piece(2, "rook", [0,7])
  end

  def move(player,current_loc,new_loc)
    if @game_board[current_loc[0]][current_loc[1]].piece == nil
      puts "Your piece selection didn't have a piece."
      return false
    end
    if player != @game_board[current_loc[0]][current_loc[1]].piece.player
      puts "You can't move your opponent's piece."
      return false
    end
    if @game_board[current_loc[0]][current_loc[1]].piece.valid_moves(@game_board).include?(new_loc)
      move_mechanics(player,current_loc,new_loc)
    else
      puts "You are unable to move there, try again." 
      return false
    end
  end

  def move_mechanics(player,current_loc,new_loc)
    update_player_array(player,current_loc,new_loc)
    @game_board[current_loc[0]][current_loc[1]]
    @game_board[current_loc[0]][current_loc[1]].piece.position = new_loc
    if (@game_board[current_loc[0]][current_loc[1]].piece.is_a? Pawn) || (@game_board[current_loc[0]][current_loc[1]].piece.is_a? King) || (@game_board[current_loc[0]][current_loc[1]].piece.is_a? Rook)
      @game_board[current_loc[0]][current_loc[1]].piece.moved = true
    end

    if @game_board[new_loc[0]][new_loc[1]].piece != nil
      captured(player,new_loc)
    end
    @game_board[new_loc[0]][new_loc[1]] = @game_board[current_loc[0]][current_loc[1]]
    @game_board[current_loc[0]][current_loc[1]] = BoardLoc.new
  end

  def update_player_array(player,current_loc,new_loc)
    if player == 1
      @player_1_pieces.delete(current_loc)
      @player_1_pieces << new_loc
    else
      @player_2_pieces.delete(current_loc)
      @player_2_pieces << new_loc
    end
  end

  def captured(player,loc,temp_piece = nil)
    if player == 1
      if @game_board[loc[0]][loc[1]].is_a? Pawn
        @player_2_captured_pawns << @game_board[loc[0]][loc[1]].piece.token
      else
        @player_2_captured_nobals << @game_board[loc[0]][loc[1]].piece.token
      end
      @player_2_pieces.delete(loc)
    else
      if @game_board[loc[0]][loc[1]].is_a? Pawn
        @player_1_captured_pawns << @game_board[loc[0]][loc[1]].piece.token
      else
        @player_1_captured_nobals << @game_board[loc[0]][loc[1]].piece.token
      end
      @player_1_pieces.delete(loc)
    end

  end

  def in_check?(player)
    if player == 1
      @player_2_pieces.length.times do |index|
        if @game_board[@player_2_pieces[index][0]][@player_2_pieces[index][1]].piece.valid_moves(@game_board).include?(@p_1_king)
          return true
        end
      end
    elsif player == 2
      @player_1_pieces.length.times do |index|
        if @game_board[@player_1_pieces[index][0]][@player_1_pieces[index][1]].piece.valid_moves(@game_board).include?(@p_2_king)
          return true
        end
      end
    end
    return false
  end

  def checkmate?(player)
    if player == 1
      other_player = 2
    else
      other_player = 1
    end

    if in_check?(other_player)
      if player == 1
        return will_check?(2)
      else
        return will_check(1)
      end
    end
  end

  def will_check(player)
    in_check = true
    if player == 1
      player_1_pieces.length.times do |i|
        @game_board[@player_1_pieces[index][0]][@player_1_pieces[index][1]].piece.valid_moves.length.times do |j|
          temp_game_board = @game_board.dup
          temp_game_board.move(player,player_1_pieces[i], @game_board[@player_1_pieces[index][0]][@player_1_pieces[index][1]].piece.valid_moves[j])
          if temp_game_board.in_check?(1) == false
            in_check = false
          end
        end
      end
    else
      player_2_pieces.length.times do |i|
        @game_board[@player_2_pieces[index][0]][@player_2_pieces[index][1]].piece.valid_moves.length.times do |j|
          temp_game_board = @game_board.dup
          temp_game_board.move(player,player_2_pieces[i], @game_board[@player_2_pieces[index][0]][@player_2_pieces[index][1]].piece.valid_moves[j])
          if temp_game_board.in_check?(2) == false
            in_check = false
          end
        end
      end
    end
    return in_check
  end

  def turn(player)
    if @selection[player - 1] == 'ai'                     #selection array holds human/ai player info
      if player == 1                                        #if AI, array value is object AI.
        ai_turn(player, @player_1_pieces)   
      else
        ai_turn(player, @player_2_pieces)   
      end
    else
      human_turn(player)
    end
  end

  def human_turn(player)
    puts "Player #{player}, it is your turn."
    if in_check?(player)
      puts Rainbow("You are in check! You must fix this.").yellow
    end
    continue = false
    while continue == false
      entered_piece = false
      entered_move = false
      while entered_piece == false
        puts "Please enter the piece you want to move."
        entered_piece = gets.chomp
        entered_piece = move_conversion(entered_piece)
      end
      #The move_conversion changes the on screen grid option to proper array
      while entered_move == false
        puts "Please enter the new location."
        entered_move = gets.chomp
        entered_move = move_conversion(entered_move)
      end
      continue = move(player,entered_piece,entered_move)
      if checkmate?(player)
        return false
      end
    end
  end

  def ai_turn(player, pieces)
    move = false
    pick = Array.new(2)
    #if player == 1
      while move == false
        pick = pieces[rand(pieces.length)]
        if @game_board[pick[0]][pick[1]].piece.valid_moves(@game_board).length > 0
          move = @game_board[pick[0]][pick[1]].piece.valid_moves(@game_board)[rand(@game_board[pick[0]][pick[1]].piece.valid_moves(@game_board).length)]
        end
      end
    #end

    #if player == 2
      #while move == false
       # pick = @player_2_pieces[rand(@player_2_pieces.length)]
        #if @game_board[pick[0]][pick[1]].valid_moves
         # move = @game_board[pick[0]][pick[1]].valid_moves[rand.(@game_board[pick[0]][pick[1]].valid_moves.length)]
        #end
      #end
    #end
    sleep(1)
    move_mechanics(player,pick,move)
  end

  #class AI

   # def initialize(player)
    #  @player = player
    #end
    
    #def ai_turn(player, pieces, board)
     # move = false
      #pick = Array.new(2)
      #if player == 1
       # while move == false
        #  pick = pieces[rand(pieces.length)]
         # if board[pick[0]][pick[1]].piece.valid_moves(board).length > 0
          #  move = board[pick[0]][pick[1]].piece.valid_moves(board)[rand(board[pick[0]][pick[1]].piece.valid_moves(board).length)]
          #end
        #end
      #end

      #if player == 2
        #while move == false
         # pick = @player_2_pieces[rand(@player_2_pieces.length)]
          #if @game_board[pick[0]][pick[1]].valid_moves
           # move = @game_board[pick[0]][pick[1]].valid_moves[rand.(@game_board[pick[0]][pick[1]].valid_moves.length)]
          #end
        #end
      #end
      #sleep(1)
      #move_mechanics(player,board[pick[0]][pick[1]],move)
    #end
    
  #end
end

class BoardLoc
 attr_accessor :display, :piece
  def initialize()
    @token = nil
    @display = "   "
    @piece = nil
  end

  def new_piece(player, type, loc)
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
end

#def turn(player,board)
 # puts "Player #{player}, it is your turn."
  #if board.in_check?(player)
   # puts Rainbow("You are in check! You must fix this.").yellow
  #end
 # continue = false
 # while continue == false
  #  entered_piece = false
   # entered_move = false
    #while entered_piece == false
     # puts "Please enter the piece you want to move."
      #entered_piece = gets.chomp
      #entered_piece = move_conversion(entered_piece)
#    end
 #   #The move_conversion changes the on screen grid option to proper array
  #  while entered_move == false
   #   puts "Please enter the new location."
    #  entered_move = gets.chomp
     # entered_move = move_conversion(entered_move)
    #end
    #continue = board.move(player,entered_piece,entered_move)
    #if board.checkmate?(player)
     # return false
    #end
  #end
#end

def move_conversion(loc)
  loc = loc.chars
  return_array = letter_conversion(loc)
  if return_array.include?(nil) || return_array[0] > 7
    puts "Please reference the game board for valid locations."
    return false
  end
  return return_array  
end

def letter_conversion(letter)
  value = Array.new(2)
  2.times do |i|
    case letter[i].downcase
    when '1'
      value[0] = 7
    when '2'
      value[0] = 6
    when '3'
      value[0] = 5
    when '4'
      value[0] = 4
    when '5'
      value[0] = 3
    when '6'
      value[0] = 2
    when '7'
      value[0] = 1
    when '8'
      value[0] = 0
    when 'a'
      value[1] = 0
    when 'b'
      value[1] = 1
    when 'c'
      value[1] = 2
    when 'd'
      value[1] = 3
    when 'e'
      value[1] = 4
    when 'f'
      value[1] = 5
    when 'g'
      value[1] = 6
    when 'h'
      value[1] = 7
    else
      value[0] = 8
    end
  end

  return value
end
  

def game_loop(game)
  player = 1
  while true
    game.display
    game.turn(player)  
    if player == 1
      player = 2
    else
      player = 1
    end
  end
end
  

def game()
  puts "Welcome to Chess."
  puts "Would you like to play:"
  puts "1. Human vs Human"
  puts "2. Human vs AI"
  puts "3. AI vs Human"
  puts "4. AI vs AI"
  selection = false
  while selection == false
    selection = select_player(gets.chomp)
  end
  game = Game_Board.new(selection)
  game_loop(game)
end

def select_player(selection)
  players = Array.new(2)
  case selection
  when '1'
    players = ['human', 'human']
  when '2'
    players = ['human', 'ai']
  when '3'
    players = ['ai', 'human']
  when '4'
    players = ['ai', 'ai']
  else
    puts "Please select 1 through 4."
    return false
  end
  return players
end

game()
