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
    return if ver_pos >= 8 || hor_pos >= 8

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
    return if ver_pos <= 1 || hor_pos >= 8

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
    return if ver_pos >= 8 || hor_pos <= 1

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
    return if ver_pos <= 1 || hor_pos <= 1

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
  def generate_vertical_horizontal_moves(possible_moves, ver_pos, hor_pos)
    generate_right_moves(possible_moves, ver_pos, hor_pos)
    generate_left_moves(possible_moves, ver_pos, hor_pos)
    generate_up_moves(possible_moves, ver_pos, hor_pos)
    generate_down_moves(possible_moves, ver_pos, hor_pos)
  end

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

  # all king's moves
  def generate_king_moves(chesspiece_location)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    possible_moves = []

    generate_upper_moves(ver_pos, hor_pos, possible_moves)
    generate_lower_moves(ver_pos, hor_pos, possible_moves)
    generate_left_right_moves(ver_pos, hor_pos, possible_moves)

    possible_moves
  end

  def generate_upper_moves(ver_pos, hor_pos, possible_moves)
    ver_pos += 1
    hor_pos -= 1

    3.times do
      break if ver_pos > 8

      # special case for when king is at the edge or corner of the board (so king stay in range)
      if hor_pos < 1
        hor_pos += 1
        next
      end

      next if hor_pos > 8

      possible_moves << [ver_pos, hor_pos]
      hor_pos += 1
    end
  end

  def generate_lower_moves(ver_pos, hor_pos, possible_moves)
    ver_pos -= 1
    hor_pos -= 1

    3.times do
      break if ver_pos < 1

      # special case for when king is at the edge or corner of the board (so king stay in range)
      if hor_pos < 1
        hor_pos += 1
        next
      end

      next if hor_pos > 8

      possible_moves << [ver_pos, hor_pos]
      hor_pos += 1
    end
  end

  def generate_left_right_moves(ver_pos, hor_pos, possible_moves)
    possible_moves << [ver_pos, hor_pos - 1] if (hor_pos - 1) >= 1
    possible_moves << [ver_pos, hor_pos + 1] if (hor_pos + 1) <= 8
  end
end
