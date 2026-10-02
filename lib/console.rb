class Console
  def ask_column(player_name)
    loop do
      print "#{player_name}, choose a column (1 - 7, or q to quit): "
      input = gets.chomp.strip
      return :quit if input.casecmp("q").zero?
      return input.to_i - 1 if input.match?(/\A[1-7]\z/)

      puts "Invalid entry, try again."
    end
  end

  def ask_resume_choice
    loop do
      print "A saved game was found. Enter C to continue or N to start a new game: "
      choice = gets.chomp.downcase
      return :continue if choice == "c"
      return :new if choice == "n"

      puts "Please enter C or N."
    end
  end

  def announce_full_column
    puts "That column is full. Choose another column."
  end

  def announce_saved_game
    puts "Game saved. You can continue it next time."
  end

  def announce_winner(player)
    puts "#{player.name} won the game"
  end

  def announce_draw
    puts "Board is full, its a draw game"
  end
end
