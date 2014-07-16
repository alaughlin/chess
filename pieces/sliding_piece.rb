require_relative 'piece.rb'

class SlidingPiece < Piece
  def valid_move?(target, board)
    path_spaces = path(target).map { |pos| board[pos] }
    # removes the target from path_spaces so it isn't checked
    path_spaces.pop

    # checks to see there's nothing blocking the path
    super(target, board) && path_spaces.all? { |space| space.nil? }
  end


  def path(target)
    # returns array with all spaces in path to target
    path_arr = []

    temp_space = @position.dup
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