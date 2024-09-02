# Store moves for chesspieces that share similars moves
module Move_set
  # Move sets for diagonal moves (Bishop)
  def generate_diagonal_moves(ver_pos, hor_pos, possible_moves)
    generate_upper_right_moves(ver_pos, hor_pos, possible_moves)
    generate_lower_right_moves(ver_pos, hor_pos, possible_moves)
    generate_upper_left_moves(ver_pos, hor_pos, possible_moves)
    generate_lower_left_moves(ver_pos, hor_pos, possible_moves)
  end

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

  # Moves for vertical and horizontal moves (Rook)
  def generate_right_moves(possible_moves, ver_pos, hor_pos)
    temp_moves = []
    (8 - hor_pos).times do
      hor_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_left_moves(possible_moves, ver_pos, hor_pos)
    temp_moves = []
    (hor_pos - 1).times do
      hor_pos -= 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_up_moves(possible_moves, ver_pos, hor_pos)
    temp_moves = []
    (8 - ver_pos).times do
      ver_pos += 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end

  def generate_down_moves(possible_moves, ver_pos, hor_pos)
    temp_moves = []
    (ver_pos - 1).times do
      ver_pos -= 1
      temp_moves << [ver_pos, hor_pos]
    end
    possible_moves << temp_moves
  end
end
