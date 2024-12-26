require 'json'

# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'

    @turn = 0

    create_new_game(@board)

    loop do
      show_grid

      player_king = find_king(@turn)
      opponent_status = checked?(player_king[1], @board, player_turn(@turn))
      # p opponent_status
      checkmate_status = checkmate?(player_king[1], opponent_status[0], @board, player_turn(@turn)) if opponent_status[1] == true # rubocop:disable Layout/LineLength
      # p checkmate_status
      break if checkmate_status == true

      temp = player_input
      next if player_input_valid?(temp) == false
      next if player_own_piece?(temp) == false

      next if move(temp[0], temp[1]).nil?

      @turn += 1
    end
    p 'Checkmate'
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
