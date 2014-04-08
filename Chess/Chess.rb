class Piece

  VERTS = [[1, 0], [-1,0], [0, 1], [0, -1]]
  DIAGS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  attr_accessor :position

  # def initialize(board, pos, color)
  #   @board = board
  #   @pos = pos
  #   @color = color
  # end

  def moves
    raise NotImplementedYet
  end

  def on_board?(coords)
    coords.all? {|coord| coord.between?(0,7) }
  end

  def displacement(old_pos, move)
    [old_pos[0] + move[0], old_pos[1] + move[1]]
  end
end

class SlidingPiece < Piece

  def moves(directions) #returns ALL possible moves (length & direction)
    valid_moves = []
    directions.each do |direction|
      direction_moves = move_farther(direction)
      valid_moves += direction_moves unless direction_moves.empty?
    end
    valid_moves
  end

  def move_farther(direction)
    direction_moves = []
    coord = position
    while true do
      coord = displacement(coord, direction)
      on_board?(coord) ? direction_moves <<  coord : break
    end
    direction_moves
  end

end

class Bishop < SlidingPiece
  def moves
    super(DIAGS)
  end

end

class Rook < SlidingPiece

  def moves
    super(VERTS)
  end
end

class Queen < SlidingPiece

  def moves
    super(DIAGS + VERTS)
  end
end

class SteppingPiece < Piece

  def moves(directions)
    valid_moves = []
    directions.map do |move|
      coord = displacement(position, move)
      valid_moves <<  coord if on_board?(coord)
    end
    valid_moves
  end

end

class Knight < SteppingPiece
  MOVES = [
            [2,1],[2,-1],[-2,1],[-2,-1],
            [1,2],[1,-2],[-1,2],[-1,-2]
          ]
  def moves
    super(MOVES)
  end
end

class King < SteppingPiece
  # MOVES = [
  #           [1, 0],[1, 1],[1, -1],[0, 1],
  #           [0, -1],[-1, 1],[-1, 0],[-1, -1]
  #         ]

    def moves
      super(VERTS + DIAGS)
    end
end

class Pawn < Piece
end
knight = King.new
knight.position = [7,7]
p knight.moves

queen = Queen.new
queen.position = [7,7]
p queen.moves

