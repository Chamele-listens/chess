require_relative 'chesspiece_main'

# Check if pawn made legal moves change pawn to queen when at end of board
class Pawn < Chesspiece
  include Basic_tools
  attr_accessor :has_move

  def initialize(type)
    @type = type
    @has_move = false
  end

  def pawn_move_check(chesspiece_location, chesspiece_distination, board)
    possible_moves = generate_moves(chesspiece_location)

    return true if possible_moves.include?(chesspiece_distination)

    false
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_one_or_two_up_moves(possible_moves, ver_pos, hor_pos)

    possible_moves
  end

  def generate_one_or_two_up_moves(possible_moves, ver_pos, hor_pos)
    if @has_move == true
      possible_moves << [ver_pos + 1, hor_pos]
    else
      possible_moves << [ver_pos + 1, hor_pos]
      possible_moves << [ver_pos + 2, hor_pos]
      @has_move = true
    end
  end
end
