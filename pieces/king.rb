require_relative 'piece.rb'

class King < Piece
  attr_accessor :moved

  def initialize(position, color, board)
    super(position, color, board)
    @moved = false
  end

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
    valid_targets = [[7,2], [7,6], [0,2], [0,6]]
    return false unless valid_targets.include?(target)

    rook_pos, rook_target = castle_helper(target)

    if rook_pos.nil? || rook_target.nil?
      return false
    end

    # castle helper determines our positions depending on target
    return false if @board[rook_pos].moved?
    # checking if the rook has a valid move; if true, path is empty
    return false unless @board[rook_pos].valid_move?(rook_target, @board) &&
      @board[rook_target].nil?
    # checking to see that the king doesn't move through or into check.
    return false if self.puts_in_check?(rook_target) || self.puts_in_check?(target)

    true
  end

  def castle_helper(target)
    if @color == :white && target == [7,2]
      [[7,0], [7,3]]
    elsif @color == :white && target == [7,6]
      [[7,7], [7,5]]
    elsif @color == :black && target == [0,2]
      [[0,0], [0,3]]
    elsif @color == :black && target == [0,6]
      [[0,7], [0,5]]
    else
      return [nil, nil]
    end
  end

  def render
    @color == :black ? "♚" : "♔"
  end
end