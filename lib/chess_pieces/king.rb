require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include Basic_tools
  def initialize(type)
    @type = type
  end

  def king_move_check(chesspiece_location, chesspiece_distination, board)
    p generate_moves(chesspiece_location)
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_upper_moves(ver_pos, hor_pos, possible_moves)
    generate_lower_moves(ver_pos, hor_pos, possible_moves)
    generate_left_right_moves(ver_pos, hor_pos, possible_moves)

    possible_moves
  end

  def generate_upper_moves(ver_pos, hor_pos, possible_moves)
    ver_pos += 1
    hor_pos -= 1

    3.times do
      possible_moves << [ver_pos, hor_pos]
      hor_pos += 1
    end
  end

  def generate_lower_moves(ver_pos, hor_pos, possible_moves)
    ver_pos -= 1
    hor_pos -= 1

    3.times do
      possible_moves << [ver_pos, hor_pos]
      hor_pos += 1
    end
  end

  def generate_left_right_moves(ver_pos, hor_pos, possible_moves)
    possible_moves << [ver_pos, hor_pos - 1]
    possible_moves << [ver_pos, hor_pos + 1]
  end
end
