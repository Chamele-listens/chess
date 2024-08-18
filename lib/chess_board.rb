require_relative 'tools/basic_tools'
require_relative 'chess_pieces/knight'

class Vertex
  attr_accessor :up, :right, :data

  def initialize(data = '[ ]', up = nil, right = nil)
    @data = data
    @up = up
    @right = right
  end
end

class Chessboard
  include Basic_tools
  attr_accessor :board

  def initialize(board = nil)
    @board = board
  end

  def create_board(grid = 8)
    @board = Vertex.new if @board.nil?
    starting_square_x = @board

    stack_row(starting_square_x, grid)
  end

  def stack_row(starting_square_x, grid, counter = 0)
    grid.times do
      starting_square_y = starting_square_x

      counter += 1

      create_row(grid, starting_square_x)

      return if counter == grid

      starting_square_y.up = Vertex.new
      starting_square_x = starting_square_y.up
    end
  end

  def create_row(grid, starting_square_x)
    (grid - 1).times do
      starting_square_x.right = Vertex.new
      next_square_x = starting_square_x.right
      starting_square_x = next_square_x
    end
  end

  def show_grid(square = @board)
    full_display = {}
    grid_number = 0

    loop do
      starting_square_y = square
      break if starting_square_y.nil?

      grid_number += 1

      row_to_display(full_display, square, grid_number)

      square = starting_square_y.up
    end

    print_board_to_console(full_display, grid_number)
  end

  def row_to_display(full_display, square, grid_number, horizontal_display = [])
    loop do
      horizontal_display << (square.data.is_a?(Chesspiece) ? "[#{square.data.type}]" : square.data)

      if square.right.nil?
        full_display[grid_number] = horizontal_display
        break
      end

      next_square_x = square.right
      square = next_square_x
    end
  end

  def print_board_to_console(full_display, grid_number)
    full_display.reverse_each { |num, row| p "#{num} #{row}".gsub!(/"/, '') }

    row_num = []
    grid_number.times { |num| row_num << (num + 1).to_s }
    number_row_button = ' '
    row_num.each { |num| number_row_button << "   #{num} " }
    p number_row_button
  end

  def remove_chesspiece(chesspiece_location)
    select_grid(chesspiece_location) do |square|
      chesspiece = square.data
      square.data = '[ ]'
      return chesspiece
    end
  end

  def add_chesspiece(chesspiece_distination, chess_type)
    select_grid(chesspiece_distination) do |square|
      square.data = chess_type
      return square.data
    end
  end

  def move(chesspiece_location, chesspiece_distination)
    chess_type = select_grid(chesspiece_location) { |square| square.data }

    if chess_type.is_a?(Knight)
      # p "It is a knight"
      # p chess_type.knight_move(chesspiece_location,chesspiece_distination)
      temp = chess_type.knight_move_check(chesspiece_location, chesspiece_distination)
      return 'invaild move' if temp == false
    end

    chess_type = remove_chesspiece(chesspiece_location)
    add_chesspiece(chesspiece_distination, chess_type)
    chesspiece_distination
  end

  def generate_moves(chesspiece_location)
    location = chesspiece_location.dup

    possible_moves = []

    ver_cor = location[0]
    hor_cor = location[1]

    # Up position
    possible_moves << [ver_cor + 2, hor_cor - 1]
    possible_moves << [ver_cor + 2, hor_cor + 1]

    # down position
    possible_moves << [ver_cor - 2, hor_cor - 1]
    possible_moves << [ver_cor - 2, hor_cor + 1]

    # right position
    possible_moves << [ver_cor - 1, hor_cor + 2]
    possible_moves << [ver_cor + 1, hor_cor + 2]

    # left position
    possible_moves << [ver_cor - 1, hor_cor - 2]
    possible_moves << [ver_cor + 1, hor_cor - 2]

    # .select {|i| (i[0] < 8 && i[1] < 8) && (i[0] > 0 && i[1] > 0)}
    possible_moves.select { |i| (i[0] < 8 && i[1] < 8) && (i[0] > 0 && i[1] > 0) }
  end
end
