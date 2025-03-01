# reusable tool for debuging,gameplay and adding chess pieces on board
module Basic_tools
  @@same_color_check_block = ->(other_chesspiece, color) { other_chesspiece.color == color }
  @@diff_color_check_block = ->(other_chesspiece, color) { other_chesspiece.color != color }

  def self.same_color_check
    @@same_color_check_block
  end

  def self.diff_color_check
    @@diff_color_check_block
  end

  def select_grid(user_grid_select, grid_location = [1, 1], square = @board, &block)
    starting_square_y = square

    loop do
      return block.call(square) if grid_location == user_grid_select

      break if square.right.nil?

      next_square_x = square.right
      square = next_square_x
      grid_location[1] += 1
    end
    grid_location[1] = 1
    grid_location[0] += 1
    return nil if grid_location[0] > user_grid_select[0]

    select_grid(user_grid_select, grid_location, starting_square_y.up, &block)
  end

  def add_new_chesspiece(chesspiece_distination, chess_type, color, board = @board)
    select_grid(chesspiece_distination, [1, 1], board) do |square|
      square.data = case chess_type
                    when '♞', '♘'
                      Knight.new(chess_type, color)
                    when '♜', '♖'
                      Rook.new(chess_type, color)
                    when '♝', '♗'
                      Bishop.new(chess_type, color)
                    when '♚', '♔'
                      King.new(chess_type, color)
                    when '♟', '♙'
                      Pawn.new(chess_type, color)
                    when '♛', '♕'
                      Queen.new(chess_type, color)
                    else
                      Chesspiece.new(chess_type, color)
                    end
    end
  end

  def get_chesspiece_from_board(moves, board)
    select_grid(moves, [1, 1], board) { |square| square.data }
  end

  def check_chesspiece_color(chesspiece_location, board, color)
    chesspiece = get_chesspiece_from_board(chesspiece_location, board)
    chesspiece.is_a?(Chesspiece) && chesspiece.color == color
  end

  # For limiting chesspiece move to not move pass a chesspiece without destorying it
  # uses block to determine which pieces can a chess piece destory
  def move_limit(possible_moves, board, color, color_check_block1 = @@diff_color_check_block, color_check_block2 = @@same_color_check_block) # rubocop:disable Layout/LineLength
    possible_moves.each do |moves_set|
      moves_set.each_with_index do |moves, index|
        other_chesspiece = get_chesspiece_from_board(moves, board)

        # checks if the chess piece is a different color from the player (if @@diff_color_check_block is given)
        if other_chesspiece.is_a?(Chesspiece) && color_check_block1.call(other_chesspiece, color)
          moves_set.slice!((index + 1)..-1)
        end

        # checks if the chess piece is the same color as the player (if @@same_color_check_block is given)
        if other_chesspiece.is_a?(Chesspiece) && color_check_block2.call(other_chesspiece, color)
          moves_set.slice!(index..-1)
        end
      end
    end
    possible_moves
  end

  def remove_duplicate_pos(path_set)
    visited_path = []

    output = ''

    output = path_set.map do |path|
      new_path = path.uniq - visited_path
      visited_path += new_path
      new_path
    end

    output.reject!(&:empty?)
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

  # method to check if pawn can attack nearby piece
  def opponent_chesspiece_nearby_own_piece(possible_moves, chesspiece_location, board)
    ver_pos = chesspiece_location[0]
    hor_pos = chesspiece_location[1]

    both_side = []

    current_pawn = get_chesspiece_from_board(chesspiece_location, board)

    if current_pawn.color == 'white'
      possible_moves = attack_black_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    elsif current_pawn.color == 'black'
      possible_moves = attack_white_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    end

    [possible_moves.flatten(1)]
  end

  def attack_black_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    both_side << [ver_pos + 1, hor_pos + 1] # right side
    both_side << [ver_pos + 1, hor_pos - 1] # left side

    both_side.select! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) && get_chesspiece_from_board(move, board).color == 'black' } # rubocop:disable Layout/LineLength

    possible_moves << both_side
  end

  def attack_white_piece(both_side, ver_pos, hor_pos, possible_moves, board)
    both_side << [ver_pos - 1, hor_pos + 1] # right side
    both_side << [ver_pos - 1, hor_pos - 1] # left side

    both_side.select! { |move| get_chesspiece_from_board(move, board).is_a?(Chesspiece) && get_chesspiece_from_board(move, board).color == 'white' } # rubocop:disable Layout/LineLength

    possible_moves << both_side
  end

  def check_chess_type(chess_type)
    white_pieces = ['♚', '♛', '♜', '♝', '♞', '♟']
    black_pieces = ['♔', '♕', '♖', '♗', '♘', '♙']

    # same_color_block = -> { index }

    # diff_color_block = -> { (index + 1) }

    return true if white_pieces.include?(chess_type) # true for white

    false if black_pieces.include?(chess_type) # false for black
  end
end
