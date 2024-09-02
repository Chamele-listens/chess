require_relative 'chesspiece_main'

class Queen < Chesspiece
  include Basic_tools
  attr_accessor :has_move

  def initialize(type)
    @type = type
    @has_move = false
  end

  def queen_move_check(chesspiece_location,chesspiece_distination,board)
    p 'ran'
  end

  def generate_moves(chesspiece_distination)
    p 'ran'
  end
end