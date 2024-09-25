require_relative 'player'

class Board
  ROWS = 6
  COLUMNS = 7
  EMPTY_SLOT = '   '.freeze

  attr_reader :current_player

  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS, EMPTY_SLOT) }
    @player1 = Player.new('Player 1', ' x ')
    @player2 = Player.new('Player 2', ' o ')
    @current_player = @player1
  end

  def display_board
    col = '|'
    row = '+---+---+---+---+---+---+---+'

    puts row
    @board.each do |line|
      puts "#{col}#{line.join(col)}#{col}"
      puts row
    end
    puts "  #{(1..COLUMNS).to_a.join('   ')}"
  end

  def drop_token(col)
    (ROWS - 1).downto(0) do |row|
      if @grid[row][col] == EMPTY_SLOT
        @grid[row][col] = @current_player.token
        return true
      end
    end

    false
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def board_full?
    @grid.flatten.none?(EMPTY_SLOT)
  end
end
