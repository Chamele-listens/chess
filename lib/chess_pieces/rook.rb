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

    generate_right_moves(possible_moves, ver_pos, hor_pos, location)

    generate_left_moves(possible_moves, ver_pos, hor_pos, location)

    generate_up_moves(possible_moves, ver_pos, hor_pos, location)

    generate_down_moves(possible_moves, ver_pos, hor_pos, location)

    possible_moves
  end

  def generate_right_moves(possible_moves, ver_pos, hor_pos, location)
    temp_moves = []
    (8 - location[1]).times do
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_left_moves(possible_moves, ver_pos, hor_pos, location)
    temp_moves = []
    (location[1] - 1).times do
      hor_pos -= 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_up_moves(possible_moves, ver_pos, hor_pos, location)
    temp_moves = []
    (8 - location[0]).times do
      ver_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_down_moves(possible_moves, ver_pos, hor_pos, location)
    temp_moves = []
    (location[0] - 1).times do
      ver_pos -= 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end
end
