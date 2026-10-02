require_relative "../lib/console"

describe Console do
  subject(:console) { described_class.new }

  describe "#ask_column" do
    before do
      allow(console).to receive(:print)
    end

    it "returns the selected column as a zero-based index" do
      allow(console).to receive(:gets).and_return("4")

      expect(console.ask_column("Alice")).to eq(3)
    end

    it "repeats the prompt after invalid input" do
      allow(console).to receive(:gets).and_return("0", "4")
      expect(console).to receive(:puts).with("Invalid entry, try again.")

      expect(console.ask_column("Alice")).to eq(3)
    end

    it "returns the quit command" do
      allow(console).to receive(:gets).and_return("q")

      expect(console.ask_column("Alice")).to eq(:quit)
    end
  end

  describe "#ask_resume_choice" do
    it "asks the user to choose whether to continue or start over" do
      allow(console).to receive(:print)
      allow(console).to receive(:gets).and_return("c")

      expect(console.ask_resume_choice).to eq(:continue)
    end

    it "starts a new game when the user chooses N" do
      allow(console).to receive(:print)
      allow(console).to receive(:gets).and_return("n")

      expect(console.ask_resume_choice).to eq(:new)
    end
  end
end
