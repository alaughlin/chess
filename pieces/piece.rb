class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(position, color, board)
    @color, @position, @board, @captured = color, position, board, false
  end

  def move(target)
    return nil unless valid_move?(target, @board)
    raise InvalidMoveError if puts_in_check?(target)
    @board[@position] = nil
    @board[target] = self

    @position = target
  end

  def inspect
    "#{color.capitalize} #{self.class} at position #{@position}."
  end

  def valid_move?(target, board)
    # valid_move needs to be able to recieve a board as an argument
    # because sometimes, (e.g. puts_in_check?) it needs to look at
    # a duped board and not the original
    board[target].nil? || board[target].color != self.color
  end

  def valid_moves
    moves = []

    8.times do |x|
      8.times do |y|
        cur_pos = [x, y]
        if self.valid_move?(cur_pos, @board) && !self.puts_in_check?(cur_pos)
          moves << cur_pos
        end
      end
    end

    moves
  end

  def puts_in_check?(target)
    new_board = @board.dup

    new_board[@position] = nil
    new_board[target] = self.class.new(target, @color, new_board)

    new_board.in_check?(@color)
  end

  def captured?
    @captured
  end
end
