require_relative 'chesspiece_main'

# check if a moves a rook instance made is legal
class Rook < Chesspiece
  include Basic_tools
  def initialize(type)
    @type = type
  end

  def rook_move_check(chesspiece_location, chesspiece_distination, board)
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

    generate_right_moves(possible_moves, ver_pos, hor_pos)

    generate_left_moves(possible_moves, ver_pos, hor_pos)

    generate_up_moves(possible_moves, ver_pos, hor_pos)

    generate_down_moves(possible_moves, ver_pos, hor_pos)

    possible_moves
  end
end
