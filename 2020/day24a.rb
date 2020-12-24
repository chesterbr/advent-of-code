input = File.readlines("input", chomp:true)

# map each direction to the change in y, x
deltas = {
  "sw" => [1, -1],
  "se" => [1, 0],
  "w"  => [0, -1],
  "e"  => [0, 1],
  "ne" => [-1, 1],
  "nw" => [-1, 0],
}

flipped_tiles = []
input.each do |line|
  directions = line.scan(/(e|se|sw|w|nw|ne)/).map(&:first)
  y = x = 0
  directions.each do |direction|
    y = y + deltas[direction][0]
    x = x + deltas[direction][1]
  end
  if flipped_tiles.any?([y, x])
    flipped_tiles.delete([y, x])
  else
    flipped_tiles << [y, x]
  end
end




puts flipped_tiles.inspect
puts flipped_tiles.count


