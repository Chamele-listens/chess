require_relative 'chesspiece_main'

class Bishop < Chesspiece
  include Basic_tools
  def initialize(type)
    @type = type
  end

  def bishop_move_check(chesspiece_location, chesspiece_distination, board)
    generate_moves(chesspiece_location)
    p 'Ran!'
  end

  def generate_moves(chesspiece_location)
    chesspiece_location
  end
end
