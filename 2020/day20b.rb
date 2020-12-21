require "set"
input = File.readlines("input", chomp:true)

def rotate(tile)
  tile.transpose.map(&:reverse)
end

# We only need to flip one direction (the other is covered by
# rotating and flip). Chose vertical because it's simper
def flip(tile)
  tile.reverse
end

def borders_of(tile)
  tile_t = tile.transpose
  {
    top: tile.first.join,
    right: tile_t.last.join,
    bottom: tile.last.join,
    left: tile_t.first.join,
  }
end

# For debugging purposes (also works with @map_image)
def print(tile)
  puts tile.map(&:join)
end

# The code only stores the original tiles, using this method to
# retrieve the rotated/flipped ones. id is a string containing
# the original input ID and number ("id-rotations-flips")
def tile_for(id)
  original_id, rotations, flips = id.split("-").map(&:to_i)
  tile = @tiles["#{original_id}-0-0"].clone.map(&:clone)
  rotations.times do
    tile = rotate(tile)
  end
  flips.times do
    tile = flip(tile)
  end
  tile
end

def remove_border(tile)
  tile[1..tile.count-2].map do |line|
    line[1..line.count-2]
  end
end

def neighbours_of(id)
  prefix = id.to_i.to_s
  tile = tile_for(id)
  {
    left:   @borders[:right][borders_of(tile)[:left]].clone,
    right:  @borders[:left][borders_of(tile)[:right]].clone,
    bottom: @borders[:top][borders_of(tile)[:bottom]].clone,
    top:    @borders[:bottom][borders_of(tile)[:top]].clone,
  }.each do |direction, list|
    list.reject!{ |neighbour_id| neighbour_id.start_with?(prefix) }
  end
end

# Recursively fill the @map array, by starting at a point (x, y) for
# which we know the correct transformed tile (id), and going towards
# given horizontal and vertical directions (dx, dy)
def fill(x, y, dx, dy, id)
  return if (x < 0 || y < 0 || x > @map_size - 1 || y > @map_size - 1 || @map[y][x])
  @map[y][x] = id
  neighbours = neighbours_of(id)
  new_x_tile = neighbours[dx == 1 ? :right : :left].first
  new_y_tile = neighbours[dy == 1 ? :bottom : :top].first
  fill(x + dx, y, dx, dy, new_x_tile)
  fill(x, y + dy, dx, dy, new_y_tile)
end

# This collection is just the parsed input (keys are the original IDs,
# values are the tiles as an array of arrays of 1-character strings)
@tiles = {}

# A "border" is a string with the joined characters (e.g., "#...#.##").
# For each direction and border, this lists the IDs of transformed
# tiles that contain the border in that direction.
@borders =  { top: {}, right: {}, bottom: {}, left: {} }

# Parse input into tiles and borders
original_id = nil
tile = []
input.append("").each do |line|
  if line.start_with? "Tile"
    original_id = line.split(" ").last.to_i
    tile = []
  elsif line != ""
    tile << line.split("")
  else
    @tiles["#{original_id}-0-0"] = tile
    0.upto(3) do |rotations|
      0.upto(1) do |flips|
        %i(top right bottom left).each do |direction|
          border = borders_of(tile)[direction]
          @borders[direction][border] ||= []
          @borders[direction][border] << "#{original_id}-#{rotations}-#{flips}"
        end
        tile = flip(tile)
      end
      tile = rotate(tile)
    end
  end
end

# Build the map starting from an arbitrary corner (any of the original
# tiles that contains no neighbour in two directions, like a puzzle
# corner) and recursively filling in towards the middle.
# The result is an array of arrays of transformed tile ids.
@map_size = Math.sqrt(@tiles.count).to_i
@map = Array.new(@map_size).map { Array.new(@map_size) }
x = nil
y = nil
@tiles.each do |id_prefix, tile|
  neighbours = neighbours_of("#{id_prefix}-0-0")
  if neighbours.values.count([]) == 2
    # Find the coordinates and fill direction for the tile's corner
    # E.g., if it has no top and lef neighbours, place it on top/left
    # (0, 0) and fill the other tiles towards bottom and right (1, 1)
    x, dx = (neighbours[:right].any? ? [0, 1] : [@map_size - 1, -1])
    y, dy = (neighbours[:bottom].any? ? [0, 1] : [@map_size - 1, -1])
    fill(x, y, dx, dy, "#{id_prefix}-0-0")
    break
  end
end

# Using the tile ids, recreate the map as a giant tile (map_image)
map_image = []
@map.each do |line|
  tiles_for_line = line.map { |tile| remove_border(tile_for(tile)) }
  0.upto(tiles_for_line.first.count - 1) do |i|
    map_image << tiles_for_line.map { |tile| tile[i] }.reduce(&:+)
  end
end

# Now let's hunt monsters. We start with the monster image
# as an array of string lines, only replacing spaces with dots
@sea_monster = <<-MONSTER.chomp.split("\n")
..................#.
#....##....##....###
.#..#..#..#..#..#...
MONSTER

# Prefix the monster so that the returned array strings
# are regexps that match a monster at the given column
def sea_monster_regexps(column)
  prefix = "." * column
  @sea_monster.map { |line| "^" + prefix + line }
end

# Now we can hunt monsters! Look for them on each rotation/flip
# of the map - when we find one with monsters, paint its "O"s on
# the image, then count the remaining "#"s (roughness)
sea_monster_height = @sea_monster.count
sea_monster_width = @sea_monster.first.length
map_height = map_image.count
map_width = map_image.first.length
roughness = nil
0.upto(3) do |rotations|
  0.upto(1) do |flips|
    current_image = map_image.clone.map(&:join)
    monsters = []
    0.upto(map_height - sea_monster_height) do |y|
      0.upto(map_width - sea_monster_width) do |x|
        regexps = sea_monster_regexps(x)
        monsters << [y, x] if 0.upto(regexps.count - 1).all? do |i|
          current_image[y + i].match?(regexps[i])
        end
      end
    end
    unless monsters.empty?
      # This was the map, now let's "color" the dragons
      monsters.each do |y, x|
        0.upto(sea_monster_height - 1) do |i|
          0.upto(sea_monster_width - 1) do |j|
            current_image[y + i][x + j] = "O" if @sea_monster[i][j] == "#"
          end
        end
      end
      roughness = current_image.join.count("#")
      break
    end
    map_image = flip(map_image)
  end
  map_image = rotate(map_image)
end

# Part 1
corner_original_ids = [
  @map.first.first,
  @map.first.last,
  @map.last.first,
  @map.last.last
].map(&:to_i)
puts corner_original_ids.reduce(:*)

# Part 2
puts roughness

