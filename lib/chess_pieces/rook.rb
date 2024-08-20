require_relative 'chesspiece_main'

class Rook < Chesspiece
  def initialize(type)
    @type = type
  end

  def rook_move_check(chesspiece_location, chesspiece_distination)
    p generate_moves(chesspiece_location)
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_right_moves(possible_moves, ver_pos, hor_pos, location)

    generate_left_moves(possible_moves, ver_pos, hor_pos, location)

    possible_moves
  end

  def generate_right_moves(possible_moves, ver_pos, hor_pos, location)
    (8 - location[1]).times do
      hor_pos += 1
      possible_moves << [ver_pos, hor_pos]
    end
  end

  def generate_left_moves(possible_moves, ver_pos, hor_pos, location)
    (location[1] - (location[1] - 1)).times do
      hor_pos -= 1
      possible_moves << [ver_pos, hor_pos]
    end
  end
end
