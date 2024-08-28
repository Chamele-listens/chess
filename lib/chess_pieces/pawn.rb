require_relative 'chesspiece_main'

# Check if pawn made legal moves change pawn to queen when at end of board
class Pawn < Chesspiece
  include Basic_tools

  def initialize(type)
    @type = type
    @has_move = false
  end

  def check_pawn_move
    pass
  end

  def generate_moves
    pass
  end
end
