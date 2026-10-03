require_relative "board"

class ComputerPlayer
  CENTER_FIRST_COLUMNS = [ 3, 2, 4, 1, 5, 0, 6 ].freeze

  def choose_column(board, token, opponent_token)
    available_columns = CENTER_FIRST_COLUMNS.select do |column|
      board.to_a.first[column] == Board::EMPTY_SLOT
    end

    winning_move(board, token, available_columns) ||
      winning_move(board, opponent_token, available_columns) ||
      available_columns.first
  end

  private

  def winning_move(board, token, columns)
    columns.find do |column|
      candidate = Board.new
      candidate.load_grid(board.to_a)
      candidate.drop_token?(column, token)
      candidate.winner?(token)
    end
  end
end
