require_relative "../lib/game"

describe ConnectFour do
  describe "#ask_column" do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:print)
    end

    context "when the user enters a valid input" do
      before do
        allow(game).to receive(:gets).and_return("4")
      end

      it "returns the selected column minus one" do
        expect(game.ask_column).to eq(3)
      end

      it "prompts the current player to choose a column" do
        expect(game).to receive(:print).with("Player 1, choose a column (1 - 7): ")

        game.ask_column
      end
    end

    context "when the user enters invalid input before a valid input" do
      before do
        allow(game).to receive(:gets).and_return("0", "8", "q", "5")
      end

      it "prints an error message and retries" do
        expect(game).to receive(:puts).with("Invalid entry, try again.").exactly(3).times

        expect(game.ask_column).to eq(4)
      end
    end
  end

  describe "#play" do
    subject(:game) { described_class.new }

    it "ends and announces a win after a player gets four in a row" do
      allow(game).to receive(:ask_column).and_return(0, 6, 1, 6, 2, 5, 3)

      expect { game.play }.to output(/Player 1 won the game/).to_stdout
    end
  end
end
