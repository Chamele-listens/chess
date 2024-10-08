require_relative 'chesspiece_main'

# King class for checking if checkmate or stalemate and limit kings movement
class King < Chesspiece
  include Basic_tools
  def initialize(type, color)
    @type = type
    @color = color
  end

  def king_move_check(chesspiece_location, chesspiece_distination, board)
    opponent_status = checked?(chesspiece_location, board)

    p checkmate?(chesspiece_location, opponent_status[0], board)

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
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    path = []

    check_king_surrounding(ver_pos, hor_pos, path, board)

    opponent_pieces = find_pieces_in_king_path(path, board)

    p opponent_pieces

    is_checked = find_path_to_king(chesspiece_location, opponent_pieces, board)

    [opponent_pieces, is_checked]
  end

  def checkmate?(chesspiece_location, opponent_pieces, board)
    # path_around_king = []

    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    all_pos = generate_all_possible_pos

    own_chesspieces = find_own_piece_from_path_set(all_pos, @color, board)

    p own_chesspieces

    chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board)

    opponent_path = generate_all_opponent_path(opponent_pieces, board)

    king_escape?(chesspiece_location, opponent_path)
  end

  def king_escape?(chesspiece_location, opponent_path)
    king_moves = generate_moves(chesspiece_location)

    !(king_moves - opponent_path).empty?
  end

  def generate_all_opponent_path(opponent_pieces, board)
    opponent_path = []

    opponent_pieces.each do |opp, opp_pos|
      temp_path = opp.generate_moves(opp_pos)

      move_limit(temp_path, board, opp.color) unless opp.is_a?(Knight)

      # p "#{temp_path} from #{opp.type} at #{opp_pos}"

      opponent_path << temp_path.flatten(1)

      opponent_path << [opp_pos]
    end

    opponent_path.flatten(1).uniq
  end

  def check_king_surrounding(ver_pos, hor_pos, path, board)
    generate_diagonal_moves(ver_pos, hor_pos, path)

    generate_vertical_horizontal_moves(path, ver_pos, hor_pos)

    # 4 generate_digonal_moves to check for knight further from the king
    generate_diagonal_moves(ver_pos, hor_pos - 1, path)

    generate_diagonal_moves(ver_pos, hor_pos + 1, path)

    generate_diagonal_moves(ver_pos + 1, hor_pos, path)

    generate_diagonal_moves(ver_pos - 1, hor_pos, path)

    move_limit(path, board, @color)

    remove_duplicate_pos(path)
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

      move_limit(opponent_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      p 'checked' if opponent_path.flatten(1).include?(chesspiece_location)
    end
  end

  def chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board)
    own_chesspieces.each do |chesspiece, pos|
      own_path = chesspiece.generate_moves(pos)

      move_limit(own_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      opponent_pieces.each do |opponent_chesspiece, opp_pos|
        opponent_path = opponent_chesspiece.generate_moves(opp_pos)

        move_limit(opponent_path, board, opponent_chesspiece.color) unless chesspiece.is_a?(Knight)

        opponent_path << [opp_pos]

        chess_path_intercept?(own_path, opponent_path, opponent_chesspiece, chesspiece)
      end
    end
  end

  def chess_path_intercept?(own_path, opponent_path, opponent_chesspiece, chesspiece)
    own_path.each do |path|
      opponent_path.each do |opp_path|
        opp_path.each do |opp_move|
          p "King is protected from #{opponent_chesspiece.type} at #{opp_move} by #{chesspiece.type}" if path.include?(opp_move) # rubocop:disable Layout/LineLength
        end
      end
    end
  end

  def find_own_piece_from_path_set(path_around_king, color, board)
    own_chesspieces = {}
    path_around_king.each do |path_set|
      path_set.each do |path|
        square = get_chesspiece_from_board(path, board)
        next unless square.is_a?(Chesspiece)

        own_chesspieces[square] = path if square.is_a?(Chesspiece) && square.color == color
      end
    end
    own_chesspieces
  end

  def generate_all_possible_pos(start_pos = [1, 0], all_pos = [])
    8.times do
      temp_pos = []
      8.times do
        temp_pos << [start_pos[0], start_pos[1] += 1]
      end
      all_pos << temp_pos
      start_pos[1] = 0
      start_pos[0] += 1
    end

    all_pos
  end
end
