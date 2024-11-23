require_relative 'chesspiece_main'

# class for checking if knight piece moves is legal
class Knight < Chesspiece
  def initialize(type, color)
    @type = type
    @color = color
  end

  def knight_move_check(chesspiece_location, chesspiece_distination)
    possible_moves = generate_moves(chesspiece_location)

    return true if possible_moves.flatten(1).include?(chesspiece_distination)

    false
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    possible_moves = []

    ver_pos = location[0]
    hor_pos = location[1]

    # Up position
    possible_moves << [ver_pos + 2, hor_pos - 1]
    possible_moves << [ver_pos + 2, hor_pos + 1]

    # down position
    possible_moves << [ver_pos - 2, hor_pos - 1]
    possible_moves << [ver_pos - 2, hor_pos + 1]

    # right position
    possible_moves << [ver_pos - 1, hor_pos + 2]
    possible_moves << [ver_pos + 1, hor_pos + 2]

    # left position
    possible_moves << [ver_pos - 1, hor_pos - 2]
    possible_moves << [ver_pos + 1, hor_pos - 2]

    # .select {|i| (i[0] < 8 && i[1] < 8) && (i[0] > 0 && i[1] > 0)}
    possible_moves.select! { |i| (i[0] <= 8 && i[1] <= 8) && (i[0] > 0 && i[1] > 0) }

    # p "knight moves are #{possible_moves}"

    [possible_moves]
  end
end
