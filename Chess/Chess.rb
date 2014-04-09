require './pieces'
require './board'
require './player'
require 'debugger'


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
      board.render

      begin
        start_pos, end_pos = current_player.get_move
        # validate_user_input(start_pos, end_pos)
      rescue
        puts 'Invalid input. Format should be f3, g2'
        retry
      end

      board.make_move(start_pos, end_pos)

      board.render
      # checks the move
      # play the move if valid

      current_player = other_player(current_player)
      @current_color = current_player.color
    end

    puts "Wait, did I say cheese?"
    puts "I did mean cheese"
  end

  def other_player(player)
    player == white_player ? black_player : white_player
  end

  def validate_user_input(start_pos, end_pos)
    p "tests"
    unless board[start_pos].own_color?(current_color)
      raise "Other player's piece"
    end
  end
end


game = Chess.new(HumanPlayer.new("jacky"), HumanPlayer.new("Jack the reap"))

game.play