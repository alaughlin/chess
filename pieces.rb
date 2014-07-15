class Piece
  attr_reader :color, :position

  def initialize(position, color, board)
    @color, @position, @board = color, position, board
  end

  def move(target)
    return nil unless valid_move?(target)
  end

  def inspect
    "#{color.capitalize} #{self.class}"
  end
end

class SlidingPiece < Piece
  def moves

  end

end

class SteppingPiece < Piece

end

class Queen < SlidingPiece
  @move_set = [:straight, :diagonal]
end

class Bishop < SlidingPiece
  @move_set = [:diagonal]
end

class Rook < SlidingPiece
  @move_set = [:straight]
end

class King < SteppingPiece

end

class Knight < SteppingPiece

end

class Pawn < SteppingPiece # ?? or just Piece?

end
