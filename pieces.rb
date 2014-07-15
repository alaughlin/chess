class Piece
  attr_reader :color, :position

  def initialize(position, color, board)
    @color, @position, @board = color, position, board
  end

  def move(target)
    return nil unless valid_move?(target)
  end

  def inspect
    "#{color.capitalize} #{self.class} at position #{@position}."
  end

end

class SlidingPiece < Piece
  def moves

  end

  def path(target)
    path_arr = []

    temp_space = @position
    until temp_space == target
      (0..1).each do |i|
        case temp_space[i] <=> target[i]
        when -1
          temp_space[i] += 1
        when 1
          temp_space[i] -= 1
        end
      end

      path_arr << temp_space.dup
    end

    path_arr
  end

  def straight_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]
    offsets.any? { |num| num == 0 }
  end

  def diagonal_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]
    offsets[0].abs == offsets[1].abs
  end

end

class SteppingPiece < Piece

end

class Queen < SlidingPiece
  def valid_move?(target)
    straight_move?(target) || diagonal_move?(target)
  end
end

class Bishop < SlidingPiece
  def valid_move?(target)
    diagonal_move?(target)
  end
end

class Rook < SlidingPiece
  def valid_move?(target)
    straight_move?(target)
  end
end

class King < SteppingPiece
end

class Knight < SteppingPiece
end

class Pawn < SteppingPiece # ?? or just Piece?
end
