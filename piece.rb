class Piece
  attr_reader :board, :symbol, :color

  def initialize(color, initial_position, board)
    @color, @pos, @board = color, initial_position, board
    @king = false
  end

  def perform_jump(end_pos)
    positions = valid_pos(move_diffs.map {|row, col| [row * 2, col * 2]})

    if positions.include?(end_pos)
      @board[end_pos], @board[@pos] = @board[@pos], nil
      @board[enemy_pos(@pos, end_pos)] = nil
      @pos = end_pos
      #perform_moves!
    else
      raise InvalidMoveError "Not a valid move"
    end

    maybe_promote
  end

  def perform_moves(move_sequence)
    if valid_moves_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError "Not a valid move"
    end
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      perform_slide(move_sequence.shift)
    else
      until move_sequence.empty?
        perform_jump(move_sequence.shift)
      end
    end
  end

  def perform_slide(end_pos)
    positions = valid_pos(move_diffs)

    if positions.include?(end_pos)
      @board[end_pos], @board[@pos] = @board[@pos], nil
      @pos = end_pos
    else
      raise InvalidMoveError "Not a valid move"
    end

    maybe_promote
  end

  def symbol
    case @color
    when :red
      @symbol = @king ? "\u26C1".encode('utf-8') : "\u26C0".encode('utf-8')
    when :black
      @symbol = @king ? "\u26C3".encode('utf-8') : "\u26C2".encode('utf-8')
    end
  end

  def valid_move_seq?(move_sequence)
    test_board = @board.dup
    begin
      test_board.perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      false
    else
      true
    end
  end

  protected

  def back_row?
    case @color
    when :red
      @pos.first == 7
    when :black
      @pos.first == 0
    end
  end

  def enemy_pos(start_pos, end_pos)
    diff = [(end_pos[0] - start_pos[0])/2, (end_pos[-1] - start_pos[-1])/2]
    diff.map! {|row, col| [(row + start_pos[0]), (col + start_pos[-1])]}
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
    positions.map! {|row, col| [(row + @pos[0]), (col + @pos[-1])]}
    positions.select! {|row, col| row.between?(0,7) && col.between?(0,7)}
    positions.select! {|pos| @board[pos].nil?}
  end

end

class InvalidMoveError < StandardError ; end
