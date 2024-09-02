# Store moves for chesspieces that share similars moves
module Move_set
  # Move sets for diagonal moves (Bishop)
  def generate_upper_right_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos += 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos >= 8 || hor_pos >= 8
    end
    possible_moves << temp_moves
  end

  def generate_lower_right_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos -= 1
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos <= 1 || hor_pos >= 8
    end
    possible_moves << temp_moves
  end

  def generate_upper_left_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos += 1
      hor_pos -= 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos >= 8 || hor_pos <= 1
    end
    possible_moves << temp_moves
  end

  def generate_lower_left_moves(ver_pos, hor_pos, possible_moves)
    temp_moves = []
    loop do
      ver_pos -= 1
      hor_pos -= 1
      temp_moves << [ver_pos, hor_pos]
      break if ver_pos <= 1 || hor_pos <= 1
    end
    possible_moves << temp_moves
  end
end
