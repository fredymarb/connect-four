require_relative "../lib/player"

describe Player do
  describe "player attributes" do
    subject(:player) { described_class.new("Alice", "x") }

    it "exposes the player's name" do
      expect(player.name).to eq("Alice")
    end

    it "exposes the player's token" do
      expect(player.token).to eq("x")
    end
  end
end
