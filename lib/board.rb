class Board
  ROWS = 6
  COLUMNS = 7
  EMPTY_SLOT = '   '.freeze

  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS, EMPTY_SLOT) }
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
end
