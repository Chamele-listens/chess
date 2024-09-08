require_relative 'chesspiece_main'

class Bishop < Chesspiece
  include Basic_tools
  def initialize(type, color)
    @type = type
    @color = color
  end

  def bishop_move_check(chesspiece_location, chesspiece_distination, board)
    temp = generate_moves(chesspiece_location)
    possible_moves = move_limit(temp, board, @color)

    return true if possible_moves.flatten(1).include?(chesspiece_distination)

    false
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_diagonal_moves(ver_pos, hor_pos, possible_moves)

    possible_moves
  end
end
