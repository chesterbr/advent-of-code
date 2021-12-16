# this was the first one that I could not get to good solution myself, probably
# because I never studied graph theory formally; this is a crude Dijikstra shortest
# path algorithm implementation which could be faster with a priority queue
# that avoided the `min_by` operation, but works

require 'set'

input = File.readlines("input", chomp:true)

risk = {}
input.each_with_index do |line, y|
  line.split("").each_with_index do |char, x|
    risk[[y, x]] = char.to_i
  end
end

size = input.size
infinity = 9 * size * size
start = [0, 0]
destination = [size - 1, size - 1]

distance = Hash.new { infinity }

current_node = start
distance[current_node] = 0

unvisited_nodes = 0.upto(size - 1).to_a.product(0.upto(size - 1).to_a).to_set

loop do
  y, x = current_node
  neighbours = []
  neighbours << [y, x + 1] if x < size - 1 && unvisited_nodes.include?([y, x + 1])
  neighbours << [y + 1, x] if y < size - 1 && unvisited_nodes.include?([y + 1, x])
  neighbours << [y, x - 1] if x > 0 && unvisited_nodes.include?([y, x - 1])
  neighbours << [y - 1, x] if y > 0 && unvisited_nodes.include?([y - 1, x])

  neighbours.each do |neighbour|
    distance[neighbour] = [distance[neighbour], distance[current_node] + risk[neighbour]].min
  end

  unvisited_nodes.delete(current_node)
  break if current_node == destination

  current_node = unvisited_nodes.min_by { |node| distance[node] }
end

puts distance[[size -1, size - 1]]




