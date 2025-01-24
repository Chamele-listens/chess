# Logic for constrainting chess moves during gameloop
module Chesspiece_constraint
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

  def move_king_out_of_check(player_pos_destination, opponent_pieces, is_checked)
    return false unless get_chesspiece_from_board(player_pos_destination[0], @board).is_a?(King)
    return false if is_checked == false

    p player_pos_destination

    opp_piece_path = only_generate_opponent_path_for_dangerous_pieces(player_pos_destination[0], opponent_pieces, @board) # rubocop:disable Layout/LineLength

    opponent_path = opp_piece_path[1]

    if opponent_path.include?(player_pos_destination[1])
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

    # p opponent_path

    # p "#{opponent_path.include?(king_pos)} and #{!opponent_path.include?(player_input[1])}"

    if opponent_path.include?(king_pos) && !opponent_path.include?(player_input[1])
      p 'Move will leave king exposed !'
      add_chesspiece(player_input[0], removed_piece)
      return true
    end

    # p 'The king is not expose if this part runs'

    add_chesspiece(player_input[0], removed_piece)

    false
  end
end
