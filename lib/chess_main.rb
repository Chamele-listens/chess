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
# p b.add_new_chesspiece([6, 4], '♞', 'white')
# p b.add_new_chesspiece([4, 3], '♜', 'white')
# p b.add_new_chesspiece([4, 5], '♜', 'white')
# p b.add_new_chesspiece([4, 7], '♝', 'white')
p b.add_new_chesspiece([1, 8], '♚', 'white')
# p b.add_new_chesspiece([2, 3], '♟', 'white')
# 7.times { |i| b.add_new_chesspiece([2, i + 2], '♟', 'white') }
# p b.add_new_chesspiece([4, 5], '♛', 'white')
# p b.add_new_chesspiece([3, 5], '♝', 'white')
# p b.add_new_chesspiece([6, 3], '♝', 'white')
# p b.add_new_chesspiece([8, 7], '♜', 'white')
# p b.add_new_chesspiece([6, 2], '♕', 'black')
# p b.add_new_chesspiece([6, 2], '♜', 'white')
p b.add_new_chesspiece([6, 8], '♖', 'black')

p b.add_new_chesspiece([5, 8], '♔', 'black')
# p b.add_new_chesspiece([5, 1], '♖', 'black')
p b.add_new_chesspiece([6, 1], '♖', 'black')
p b.add_new_chesspiece([1, 6], '♜', 'white')
p b.add_new_chesspiece([7, 5], '♜', 'white')
# p b.add_new_chesspiece([1, 7], '♜', 'white')
# p b.add_new_chesspiece([1, 7], '♞', 'white')
p b.add_new_chesspiece([4, 8], '♙', 'black')

# p b.knight_move([4,4],[6,6])
b.show_grid

b.start(b)

# p b
