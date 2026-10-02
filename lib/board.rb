class Board
  ROWS = 6
  COLUMNS = 7
  EMPTY_SLOT = "   ".freeze

  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS, EMPTY_SLOT) }
  end

  def to_a
    @grid.map(&:dup)
  end

  def load_grid(grid)
    raise ArgumentError, "Invalid saved board" unless valid_grid?(grid)

    @grid = grid.map(&:dup)
  end

  def display_board
    col = "|"
    row = "+---+---+---+---+---+---+---+"

    puts row
    @grid.each do |line|
      cells = line.map { |cell| cell.center(3) }
      puts "#{col}#{cells.join(col)}#{col}"
      puts row
    end
    puts "  #{(1..COLUMNS).to_a.join('   ')}"
  end

  def drop_token?(col, token)
    (ROWS - 1).downto(0) do |row|
      if @grid[row][col] == EMPTY_SLOT
        @grid[row][col] = token
        return true
      end
    end

    false
  end

  def board_full?
    @grid.flatten.none?(EMPTY_SLOT)
  end

  def winner?(token)
    horizontal_win?(token) || vertical_win?(token) || diagonal_win?(token)
  end

  private

  def valid_grid?(grid)
    grid.is_a?(Array) && grid.size == ROWS && grid.all? { |row| valid_row?(row) }
  end

  def valid_row?(row)
    valid_cells = [ EMPTY_SLOT, "X", "O" ]
    row.is_a?(Array) && row.size == COLUMNS && row.all? { |cell| valid_cells.include?(cell) }
  end

  def horizontal_win?(token)
    @grid.any? do |row|
      row.each_cons(4).any? { |cons| cons.uniq == [ token ] }
    end
  end

  def vertical_win?(token)
    @grid.transpose.any? do |col|
      col.each_cons(4).any? { |cons| cons.uniq == [ token ] }
    end
  end

  def diagonal_win?(token)
    diagonal_check?(@grid, token) || diagonal_check?(@grid.map(&:reverse), token)
  end

  def diagonal_check?(board, token)
    offset = [ 0, 1, 2, 3 ]

    (0..(ROWS - offset.size)).each do |row|
      (0..(COLUMNS - offset.size)).each do |col|
        return true if offset.all? { |i| board[row + i][col + i] == token }
      end
    end

    false
  end
end
