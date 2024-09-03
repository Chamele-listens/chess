require_relative 'chesspiece_main'

class Queen < Chesspiece
  include Basic_tools
  attr_accessor :has_move

  def initialize(type)
    @type = type
  end

  def queen_move_check(chesspiece_location, chesspiece_distination, board)
    temp = generate_moves(chesspiece_location)
    possible_moves = move_limit(temp, board)

    return true if possible_moves.flatten(1).include?(chesspiece_distination)

    false
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_diagonal_moves(ver_pos, hor_pos, possible_moves)

    generate_vertical_horizontal_moves(possible_moves, ver_pos, hor_pos)

    possible_moves
  end
end
