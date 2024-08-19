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

  def add_new_chesspiece(chesspiece_distination, chess_type)
    select_grid(chesspiece_distination) do |square|
      square.data = if chess_type == '♞'
                      Knight.new(chess_type)
                    else
                      Chesspiece.new(chess_type)
                    end
    end
  end
end
