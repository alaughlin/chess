class Piece
  attr_reader :color, :position

  def initialize(position, color, board)
    @color, @position, @board = color, position, board
  end

  def move(target)
    return nil unless valid_move?(target)

    board[@position] = nil
    board[target] = self

    @position = target
  end

  def inspect
    "#{color.capitalize} #{self.class} at position #{@position}."
  end

  def valid_move?(target)
    @board[target].color != self.color && puts_in_check? == false
  end

  def puts_in_check?(target)
    new_board = @board.dup

    new_board[pos].move(target)
    new_board.in_check?(@color)
  end
end

class SlidingPiece < Piece
  def valid_move?(target)
    path_spaces = path(target).map { |pos| @board[pos] }
    path_spaces.pop!

    # checks to see there's nothing blocking the path
    # and that the target isn't one of our own pieces
    super(target) && path_spaces.all? { |space| space.nil? }
  end


  def path(target)
    # returns array with all spaces in path to target
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
    super(target) && (straight_move?(target) || diagonal_move?(target))
  end
end

class Bishop < SlidingPiece
  def valid_move?(target)
    super(target) && diagonal_move?(target)
  end
end

class Rook < SlidingPiece
  def valid_move?(target)
    super(target) && straight_move?(target)
  end
end

class King < SteppingPiece
  def valid_move?(target)
    super(target) && king_like_move?(target)
  end

  def king_like_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]
    offsets.all? { |offset| offset.abs <= 1 }
  end
end

class Knight < SteppingPiece
  DELTAS = [
      [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2]
    ]

  def valid_move?(target)
    super(target) && knight_like_move?(target)
  end

  def knight_like_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]
    super(target) && DELTAS.include? offsets
  end
end

class Pawn < SteppingPiece # ?? or just Piece?

end
