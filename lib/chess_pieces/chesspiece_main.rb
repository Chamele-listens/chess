# Parent class for describeing all chess pieces
class Chesspiece
  attr_accessor :type

  def initialize(type)
    @type = type
  end
end
