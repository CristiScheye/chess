class Piece

  VERTS = [[1, 0], [-1,0], [0, 1], [0, -1]]
  DIAGS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  ALL_DIRS = VERTS + DIAGS

  attr_accessor :position
  attr_reader :color, :board

  def initialize(board, pos, color)
    @board = board
    @position = pos
    @color = color
  end

  def moves
    raise NotImplementedYet
  end

  def on_board?(coords)
    coords.all? {|coord| coord.between?(0,7) }
  end

  def capture_piece?(coords)
    target = board[coords]
    return false if target.nil?
    target.color != self.color
  end

  def contains_own_color?(coords)
    target = board[coords]
    return false if target.nil?
    board[coords].color == self.color
  end

  def displacement(old_pos, move)
    [old_pos[0] + move[0], old_pos[1] + move[1]]
  end

end



class SlidingPiece < Piece

  def moves #returns ALL possible moves (length & direction)
    valid_moves = []
    self.dirs.each do |direction|
      direction_moves = move_farther(direction)
      valid_moves += direction_moves unless direction_moves.empty?
    end
    valid_moves
  end

  def move_farther(direction)
    direction_moves = []
    coord = position
    until capture_piece?(coord)
      coord = displacement(coord, direction)
      break if !on_board?(coord)
      break if contains_own_color?(coord)
      direction_moves <<  coord
    end
    direction_moves
  end

end

class Bishop < SlidingPiece

  def dirs
    DIAGS
  end

  def render
    'B'
  end
end

class Rook < SlidingPiece

  def dirs
    VERTS
  end

  def render
    'R'
  end
end

class Queen < SlidingPiece
  def dirs
    ALL_DIRS
  end

  def render
    'Q'
  end
end

class SteppingPiece < Piece

  def moves(directions)
    valid_moves = []
    directions.map do |move|
      coord = displacement(position, move)
      valid_moves <<  coord if on_board?(coord) && !contains_own_color?(coord)
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

  def render
    'K'
  end
end

class King < SteppingPiece
  def moves
    super(ALL_DIRS)
  end

  def render
    'W'
  end
end

class Pawn < Piece

  def moves
    #REFACTOR!!!
    valid_moves = []
    if on_home?
      if color == :white
        valid_moves << displacement(position, [2, 0])
      else
        valid_moves << displacement(position, [-2, 0])
      end
    end

    if color == :white
      forward_move = displacement(position, [1, 0])
    else
      forward_move = displacement(position, [-1, 0])
    end

    if color == :white
      diag_left = displacement(position, [1, -1])
      diag_right = displacement(position, [1, 1])
      valid_moves << diag_left if capture_piece?(diag_left)
      valid_moves << diag_right if capture_piece?(diag_right)
    else
      diag_left = displacement(position, [-1, -1])
      diag_right = displacement(position, [-1, 1])
      valid_moves << diag_left if capture_piece?(diag_left)
      valid_moves << diag_right if capture_piece?(diag_right)
    end

    valid_moves << forward_move if on_board?(forward_move) && board[forward_move].nil?
  end

  def on_home?
    color == :white ? position[0] == 1 : position[0] == 6
  end

  def render
    'P'
  end
end

