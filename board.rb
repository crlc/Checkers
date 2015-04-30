require_relative 'piece.rb'

class Board

  def initialize(initial = true)
    @grid = Array.new(8) { Array.new(8) }
    setup_pieces if initial
  end

  def dup
    dup_board = Board.new(false)
    self.each do |row, i|
      row.each do |col, j|
        if col
          col = col.dup(dup_board)
          dup_board[i][j] = col
        end
      end
    end
    dup_board
  end

  def over?
    won? || lost?
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

  def setup_pieces
    @grid.each_with_index do |row, i|
      next if i.between?(3,4)
      color = (i < 4) ? :red : :black
      row.each_index do |j|
        next if (i.even? && j.even?) || (i.odd? && j.odd?)
        @grid[i][j] = Piece.new(color, [i, j], self)
      end
    end
  end
end
