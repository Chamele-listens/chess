require_relative 'chesspiece_main'

class Bishop < Chesspiece
  include Basic_tools
  def initialize(type)
    @type = type
  end

  def bishop_move_check(chesspiece_location, chesspiece_distination, board)
    p generate_moves(chesspiece_location)
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_upper_right_moves(ver_pos, hor_pos, possible_moves, location)

    generate_lower_right_moves(ver_pos, hor_pos, possible_moves, location)

    possible_moves
  end

  def generate_upper_right_moves(ver_pos, hor_pos, possible_moves, location)
    temp_moves = []
    (8 - location[1]).times do
      ver_pos += 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_lower_right_moves(ver_pos, hor_pos, possible_moves, location)
    temp_moves = []
    (8 - location[1]).times do
      ver_pos -= 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end
end
