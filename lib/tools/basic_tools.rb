
module Basic_tools
  def select_grid(user_grid_select,grid_location = [1,1],square = @board,&block)
      #grid_location = [1,1]

      starting_square_y = square

      loop do
          if grid_location == user_grid_select
              #return square.data
              #return yield(square)
              return block.call(square)
          end

          if square.right.nil?
              break
          end

          next_square_x = square.right
          square = next_square_x
          grid_location[1] += 1
      end
      grid_location[1] = 1
      grid_location[0] += 1
      return nil if grid_location[0] > user_grid_select[0]
      #next_square_y = starting_square_y.up

      select_grid(user_grid_select,grid_location,starting_square_y.up,&block)
  end

  def add_new_chesspiece(chesspiece_distination,chess_type)
      select_grid(chesspiece_distination) do |square|
          if chess_type == "♞"
              square.data = Knight.new(chess_type)
          else
              square.data = Chesspiece.new(chess_type)
          end
          #return square.data
      end
  end
end