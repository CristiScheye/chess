class Player
  attr_accessor :name, :color

  def initialize(name)
    @name = name
  end

end

class HumanPlayer < Player

  attr_reader :letter_map

  def initialize(name)
    super(name)
    @letter_map = {}
    make_translation_hash
  end

  def get_move
    start_pos, end_pos = gets.chomp.split(',')
    [start_pos, end_pos].map{|coords_string| translate(coords_string) }
  end

  def translate(coords_string)
    row_char, col_num = coords_string.split("")
    row_num = letter_map[row_char]
    [row_num, col_num.to_i]
  end


  def make_translation_hash
    ('a'..'i').to_a.each_with_index do |char, index|
      letter_map[char] = index
    end
  end

  def translate(coords_string)
    row_char, col_num = coords_string.split("")
    row_num = letter_map[row_char]
    [row_num, col_num.to_i]
  end

end

class ComputerPlayer < Player
end
