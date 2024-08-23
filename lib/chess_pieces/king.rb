require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include basic_tools
  def initialize(type)
    @type = type
  end

  def check_king_move(chesspiece_location, chesspiece_distination, board)
    chesspiece_location
  end

  def generate_moves(chesspiece_location)
    chesspiece_location
  end
end
