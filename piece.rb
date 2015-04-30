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

  def perform_slide(end_pos)
    moves = move_diffs.select {|row, col| (row + @pos.first), (col + @post.last)}
    if moves.include?(end_pos)
      #move
    else
      #return error and retry
  end

  def perform_jump

  end
end
