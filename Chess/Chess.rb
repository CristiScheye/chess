require './pieces'
require './board'
require './player'
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
    puts "CHEESE!!!!!"

    current_player = white_player
    @current_color = current_player.color

    until board.checkmate?(@current_color)
      # debugger
      board.render

      begin
        puts "#{current_player.name}'s turn (#{@current_color.to_s})".colorize(:white)
        start_pos, end_pos = current_player.get_move
        puts "Got the move"

        if start_pos == "save"
          save_time = Time.now
          filename = save_time.strftime("chess_%F_%H%M%S.yml")
          save_game(filename)
          puts "Saved game as #{filename}. Keep playing or press CTRL+C to exit."
          # current_player = other_player(current_player)
          # @current_color = current_player.color
          # p @current_color
        end

        board.make_move(start_pos, end_pos)

      rescue
        puts 'Invalid move. Try again. Format should be f3, g2'.colorize(:red)
        retry
      end
      current_player = other_player(current_player)
      @current_color = current_player.color
    end

    puts "Wait, did I say cheese?"
    puts "I did mean cheese"
  end

  def other_player(player)
    player == white_player ? black_player : white_player
  end

  def save_game(filename)
    File.open(filename, "w") do |f|
      f.write(self.to_yaml)
    end
  end

  def self.load_game
    filename = ARGV.shift
    YAML::load_file(filename).play
  end

end

if $PROGRAM_NAME == __FILE__

  if ARGV.count == 0
    game = Chess.new(HumanPlayer.new("jacky"), HumanPlayer.new("Jack the reap"))
    game.play
  else
    Chess.load_game
  end
end

game = Chess.new(HumanPlayer.new("jacky"), HumanPlayer.new("Jack the reap"))

game.play

