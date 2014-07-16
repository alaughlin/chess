require_relative 'piece.rb'

class Knight < Piece
  DELTAS = [
      [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2]
    ]

  def valid_move?(target, board)
    super(target, board) && knight_like_move?(target)
  end

  def knight_like_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]

    DELTAS.include?(offsets)
  end

  def render
    @color == :black ? "♞" : "♘"
  end
end