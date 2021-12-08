input = File.readlines("input", chomp:true)

crab_positions = input.first.split(",").map(&:to_i)
crab_positions.sort!

costs = {}

costs[crab_positions.first] = crab_positions.map { |p| (crab_positions.first - p).abs }.sum

crab_count_to_left_of_current_position = 0
crab_count_to_right_of_current_position = crab_positions.size

crab_positions.first.upto(crab_positions.last) do |position|
  crab_count_on_current_position = crab_positions.count(position)
  crab_count_to_right_of_current_position -= crab_count_on_current_position

  costs[position] ||= costs[position - 1] + crab_count_to_left_of_current_position - crab_count_on_current_position - crab_count_to_right_of_current_position

  crab_count_to_left_of_current_position += crab_count_on_current_position
end

puts costs.min_by { |_, v| v }.last
