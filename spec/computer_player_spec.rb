require_relative "../lib/computer_player"

describe ComputerPlayer do
  subject(:computer_player) { described_class.new }

  describe "#choose_column" do
    it "takes an immediate winning move" do
      board = Board.new
      3.times { |column| board.drop_token?(column, "O") }

      expect(computer_player.choose_column(board, "O", "X")).to eq(3)
    end

    it "blocks the opponent's immediate winning move" do
      board = Board.new
      3.times { |column| board.drop_token?(column, "X") }

      expect(computer_player.choose_column(board, "O", "X")).to eq(3)
    end

    it "prefers the center column when there is no immediate threat" do
      expect(computer_player.choose_column(Board.new, "O", "X")).to eq(3)
    end

    it "chooses an available column when the center is full" do
      board = Board.new
      Board::ROWS.times { board.drop_token?(3, "X") }

      expect(computer_player.choose_column(board, "O", "X")).to eq(2)
    end
  end
end
