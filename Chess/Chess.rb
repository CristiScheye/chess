require './pieces'
require './board'


b = Board.new
b.board
b.render
b.move([1,2], [3,2])
b.render
b.move([3,2], [4, 2])
b.move([4, 2], [5,2])
b.render
b.move([5, 2], [6,2])
b.move([6, 2], [7,2])
b.render
b.move([5, 2], [7,3])
b.render


# b.move([7,1], [5,2])
# b.render




# pawn = Pawn.new(b, [7,7], :white)
# p pawn.moves
#
# pawn2 = Pawn.new(b, [3,3], :black)
# p pawn2.class

