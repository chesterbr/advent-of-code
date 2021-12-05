lines = File.readlines("input", chomp:true)

set_bit_counts = [0] * lines.first.length
clear_bit_counts = set_bit_counts.dup
lines.each do |line|
  bits = line.split("")
  bits.each_with_index do |bit, index|
    set_bit_counts[index] += 1 if bit == "1"
    clear_bit_counts[index] += 1 if bit == "0"
  end
end

gamma = ""
epsilon = ""

0.upto(set_bit_counts.length - 1) do |index|
  if set_bit_counts[index] > clear_bit_counts[index]
    gamma = gamma + "1"
    epsilon = epsilon + "0"
  else
    gamma = gamma + "0"
    epsilon = epsilon + "1"
  end
end

gamma = gamma.to_i(2)
epsilon = epsilon.to_i(2)

puts gamma
puts epsilon
puts gamma * epsilon
