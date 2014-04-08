class Piece

  attr_accessor :position

  def moves
    raise NotImplementedYet
  end
end

class SlidingPiece < Piece
  def moves
  end
end

class Bishop < SlidingPiece


end

class Rook < SlidingPiece
end

class Queen < SlidingPiece
end

class SteppingPiece < Piece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

class Pawn < Piece
end