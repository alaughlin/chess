require_relative 'sliding_piece.rb'

class Queen < SlidingPiece
  def valid_move?(target, board)
    super(target, board) && (straight_move?(target) || diagonal_move?(target))
  end

  def render
    @color == :black ? "♛" : "♕"
  end
end