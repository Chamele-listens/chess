require 'json'
require_relative 'tools/save_load_system'
require_relative 'tools/chesspiece_constraint'

# all gameplay functionality for the same chessBoard class
class Chessboard
  include Save_load_system
  include Chesspiece_constraint

  def start(game_object)
    p 'Play a game of chess !'

    # @turn = 0

    create_new_game(@board)

    loop do
      show_grid

      player_king = find_king(@turn)

      king_piece = player_king[0]
      king_pos = player_king[1]

      opponent_status = checked?(king_pos, @board, player_turn(@turn))

      opponent_pieces = opponent_status[0]
      is_checked = opponent_status[1]

      opponent_path = generate_all_opponent_path(opponent_pieces, @board)

      # break if stalemate?(opponent_path, king_pos, king_piece.color, @board) == true

      checkmate_status = checkmate?(king_pos, opponent_pieces, @board, player_turn(@turn)) if is_checked == true

      if checkmate_status == true
        p 'checkmate'
        break
      end

      if is_checked == true
        own_chesspieces = get_king_own_chesspiece_in_check(king_pos, opponent_pieces, player_turn(@turn), @board)
      end

      player_pos_destination = player_input

      player_piece_pos = player_pos_destination[0]
      player_piece_destination = player_pos_destination[1]

      next if save_load?(player_pos_destination, game_object) == true

      next if chesspiece_constraint?(player_pos_destination, player_king, own_chesspieces, opponent_status, opponent_path) == true # rubocop:disable Layout/LineLength

      # Edge case: when king is in checkmate, king must move out of checkmate not towards (Fixed)

      next if player_input_valid?(player_pos_destination) == false
      next if player_own_piece?(player_pos_destination) == false

      next if move(player_piece_pos, player_piece_destination).nil?

      @turn += 1
    end
  end

  def chesspiece_constraint?(player_pos_destination, player_king, own_chesspieces, opponent_status, opponent_path)
    opponent_pieces = opponent_status[0]
    is_checked = opponent_status[1]

    player_piece_pos = player_pos_destination[0]

    king_piece = player_king[0]
    king_pos = player_king[1]

    return true if stop_king_from_moving_into_check(player_pos_destination, king_piece, king_pos, opponent_path, is_checked) == true && player_piece_pos == king_pos && is_checked == false # rubocop:disable Layout/LineLength

    return true if move_king_out_of_check(player_pos_destination, opponent_pieces, is_checked) == true

    return true if more_than_1_pieces_checking_king?(player_piece_pos, king_pos, opponent_pieces, is_checked) == true

    return true if king_exposed?(player_pos_destination, opponent_pieces, king_pos, is_checked)

    return true if limit_player_moves_during_check(player_king, player_pos_destination, is_checked, own_chesspieces) == true && is_checked == true # rubocop:disable Layout/LineLength

    false
  end

  def player_input
    p "its #{player_turn(@turn)} turn !"

    input = gets.chomp

    proper_input = []

    return input if input.count('a-zA-Z').positive?

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

    false unless get_chesspiece_from_board(move_pos[0], @board).color == player_turn(@turn)

    # p 'Its the player own piece'
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
