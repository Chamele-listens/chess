require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include Basic_tools
  include Checkmate_logic
  def initialize(type, color)
    @type = type
    @color = color
  end

  def king_move_check(chesspiece_location, chesspiece_distination, board)
    # opponent_status = checked?(chesspiece_location, board)

    # p checkmate?(chesspiece_location, opponent_status[0], board)

    possible_moves = generate_moves(chesspiece_location)

    return true if possible_moves.include?(chesspiece_distination)

    false
  end

  def generate_moves(chesspiece_location)
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
