require "pry-byebug"
require "json"

class Hangman
  def initialize
    @number_of_guesses = 0
    @letters_guessed = []
    @word_to_guess = generate_random_word
    @letters_guessed_correctly = generate_blanks
    begin_game
  end

  def begin_game
    puts "Welcome to hangman, would you like to start a new game(1) or load a saved game(2)?"
    choice = gets.chomp
    if choice == "1"
      puts "Take your first guess\n #{@letters_guessed_correctly.join(" ")}"
      user_turn(input_check(gets.chomp))
    elsif choice == "2"
      load_game
    else
      begin_game
    end
  end

  def user_turn(letter)
    system("clear")
    @letters_guessed.push(letter)
    @number_of_guesses += 1
    @word_to_guess.each_with_index do |element, index| if element == letter
      @letters_guessed_correctly[index] = letter
      end
    end 
    populate_display
    check_for_complete
  end

  def populate_display
    puts "\n\n#{@letters_guessed_correctly.join(" ")} \n\n #{@letters_guessed.join("  ")} \n\n
    You've had #{@number_of_guesses} out of 11 strikes \n\n    Enter save to save the game"
  end

  def check_for_complete
    if @number_of_guesses == 11
      system("clear")
      puts "\n\nYou didn't get it :(, the word was: \n\n #{@word_to_guess.join("")}\n\n"
    elsif
      @letters_guessed_correctly.include?("_")
      user_turn(input_check(gets.chomp))
    else
     puts "\n   You got it! \n\n #{@word_to_guess}"
    end
  end

  def input_check(input)
    if  @letters_guessed.include?(input)
      puts "You already used that letter"
      input_check(gets.chomp)
    elsif input.match(/[a-z]|[A-Z]/) && input.length == 1
      input.downcase
    elsif input.downcase == "save"
      save_game()
    else
      puts "Input must be any letter between A-Z"
    input_check(gets.chomp) 
   end
  end

  def generate_random_word
    dictionary_array = File.readlines("desk.txt")
    word = dictionary_array[rand(dictionary_array.length)].chomp
  
    if word.length > 5 && word.length < 9
      word.downcase.split("")
    else
      generate_random_word
    end
  end

  def generate_blanks
    arr = []
    @word_to_guess.length.times do arr.push("_")
    end
    return arr
  end

  def save_game
    puts "What would you like to call your saved game?"
    name = gets.chomp

    data_hash = {number_of_guesses: @number_of_guesses,
      letters_guessed: @letters_guessed,
      word_to_guess: @word_to_guess, 
      letters_guessed_correctly: @letters_guessed_correctly}
    
    Dir.mkdir('saved') unless Dir.exist?('saved')
    file = "saved/#{name}.JSON"
    File.write(file, JSON.dump(data_hash))
    exit
  end

  def load_game
    arr = Dir.entries("saved").select { |f| File.file? File.join("saved", f)}
    arr.each_with_index { |item, index| arr[index] = item[0...-5]}

    puts "Enter the name of the game you would like to load\n\n #{arr.join("   \n ")}"

    file = File.read("saved/#{check_for_file(gets.chomp)}.JSON")
    hash = JSON.parse(file)
    @number_of_guesses = hash['number_of_guesses'].to_i
    @letters_guessed_correctly = hash['letters_guessed_correctly']
    @word_to_guess = hash['word_to_guess']
    @letters_guessed_correctly = hash['letters_guessed_correctly']
    system("clear")
    populate_display
    user_turn(input_check(gets.chomp))
  end

  def check_for_file(file)
    if File.exist?("saved/#{file}.JSON")
      return file
    else
      puts "The file name you entered is incorrect or does not exist, try again"
      check_for_file(gets.chomp)
    end
  end
end

Hangman.new()