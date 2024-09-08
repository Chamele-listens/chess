# Parent class for describeing all chess pieces
class Chesspiece
  include Move_set
  attr_accessor :type, :color

  def initialize(type, color)
    @type = type
    @color = color
  end
end
