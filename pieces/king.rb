require_relative 'piece.rb'

class King < Piece
  def valid_move?(target, board)
    super(target, board) && (king_like_move?(target) || valid_castle?(target))
  end

  def king_like_move?(target)
    offsets = [ target[0] - @position[0], target[1] - @position[1] ]

    offsets.all? { |offset| offset.abs <= 1 }
  end

  # this is for castling logic...
  def move(target)
    if !self.moved? && valid_castle?(target)
      castle(target)
    else
      super(target)
      @moved = true
    end
  end

  def moved?
    @moved
  end

  def castle(target)
    @board[@position] = nil
    @board[target] = self
    @position = target
    @moved = true

    if @color == :white && target == [7,2]
      rook = @board[[7, 0]]
      @board[[7,0]] = nil
      @board[[7,3]] = rook
      rook.position = [7, 3]
      rook.moved = true
    elsif @color == :white && target == [7,6]
      rook = @board[[7, 7]]
      @board[[7,7]] = nil
      @board[[7,5]] = rook
      rook.position = [7, 5]
      rook.moved = true
    elsif @color == :black && target == [0,2]
      rook = @board[[0, 0]]
      @board[[0,0]] = nil
      @board[[0,3]] = rook
      rook.position = [0, 3]
      rook.moved = true
    elsif @color == :black && target == [0,6]
      rook = @board[[0, 7]]
      @board[[0,7]] = nil
      @board[[0,5]] = rook
      rook.position = [0, 5]
      rook.moved = true
    end
  end

  def valid_castle?(target)
    # four types of castles, each is unique
    if @color == :white && target == [7,2]
      # [7, 0] is the castling rook's position
      return false if @board[[7,0]].moved?
      # checking if the rook has a valid move; if true, path is empty
      return false unless @board[[7,0]].valid_move?([7, 3], @board) && @board[[7,3]].nil?
      # checking to see that the king doesn't move through or into check.
      return false if self.puts_in_check?([7,3]) || self.puts_in_check?(target)

    elsif @color == :white && target == [7,6]
      return false if @board[[7,7]].moved?
      return false unless @board[[7,7]].valid_move?([7, 5], @board) && @board[[7,5]].nil?
      return false if self.puts_in_check?([7,5]) || self.puts_in_check?(target)

    elsif @color == :black && target == [0,2]
      return false if @board[[0,0]].moved?
      return false unless @board[[0,0]].valid_move?([0, 3], @board) && @board[[0,3]].nil?
      return false if self.puts_in_check?([0,3]) || self.puts_in_check?(target)

    elsif @color == :black && target == [0,6]
      return false if @board[[0,7]].moved?
      return false unless @board[[0, 7]].valid_move?([0, 5], @board) && @board[[0,5]].nil?
      return false if self.puts_in_check?([0,5]) || self.puts_in_check?(target)
    else
      # returns false if the target is invalid
      return false
    end
    # if ALLLLL that is true, we can castle!
    true
  end

  def render
    @color == :black ? "♚" : "♔"
  end
end