# all gameplay functionality for the same chessBoard class
class Chessboard
  def start
    p 'Play a game of chess !'
    show_grid

    turn = 0

    loop do
      p "its #{player_turn(turn)} turn !"
      temp = gets.chomp
      p "you typed #{temp}"
      turn += 1
    end
  end

  def player_turn(turn)
    player = %w[white black]
    return player[0] if turn.even?

    player[1] if turn.odd?
  end
end
