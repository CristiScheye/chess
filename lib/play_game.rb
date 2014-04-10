require './chess'
require './pieces'
require './board'
require './player'

if $PROGRAM_NAME == __FILE__

  if ARGV.count == 1
    Chess.load_game
  else
    puts "Enter name for player 1"
    player1_name = gets.chomp
    puts "Enter name for player 2"
    player2_name = gets.chomp

    Chess.new(HumanPlayer.new(player1_name), HumanPlayer.new(player2_name)).play
  end
end
