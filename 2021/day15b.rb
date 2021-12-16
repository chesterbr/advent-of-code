# Of course, for part 1 my unoptimized solution didn't work, so I built this one
# that implements a specialized priority queue, backed by a SortedSet.
#
# In Ruby 2.x, it ran even slower than the original, but on JRuby (which likely
# backs collections with Java's time-tested ones) it flies (getting the full
# ansuer in < 8s of CPU time)

require 'set'

input = File.readlines("input", chomp:true)

tile_size = input.size
risk = {}
0.upto(4) do |tile_y|
  0.upto(4) do |tile_x|
    input.each_with_index do |line, y|
      line.split("").each_with_index do |char, x|
        risk[[tile_y * tile_size + y, tile_x * tile_size + x]] = ((char.to_i + tile_y + tile_x) - 1) % 9 + 1
      end
    end
  end
end

size = tile_size * 5
infinity = 9 * size * size
start_coords = [0, 0]
destination_coords = [size - 1, size - 1]

class UnvisitedCavesQueue
  def initialize
    @sorted_distance_and_coords = SortedSet.new
    @coords_to_distance = {}
  end

  def set(coords, distance)
    if self.include?(coords)
      self.delete(coords)
    end

    @sorted_distance_and_coords << [distance, coords]
    @coords_to_distance[coords] = distance
  end

  def distance(coords)
    @coords_to_distance[coords]
  end

  def include?(coords)
    @coords_to_distance.include?(coords)
  end

  def delete(coords)
    distance = @coords_to_distance.delete(coords)
    @sorted_distance_and_coords.delete([distance, coords])
  end

  def next_coords
    element = @sorted_distance_and_coords.find { true }

    element[1]
  end
end

queue = UnvisitedCavesQueue.new
0.upto(size - 1) do |y|
  0.upto(size - 1) do |x|
    if [y, x] == start_coords
      queue.set([y, x], 0)
    else
      queue.set([y, x], infinity)
    end
  end
end

current_coords = start_coords

loop do
  y, x = current_coords
  # puts current_coords.inspect
  neighbours = []
  neighbours << [y, x + 1] if x < size - 1 && queue.include?([y, x + 1])
  neighbours << [y + 1, x] if y < size - 1 && queue.include?([y + 1, x])
  neighbours << [y, x - 1] if x > 0 && queue.include?([y, x - 1])
  neighbours << [y - 1, x] if y > 0 && queue.include?([y - 1, x])

  neighbours.each do |neighbour_coords|
    tentative_new_distance = queue.distance(current_coords) + risk[neighbour_coords]
    if tentative_new_distance < queue.distance(neighbour_coords)
      queue.set(neighbour_coords, tentative_new_distance)
    end
  end

  break if current_coords == destination_coords

  queue.delete(current_coords)
  current_coords = queue.next_coords
end

puts queue.distance(destination_coords)




