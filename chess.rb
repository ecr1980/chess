require 'json'
require 'rainbow'
require './lib/king'
require './lib/queen'
require './lib/bishop'
require './lib/knight'
require './lib/rook'
require './lib/pawn'


class Game_Board

  attr_accessor :game_board, :player_1_pieces, :player_2_pieces, :player_1_captured_nobals,
  :player_2_captured_nobals, :player_1_captured_pawns, :player_2_captured_pawns, :p_1_king,
  :p_2_king, :turn_counter, :en_passant_decay, :selection

  def initialize(selection)
    @selection = selection
    @game_board = Array.new(8) { Array.new(8)}
    @turn_counter = -0.5
    @en_passant_decay = 0.0
    board_color = 1
    8.times do |x_index|
      8.times do |y_index|
        @game_board[x_index][y_index] = BoardLoc.new()
        board_color += 1
      end
    end
    if selection == "continue"
      load('autosave')
    elsif selection == "load"
      load_menu()
    else
      player_setup()
    end
  end

  def save(filename = "autosave")
    save_player_1_pieces = Array.new
    save_player_2_pieces = Array.new
    save_game_status = {:player_1_pieces=>@player_1_pieces, :player_2_pieces=>@player_2_pieces,
                 :player_1_captured_nobals=>@player_1_captured_nobals, :player_2_captured_nobals=>@player_2_captured_nobals,
                 :player_1_captured_pawns=>@player_1_captured_pawns, :player_2_captured_pawns=>player_2_captured_pawns, 
                 :p_1_king=>@p_1_king, :p_2_king=>@p_2_king, :turn_counter=>@turn_counter, :en_passant_decay=>@en_passant_decay,
                 :selection=>@selection}.to_json
    2.times do |player|  
      if player == 0
        player_pieces = @player_1_pieces
      else
        player_pieces = @player_2_pieces
      end          
      player_pieces.length.times do |index|
        if (@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.is_a? Pawn) ||
           (@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.is_a? Rook) ||
           (@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.is_a? King)

          save_player_1_pieces << {:name=>@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.name, :player=>(player + 1), :position=>player_pieces[index],
                                   :moved=>@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.moved}.to_json
        else
          save_player_1_pieces << {:name=>@game_board[player_pieces[index][0]][player_pieces[index][1]].piece.name, :player=>(player + 1), :position=>player_pieces[index]}.to_json
        end
      end
    end
    
    file = File.open("save_files/#{filename}.txt","w")
    file.puts save_game_status
    file.puts save_player_1_pieces
    file.puts save_player_2_pieces
    file.close
    return true
  end

  def load_menu
    puts "Please enter a file name you wish you load, or exit to return."
    file_list = Dir.children("save_files")
    file_list.length.times do |i|
      file_list[i].slice! ".txt"
      puts file_list[i]
    end
    file_name = gets.downcase.chomp
    unless (File.exist?("save_files/#{file_name}.txt"))
      p file_name
      puts "#{file_name}.txt"
      return false
    end
    load(file_name)
  end


  def load(filename = "autosave")
    file = File.open("save_files/#{filename}.txt", "r")
    save_game_status = file.readline
    save_game_status = JSON.parse(save_game_status).to_hash
    @player_1_pieces = save_game_status["player_1_pieces"]
    @player_2_pieces = save_game_status["player_2_pieces"]
    @player_1_captured_nobals = save_game_status["player_1_captured_nobals"]
    @player_2_captured_nobals = save_game_status["player_2_captured_nobals"]
    @player_1_captured_pawns = save_game_status["player_1_captured_pawns"]
    @player_2_captured_pawns = save_game_status["player_2_captured_pawns"]
    @p_1_king = save_game_status["p_1_king"]
    @p_2_king = save_game_status["p_1_king"]
    @turn_counter = save_game_status["turn_counter"]
    @en_passant_decay = save_game_status["en_passant_decay"]
    @selection = save_game_status["selection"]  
    2.times do |side|
      if side == 0
        player_pieces = @player_1_pieces
      else
        player_pieces = @player_2_pieces
      end 
      player_pieces.length.times do |index|
        player_piece = file.readline
        player_piece = JSON.parse(player_piece).to_hash
        name = player_piece["name"]
        player = player_piece["player"]
        position = player_piece["position"]
        @game_board[position[0]][position[1]].new_piece(player, name, position)
        if (@game_board[position[0]][position[1]].piece.is_a? Pawn) ||
          (@game_board[position[0]][position[1]].piece.is_a? Rook) ||
          (@game_board[position[0]][position[1]].piece.is_a? King)
          if player_piece["moved"] == true
            @game_board[position[0]][position[1]].piece.moved = true
          end
        end
      end
    end
    file.close
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
      @game_board[6][index].new_piece(1, "Pawn", [6,index])
      @game_board[1][index].new_piece(2, "Pawn", [1,index])
    end
    @game_board[7][0].new_piece(1, "Rook", [7,0])
    @game_board[7][1].new_piece(1, "Knight", [7,1]) 
    @game_board[7][2].new_piece(1, "Bishop", [7,2]) 
    @game_board[7][3].new_piece(1, "Queen", [7,3]) 
    @game_board[7][4].new_piece(1, "King", [7,4]) 
    @game_board[7][5].new_piece(1, "Bishop", [7,5]) 
    @game_board[7][6].new_piece(1, "Knight", [7,6])
    @game_board[7][7].new_piece(1, "Rook", [7,7])  
    @game_board[0][0].new_piece(2, "Rook", [0,0])
    @game_board[0][1].new_piece(2, "Knight", [0,1])
    @game_board[0][2].new_piece(2, "Bishop", [0,2]) 
    @game_board[0][3].new_piece(2, "Queen", [0,3])
    @game_board[0][4].new_piece(2, "King", [0,4]) 
    @game_board[0][5].new_piece(2, "Bishop", [0,5]) 
    @game_board[0][6].new_piece(2, "Knight", [0,6]) 
    @game_board[0][7].new_piece(2, "Rook", [0,7])
  end

  def display
    puts "\n\n#{@player_1_captured_nobals.join(' ')}"
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
    puts "#{@player_2_captured_pawns.join(' ')}\n\n"
  end

  #THIS SECTION DEFINES TURN BEHAVIOR
  def draw_conditions()
    if @turn_counter == 50
      return true
    elsif (@player_1_pieces.length == 1 && @player_2_pieces.length == 1)
      return true
    elsif @player_1_pieces.length <= 2 && @player_2_pieces.length <= 2
      name_1 = Array.new
      name_2 = Array.new
      @player_1_pieces.length.times do |i|
        name_1 << @game_board[@player_1_pieces[i][0]][@player_1_pieces[i][1]].piece.name
      end
      @player_2_pieces.length.times do |i|
        name_2 << @game_board[@player_2_pieces[i][0]][@player_2_pieces[i][1]].piece.name
      end

      unless name_1.include?("Pawn") || name_1.include?("Queen") || name_1.include?("Rook") ||
             name_2.include?("Pawn") || name_2.include?("Queen") || name_2.include?("Rook")
        return true
      end
    end
    return false
  end

  def turn(player)
    @turn_counter += 0.5
    if @en_passant_decay > 0
      @en_passant_decay -= 0.5
    end
    if will_check?(player) != false
      if in_check?(player)
        puts Rainbow("Checkmate!").yellow
      else
        puts Rainbow("Stalemate.").yellow
      end
      return false
    end
    if draw_conditions()
      puts Rainbow("The game has ended in a draw.").yellow
      return false
    end
    if @selection[player - 1] == 'ai'                     #selection array holds human/ai player info
      if player == 1                                        #if AI, array value is object AI.
        ai_turn(player, @player_1_pieces)   
      else
        ai_turn(player, @player_2_pieces)   
      end
    else
      human_turn(player)
    end
    save()
  end

  def human_turn(player)
    disable_en_passant(player)
    puts "Player #{player}, it is your turn."
    if in_check?(player)
      puts Rainbow("You are in check! You must fix this.").yellow
    end
    continue = false
    while continue == false
      entered_piece = false
      entered_move = false
      while entered_piece == false
        puts "Please enter the piece you want to move, or type save, load, or quit."
        entered_piece = gets.chomp
        entered_piece = entered_piece.downcase
        if entered_piece == "save"
          puts "Please enter the name of your new save file, or type exit to exit."
          save_file = gets.downcase.chomp
          if save_file == "exit" || save_file == ""
            puts "No file saved."
          else
            save(save_file)
          end
          entered_piece = false
        elsif entered_piece == "quit"
          puts "Thank you for playing!"
          return false
        elsif entered_piece == "load"
          load_menu()
        else
          entered_piece = move_conversion(entered_piece)
        end
      end
      #The move_conversion changes the on screen grid option to proper array
      while entered_move == false
        puts "Please enter the new location, or special move if it is available."
        entered_move = gets.chomp
        entered_move = entered_move.downcase
        if entered_move != "castle" && entered_move != "en passant"
          entered_move = move_conversion(entered_move)
        elsif entered_move == "en passant"
          if en_passant_decay == 0
            puts "That move is unavailable at this time."
            return false
          end
          puts "Which pawn would you like to take?"
          pawn = gets.chomp
          pawn = move_conversion(pawn)
          if (pawn[1] == entered_piece[1]-1) && (pawn[0] == entered_piece[0])
            entered_move = "en passant-"
          elsif (pawn[1] == entered_piece[1]+1) && (pawn[0] == entered_piece[0])
            entered_move = "en passant+"
          else
            puts "that's not a good move"
            entered_move = false
          end
        elsif entered_move == "castle"
          if game_board[entered_piece[0]][entered_piece[1]].piece != nil && (game_board[entered_piece[0]][entered_piece[1]].piece.is_a? King)
            puts "Which rook do you want to switch with?"
            temp_piece = gets.chomp
            temp_piece = move_conversion(temp_piece)
            if temp_piece
              entered_piece = temp_piece
            else
              entered_move = false
            end
          end
        end
        
      end
      continue = move(player,entered_piece,entered_move)
    end
    return true
  end

  def ai_turn(player, pieces)
    disable_en_passant(player)
    checkmate_moves = Array.new
    check_moves = Array.new
    queen_moves = Array.new
    nobal_moves = Array.new
    pawn_moves = Array.new
    non_catch_moves = Array.new
    good_move = false
    used = false
    sleep(1) #sleep is used to give the illusion that the AI opponent is taking a moment in thought.

    if player == 1
      player_pieces = player_1_pieces
      castle_row = 7
      en_passant_row = 3
      other_king = @p_2_king
    else
      player_pieces = player_2_pieces
      castle_row = 0
      en_passant_row = 4
      other_king = @p_1_king
    end

    player_pieces.length.times do |pieces_index|
      @game_board[player_pieces[pieces_index][0]][player_pieces[pieces_index][1]].piece.valid_moves(@game_board).length.times do |moves_index|
        potential_move = @game_board[player_pieces[pieces_index][0]][player_pieces[pieces_index][1]].piece.valid_moves(@game_board)[moves_index]
        if @game_board[player_pieces[pieces_index][0]][player_pieces[pieces_index][1]].piece.deep_moves(@game_board, potential_move).include?(other_king)
            check_moves << [player_pieces[pieces_index], potential_move]
        elsif @game_board[potential_move[0]][potential_move[1]].piece.is_a? Queen
          queen_moves << [player_pieces[pieces_index], potential_move]
        elsif (@game_board[potential_move[0]][potential_move[1]].piece.is_a? Bishop) || (@game_board[potential_move[0]][potential_move[1]].piece.is_a? Knight) || (@game_board[potential_move[0]][potential_move[1]].piece.is_a? Rook)
          nobal_moves << [player_pieces[pieces_index], potential_move]
        elsif @game_board[potential_move[0]][potential_move[1]].piece.is_a? Pawn
          pawn_moves << [player_pieces[pieces_index], potential_move]
        else
          non_catch_moves << [player_pieces[pieces_index], potential_move]
        end
      end         
    end

    #adding castling
    if (@game_board[castle_row][4].piece.is_a? King) && @game_board[castle_row][4].piece.moved == false
      if (@game_board[castle_row][0].piece.is_a? Rook) && @game_board[castle_row][0].piece.moved == false
        non_catch_moves << [[castle_row,0], "castle"]
      end
      if (@game_board[castle_row][7].piece.is_a? Rook) && @game_board[castle_row][7].piece.moved == false
        non_catch_moves << [[castle_row,7], "castle"]
      end
    end

    #adding en passant. Special note, unlike castling, the full move is not entirely determined by the
    #location of the pawn in question. A + or - has been added to the en passant string to tell the 
    #movement mechanics method which pawn is being taken in the move.
    if @en_passant_decay > 0
      8.times do |i|
        if player_pieces.include?([en_passant_row,i]) && (@game_board[en_passant_row][i].piece.is_a? Pawn)
          if (i - 1 >= 0) && (@game_board[en_passant_row][i-1].piece.is_a? Pawn)
            unless player_pieces.include?([en_passant_row,i-1]) || (@game_board[en_passant_row][i-1].piece.en_passant_vulnerable == false)
              pawn_moves << [[en_passant_row,i], "en passant-"]
            end
          elsif (i + 1 < 8) && (@game_board[en_passant_row][i+1].piece.is_a? Pawn)
            unless player_pieces.include?([en_passant_row,i+1]) || (@game_board[en_passant_row][i+1].piece.en_passant_vulnerable == false)
              pawn_moves << [[en_passant_row,i], "en passant+"]
            end
          end
        end
      end
    end


    
    while good_move == false
      if check_moves.length != 0
        pick = check_moves[rand(check_moves.length)]
        self_check = 1
      elsif queen_moves.length != 0
        pick = queen_moves[rand(queen_moves.length)]
        self_check = 2
      elsif nobal_moves.length != 0
        pick = nobal_moves[rand(nobal_moves.length)]
        self_check = 3
      elsif pawn_moves.length != 0
        pick = pawn_moves[rand(pawn_moves.length)]
        self_check = 4
      elsif non_catch_moves.length != 0
        pick = non_catch_moves[rand(non_catch_moves.length)]
        self_check = 5
      else
        if in_check?(player)
          puts Rainbow("Checkmate!").yellow
        else
          puts Rainbow("The game has ended in a stalemate.").yellow
        end
        return false
      end

      #if a move results in check, it is undone and deleted from the array of moves that contained it.
      if move_mechanics(player,pick[0],pick[1])
        good_move = true
      else
        case self_check
        when 1
          check_moves.delete(pick)
        when 2
          queen_moves.delete(pick)
        when 3
          nobal_moves.delete(pick)
        when 4
          pawn_moves.delete(pick)
        when 5
          non_catch_moves.delete(pick)
        end
      end
    end
    return true

  end

  def disable_en_passant(player)
    if player == 1
      player_pieces = @player_1_pieces
    else
      player_pieces = @player_2_pieces
    end

    player_pieces.length.times do |piece|
      if @game_board[player_pieces[piece][0]][player_pieces[piece][1]].piece.is_a? Pawn
        @game_board[player_pieces[piece][0]][player_pieces[piece][1]].piece.en_passant_vulnerable = false
      end
    end
  end


  #THIS SECTION DEFINES MOVEMENT BEHAVOIR


    #board is included to check potential moves in the future without actually
    #moving pieces. @game_board is default.
  def move(player,current_loc,new_loc,board = self,checking = false)
   
    if board.game_board[current_loc[0]][current_loc[1]].piece == nil
      puts "Your piece selection didn't have a piece."
      return false
    end

    if player != board.game_board[current_loc[0]][current_loc[1]].piece.player
      puts "You can't move your opponent's piece."
      return false
    end

    #This sends the valid move to be completed.
    if board.game_board[current_loc[0]][current_loc[1]].piece.valid_moves(board.game_board).include?(new_loc)
      if move_mechanics(player,current_loc,new_loc,board) == false
        unless checking == true
          puts "That would put you in check."
        end
        return false
      end
    elsif new_loc == 'castle' || new_loc.include?("en passant")
      if move_mechanics(player,current_loc,new_loc,board) == false
        puts "That are unable to make that move at this time."
        return false
      end
    #Else catches all invalid moves of a valid piece.
    else
      puts "You are unable to move there, try again." 
      return false
    end
  end




  def pawn_switch(player, location)
    if player == 1
      other_player = 2
    else
      other_player = 1
    end
    #AI logic - AI should choose a knight if it would result in checkmate, otherwise 
    #it will choose a queen.
    if @selection[player - 1] == 'ai'
      @game_board[location[0]][location[1]].new_piece(player, "Knight", location)
      unless will_check?(other_player)
        @game_board[location[0]][location[1]].new_piece(player, "Queen", location)
      end
    else
      promotion = ""
      until (promotion == 'rook' || promotion == 'knight' || promotion == 'bishop' || promotion == 'queen') do
        puts "Your pawn has reached the opponent's side, please select your promotion."
        puts "Rook, Knight, Bishop, or Queen."
        promotion = gets.downcase.chomp
        unless (promotion == 'rook' || promotion == 'knight' || promotion == 'bishop' || promotion == 'queen')
          puts "I'm sorry, I didn't understand that, please try again."
        end
      end

      case promotion
      when 'rook'
        @game_board[location[0]][location[1]].new_piece(player, "Rook", location)
        game_board[location[0]][location[1]].piece.moved = true
      when 'knight'
        @game_board[location[0]][location[1]].new_piece(player, "Knight", location)
      when 'bishop'
        @game_board[location[0]][location[1]].new_piece(player, "Bishop", location)
      when 'queen'
        @game_board[location[0]][location[1]].new_piece(player, "Queen", location)
      end
    end
  end




  def get_enemy_moves(player,board)
    enemey_moves = Array.new
    if player == 1
      board.player_2_pieces.length.times do |piece_index|
        board.game_board[board.player_2_pieces[piece_index][0]][board.player_2_pieces[piece_index][1]].piece.valid_moves(board.game_board).length.times do |moves|
          enemey_moves << board.game_board[board.player_2_pieces[piece_index][0]][board.player_2_pieces[piece_index][1]].piece.valid_moves(board.game_board)[moves]
        end
      end
    else
      board.player_1_pieces.length.times do |piece_index|
        board.game_board[board.player_1_pieces[piece_index][0]][board.player_1_pieces[piece_index][1]].piece.valid_moves(board.game_board).length.times do |moves|
          enemey_moves << board.game_board[board.player_1_pieces[piece_index][0]][board.player_1_pieces[piece_index][1]].piece.valid_moves(board.game_board)[moves]
        end
      end
    end
    return enemey_moves
  end




  def castle_mechanics(loc, enemey_moves, board)
    #loc is the location of the rook that will be involved. Since castling requires that neither rook
    #nor king has been moved, knowing the rook's location tells us both the player, and the king's location.

    #a and b are just for coordinates that are related to loc[1]
    #a is closest to the king and the rook's new spot.
    #b is 2 from the king and the king's new spot.
    if loc[1] == 0
      a = 3
      b = 2
    else
      a = 5
      b = 6
    end

    if enemey_moves.include?([loc[0],a]) || enemey_moves.include?([loc[0],b]) || enemey_moves.include?([loc[0],4])
      return false
    elsif board.game_board[loc[0]][a].piece != nil || board.game_board[loc[0]][b].piece != nil || (loc[1] == 0  && board.game_board[loc[0]][1].piece != nil)
      return false
    else
      board.game_board[loc[0]][a] = board.game_board[loc[0]][loc[1]]
      board.game_board[loc[0]][b] = board.game_board[loc[0]][4]
      board.game_board[loc[0]][a].piece.position = [loc[0],a]
      board.game_board[loc[0]][b].piece.position = [loc[0],b]
      board.game_board[loc[0]][loc[1]] = BoardLoc.new
      board.game_board[loc[0]][4] = BoardLoc.new
      board.game_board[loc[0]][a].piece.moved = true
      board.game_board[loc[0]][b].piece.moved = true
      if loc[0] == 0
        @p_2_king = [loc[0],b]
        player = 2
      else
        @p_1_king = [loc[0],b]
        player = 1
      end
      update_player_array(player,loc,[loc[0],a],board, nil)
      update_player_array(player,[loc[0],4],[loc[0],b],board, nil)
      return true
    end

  end





    #makes the changes to move the piece on the board, updating move if
    #appropriate, and removing the other player's piece if one was captured
  def move_mechanics(player,current_loc,new_loc,board = self)

    if new_loc == "castle"
      enemey_moves = get_enemy_moves(player,board)
      return castle_mechanics(current_loc,enemey_moves,board)
    end


    if new_loc.include?("en passant")
      if player == 1
        up_down_change = -1
      else
        up_down_change = 1
      end

      if new_loc.include?("+")
        left_right_change = 1
      else
        left_right_change = -1
      end
      
      temp_player_pawn = board.game_board[current_loc[0]][current_loc[1]]
      temp_oponent_pawn = board.game_board[current_loc[0]][current_loc[1] + left_right_change]
      was_captured = temp_oponent_pawn.piece.token

      board.game_board[current_loc[0] + up_down_change][current_loc[1] + left_right_change] = temp_player_pawn
      board.game_board[current_loc[0]][current_loc[1]] = BoardLoc.new
      board.game_board[current_loc[0]][current_loc[1] + left_right_change] = BoardLoc.new

      update_player_array(player,current_loc,[current_loc[0] + up_down_change,current_loc[1] + left_right_change],board, nil)
      captured(player, [current_loc[0],current_loc[1] + left_right_change], was_captured)

      if in_check?(player, board)
        board.game_board[current_loc[0]][current_loc[1]] = temp_player_pawn
        board.game_board[current_loc[0]][current_loc[1] + left_right_change] = temp_oponent_pawn
        board.game_board[current_loc[0] + up_down_change][current_loc[1] + left_right_change] = BoardLoc.new
        if player == 1
          player_1_pieces << [current_loc[0],current_loc[1]]
          player_1_pieces.delete([current_loc[0] + up_down_change, current_loc[1] + left_right_change])
          player_2_pieces << [current_loc[0],current_loc[1] + left_right_change]
          player_2_captured_pawns.delete(was_captured)
        else
          player_2_pieces << [current_loc[0],current_loc[1]]
          player_2_pieces.delete([current_loc[0] + up_down_change, current_loc[1] + left_right_change])
          player_1_pieces << [current_loc[0],current_loc[1] + left_right_change]
          player_1_captured_pawns.delete(was_captured)
        end
        return false
      end

      board.game_board[current_loc[0] + up_down_change][current_loc[1] + left_right_change].piece.position = [current_loc[0] + up_down_change, current_loc[1] + left_right_change]
      @turn_counter = -0.5
      return true
    end

    if board.game_board[new_loc[0]][new_loc[1]].piece != nil
      was_captured = board.game_board[new_loc[0]][new_loc[1]].piece.token
      temp = board.game_board[new_loc[0]][new_loc[1]].piece
    else
      was_captured = nil
    end


    #update king location
    if board.game_board[current_loc[0]][current_loc[1]].piece.is_a? King
      if player == 1
        @p_1_king = new_loc
      else
        @p_2_king = new_loc
      end
    end

    #updates the new location with the moved piece, and empties the
    #old location.
    board.game_board[new_loc[0]][new_loc[1]] = board.game_board[current_loc[0]][current_loc[1]]
    board.game_board[current_loc[0]][current_loc[1]] = BoardLoc.new

    #The following reverses any changes made thus far if the move puts the player in check, and 
    #returns false to continue move selection.
    if in_check?(player)
      board.game_board[current_loc[0]][current_loc[1]] = board.game_board[new_loc[0]][new_loc[1]]
      board.game_board[new_loc[0]][new_loc[1]] = BoardLoc.new
      if board.game_board[current_loc[0]][current_loc[1]].piece.is_a? King
        if player == 1
          @p_1_king = current_loc
        else
          @p_2_king = current_loc
        end
      end
      board.game_board[new_loc[0]][new_loc[1]].piece = temp
      sleep(2)
      return false
    end


    if board == self
      if (board.game_board[new_loc[0]][new_loc[1]].piece.is_a? Pawn) || (board.game_board[new_loc[0]][new_loc[1]].piece.is_a? King) || (board.game_board[new_loc[0]][new_loc[1]].piece.is_a? Rook)
        board.game_board[new_loc[0]][new_loc[1]].piece.moved = true
      end
    end


    update_player_array(player,current_loc,new_loc,board, was_captured)
    board.game_board[new_loc[0]][new_loc[1]].piece.position = new_loc

    #turn counter // a draw may be declared after 50 turns from the last capture or pawn move.
    if board.game_board[new_loc[0]][new_loc[1]].piece.is_a? Pawn
      @turn_counter = -0.5
      if (current_loc[0] - new_loc[0] == 2) || (current_loc[0] - new_loc[0] == -2)
        if ((board.game_board[new_loc[0]][new_loc[1]+1] != nil) && (board.game_board[new_loc[0]][new_loc[1]+1].piece.is_a? Pawn)) || ((board.game_board[new_loc[0]][new_loc[1]-1] != nil) && (board.game_board[new_loc[0]][new_loc[1]-1].piece.is_a? Pawn))
          board.game_board[new_loc[0]][new_loc[1]].piece.en_passant_vulnerable = true
          @en_passant_decay = 1.0
        end
      end
    end

    #pawn switch switches the pawn to a new piece once it reaches the end.
    if new_loc[0] == 0 || new_loc[0] == 7
      if board.game_board[new_loc[0]][new_loc[1]].piece.is_a? Pawn
        pawn_switch(player,new_loc)
      end
    end
      
    return true
  end


    #player array is used to check for check and checkmate, as well
    #as the AI's turn. This updates those arrays after each move.
  def update_player_array(player,current_loc,new_loc,board, was_captured)
    if board == self && was_captured != nil 
      captured(player, new_loc, was_captured)
      #turn counter // a draw may be declared after 50 turns from the last capture or pawn move.
      @turn_counter = -0.5
    end
    if player == 1
      board.player_1_pieces.delete(current_loc)
      board.player_1_pieces << new_loc
    else
      board.player_2_pieces.delete(current_loc)
      board.player_2_pieces << new_loc
    end
  end


    #updates the array used to display the player's captured pieces.
    #UI only, it does not affect game logic.
  def captured(player, loc, was_captured)
    if player == 1
      if was_captured == "\u2659"
        @player_2_captured_pawns << was_captured
      else
        @player_2_captured_nobals << was_captured
      end
      @player_2_pieces.delete(loc)
    else
      if was_captured == "\u265F"
        @player_1_captured_pawns << was_captured
      else
        @player_1_captured_nobals << was_captured
      end
      @player_1_pieces.delete(loc)
    end
    if was_captured == "\u2654" || was_captured == "\u265A"
      puts "Error: King caputred. #{was_captured}"
      sleep(2000)
    end
  end



  #THIS SECTION DEFINES CHECK / CHECKMATE BEHAVIOR

  def in_check?(player, board = self)
    enemey_moves = get_enemy_moves(player,board)
    if player == 1
      if enemey_moves.include?(board.p_1_king)
        return true
      end
    elsif player == 2
      if enemey_moves.include?(board.p_2_king)
        return true
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
        return will_check?(1)
      end
    else
    end
  end

  def will_check?(player)
    in_check = true
    if player == 1
      player_pieces = @player_1_pieces
    else
      player_pieces = @player_2_pieces
    end

    player_pieces.length.times do |i|
      @game_board[player_pieces[i][0]][player_pieces[i][1]].piece.valid_moves(@game_board).length.times do |j|
        temp_game_board = Marshal.load(Marshal.dump(self))
        if temp_game_board.move(player,[player_pieces[i][0],player_pieces[i][1]], @game_board[player_pieces[i][0]][player_pieces[i][1]].piece.valid_moves(@game_board)[j],temp_game_board,true) != false
          in_check = false
        end
      end
    end

    return in_check
  end
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
    when "Pawn"
      @piece = Pawn.new(player, loc)
    when "King"
      @piece = King.new(player, loc)
    when "Queen"
      @piece = Queen.new(player, loc)
    when "Knight"
      @piece = Knight.new(player, loc)
    when "Bishop"
      @piece = Bishop.new(player, loc)
    when "Rook"
      @piece = Rook.new(player, loc)
    end
    @token = @piece.token
    @display = " #{@token} "
  end
end


#THIS SECTIN DEFINES PLAYER INTERACTION

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
  

#THIS SECTION DEFINES ACTUAL GAME SETUP


def game_loop(game)
  player = 1
  game.display
  keep_playing = true
  while keep_playing
    
    keep_playing = game.turn(player)  
    if keep_playing == false
      return
    end
    if player == 1
      player = 2
    else
      player = 1
    end
    game.display
  end
end
  

def game()
  keep_playing = true
  while keep_playing == true
    save_game = nil
    unless Dir.exist?("save_files")
      Dir.mkdir("save_files")
    end
    puts "Welcome to Chess."
    puts "Would you like to play:"
    puts "1. Human vs Human"
    puts "2. Human vs AI"
    puts "3. AI vs Human"
    puts "4. AI vs AI"
    if File.exist?("save_files/autosave.txt")
      saves = true
      puts 'Type "continue" to continue the last game.'
      puts 'Or type "load" to load a previous save.'
    else 
      saves = false
    end
    selection = false
    while selection == false
      selection = gets.downcase.chomp
      if (selection.include? 'load') && saves == true
        selection = 'load'
      elsif (selection.include? 'continue') && saves == true
        selection = 'continue'
      else
        selection = select_player(selection)
      end
    end
    game = Game_Board.new(selection)
    game_loop(game)
    puts "Would you like to play again?"
    play_again = gets.downcase.chomp
    while play_again != "yes" && play_again != "no"
      puts "Please type yes or no"
      play_again = gets.downcase.chomp
    end
    if play_again == "no"
      puts "Thank you for playing."
      keep_playing = false
    end
  end
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
