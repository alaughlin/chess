require_relative 'sliding_piece.rb'

class Bishop < SlidingPiece
  def valid_move?(target, board)
    super(target, board) && diagonal_move?(target)
  end

  def render
    @color == :black ? "♝" : "♗"
  end
end