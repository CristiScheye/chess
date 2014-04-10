require './error'

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
    move_input = gets.chomp.split(',')
    if move_input == "save"
      return "save"
    elsif move_input.size != 2
      raise InputFormatError, 'Must enter start position, end position (e.g. b3, c3)'
    else
      move_input.map{|coords_string| translate(coords_string) }
    end
  end

  def translate(coords_string)
    coords_string = coords_string.gsub(' ', '').downcase
    row_char, col_num = coords_string.split("")
    row_num = letter_map[row_char]
    [row_num, col_num.to_i]
  end

  def make_translation_hash
    ('a'..'i').to_a.each_with_index do |char, index|
      letter_map[char] = index
    end
  end
end

class ComputerPlayer < Player
end
