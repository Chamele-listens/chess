require_relative 'chesspiece_main'

class Bishop < Chesspiece
  include Basic_tools
  def initialize(type)
    @type = type
  end

  def bishop_move_check(chesspiece_location, chesspiece_distination)
    generate_moves(chesspiece_location)
  end

  def generate_moves(chesspiece_location)
    pass
  end
end
