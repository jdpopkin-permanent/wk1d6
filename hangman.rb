class HumanPlayer

  def initialize(mode = :guesser)

  end

  def choose_word
    length = 0
    loop do 
      puts "Enter the length of your word."
      length = gets.chomp.to_i
      next if length.nil? || length < 1
      break
    end

    dummy_word = "" 
    length.times do 
      dummy_word << "_"
    end

    dummy_word
  end

  def guess_word(dummy_word)
    char = ""
    loop do
      puts "Guess a letter!"
      char = gets.chomp.downcase
      break if ("a".."z").include?(char)
    end

    char
  end

  def update_dummy(guess, dummy_word)
    puts "Where does the letter #{guess} appear in your word? Enter comma-separated indices."
    index_chars = gets.chomp.split(",")
    indices = []

    index_chars.each do |char|
      indices << char.to_i if char.to_i > 0 && char.to_i <= dummy_word.length
    end

    indices.compact.each {|i| dummy_word[i - 1] = guess }
    dummy_word
  end

  def word
    "- well, how should I know?"
  end

end

class ComputerPlayer

  attr_reader :word, :difficulty
  attr_accessor :dictionary_array, :guessed_letters, :available_letters

  def initialize(dictionary, mode = :wordsmith, difficulty = :easy)
    @dictionary_array = File.read(dictionary).split
    @mode = mode
    @guessed_letters = []
    @available_letters = ("a".."z").to_a
    @difficulty = difficulty
  end

  def choose_word # set up word choice and return dummy word string
    @word = dictionary_array.sample
    
    dummy_word = ""
    word.length.times do
      dummy_word << "_"
    end
    
    dummy_word
  end

  def update_dummy(guess, dummy_word)
    (0...word.length).each do |i|
      if word[i] == guess
        dummy_word[i] = guess
      end
    end

    dummy_word
  end

  def update_dictionary(dummy_word)
    dictionary_array.select! { |word| word.length == dummy_word.length }

    unless difficulty == :easy
      # remove words that don't match a regex of the dummy
    end
  end

  def guess_word(dummy_word)
    update_dictionary(dummy_word)

    guess = ""
    if difficulty == :easy
      guess = available_letters.sample
    elsif difficulty == :medium

    elsif difficulty == :hard

    end
      
    guessed_letters << guess
    available_letters.delete(guess)
    
    guess
  end

end

class Hangman

  attr_reader :guesser_player, :wordsmith_player

  def initialize(dictionary)
    
    set_players(dictionary)
  end

  def set_players(dictionary)
    number_humans = ask_number_humans
    case number_humans
    when 0
      # fill in later. ask for strength of guesser.
      @wordsmith_player = ComputerPlayer.new(dictionary)
      difficulty = ask_strength
      @guesser_player = ComputerPlayer.new(dictionary, :guesser, difficulty)
    when 1
      @guesser_player, @wordsmith_player = ask_roles(dictionary)
      # play
    when 2
      # fill in later
      @wordsmith_player = HumanPlayer.new
      @guesser_player = HumanPlayer.new
    end
  end

  def ask_strength
    strength = 0
    loop do
      puts "Would you like a weak (0), medium (1), or strong (2) guesser?"
      strength = gets.chomp.to_i
      break if (0..2).include?(strength)
    end

     difficulty = get_difficulty(strength)
  end

  def ask_roles(dictionary)
    choice = -1
    loop do
      puts "Will the human be guessing (0) or choosing a word (1)? Enter 0 or 1 to choose."
      choice = gets.chomp.to_i
      break if (0..1).include?(choice)
    end

    case choice
    when 0
      # human is guessing
      return [HumanPlayer.new, ComputerPlayer.new(dictionary)]
    when 1
      # computer is guessing, ask about difficulty
      difficulty = ask_strength
      
      # initialize human and computer players, then return them
      # dic mode diffic
      return [ComputerPlayer.new(dictionary, :guesser, difficulty), HumanPlayer.new]
    end
  end

  def get_difficulty(num)
    case num
    when 0
      return :easy
    when 1
      return :medium
    when 2
      return :hard
    end
    raise "Error: difficulty not found"
  end

  def ask_number_humans
    loop do
      puts "How many humans will be playing this game? (0, 1, 2)"
      number = gets.chomp.to_i
      return number if (0..2).include?(number)
    end
  end

  def win?(dummy_word)
    if dummy_word.split("").include?("_")
      false
    else
      true
    end
  end

  def play
    miss_limit = 5 # number of incorrect guesses before you lose
    misses = 0

    # get dummy word from @wordsmith_player
    dummy_word = wordsmith_player.choose_word
    guesses = []

    while misses < miss_limit
      puts "\n#{miss_limit - misses} incorrect guesses left."
      puts dummy_word
      old_dummy_word = dummy_word.dup

      # prompt guesser for guess
      guess = guesser_player.guess_word(dummy_word)
      guesses << guess
      puts "Letter guessed: #{guess}"
      puts "Guessed letters: #{guesses.join(", ")}" # one function for this?

      # update dummy_word, misses
      dummy_word = wordsmith_player.update_dummy(guess, dummy_word)
      misses += 1 if old_dummy_word == dummy_word

      # check for win
      if win?(dummy_word)
        puts dummy_word
        puts "The guesser wins!"
        break
      end
    end

    puts "The wordsmith wins! The correct word was #{wordsmith_player.word}" unless misses < miss_limit
  end

end

hm = Hangman.new("dictionary.txt")
hm.play