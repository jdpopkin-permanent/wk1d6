class WordChains

  attr_accessor :all_words, :visited_words

  def initialize(start_word, end_word, dictionary)
    @visited_words = {start_word => nil}
    @all_words = File.read(dictionary).split
    @all_words.select! {|dict_word| start_word.length == dict_word.length }
  end

  def adjacent_words(word, dictionary)
    adjacent_words = []
    (0...word.length).each do |i|
      regex_string = word.dup
      regex_string[i] = "."
      regex = Regexp.new(regex_string)

      @all_words.each do |curr|
        if curr =~ regex && !visited_words.has_key?(curr)
          adjacent_words << curr
          @visited_words[curr] = word
          @all_words.delete(curr)
        end
      end
    end

    adjacent_words
  end

  def build_chain(visited_words, word)
    chain = [word]

    until visited_words[word].nil?
      word = visited_words[word]
      chain.unshift(word)
    end

    chain
  end

  def find_chain(start_word, end_word, dictionary)
    current_words = [start_word]

    loop do 
      if current_words.include?(end_word)
        return build_chain(@visited_words, end_word)
      end

      new_words = []
      current_words.each do |word|
        new_words += adjacent_words(word, dictionary)
      end

      current_words = new_words
    end
  end

end

loop do
  words = File.read("dictionary.txt").split
  puts "What word would you like to start at?"
  start_word = gets.chomp
  unless words.include?(start_word)
    puts "Starting word not found in dictionary.txt."
    next
  end
  puts "What word would you like to end up at?"
  end_word = gets.chomp
  unless words.include?(start_word)
    puts "Goal word not found in dictionary.txt."
    next
  end
  if start_word.length != end_word.length
    puts "Word lengths must match."
    next
  end

  wc = WordChains.new(start_word, end_word, "dictionary.txt")
  puts wc.find_chain(start_word, end_word, "dictionary.txt")
end