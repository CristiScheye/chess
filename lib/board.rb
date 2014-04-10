require 'debugger'
require 'colorize'

class Board

  attr_accessor :board

  def initialize(place_pieces = true)
    @board = Array.new(8) { Array.new(8)}
    if place_pieces
      set_pieces(:white)
      set_pieces(:black)
    end
  end

  def set_pieces(color)
    row = color == :white ? 0 : 7
    @board[row] = [
      Rook.new(self,   [row, 0], color),
      Knight.new(self, [row, 1], color),
      Bishop.new(self, [row, 2], color),
      Queen.new(self,  [row, 3], color),
      King.new(self,   [row, 4], color),
      Bishop.new(self, [row, 5], color),
      Knight.new(self, [row, 6], color),
      Rook.new(self,   [row, 7], color)
        ]
    place_pawns(color)
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def place_pawns(color)
    row = color == :white ? 1 : 6
    @board.count.times do |index|
      @board[row][index] = Pawn.new(self, [row, index], color)
    end
  end

  def render
    puts "   A  B  C  D  E  F  G  H "
    board.each_with_index do |row,row_index|
      row_squares = row.map.with_index do |piece, col_index|
        square_color = ((row_index + col_index).even? ? :light_white : :black)
        if piece.nil?
          square_char = ' '
        else
          square_char = piece.render.colorize(piece.render_color).bold
        end
        square_char = " #{square_char} ".colorize(background: square_color)
      end
      row_str = row_squares.join
      puts "#{row_index + 1} #{row_str} #{row_index + 1}"
    end
    puts "   A  B  C  D  E  F  G  H "
  end

  def in_check?(color)
    king_pos = king_position(color)
    each_piece { |piece| return true if piece.moves && piece.moves.include?(king_pos) }
    false
  end

  def king_position(color)
    each_piece do |piece|
      return piece.position if piece.is_a?(King) && piece.color == color
    end
  end

  def each_piece(&blk)
    board.each do |row|
      row.each do |piece|
        next if piece.nil?
        blk.call(piece)
      end
    end
  end

  def dup
    duped_board = Board.new(false)
    each_piece do |piece|
      duped_piece = piece.dup
      duped_board[piece.position] = duped_piece
      duped_piece.board = duped_board
    end
    duped_board
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    piece.position = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
    self
  end


  def move(start_pos, end_pos)
    self.dup.move!(start_pos, end_pos)
  end


  def make_move(start_pos, end_pos)
    piece = self[start_pos]
    if piece.nil?
      raise InvalidMoveError, "Hmmm... no piece there."
    elsif !piece.valid_moves.include?(end_pos)
      raise InvalidMoveError, "WHAT THE DEUCE?! Can't move there."
    else
      move!(start_pos, end_pos)
    end
    nil
  end

  def checkmate?(color)
    checkmate = true
    each_piece do |piece|
      next if piece.color != color
      checkmate = false unless piece.valid_moves.empty?
    end
    checkmate
  end
end
