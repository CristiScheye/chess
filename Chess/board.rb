require 'debugger'
class Board

  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8)}
    set_pieces(:white)
    set_pieces(:black)
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
    render_string = "  0   1   2   3   4   5   6   7 \n"
    board.each do |row|
      row_string = ""
      row.each do |piece|
        piece_char = piece.nil? ? ' ' : piece.render
        row_string << " |#{piece_char}|"
      end
      render_string << "#{row_string}\n---------------------------------\n"
    end
    p "test Im rendering"
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

  def move(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    #Add Exceptions later
    piece = self[start_pos]

    p "#{piece.class} starting at at #{start_pos}"
    p "#{piece.class} can move to #{piece.moves}"
    if piece.moves && piece.moves.include?(end_pos)
      piece.position = end_pos
      board[end_row][end_col] = piece
      self[start_pos] = nil
    else
       puts "GOD DAMN IT"
       puts piece.moves
    end


    p "#{piece.class} now at #{end_pos}"

    if in_check?(piece.color)
      move(end_pos, start_pos)
      raise "DUH. CAN'T DO THAT."
    end
    self
  end

end
