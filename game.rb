require_relative 'board.rb'
require 'colorize'

class Game

  def initialize
    @colors = [:red, :black]
    @board = Board.new(@colors)
  end

  def play
    until over?
      @board.render
      print "Give me a starting position followed by an ending position(s) 11 22"
      begin
        pos_array = gets.chomp.split
        if @board[pos_array.first].color == @colors.first
          @board[pos_array.first].perform_moves(pos_array.drop(1))
        else
          raise InvalidMoveError "Move your own piece, please!"
        end
        @colors.push(@colors.shift)
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
    end
  end

end

g = Game.new
g.play
