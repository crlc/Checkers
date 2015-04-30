class Piece

  def initialize(color, initial_position)
    @king = false
    @color = color
    @pos = initial_position
  end

  def perform_jump
    positions = valid_pos(move_diffs.map {|row, col| [row * 2, col * 2]})

    if positions.include?(end_pos)
      @board[end_pos], @board[@pos] = @board[@pos], nil
      @board[enemy_pos(@pos, end_pos)] = nil
      @pos = end_pos
    elsif @board.possible_moves?
      #lose if no possible moves
    else
      raise InvalidMoveError "Not a valid move"
    end

    maybe_promote
  end

  def perform_slide(end_pos)
    positions = valid_pos(move_diffs)

    if positions.include?(end_pos)
      @board[end_pos], @board[@pos] = @board[@pos], nil
      @pos = end_pos
    elsif @board.possible_moves?
      #lose if no possible moves
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

  def enemy_pos(start, end)
    diff = [(end.first - start.first)/2, (end.last - start.last)/2]
    diff.map! {|row, col| (row + start.first), (col + start.last)}
  end

  def maybe_promote
    @king = true if back_row?
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

  def valid_pos(positions)
    positions.map! {|row, col| (row + @pos[0]), (col + @pos[-1])}
    positions.select! {|row, col| row.between?(0,7) && col.between?(0,7)}
    positions.select! {|pos| @board[pos].nil?}
  end

end

class InvalidMoveError < StandardError ; end
