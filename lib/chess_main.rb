require_relative 'chess_board'

# a = Vertex.new
# a.up = "Hi"
# p a
# ♔
b = Chessboard.new
b.create_board(8)
# b.board.data = Chesspiece.new("♔")
# p b.add_new_chesspiece([1,1],"♔")
b.show_grid
p b.select_grid([1, 1]) { |square| square.data }
# p b.move([1,1],[1,3])
# b.show_grid
# b.add_chesspiece([2,2],"♞")
p b.add_new_chesspiece([6, 4], '♞')
p b.add_new_chesspiece([3, 2], '♜')
p b.add_new_chesspiece([4, 5], '♝')
p b.add_new_chesspiece([5, 8], '♚')
p b.add_new_chesspiece([3, 3], '♟')
b.move([3, 3], [5, 3])
b.move([5, 3], [6, 3])
# b.move([4, 4], [6, 5])
# p b.knight_move([4,4],[6,6])
b.show_grid

# p b
