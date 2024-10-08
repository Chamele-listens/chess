require 'json'

# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'
    show_grid

    @turn = 0

    loop do
      temp = player_input
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

  def player_own_piece?(move_pos)
    p 'ran'
    return false unless get_chesspiece_from_board(move_pos[0], @board).color == player_turn(@turn)

    @turn += 1
    p 'Its the player own piece'
  end

  def player_turn(turn)
    player = %w[white black]
    return player[0] if turn.even?

    player[1] if turn.odd?
  end
end
