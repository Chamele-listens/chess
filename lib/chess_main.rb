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
p b.add_new_chesspiece([6, 4], '♞', 'white')
p b.add_new_chesspiece([4, 3], '♜', 'white')
# p b.add_new_chesspiece([4, 5], '♜', 'white')
p b.add_new_chesspiece([4, 7], '♝', 'white')
p b.add_new_chesspiece([5, 8], '♚', 'white')
p b.add_new_chesspiece([3, 3], '♟', 'white')
p b.add_new_chesspiece([6, 1], '♛', 'white')
# p b.add_new_chesspiece([2, 3], '♝', 'white')
# p b.add_new_chesspiece([6, 3], '♝', 'white')
p b.add_new_chesspiece([8, 7], '♜', 'white')
p b.add_new_chesspiece([5, 5], '♕', 'black')
p b.add_new_chesspiece([6, 7], '♖', 'black')
p b.add_new_chesspiece([8, 3], '♔', 'black')
# p b.add_new_chesspiece([4, 6], '♘', 'black')
# p b.add_new_chesspiece([6, 2], '♙', 'black')
# b.move([4, 5], [3, 4])
# b.move([3, 2], [5, 3])
# b.move([5, 8], [4, 8]) king
b.move([6, 2], [4, 2])
b.move([4, 2], [3, 2])
b.move([3, 2], [2, 2])
# b.move([2, 2], [1, 2])
# b.move([5, 8], [4, 8])
# p b.knight_move([4,4],[6,6])
b.show_grid

b.start

# p b
