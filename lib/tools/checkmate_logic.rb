# module containing all logic for checking if a king is in checkmate
module Checkmate_logic
  def checked?(chesspiece_location, board, color)
    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    path = []

    path = generate_all_possible_pos

    opponent_pieces = find_pieces_in_king_path(path, board)

    # p opponent_pieces

    opponent_pieces.reject! { |chesspiece| chesspiece.color == color }

    is_checked = find_path_to_king(chesspiece_location, opponent_pieces, board, color)

    [opponent_pieces, is_checked]
  end

  def checkmate?(chesspiece_location, opponent_pieces, board, color)
    # path_around_king = []

    location = chesspiece_location.dup

    ver_pos = location[0]
    hor_pos = location[1]

    own_chesspieces = get_king_own_chesspiece_in_check(chesspiece_location, opponent_pieces, color, board)

    # return false if opponent_pieces.count <= own_chesspieces.count

    # use king_escape? or if there's any piece that can protct him
    # as a way to check for checkmate

    p 'ran'

    # TODO: change naming convention for opponent_pieces

    temp_opponent_pieces = remove_non_dangerous_piece(chesspiece_location, opponent_pieces)

    opponent_path = generate_all_opponent_path(temp_opponent_pieces, board)

    return true if king_escape?(chesspiece_location, opponent_path, board) && own_chesspieces.count.zero?

    false
  end

  def stalemate?(opponent_pieces, opponent_path, chesspiece_location, color, board)
    king_moves = generate_king_moves(chesspiece_location)
    # return false if king_moves.count { |move| check_chesspiece_color(move, board, color) } > 1

    king_moves.reject! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) }

    return false if find_piece_to_prevent_stalemate?(color, board, opponent_pieces) == true

    p "#{!opponent_path.include?(chesspiece_location)} and #{(king_moves - opponent_path).empty?}"

    if !opponent_path.include?(chesspiece_location) && (king_moves - opponent_path).empty?
      p 'stalemate'
      return true
    end

    false
  end

  def find_piece_to_prevent_stalemate?(color, board, opponent_pieces)
    own_chesspiece_path = []

    all_opp_pos = []

    own_chesspieces = get_all_king_pieces(color, board)

    own_chesspiece_path = generate_king_pieces_path(own_chesspiece_path, own_chesspieces, board)

    opponent_pieces.each_value { |opp_pos| all_opp_pos << opp_pos }

    if own_chesspiece_path.flatten(2).any? { |path| all_opp_pos.include? path }
      # p 'Own piece can prevent stalemate !'
      true
    else
      # p "Own piece can't prevent stalemate !"
      false
    end
  end

  def get_all_king_pieces(color, board)
    all_pos = generate_all_possible_pos

    own_chesspieces = find_own_piece_from_path_set(all_pos, color, board)

    own_chesspieces.reject! { |chesspiece| chesspiece.is_a?(King) }

    own_chesspieces
  end

  def generate_king_pieces_path(own_chesspiece_path, own_chesspieces, board)
    own_chesspieces.each do |chesspiece, pos|
      own_path = chesspiece.generate_moves(pos)

      own_path = opponent_chesspiece_nearby_own_piece(own_path, pos, board) if chesspiece.is_a?(Pawn)

      move_limit(own_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      own_chesspiece_path << own_path
    end

    own_chesspiece_path
  end

  def get_king_own_chesspiece_in_check(chesspiece_location, opponent_pieces, color, board)
    all_pos = generate_all_possible_pos

    own_chesspieces = find_own_piece_from_path_set(all_pos, color, board)

    own_chesspieces.reject! { |chesspiece| chesspiece.is_a?(King) }

    # p own_chesspieces

    own_chesspieces = chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board, chesspiece_location)

    remove_pawn_that_cant_protect_king(own_chesspieces, color, board)
  end

  def king_escape?(chesspiece_location, opponent_path, board)
    king_moves = generate_king_moves(chesspiece_location)
    king_moves << chesspiece_location
    king_moves.reject! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) }
    true if (king_moves - opponent_path).empty?
  end

  def generate_all_opponent_path(opponent_pieces, board)
    opponent_path = []

    opponent_pieces.each do |opp, opp_pos|
      temp_path = opp.generate_moves(opp_pos)

      # move_limit(temp_path, board, opp.color) unless opp.is_a?(Knight)

      # p "#{temp_path} from #{opp.type} at #{opp_pos}"

      opponent_path << temp_path.flatten(1)

      yield(opponent_path, opp_pos) if block_given?
    end

    opponent_path.flatten(1).uniq
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

  def find_path_to_king(chesspiece_location, opponent_pieces, board, color)
    opponent_pieces.each do |chesspiece, pos|
      next if chesspiece.is_a?(King) && chesspiece.color == color

      opponent_path = chesspiece.generate_moves(pos)

      move_limit(opponent_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      if opponent_path.flatten(1).include?(chesspiece_location)
        p 'King is in check'
        return true
      end
    end
    false
  end

  def remove_non_dangerous_piece(chesspiece_location, opponent_pieces)
    dangerouse_piece = {}
    opponent_pieces.each do |chesspiece, pos|
      temp_moves = chesspiece.generate_moves(pos)
      temp_moves.flatten!(1)

      # p 'King is in danger !' if temp_moves.include?(chesspiece_location)
      dangerouse_piece[chesspiece] = pos if temp_moves.include?(chesspiece_location)
    end
    dangerouse_piece
  end

  def remove_pawn_that_cant_protect_king(own_chesspieces, color, board)
    own_chesspieces.each do |pawn, pos|
      next unless pawn.is_a?(Pawn)

      ver_pos = pos[0]
      hor_pos = pos[1]

      pos = [ver_pos + 1, hor_pos] if color == 'white'
      pos = [ver_pos - 1, hor_pos] if color == 'black'

      own_chesspieces.delete(pawn) if get_chesspiece_from_board(pos, board).is_a?(Chesspiece)
    end
    own_chesspieces
  end

  def chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board, king_location)
    chesspiece_protect_king = {}

    own_chesspieces.each do |chesspiece, pos|
      own_path = chesspiece.generate_moves(pos)

      own_path = opponent_chesspiece_nearby_own_piece(own_path, pos, board) if chesspiece.is_a?(Pawn)

      move_limit(own_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      compare_own_piece_with_opponent_path(chesspiece_protect_king, pos, board, opponent_pieces, king_location, chesspiece, own_path) # rubocop:disable Layout/LineLength
    end
    p chesspiece_protect_king
    chesspiece_protect_king
  end

  def compare_own_piece_with_opponent_path(chesspiece_protect_king, pos, board, opponent_pieces, king_location, chesspiece, own_path) # rubocop:disable Metrics/ParameterLists,Layout/LineLength
    opponent_pieces.each do |opponent_chesspiece, opp_pos|
      opponent_path = opponent_chesspiece.generate_moves(opp_pos)

      move_limit(opponent_path, board, opponent_chesspiece.color) unless opponent_pieces.is_a?(Knight)

      opponent_path = chesspiece_cutoff_moves(opponent_chesspiece, opponent_path, opp_pos, king_location)

      opponent_path << [opp_pos]

      temp = chess_path_intercept?(own_path, opponent_path, opponent_chesspiece, chesspiece)

      next if filter_non_dangerous_piece(temp, opponent_chesspiece, opponent_path, king_location) == false

      chesspiece_protect_king[temp] = pos
    end
  end

  def filter_non_dangerous_piece(temp, opponent_chesspiece, opponent_path, king_location)
    return false if temp == false

    return false if temp.is_a?(Pawn) && opponent_chesspiece.is_a?(Knight)

    return false if opponent_chesspiece_dangerous?(opponent_path, king_location) == false

    true
  end

  def chesspiece_cutoff_moves(opponent_chesspiece, opponent_path, opp_pos, king_location)
    opponent_path = cutoff_bishop_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Bishop)

    opponent_path = cutoff_rook_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Rook)

    opponent_path = cutoff_queen_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Queen)

    opponent_path
  end

  def opponent_chesspiece_dangerous?(opponent_path, king_location)
    return true if opponent_path.flatten(1).include?(king_location)

    false
  end

  def cutoff_bishop_moves(chess_path, pos, king_pos)
    temp = []

    king_ver_pos = king_pos[0]
    king_hor_pos = king_pos[1]

    ver_pos = pos[0]
    hor_pos = pos[1]

    chess_path.each do |path|
      if king_hor_pos > hor_pos # lower and upper right
        if king_ver_pos < ver_pos
          temp << path.select { |move| move[0] < ver_pos && move[1] > hor_pos }
        elsif king_ver_pos > ver_pos
          temp << path.select { |move| move[0] > ver_pos && move[1] > hor_pos }
        end
      end

      if king_hor_pos < hor_pos # lower and upper left
        if king_ver_pos < ver_pos
          temp << path.select { |move| move[0] < ver_pos && move[1] < hor_pos }
        elsif king_ver_pos > ver_pos
          temp << path.select { |move| move[0] > ver_pos && move[1] < hor_pos }
        end
      end
    end

    temp
  end

  def cutoff_rook_moves(chess_path, pos, king_pos)
    temp = []

    king_ver_pos = king_pos[0]
    king_hor_pos = king_pos[1]

    ver_pos = pos[0]
    hor_pos = pos[1]

    chess_path.each do |path|
      if king_hor_pos == hor_pos # horizontal
        if king_ver_pos < ver_pos
          temp << path.select { |move| move[0] < ver_pos && move[1] == hor_pos }
        elsif king_ver_pos > ver_pos
          temp << path.select { |move| move[0] > ver_pos && move[1] == hor_pos }
        end
      end

      if king_ver_pos == ver_pos # vertical
        if king_hor_pos > hor_pos
          temp << path.select { |move| move[0] == ver_pos && move[1] > hor_pos }
        elsif king_hor_pos < hor_pos
          temp << path.select { |move| move[0] == ver_pos && move[1] < hor_pos }
        end
      end
    end

    temp
  end

  def cutoff_queen_moves(chess_path, pos, king_pos)
    # p chess_path
    temp = []
    # not done yet
    king_ver_pos = king_pos[0]
    king_hor_pos = king_pos[1]

    ver_pos = pos[0]
    hor_pos = pos[1]

    temp << cutoff_rook_moves(chess_path, pos, king_pos).flatten(1)

    temp << cutoff_bishop_moves(chess_path, pos, king_pos).flatten(1)

    remove_duplicate_pos(temp)
    temp
  end

  def chess_path_intercept?(own_path, opponent_path, opponent_chesspiece, chesspiece)
    own_path.each do |path|
      opponent_path.each do |opp_path|
        opp_path.each do |opp_move|
          p "King is protected from #{opponent_chesspiece.type} at #{opp_move} by #{chesspiece.type}" if path.include?(opp_move) # rubocop:disable Layout/LineLength
          return chesspiece if path.include?(opp_move)
          # return true if path.include?(opp_move)
        end
      end
    end
    false
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
