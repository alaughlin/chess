require_relative 'sliding_piece.rb'

class BadPromotionError < ArgumentError
end

class Pawn < SlidingPiece
  def move(target)
    super(target)
    # this enables pawn promotion
    if @color == :white && @position[0] == 0
      promote
    elsif @color == :black && @position[0] == 7
      promote
    end
  end

  def promote
    print "Your pawn is promoted! Please choose a new piece: "

    begin
      input = gets.chomp.downcase

      case input
      when "queen"
        @board[@position] = Queen.new(@position, @color, @board)
      when "knight"
        @board[@position] = Knight.new(@position, @color, @board)
      when "rook"
        @board[@position] = Rook.new(@position, @color, @board)
      when "bishop"
        @board[@position] = Bishop.new(@position, @color, @board)
      else
        raise BadPromotionError
      end

    rescue BadPromotionError
      print "Please choose a queen, knight, rook, or bishop!: "
      retry
    end
  end

  def valid_move?(target, board)
    super(target, board) && pawn_like_move?(target, board)
  end

  def pawn_like_move?(target, board)
    pawn_moves = []

    if @color == :black
      # allows pawns to move forward one space into empty positions
      one_square_down = [@position[0] + 1, @position[1]]
      pawn_moves << one_square_down if board[one_square_down].nil?

      # allows pawns to move diagonally if there's an enemy present
      diag1 = [@position[0] + 1, @position[1] + 1]
      diag2 = [@position[0] + 1, @position[1] - 1]
      pawn_moves << diag1 unless board[diag1].nil? || board[diag1].color == :black
      pawn_moves << diag2 unless board[diag2].nil? || board[diag2].color == :black

      # allows pawns to move two squares if in starting row and if empty
      two_squares_down = [@position[0] + 2, @position[1]]
      if @position[0] == 1 && board[two_squares_down].nil?
        pawn_moves << two_squares_down
      end

    elsif @color == :white
      one_square_up = [@position[0] - 1, @position[1]]
      pawn_moves << one_square_up if board[one_square_up].nil?

      diag1 = [@position[0] - 1, @position[1] + 1]
      diag2 = [@position[0] - 1, @position[1] - 1]
      pawn_moves << diag1 unless board[diag1].nil? || board[diag1].color == :white
      pawn_moves << diag2 unless board[diag2].nil? || board[diag2].color == :white

      two_squares_up = [@position[0] - 2, @position[1]]
      if @position[0] == 6 && board[two_squares_up].nil?
        pawn_moves << two_squares_up
      end
    end

    pawn_moves.include?(target)
  end

  def render
    @color == :black ? "♟" : "♙"
  end
end