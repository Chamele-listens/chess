# Parent class for describeing all chess pieces
class Chesspiece
  include Move_set
  attr_accessor :type

  def initialize(type)
    @type = type
  end
end
