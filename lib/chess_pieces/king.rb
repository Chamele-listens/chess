require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include Basic_tools
  def initialize(type, color)
    @type = type
    @color = color
  end

  def king_move_check(chesspiece_location, chesspiece_distination, board)
    p checked?(chesspiece_location, board)

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

  def checked?(chesspiece_location, board)
    path_around_king = []

    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    path = []

    generate_diagonal_moves(ver_pos, hor_pos, path)

    generate_vertical_horizontal_moves(path, ver_pos, hor_pos)

    move_limit(path, board, @color)

    opponent_pieces = find_pieces_in_king_path(path, board)

    p opponent_pieces

    find_path_to_king(chesspiece_location, opponent_pieces, board)

    find_all_king_own_piece(path_around_king, ver_pos, hor_pos, board)

    own_chesspiece = find_pieces_in_king_path(path_around_king, board)

    p own_chesspiece

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
      next if chesspiece.is_a?(King) && chesspiece.color == @color

      opponent_path = chesspiece.generate_moves(pos)

      move_limit(opponent_path, board, chesspiece.color)

      p 'checked' if opponent_path.flatten(1).include?(chesspiece_location)
    end
  end

  def find_all_king_own_piece(path_around_king, ver_pos, hor_pos, board)
    find_own_piece(path_around_king, ver_pos, hor_pos, board, -> { ver_pos + 0 }, -> { hor_pos + 0 })

    find_own_piece(path_around_king, ver_pos, hor_pos, board, -> { ver_pos + 1 }, -> { hor_pos + 0 })
    find_own_piece(path_around_king, ver_pos, hor_pos, board, -> { ver_pos - 1 }, -> { hor_pos + 0 })
    find_own_piece(path_around_king, ver_pos, hor_pos, board, -> { ver_pos + 0 }, -> { hor_pos + 1 })
    find_own_piece(path_around_king, ver_pos, hor_pos, board, -> { ver_pos + 0 }, -> { hor_pos - 1 })

    remove_duplicate_pos(path_around_king)
  end

  def find_own_piece(path_around_king, ver_pos, hor_pos, board, proc_ver, proc_hor)
    ver_pos = proc_ver.call
    hor_pos = proc_hor.call

    generate_diagonal_moves(ver_pos, hor_pos, path_around_king)

    generate_vertical_horizontal_moves(path_around_king, ver_pos, hor_pos)

    path_around_king << [[ver_pos, hor_pos]]

    move_limit(path_around_king, board, @color, Basic_tools.same_color_check, Basic_tools.diff_color_check)
  end
end
