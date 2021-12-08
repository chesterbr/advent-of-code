# This file I consider cheating because Copilot autocompleted everything inside the main loop!
# If you are the person who wrote something close to this, please contact me; I'm really curious
# to know how it did this.

input = File.readlines("input", chomp:true)

crab_positions = input.first.split(",").map(&:to_i)
crab_positions.sort!

costs = {}

costs[crab_positions.first] = crab_positions.map { |p| (crab_positions.first - p).abs }.sum
last_crab_to_left_of_current_position_index = 0

crab_positions.first.upto(crab_positions.last) do |position|
  if costs[position]
    next
  end

  # Find the index of the last crab to the left of the current position
  last_crab_to_left_of_current_position_index = crab_positions.bsearch_index { |p| p < position }

  # If there is no crab to the left of the current position, then the cost is the sum of the distances from the current position to all the other positions
  if last_crab_to_left_of_current_position_index.nil?
    costs[position] = crab_positions.map { |p| (position - p).abs }.sum
  else
    # Otherwise, the cost is the sum of the distances from the current position to all the other positions, plus the distance from the last crab to the left of the current position to the current position
    costs[position] = crab_positions.map { |p| (position - p).abs }.sum + (position - crab_positions[last_crab_to_left_of_current_position_index])
  end
end

puts costs.min_by { |_, v| v }.last
