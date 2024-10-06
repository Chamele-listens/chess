require 'json'

# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'
    show_grid

    turn = 0

    loop do
      p "its #{player_turn(turn)} turn !"
      player_input = JSON.parse("[#{gets.chomp}]")
      p "you typed #{player_input} which are #{player_input[0]} and #{player_input[1]}"
      turn += 1

      show_grid
    end
  end

  def player_turn(turn)
    player = %w[white black]
    return player[0] if turn.even?

    player[1] if turn.odd?
  end
end
