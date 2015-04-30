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
    moves = move_diffs.map {|row, col| [row * 2, col * 2]}
    positions = valid_pos(move)

    maybe_promote
  end

  def perform_slide(end_pos)
    #select the moves that are on the board have no one on them
    positions = valid_pos(move_diffs)

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

  def valid_pos(positions)
    positions.map! {|row, col| (row + @pos[0]), (col + @pos[-1])}
    positions.select! {|row, col| row.between?(0,7) && col.between?(0,7)}
    positions.select! {|pos| @board[pos].nil?}
  end

end

class InvalidMoveError < StandardError ; end
