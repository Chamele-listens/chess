require_relative 'chesspiece_main'

class Rook < Chesspiece
  def initialize(type)
    @type = type
  end

  def rook_move_check(chesspiece_location, chesspiece_distination)
    pass
  end

  def generate_moves(chesspiece_location)
    pass
  end
end