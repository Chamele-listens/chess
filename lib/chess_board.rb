require_relative 'tools/basic_tools.rb'
require_relative 'chess_pieces/knight.rb'

class Vertex
    attr_accessor :up, :down, :left, :right, :data
    def initialize(data = "[ ]",up = nil,down = nil, left = nil, right = nil )
        @data = data
        @up = up
        @down = down
        @left = left
        @right = right
    end
end

class Chessboard
    include Basic_tools
    attr_accessor :board
    def initialize(board = nil)
        @board = board
    end

    def create_board(grid)
        @board = Vertex.new if @board.nil?
        square = @board
        counter = 0

        grid.times do
            starting_square_y = square

            counter += 1
            (grid-1).times do
                square.right = Vertex.new
                next_square_x = square.right
                next_square_x.left = square.object_id
                square = next_square_x      
            end

            return if counter == grid

            starting_square_y.up = Vertex.new
            next_square_y = starting_square_y.up
            next_square_y.down = starting_square_y.object_id
            square = starting_square_y.up
            #p "Hello"
        end

    end

    def show_grid(square = @board)
        full_display = {}
        horizontal_display = []
        grid_number = 0
        loop do 
            starting_square_y = square
            if starting_square_y.nil?
                break
            end
            grid_number += 1
            loop do
                if square.data.is_a?(Chesspiece)
                    #gsub(/[^a-z0-9\s]/i,'')
                    horizontal_display << "[#{square.data.type}]"
                else
                    horizontal_display << square.data
                end

                if square.right.nil?
                    full_display[grid_number] = horizontal_display
                    horizontal_display = []
                    break
                end

                
                next_square_x = square.right
                square = next_square_x
            end
            square = starting_square_y.up
        end
        full_display.reverse_each {|num,row| p "#{num} #{row}".gsub!(/"/, '')}
        row_num = []
        grid_number.times {|num| row_num << "#{num + 1}"}
        #puts "   #{row_num}"
        thing = " "
        row_num.each {|num| thing << "   #{num} " }
        p thing
    end

    def remove_chesspiece(chesspiece_location)
        select_grid(chesspiece_location) do |square|
            chesspiece = square.data
            square.data = "[ ]"
            return chesspiece
        end
    end

    def add_chesspiece(chesspiece_distination,chess_type)
        select_grid(chesspiece_distination) do |square|
            square.data = chess_type
            return square.data
        end
    end
    
    def move(chesspiece_location,chesspiece_distination)
        chess_type = select_grid(chesspiece_location) {|square| square.data}
        
        if chess_type.is_a?(Knight)
            #p "It is a knight"
            #p chess_type.knight_move(chesspiece_location,chesspiece_distination)
            temp = chess_type.knight_move_check(chesspiece_location,chesspiece_distination)
            return "invaild move" if temp == false
        end
        
        
        
        chess_type = remove_chesspiece(chesspiece_location)
        add_chesspiece(chesspiece_distination,chess_type)
        return chesspiece_distination
    end

    def generate_moves(chesspiece_location)
        location = chesspiece_location.dup

        possible_moves = []

        ver_cor = location[0]
        hor_cor = location[1]

        # Up position
        possible_moves << [ver_cor + 2,hor_cor - 1]
        possible_moves << [ver_cor + 2,hor_cor + 1]

        # down position
        possible_moves << [ver_cor - 2,hor_cor - 1]
        possible_moves << [ver_cor - 2,hor_cor + 1]

        #right position
        possible_moves << [ver_cor - 1, hor_cor + 2]
        possible_moves << [ver_cor + 1, hor_cor + 2]

        #left position
        possible_moves << [ver_cor - 1,hor_cor - 2]
        possible_moves << [ver_cor + 1,hor_cor - 2]

        #.select {|i| (i[0] < 8 && i[1] < 8) && (i[0] > 0 && i[1] > 0)}
        return possible_moves.select {|i| (i[0] < 8 && i[1] < 8) && (i[0] > 0 && i[1] > 0)}

    end

end
