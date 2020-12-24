require "set"
input = File.readlines("input", chomp:true)

# map each direction to the change in y, x
DELTAS = {
  "sw" => [1, -1],
  "se" => [1, 0],
  "w"  => [0, -1],
  "e"  => [0, 1],
  "ne" => [-1, 1],
  "nw" => [-1, 0],
}

def to_tile(y, x)
  y * 100000 + x
end

def to_coords(tile)
  [tile / 100000, tile % 100000]
end

def adjacent_tiles(tile)
  y, x = to_coords(tile)
  DELTAS.values.map do |dy, dx|
    to_tile(y + dy, x + dx)
  end
end

def adjacent_black_count(tile, black_tiles)
  adjacent_tiles(tile).count { |tile| black_tiles.any? tile }
end

black_tiles = Set.new
input.each do |line|
  directions = line.scan(/(e|se|sw|w|nw|ne)/).map(&:first)
  y = x = 0
  directions.each do |direction|
    y = y + DELTAS[direction][0]
    x = x + DELTAS[direction][1]
  end
  if black_tiles.any?(to_tile(y,x))
    black_tiles.delete(to_tile(y,x))
  else
    black_tiles << to_tile(y,x)
  end
end

1.upto(100) do |day|
  flip_to_white = Set.new
  flip_to_black = Set.new
  black_tiles.each do |black_tile|
    count = adjacent_black_count(black_tile, black_tiles)
    if count == 0 || count > 2
      flip_to_white << black_tile
    end
    adjacent_tiles(black_tile).each do |potential_white_tile|
      next if black_tiles.include? potential_white_tile
      if adjacent_black_count(potential_white_tile, black_tiles) == 2
        flip_to_black << potential_white_tile
      end
    end
  end
  black_tiles -= flip_to_white.to_a
  black_tiles += flip_to_black.to_a
  puts "Day #{day}: #{black_tiles.count}"
end

