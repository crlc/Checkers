require_relative 'board.rb'
require 'colorize'

class Game
  attr_accessor :board

  def initialize
    @colors = [:red, :black]
    @board = Board.new(@colors)
  end

  def play
    until over?
      @board.render
      print "Give me a starting position #{@colors.first} followed by an ending position(s) 11 22: "
      begin
        pos_array = prompt
        start_pos = pos_array.first
        if !@board[start_pos].nil? && @board[start_pos].color == @colors.first
          @board[start_pos].perform_moves(pos_array.drop(1))
          @colors.push(@colors.shift)
        else
          puts "Move your own piece, please!"
        end
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
    end
  end

  def prompt
    pos_array = gets.chomp.split(" ")
    pos_array.map! { |el| el.split("") }
    pos_array.map! { |el| el.map! { |str| str.to_i} }
    pos_array
  end

  def over?
    false
  end

end

g = Game.new
g.play
