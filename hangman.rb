class HumanPlayer

  def initialize(mode = :guesser)

  end

  def choose_word

  end

  def guess_word
    char = ""
    loop do
      puts "Guess a letter!"
      char = gets.chomp.downcase
      break if ("a".."z").include?(char)
    end

    char
  end

end

class ComputerPlayer

  attr_reader :dictionary, :word
  # attr_accessor :word

  def initialize(dictionary, mode = :wordsmith)
    @dictionary = dictionary
    @mode = mode
  end

  def choose_word # set up word choice and return dummy word string
    @word = File.readlines(dictionary).sample.chomp
    
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

  def guess_word
    
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
    when 1
      @guesser_player, @wordsmith_player = ask_roles(dictionary)
      # play
    when 2
      # fill in later
    end
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

      # initialize human and computer players, then return them
    end
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
      guess = guesser_player.guess_word
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

    puts "The wordsmith wins! The correct word was #{wordsmith_player.word}." unless misses < miss_limit
  end

end

hm = Hangman.new("dictionary.txt")
hm.play