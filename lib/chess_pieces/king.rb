require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include Basic_tools
  def initialize(type, color)
    @type = type
    @color = color
  end

  def king_move_check(chesspiece_location, chesspiece_distination, board)
    p mated?(chesspiece_location, board)

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

  def mated?(chesspiece_location, board)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    path = []

    generate_diagonal_moves(ver_pos, hor_pos, path)

    generate_vertical_horizontal_moves(path, ver_pos, hor_pos)

    move_limit(path, board, @color)

    opponent_pieces = find_pieces_in_king_path(path, board)

    find_path_to_king(chesspiece_location, opponent_pieces, board)

    path
  end

  def find_pieces_in_king_path(path, board)
    opponent_pieces = {}
    path.each do |path_set|
      path_set.each do |pos|
        if get_chesspiece_from_board(pos, board).is_a?(Chesspiece)
          opponent_pieces[get_chesspiece_from_board(pos, board)] = pos
        end
      end
    end
    opponent_pieces
  end

  def find_path_to_king(chesspiece_location, opponent_pieces, board)
    opponent_pieces.each do |chesspiece, pos|
      opponent_path = chesspiece.generate_moves(pos)

      move_limit(opponent_path, board, chesspiece.color)

      opponent_path.flatten(1).each do |opponent_move|
        if opponent_move == chesspiece_location
          p 'mated'
          break
        end
      end
    end
  end
end
