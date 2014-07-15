class Piece
  attr_reader :color

  def initialize(color, position)
    @color, @position = color, position
  end

  def move(target)
    return nil unless valid_move?(target)
  end
end

class SlidingPiece < Piece
  def valid_move?(target)
    valid = false

    target_row, target_col = target
    current_row, current_col = @position

    offsets = [target_row - current_row, target_col - current_col]



    if offsets[0].abs == offsets[1].abs && @move_set.include? :diagonal
      valid = in_path?(target)
    elsif offsets.any? { |offset| offset == 0 } && @move_set.include? :straight
      valid = in_path?(target)
    end


  end

  def in_path?(target)

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