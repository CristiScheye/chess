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
    render_string = "   0   1   2   3   4   5   6   7 \n"
    letters = ("A".."I").to_a
    board.each_with_index do |row,index|

      row_string = ""
      row.each do |piece|
        piece_char = piece.nil? ? ' ' : piece.render
        row_string << " |#{piece_char}|"
      end
      render_string << "#{letters[index]}#{row_string}\n---------------------------------\n"
    end
    puts render_string
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
    #Add Exceptions later
    piece = self[start_pos]
    if piece && piece.moves && piece.valid_moves.include?(end_pos)
      move!(start_pos, end_pos)
    else
      raise 'WHAT THE DEUCE?!'
    end
    self
  end

  def checkmate?(color)
    checkmate = true
    each_piece do |piece|
      next if piece.color != color
      p "#{piece.to_s} valid moves: #{piece.valid_moves}" unless piece.valid_moves.empty?
      checkmate = false unless piece.valid_moves.empty?
    end
    checkmate
  end

end
