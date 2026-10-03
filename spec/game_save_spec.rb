require_relative "../lib/game_save"
require_relative "../lib/board"
require_relative "../lib/player"
require "tmpdir"

describe GameSave do
  describe "DEFAULT_PATH" do
    it "stores the save file in the project directory" do
      expect(described_class::DEFAULT_PATH).to eq(
        File.expand_path("../.connect_four_save.json", __dir__)
      )
    end
  end

  around do |example|
    Dir.mktmpdir("connect-four-save-spec") do |directory|
      @save = described_class.new(path: File.join(directory, "saved_game.json"))
      example.run
    end
  end

  describe "#save and #load" do
    it "stores the board and active player's token" do
      board = Board.new
      player = Player.new("Player 1", "X")
      board.drop_token?(2, player.token)

      @save.save(board: board, current_player: player)

      expect(@save.load).to eq(
        "board" => board.to_a,
        "current_player" => "X",
        "mode" => "two_players"
      )
    end

    it "stores computer mode" do
      @save.save(
        board: Board.new,
        current_player: Player.new("Computer", "O"),
        mode: :computer
      )

      expect(@save.load.fetch("mode")).to eq("computer")
    end
  end

  describe "#delete" do
    it "removes the saved game if one exists" do
      @save.save(board: Board.new, current_player: Player.new("Player 1", "X"))

      @save.delete

      expect(@save.exists?).to be false
    end

    it "does nothing when no saved game exists" do
      expect { @save.delete }.not_to raise_error
    end
  end
end
