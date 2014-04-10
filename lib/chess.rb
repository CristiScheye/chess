require './pieces'
require './board'
require './player'
require './error'

require 'debugger'
require 'colorize'
require 'yaml'

class Chess
  attr_accessor :white_player, :black_player, :board

  def initialize(player1, player2)
    @white_player = player1
    @black_player = player2
    @board = Board.new

    set_player_colors
  end

  def set_player_colors
    self.white_player.color = :white
    self.black_player.color = :black
  end

  def play
    puts "Let's play Chess!"

    current_player = white_player
    current_color = :white

    until board.checkmate?(current_color)
      board.render

      begin
        puts "#{current_player.name}'s turn (#{current_color.to_s})".colorize(:white)
        start_pos, end_pos = current_player.get_move

        save_game if start_pos == "save"

        board.make_move(start_pos, end_pos)

      rescue RuntimeError => e
        puts e.message.colorize(:red)
        retry
      end
      current_player = other_player(current_player)
      current_color = other_color(current_color)
    end

    puts 'Checkmate! Game Over.'
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def other_player(player)
    player == white_player ? black_player : white_player
  end

  def save_game
    save_time = Time.now
    filename = save_time.strftime("chess_%F_%H%M%S.yml")
    if File.write(filename, self.to_yaml)
      puts "Saved game as #{filename}."
      puts 'Keep playing or press CTRL+C to exit.'
    end
  end

  def self.load_game
    filename = ARGV.shift
    YAML::load_file(filename).play
  end
end
