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

    all_pos = generate_all_possible_pos

    own_chesspieces = find_own_piece_from_path_set(all_pos, color, board)

    own_chesspieces.reject! { |chesspiece| chesspiece.is_a?(King) }

    # p own_chesspieces

    own_chesspieces = chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board, chesspiece_location)

    own_chesspieces = remove_pawn_that_cant_protect_king(own_chesspieces, color, board)

    return false if opponent_pieces.count <= own_chesspieces.count

    p 'ran'

    opponent_path = generate_all_opponent_path(opponent_pieces, board)

    king_escape?(chesspiece_location, opponent_path, board)
  end

  def stalemate?(opponent_path, chesspiece_location, color, board)
    king_moves = generate_king_moves(chesspiece_location)
    return false if king_moves.count { |move| check_chesspiece_color(move, board, color) } > 1

    king_moves.reject! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) }

    if !opponent_path.include?(chesspiece_location) && (king_moves - opponent_path).empty?
      p 'stalemate'
      true
    else
      p 'nothing happen'
    end
  end

  def king_escape?(chesspiece_location, opponent_path, board)
    king_moves = generate_king_moves(chesspiece_location)
    king_moves << chesspiece_location
    king_moves.reject! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) }
    if (king_moves - opponent_path).empty?
      p 'checkmate'
      true
    end
  end

  def generate_all_opponent_path(opponent_pieces, board)
    opponent_path = []

    opponent_pieces.each do |opp, opp_pos|
      temp_path = opp.generate_moves(opp_pos)

      # move_limit(temp_path, board, opp.color) unless opp.is_a?(Knight)

      # p "#{temp_path} from #{opp.type} at #{opp_pos}"
      
      opponent_path << temp_path.flatten(1)

      opponent_path << [opp_pos]
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
    p own_chesspieces
  end

  def chesspiece_to_protect_king?(own_chesspieces, opponent_pieces, board, king_location)
    chesspiece_protect_king = {}

    own_chesspieces.each do |chesspiece, pos|
      own_path = chesspiece.generate_moves(pos)

      own_path = opponent_chesspiece_nearby_own_piece(own_path, pos, board) if chesspiece.is_a?(Pawn)

      move_limit(own_path, board, chesspiece.color) unless chesspiece.is_a?(Knight)

      opponent_pieces.each do |opponent_chesspiece, opp_pos|
        opponent_path = opponent_chesspiece.generate_moves(opp_pos)

        move_limit(opponent_path, board, opponent_chesspiece.color) unless chesspiece.is_a?(Knight)

        opponent_path = cutoff_bishop_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Bishop)

        opponent_path = cutoff_rook_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Rook)

        opponent_path = cutoff_queen_moves(opponent_path, opp_pos, king_location) if opponent_chesspiece.is_a?(Queen)

        opponent_path = [] if opponent_chesspiece.is_a?(Knight)

        opponent_path << [opp_pos]

        # Will find chess piece that can protect the king then store it in temp
        # then it stores it in chesspiece_protect_king as a hash along with the pices's
        # position. Then it'll be used for counting

        temp = ''

        temp = chess_path_intercept?(own_path, opponent_path, opponent_chesspiece, chesspiece)

        next if temp == false

        chesspiece_protect_king[temp] = pos
      end
    end
    p chesspiece_protect_king
    chesspiece_protect_king
  end

  def cutoff_bishop_moves(chess_path, pos, king_pos)
    king_ver_pos = king_pos[0]
    king_hor_pos = king_pos[1]

    ver_pos = pos[0]
    hor_pos = pos[1]

    if king_hor_pos < hor_pos && king_ver_pos < ver_pos # get lower_left
      chess_path = chess_path.slice(3)
    elsif king_hor_pos > hor_pos && king_ver_pos > ver_pos # get upper_right
      chess_path = chess_path.slice(0)
    elsif king_hor_pos < hor_pos && king_ver_pos > ver_pos # get upper_left
      chess_path = chess_path.slice(2)
    elsif king_hor_pos > hor_pos && king_ver_pos < ver_pos # get lower_right
      chess_path = chess_path.slice(1)
    end
    [chess_path]
  end

  def cutoff_rook_moves(chess_path, pos, king_pos)
    king_ver_pos = king_pos[0]
    king_hor_pos = king_pos[1]

    ver_pos = pos[0]
    hor_pos = pos[1]

    if king_hor_pos > hor_pos # get right
      chess_path = chess_path.slice(0)
    elsif king_hor_pos < hor_pos # get left
      chess_path = chess_path.slice(1)
    elsif king_ver_pos > ver_pos # get up
      chess_path = chess_path.slice(2)
    elsif king_ver_pos < ver_pos # get down
      chess_path = chess_path.slice(3)
    end
    [chess_path]
  end

  def cutoff_queen_moves(chess_path, pos, king_pos)
    # p chess_path
    temp = []
    # not done yet
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
