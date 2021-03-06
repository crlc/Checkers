require_relative 'piece.rb'
require 'colorize'
require 'byebug'
class Board
  attr_accessor :grid

  def initialize(colors, initial = true)
    @grid = Array.new(8) { Array.new(8) }
    @colors = colors
    setup_pieces(colors) if initial
  end

  def [](pos)
    i,j = pos
    @grid[i][j]
  end

  def []=(pos, obj)
    i,j = pos
    @grid[i][j] = obj
  end

  def dup
    dup_board = Board.new(@colors, false)
    @grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if col
          col = col.dup(dup_board)
          dup_board[[i, j]] = col
        end
      end
    end
    dup_board
  end

  def render
    system 'clear'
    @grid.reverse.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if (i.even? && j.even?) || (i.odd? && j.odd?)
          empt_col = :light_red
        else
          empt_col = :black
        end
        if col.nil?
          print "  ".colorize(:background => empt_col)
        else
          print "#{col.symbol} ".colorize(:color => col.color,
                                          :background => empt_col)
        end
      end
      puts
    end
  end

  def setup_pieces(colors)
    @grid.each_with_index do |row, i|
      next if i.between?(3,4)
      colors = (i < 4) ? @colors.first : @colors.last
      row.each_index do |j|
        next if (i.even? && j.even?) || (i.odd? && j.odd?)
        @grid[i][j] = Piece.new(colors, [i, j], self)
      end
    end
  end
end

# b = Board.new([:red, :black])
# b.render
