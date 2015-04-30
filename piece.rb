class Piece

  def initialize(color, initial_position)
    @king = false
    @color = color
    @pos = initial_position
  end

  def move_diffs
    array = [[1,1],[1,-1]]
    if @king
      array = array + array.map {|row, col| [-row, -col]}
    else
      array.map! {|row, col| [-row, -col]} unless @color == :red
    end

    array
  end

  def perform_jump
    positions = move_diffs.map {|row, col| [row * 2, col * 2]}

  end

  def perform_slide(end_pos)
    #select the moves that are on the board have no one on them
    positions = move_diffs.map {|row, col| (row + @pos.first), (col + @post.last)}
    if positions.include?(end_pos)
      @board[end_pos], @board[@pos] = @board[@pos], nil #move the piece if a valid move
      @pos = end_pos
    else
      raise InvalidMoveError "Not a valid move"
    end
    maybe_promote
  end

  protected

  def back_row?
    case @color
    when :white
      @pos.first == 0
    when :red
      @pos.first == 7
    end
  end

  def maybe_promote
    @king = true if back_row?
  end

end

class InvalidMoveError < StandardError ; end
