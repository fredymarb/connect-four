class Board
  ROWS = 6
  COLUMNS = 7
  EMPTY_SLOT = "   ".freeze
  BLUE = "\e[34m".freeze
  RESET = "\e[0m".freeze
  WIN_DIRECTIONS = [ [ 0, 1 ], [ 1, 0 ], [ 1, 1 ], [ 1, -1 ] ].freeze

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
    winning_positions = winning_positions("X") || winning_positions("O")

    puts row
    @grid.each_with_index do |line, row_index|
      cells = render_line(line, row_index, winning_positions)
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
    !winning_positions(token).nil?
  end

  private

  def valid_grid?(grid)
    grid.is_a?(Array) && grid.size == ROWS && grid.all? { |row| valid_row?(row) }
  end

  def valid_row?(row)
    valid_cells = [ EMPTY_SLOT, "X", "O" ]
    row.is_a?(Array) && row.size == COLUMNS && row.all? { |cell| valid_cells.include?(cell) }
  end

  def render_line(line, row_index, winning_positions)
    line.each_with_index.map do |cell, column_index|
      winning = winning_positions&.include?([ row_index, column_index ])
      render_cell(cell, winning)
    end
  end

  def render_cell(cell, winning)
    centered_cell = cell.center(3)
    return centered_cell unless winning

    "#{centered_cell[0]}#{BLUE}#{centered_cell[1]}#{RESET}#{centered_cell[2]}"
  end

  def winning_positions(token)
    ROWS.times do |row|
      COLUMNS.times do |column|
        positions = winning_positions_from(row, column, token)
        return positions unless positions.nil?
      end
    end

    nil
  end

  def winning_positions_from(row, column, token)
    WIN_DIRECTIONS.each do |row_offset, column_offset|
      positions = 4.times.map do |offset|
        [ row + (offset * row_offset), column + (offset * column_offset) ]
      end
      return positions if winning_line?(positions, token)
    end

    nil
  end

  def winning_line?(positions, token)
    positions.all? { |row, column| row.between?(0, ROWS - 1) && column.between?(0, COLUMNS - 1) } &&
      positions.all? { |row, column| @grid[row][column] == token }
  end
end
