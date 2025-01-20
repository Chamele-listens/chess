require 'json'

# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'

    # @turn = 0

    create_new_game(@board)

    # add_new_chesspiece([7, 3], '♞', 'white')
    # remove_chesspiece([8, 4])

    # Unexpected behavoir: (mostly fixed in checkmate_logic.rb)
    # When king is in check, it only sometimes restrict moves of king's own peice
    # and some unhelpful chesspiece can move without protecting the king.
    # The issue might be from #chesspiece_to_protect_king? with the cutoff move methods

    # Bugs:
    # - #limit_player_moves_during_check prevents piece from moving when knight is
    # not in check

    loop do
      show_grid

      player_king = find_king(@turn)
      opponent_status = checked?(player_king[1], @board, player_turn(@turn))

      opponent_path = generate_all_opponent_path(opponent_status[0], @board)

      # break if stalemate?(opponent_path, player_king[1], player_king[0].color, @board) == true

      checkmate_status = checkmate?(player_king[1], opponent_status[0], @board, player_turn(@turn)) if opponent_status[1] == true # rubocop:disable Layout/LineLength

      if checkmate_status == true
        p 'checkmate'
        break
      end

      if opponent_status[1] == true
        own_chesspieces = get_king_own_chesspiece_in_check(player_king[1], opponent_status[0], player_turn(@turn), @board) # rubocop:disable Layout/LineLength
      end

      temp = player_input

      # Edge case: when king is in checkmate, king must move out of checkmate not towards (Fixed)
      next if stop_king_from_moving_into_check(temp, player_king[0], player_king[1], opponent_path, opponent_status[1]) == true && temp[0] == player_king[1] && opponent_status[1] == false # rubocop:disable Layout/LineLength

      next if move_king_out_of_check(temp, opponent_status[0], opponent_status[1]) == true

      next if more_than_1_pieces_checking_king?(temp[0], player_king[1], opponent_status[0], opponent_status[1]) == true

      next if king_exposed?(temp, opponent_status[0], player_king[1], opponent_status[1])

      next if limit_player_moves_during_check(player_king, temp, opponent_status[1], own_chesspieces) == true && opponent_status[1] == true # rubocop:disable Layout/LineLength
      next if player_input_valid?(temp) == false
      next if player_own_piece?(temp) == false

      next if move(temp[0], temp[1]).nil?

      @turn += 1
    end
  end

  def player_input
    p "its #{player_turn(@turn)} turn !"

    input = gets.chomp

    proper_input = []

    input.split('').each { |num| proper_input << num.to_i }

    [proper_input[0..1], proper_input[2..3]]
  end

  def player_input_valid?(move_pos)
    return false unless move_pos.is_a?(Array)

    return false unless move_pos.any?(Array)

    return false unless move_pos.select { |move| move.is_a?(Array) }.count > 1

    temp = []

    move_pos.each { |move| temp << move.count }

    return false unless temp.uniq.size <= 1

    true
  end

  def player_own_piece?(move_pos)
    p 'ran'
    return false if get_chesspiece_from_board(move_pos[0], @board) == '[ ]'
    return false unless get_chesspiece_from_board(move_pos[0], @board).color == player_turn(@turn)

    p 'Its the player own piece'
  end

  def find_king(turn)
    all_pos = generate_all_possible_pos

    opponent_color = player_turn(turn)

    all_pos.each do |pos_row|
      pos_row.each do |pos|
        if get_chesspiece_from_board(pos, @board).is_a?(King) && get_chesspiece_from_board(pos, @board).color == opponent_color # rubocop:disable Layout/LineLength
          king = get_chesspiece_from_board(pos, @board)
          return [king, pos]
        end
      end
    end

    nil
  end

  # will limit where a player in check can move, including the king when it's in check
  def limit_player_moves_during_check(player_king, player_input, is_checked, own_chesspieces)
    return false if is_checked == false

    own_chesspieces[player_king[0]] = player_king[1]

    p "The king's pieces are #{own_chesspieces}"

    own_chesspieces.each_value { |chesspiece_pos| return false if player_input[0] == chesspiece_pos }

    p 'Protect your king !'

    true
  end

  def more_than_1_pieces_checking_king?(player_input, king_pos, opponent_pieces, is_checked)
    return false if is_checked == false
    return false if player_input == king_pos

    temp_opponent_pieces = remove_non_dangerous_piece(king_pos, opponent_pieces)

    if temp_opponent_pieces.count > 1
      p "there's more than 1 pieces checking the king ! Move your king !"
      return true
    end

    false
  end

  # Will stop the king from moving into check when it's no currently in check
  def stop_king_from_moving_into_check(player_input, king, king_pos, opponent_path, is_checked)
    return false unless get_chesspiece_from_board(player_input[0], @board).is_a?(King)
    return false if is_checked == true

    king_move = king.generate_moves(king_pos)

    king_legal_moves = king_move - opponent_path

    # p "The king's legal moves are #{king_legal_moves}"

    return false if king_legal_moves.include?(player_input[1])

    p 'Move will put king in check !'

    true
  end

  def move_king_out_of_check(temp, opponent_pieces, is_checked)
    return false unless get_chesspiece_from_board(temp[0], @board).is_a?(King)
    return false if is_checked == false

    p temp

    opp_piece_path = only_generate_opponent_path_for_dangerous_pieces(temp[0], opponent_pieces, @board)

    opponent_path = opp_piece_path[1]

    if opponent_path.include?(temp[1])
      p 'move your king out of check'
      return true
    end

    false
  end

  def only_generate_opponent_path_for_dangerous_pieces(pos, opponent_pieces, board)
    temp_opponent_pieces = remove_non_dangerous_piece(pos, opponent_pieces)

    opponent_path = generate_all_opponent_path(temp_opponent_pieces, board)

    [temp_opponent_pieces, opponent_path]
  end

  # Will prevent other pieces from leaving the king exposed
  def king_exposed?(player_input, opponent_pieces, king_pos, is_checked)
    return false if get_chesspiece_from_board(player_input[0], @board).is_a?(King)
    return false if is_checked == true

    removed_piece = remove_chesspiece(player_input[0])

    opponent_path = generate_all_opponent_path(opponent_pieces, @board) do |opponent_path, opp_pos|
      opponent_path << [opp_pos]
    end

    p opponent_path

    p "#{opponent_path.include?(king_pos)} and #{!opponent_path.include?(player_input[1])}"

    if opponent_path.include?(king_pos) && !opponent_path.include?(player_input[1])
      p 'Move will leave king exposed !'
      add_chesspiece(player_input[0], removed_piece)
      return true
    end

    p 'The king is not expose if this part runs'

    add_chesspiece(player_input[0], removed_piece)

    false
  end

  def player_turn(turn)
    player = %w[white black]
    return player[0] if turn.even?

    player[1] if turn.odd?
  end

  def create_new_game(board)
    create_pawn_row([2, 1], '♟', 'white', board)
    create_pawn_row([7, 1], '♙', 'black', board)
    create_player_row([1, 1], ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'], 'white', board)
    create_player_row([8, 1], ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'], 'black', board)
  end

  # TODO: fix pawn because it should not be able to destory anything in front of it
  def create_pawn_row(start_pos, pawn, color, board)
    ver_pos = start_pos[0]
    hor_pos = start_pos[1]

    8.times do |pos|
      add_new_chesspiece([ver_pos, hor_pos + pos], pawn, color, board)
    end
  end

  def create_player_row(start_pos, chesspiece, color, board)
    ver_pos = start_pos[0]
    hor_pos = start_pos[1]

    chesspiece.each_with_index do |piece, pos|
      add_new_chesspiece([ver_pos, hor_pos + pos], piece, color, board)
    end
  end
end
