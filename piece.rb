class Piece

  def initialize(color)
    @king = false
    @color = color
  end

  def move_diffs
    [[1,1],[1,-1]]
  end

  def perform_slide
  end

  def perform_jump

  end
end
