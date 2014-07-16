require_relative 'sliding_piece.rb'

class Rook < SlidingPiece
  attr_accessor :moved

  def initialize(position, color, board)
    super(position, color, board)
    @moved = false
  end

  def valid_move?(target, board)
    super(target, board) && straight_move?(target)
  end

  # this is for castling logic...
  def move(target)
    super(target)
    @moved = true
  end

  def moved?
    @moved
  end

  def render
    @color == :black ? "♜" : "♖"
  end
end