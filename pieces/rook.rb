require_relative 'sliding_piece.rb'

class Rook < SlidingPiece
  def valid_move?(target, board)
    super(target, board) && straight_move?(target)
  end

  def render
    @color == :black ? "♜" : "♖"
  end
end