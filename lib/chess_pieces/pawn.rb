require_relative 'chesspiece_main'

# Check if pawn made legal moves change pawn to queen when at end of board
class Pawn < Chesspiece
  include Basic_tools

  def initialize(type)
    @type = type
    @has_move = false
  end

  def pawn_move_check
    generate_moves
  end

  def generate_moves
    p 'ran'
  end
end
