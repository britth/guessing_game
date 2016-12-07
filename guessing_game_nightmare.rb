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

def fixed_low(h, number)
  if h.find{|k, v| k < number}
    h.find{|k, v| k < number}.first
  else
    0
  end
end
def fixed_high(h, number)
  if h.find{|k, v| k > number}
    h.find{|k, v| k > number}.first
  else
    100
  end
end

# def binary_search (a,key)  # a is the array and key is the value to be found
#     lo = 0
#     hi= a.length-1
#
#     while (lo<=hi)
#         mid = lo+((hi-lo)/2)
#
#         if a[mid] == key
#             return mid
#         elsif a[mid] < key
#             lo=mid+1
#         else
#             hi=mid-1
#         end
#
#     end
#
#     return "Value not found in array"
# end

def binary_search (a)  # a is the array and key is the value to be found
  #lo = 0
  hi= a.last.to_i
  lo = a.first.to_i
  # puts hi
  # puts lo
  mid = lo+((hi-lo)/2)

  #a[mid]
end

def computer_guessing_game
  guesses = []
  guesses_and_feedback = Hash.new
  guesses_computer_gets = 5
  high_pt = 100
  low_pt = 1
  arr = (low_pt..high_pt).to_a

  puts 'Pick a number between 1 and 100'
  number = gets.chomp
  while not is_number?(number) or number.to_i < 1 or number.to_i > 100
    if not is_number?(number)
      puts 'That\'s not a number. Try again'
    elsif number.to_i < 1
      puts 'Your number needs to be at least 1. Try again'
    elsif number.to_i > 100
      puts 'Your number needs to be no greater than 100. Try again.'
    else
      puts 'Try again'
    end
    number = gets.chomp
  end
  number = number.to_i
  puts 'Okay, got it. Now the computer will make a guess. If it\'s too high, type "High", if it\'s too low, type "Low"'
  while guesses.count < guesses_computer_gets
    guess = binary_search(arr)
    puts "Computer guesses #{guess}"
    puts "Was that too low, too high, or correct? (Your pick was #{number})"
    answer = gets.chomp.downcase
    while answer != "high" and answer != "low" and answer != "correct"
      puts 'Enter "High" if the guess is high and "Low" if the guess is low. If the computer is right, enter "Correct"'
      answer = gets.chomp.downcase
    end
    if answer == "correct"
      puts "Computer wins! Thanks for playing"
      break
    end
    if answer == "high" and guesses_and_feedback.any? {|key, value| (key < guess && value == answer) || ((key == guess - 1 || key == guess + 1) && value != answer)}
      puts "You are such a little liar. You just said that #{guesses.last} was too low. Putting computer on the right course."
      guesses_and_feedback.reject!{|key, value| (key < number && value == "high") || (key > number && value == "low")}
      low_pt = find_low(guesses_and_feedback, number)
      high_pt = find_high(guesses_and_feedback, number)
    elsif answer == "low" and guesses_and_feedback.any?{|key, value| key > guess && value == answer || ((key == guess - 1 || key == guess + 1) && value != answer)}
      puts "You are such a little liar. You just said that #{guesses.last} was too high. Putting computer on the right course."
      guesses_and_feedback.reject!{|key, value| (key < number && value == "high") || (key > number && value == "low")}
      low_pt = find_low(guesses_and_feedback, number)
      high_pt = find_high(guesses_and_feedback, number)
    elsif answer == "high"
      high_pt = guess -= 1
    elsif answer == "low"
      low_pt = guess += 1
    end
    if guesses.count == guesses_computer_gets - 1
      puts "You win! Computer didn't guess correctly!"
    end

    guesses << guess
    guesses_and_feedback[guess] = answer
    arr = (low_pt..high_pt).to_a
  end
end

play_again = "y"

while play_again != ""
  computer_guessing_game
  puts "Press 'Enter' to exit. Press any other key to play again"
  play_again = gets.chomp
end
