require 'colorize'

class Piece

  VERTS = [[1, 0], [-1,0], [0, 1], [0, -1]]
  DIAGS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  ALL_DIRS = VERTS + DIAGS

  attr_accessor :position, :board
  attr_reader :color

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

  def other_color
    self.color == :white ? :black : :white
  end

  def valid_moves
    possible_moves = self.moves
    possible_moves.reject do |move|
      dup_board = board.move(position, move)
      dup_board.in_check?(self.color)
    end
  end

  def own_color?(test_color)
    color == test_color
  end

  def to_s
    "#{self.class} #{position} #{color}"
  end

  def inspect
    self.to_s
  end
end



class SlidingPiece < Piece

  def moves #returns ALL possible moves (length & direction)
    possible_moves = []
    self.dirs.each do |direction|
      direction_moves = move_farther(direction)
      possible_moves += direction_moves
    end
    possible_moves
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
    possible_moves = []
    directions.each do |move|
      coord = displacement(position, move)
      possible_moves <<  coord if on_board?(coord) && !contains_own_color?(coord)
    end
    possible_moves
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
    "\u2654"
  end
end

class Pawn < Piece

  def moves
    #REFACTOR!!!
    possible_moves = []
    if on_home?
      if color == :white
        forward2 = displacement(position, [2, 0])
      else
        forward2 = displacement(position, [-2, 0])
      end
      possible_moves << forward2 if valid_forward?(forward2)
    end

    if color == :white
      forward1 = displacement(position, [1, 0])
    else
      forward1 = displacement(position, [-1, 0])
    end

    possible_moves << forward1 if valid_forward?(forward1)

    if color == :white
      diag_left = displacement(position, [1, -1])
      diag_right = displacement(position, [1, 1])
      possible_moves << diag_left if capture_piece?(diag_left)
      possible_moves << diag_right if capture_piece?(diag_right)
    else
      diag_left = displacement(position, [-1, -1])
      diag_right = displacement(position, [-1, 1])
      possible_moves << diag_left if capture_piece?(diag_left)
      possible_moves << diag_right if capture_piece?(diag_right)
    end
    possible_moves
  end

  def on_home?
    color == :white ? position[0] == 1 : position[0] == 6
  end

  def render
    'P'
  end

  def valid_forward?(next_position)
      on_board?(next_position) &&
      !capture_piece?(next_position) &&
      !contains_own_color?(next_position)
  end

end

