input = File.readlines("input", chomp:true)

crab_positions = input.first.split(",").map(&:to_i)
crab_positions.sort!

def move_cost(distance)
  (1 + distance) * distance / 2
end

costs = {}

crab_positions.first.upto(crab_positions.last) do |position|
  costs[position] = crab_positions.map { |p| move_cost((position - p).abs) }.sum
end

puts costs.min_by { |_, v| v }.last
