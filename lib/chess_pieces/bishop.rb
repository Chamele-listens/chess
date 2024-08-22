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

    generate_upper_right_moves(ver_pos, hor_pos, possible_moves)

    generate_lower_right_moves(ver_pos, hor_pos, possible_moves)

    possible_moves
  end

  def generate_upper_right_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos += 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos >= 8 || hor_pos >= 8
    end
    possible_moves << temp_moves
  end

  def generate_lower_right_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos -= 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos <= 1 || hor_pos >= 8
    end
    possible_moves << temp_moves
  end
end
