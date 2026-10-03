require_relative "../lib/board"

describe Board do
  subject(:board) { described_class.new }

  describe "#display_board" do
    it "displays an empty board with its column numbers" do
      expect { board.display_board }.to output(
        /\+---\+---\+---\+---\+---\+---\+---\+.*  1   2   3   4   5   6   7/m
      ).to_stdout
    end

    it "highlights a horizontal winning combination in blue" do
      4.times { |column| board.drop_token?(column, "X") }

      blue_token = Regexp.escape("\e[34mX\e[0m")
      expect { board.display_board }.to output(/(?:.*?#{blue_token}){4}/m).to_stdout
    end

    it "highlights a vertical winning combination in blue" do
      4.times { board.drop_token?(0, "O") }

      blue_token = Regexp.escape("\e[34mO\e[0m")
      expect { board.display_board }.to output(/(?:.*?#{blue_token}){4}/m).to_stdout
    end

    it "highlights a diagonal winning combination in blue" do
      board.drop_token?(0, "X")
      board.drop_token?(1, "O")
      board.drop_token?(1, "X")
      2.times { board.drop_token?(2, "O") }
      board.drop_token?(2, "X")
      3.times { board.drop_token?(3, "O") }
      board.drop_token?(3, "X")

      blue_token = Regexp.escape("\e[34mX\e[0m")
      expect { board.display_board }.to output(/(?:.*?#{blue_token}){4}/m).to_stdout
    end
  end

  describe "#drop_token?" do
    it "drops a token into an empty column" do
      expect(board.drop_token?(0, "X")).to be true
      expect(board.winner?("X")).to be false
    end

    it "stacks tokens from the bottom of a column upward" do
      4.times { board.drop_token?(0, "X") }

      expect(board.winner?("X")).to be true
    end

    it "returns false when the selected column is full" do
      6.times { board.drop_token?(0, "X") }

      expect(board.drop_token?(0, "O")).to be false
    end
  end

  describe "#to_a and #load_grid" do
    it "round-trips a board without exposing its internal grid" do
      board.drop_token?(2, "X")
      restored_board = described_class.new

      restored_board.load_grid(board.to_a)

      expect { restored_board.display_board }.to output(
        /\|   \|   \| X \|.*  1   2   3   4   5   6   7/m
      ).to_stdout
    end

    it "rejects a saved grid with an invalid shape or token" do
      expect { board.load_grid([ [ "invalid" ] ]) }.to raise_error(ArgumentError, "Invalid saved board")
    end
  end

  describe "#board_full?" do
    it "returns false while the board has empty slots" do
      expect(board.board_full?).to be false

      board.drop_token?(0, "X")

      expect(board.board_full?).to be false
    end

    it "returns true when every column is full" do
      Board::COLUMNS.times do |column|
        Board::ROWS.times { board.drop_token?(column, "X") }
      end

      expect(board.board_full?).to be true
    end
  end

  describe "#winner?" do
    it "detects a horizontal win" do
      4.times { |column| board.drop_token?(column, "X") }

      expect(board.winner?("X")).to be true
    end

    it "detects a vertical win" do
      4.times { board.drop_token?(0, "O") }

      expect(board.winner?("O")).to be true
    end

    it "detects a diagonal win" do
      board.drop_token?(0, "X")
      board.drop_token?(1, "O")
      board.drop_token?(1, "X")
      2.times { board.drop_token?(2, "O") }
      board.drop_token?(2, "X")
      3.times { board.drop_token?(3, "O") }
      board.drop_token?(3, "X")

      expect(board.winner?("X")).to be true
    end

    it "returns false when the token has no four-in-a-row" do
      board.drop_token?(0, "X")
      board.drop_token?(1, "O")
      board.drop_token?(2, "X")
      board.drop_token?(3, "O")

      expect(board.winner?("X")).to be false
      expect(board.winner?("O")).to be false
    end
  end
end
