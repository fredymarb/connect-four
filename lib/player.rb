class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end

  def ask_column
    loop do
      print "#{@name}, choose a column (1 - 7): "
      response = ask_input.to_i - 1
      return response if response.between?(0, 6)

      puts 'Invalid entry, try again.'
    end
  end

  private

  def ask_input
    gets.chomp
  end
end
