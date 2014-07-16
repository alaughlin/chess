require_relative 'piece.rb'

class King < Piece
  def valid_move?(target, board)
    super(target, board) && king_like_move?(target)
  end

  def king_like_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]

    offsets.all? { |offset| offset.abs <= 1 }
  end

  def render
    @color == :black ? "♚" : "♔"
  end
end