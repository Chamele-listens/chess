# reusable tool for debuging,gameplay and adding chess pieces on board
module Basic_tools
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

  def add_new_chesspiece(chesspiece_distination, chess_type, color)
    select_grid(chesspiece_distination) do |square|
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

  # For limiting chesspiece move to not move pass a chesspiece without destorying it
  def move_limit(possible_moves, board, color)
    possible_moves.each do |moves_set|
      moves_set.each_with_index do |moves, index|
        other_chesspiece = get_chesspiece_from_board(moves, board)

        # checks if the chess piece is a different color from the player
        moves_set.slice!((index + 1)..-1) if other_chesspiece.is_a?(Chesspiece) && other_chesspiece.color != color

        # checks if the chess piece is the same color as the player
        moves_set.slice!(index..-1) if other_chesspiece.is_a?(Chesspiece) && other_chesspiece.color == color
      end
    end
    possible_moves
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
