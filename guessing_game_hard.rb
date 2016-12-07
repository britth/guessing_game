def is_number?(value)
  true if Float(value) rescue false
end

def is_higher?(value, correct_value)
  true if value > correct_value
end

def is_lower?(value, correct_value)
  true if value < correct_value
end

def plural(value, singular, plural)
  if value != 1
    plural
  else
    singular
  end
end

def higher_or_lower?(value, correct_value)
  too_high_phrases = ['Nope, you\'re too high. Try again.', 'Too high! Try again.', 'That\'s too high. Try again.']
  too_low_phrases = ['Nope, you\'re too low. Try again.', 'Too low! Try again.', 'That\'s too low. Try again.']

  if is_higher?(value, correct_value)
    puts too_high_phrases[rand(too_high_phrases.count)]
  elsif is_lower?(value, correct_value)
    puts too_low_phrases[rand(too_low_phrases.count)]
  end
end

def compare_to_previous(value, valid_guesses, all_guesses, correct_value)
  too_high_in_a_row_phrases = ['Didn\'t we just say you were too high! Try again.', 'Too high again...seriously, go lower next time.', 'Wasting guesses...that\'s still too high. Guess again.', 'We weren\'t kidding...Pick a lower number!']
  too_low_in_a_row_phrases = ['Didn\'t we just say you were too low! Try again.', 'Too low again...seriously, go higher next time.', 'Wasting guesses...that\'s still too low. Guess again.', 'We weren\'t kidding...Pick a lower number!']
  if is_higher?(value.to_i, correct_value) and valid_guesses.last == all_guesses.last and is_higher?(valid_guesses.last.to_i, correct_value) and value.to_i > valid_guesses.last.to_i
    puts too_high_in_a_row_phrases[rand(too_high_in_a_row_phrases.count)]
  elsif is_lower?(value.to_i, correct_value) and valid_guesses.last == all_guesses.last and is_lower?(valid_guesses.last.to_i, correct_value) and value.to_i < valid_guesses.last.to_i
    puts too_low_in_a_row_phrases[rand(too_low_in_a_row_phrases.count)]
  else
    higher_or_lower?(value.to_i, correct_value)
  end
end


def guessing_game
  valid_guesses = []
  all_guesses = []
  guesses_you_get = 10

  correct_value = (1..100).to_a.shuffle.first
  while valid_guesses.count < guesses_you_get do
    new_guess = gets.chomp
    if not is_number?(new_guess)
      all_guesses << new_guess
      puts 'That\'s not a number. Try again...'
    elsif new_guess.to_i > 100
      all_guesses << new_guess
      puts 'Number should be less than 100...go lower.'
    elsif new_guess.to_i < 1
      all_guesses << new_guess
      puts 'Has to be at least 1...pick something higher.'
    elsif valid_guesses.include?(new_guess.to_i)
      all_guesses << new_guess
      if is_higher?(new_guess.to_i, correct_value)
        puts 'Look, we already told you that\'s a) not it and b) too high. Pay attention next time...'
      elsif is_lower?(new_guess.to_i, correct_value)
        puts 'Hello?! You guessed that already. Go higher next time.'
      else
        puts 'You already guessed that...try again'
      end
    elsif new_guess.to_i == correct_value.to_i
      valid_guesses << new_guess.to_i
      win_phrases = ['Wahoo, you win!!', 'You\'re a winner!', 'You won!!', 'Congrats, you won!!', 'A win for you!', 'Tada! You won!', 'Yes!! You won!!', 'Correct, you won!!']
      puts win_phrases[rand(win_phrases.length)]+" It took you #{valid_guesses.count} #{plural(valid_guesses.count, 'guess', 'guesses')}."
      break
    elsif valid_guesses.count == guesses_you_get - 1
      valid_guesses << new_guess.to_i
      all_guesses << new_guess.to_i
      puts "Sorry! You lose!"
      puts "The correct value was #{correct_value}"
    elsif valid_guesses.count == 0
      valid_guesses << new_guess.to_i
      all_guesses << new_guess.to_i
      higher_or_lower?(new_guess.to_i, correct_value)
    else
      compare_to_previous(new_guess, valid_guesses, all_guesses, correct_value)
      valid_guesses << new_guess.to_i
      all_guesses << new_guess.to_i
    end
  end
  if new_guess.to_i == correct_value.to_i
    valid_guesses.count
  else
    0
  end
end

leaderboard = []
turn = 0
play_again = "y"

while play_again != ""
  if turn < 1
    puts 'Welcome to the Guessing Game! Enter your name:'
  else
    puts 'Please enter your name:'
  end
  name = gets.chomp
  puts 'The computer has picked a number between 1 and 100. What\'s your guess?'
  score = guessing_game
  turn += 1
  if score > 0
    leaderboard << {:name=>name, :score=>score, :turn=>turn}
  end
  leaderboard = leaderboard.sort_by{|player| [player[:score], player[:turn]]}
  if leaderboard.first[:name] == name and leaderboard.first[:turn] == turn and turn > 1
    puts 'You\'re in the lead!'
  end
  puts "Current Leaderboard:"
  puts leaderboard.collect { |l| "#{l[:name]}: #{l[:score]}" }.first(5)
  puts "Press enter to exit. Press any other key to play again"
  play_again = gets.chomp
end
