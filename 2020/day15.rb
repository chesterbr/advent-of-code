input = File.readlines("input", chomp:true)

starting_numbers = input.first.split(",").map(&:to_i)

last_two_turns_spoken = []
last_spoken_number = nil
current_turn = 1
while true
  # Determine the number to speak (store in last_spoken_number)
  if starting_numbers.any?
    last_spoken_number = starting_numbers.shift
  else
    case last_two_turns_spoken[last_spoken_number].count
    when 1
      last_spoken_number = 0
    when 2
      last_spoken_number = last_two_turns_spoken[last_spoken_number].reduce(:-)
    else
      raise "boom"
    end
  end
  break if current_turn == 30000000
  last_two_turns_spoken[last_spoken_number] ||= []
  # Update last two turns for the current number and pass
  last_two_turns_spoken[last_spoken_number].unshift(current_turn)
  last_two_turns_spoken[last_spoken_number].slice!(2..)
  current_turn += 1
end

puts last_spoken_number
