def is_number?(value)
  true if Float(value) rescue false
end

guesses = 0
