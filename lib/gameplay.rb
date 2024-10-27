require 'json'

# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'
    show_grid

    @turn = 0

    loop do
      player_king = find_king(@turn)
      opponent_status = checked?(player_king[1], @board, player_turn(@turn))
      # p opponent_status
      checkmate?(player_king[1], opponent_status[0], @board, player_turn(@turn)) if opponent_status[1] == true

      temp = player_input
      next if player_input_valid?(temp) == false
      next if player_own_piece?(temp) == false

      move(temp[0], temp[1])
      show_grid
    end
  end

  def player_input
    p "its #{player_turn(@turn)} turn !"
    begin
      input = JSON.parse("[#{gets.chomp}]")
    rescue StandardError
      p 'Something went wrong'
    else
      p "you typed #{input} which are #{input[0]} and #{input[1]}"

      input
    end
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

    @turn += 1
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
end
