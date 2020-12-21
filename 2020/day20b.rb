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

# This collection is just the parsed input (keys are the original IDs,
# values are the tiles as an array of arrays of 1-character strings)
@tiles = {}

# A "border" is a string with the joined characters (e.g., "#...#.##").
# For each direction and border, this lists the IDs of transformed
# tiles that contain the border in that direction.
borders =  { top: {}, right: {}, bottom: {}, left: {} }

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
          borders[direction][border] ||= []
          borders[direction][border] << "#{original_id}-#{rotations}-#{flips}"
        end
        tile = flip(tile)
      end
      tile = rotate(tile)
    end
  end
end

def remove_border(tile)
  tile[1..tile.count-2].map do |line|
    line[1..line.count-2]
  end
end

def neighbours_of(id, borders)
  prefix = id.to_i.to_s
  tile = tile_for(id)
  {
    left:   borders[:right][borders_of(tile)[:left]].clone,
    right:  borders[:left][borders_of(tile)[:right]].clone,
    bottom: borders[:top][borders_of(tile)[:bottom]].clone,
    top:    borders[:bottom][borders_of(tile)[:top]].clone,
  }.each do |direction, list|
    list.reject!{ |neighbour_id| neighbour_id.start_with?(prefix) }
  end
end

def fill(x, y, dx, dy, id)
  return if (x < 0 || y < 0 || x > @map_size - 1 || y > @map_size - 1 || @map[y][x])
  @map[y][x] = id
  neighbours = neighbours_of(id, @borders)
  new_x_tile = neighbours[dx == 1 ? :right : :left].first
  new_y_tile = neighbours[dy == 1 ? :bottom : :top].first
  fill(x + dx, y, dx, dy, new_x_tile)
  fill(x, y + dy, dx, dy, new_y_tile)
end

map_size = Math.sqrt(@tiles.count).to_i
map = Array.new(map_size).map { Array.new(map_size) }
@map = map
@map_size = map_size
@borders = borders

used_tile_numbers = Set.new
x = nil
y = nil
@tiles.each do |id_prefix, tile|
  neighbours = neighbours_of("#{id_prefix}-0-0", borders)
  # A tile with two neighbour-less directions is a corner
  if neighbours.values.count([]) == 2
    # Figure out which corner it is, and place it accordingly
    if neighbours[:right].any?
      x = 0
      dx = 1
    else
      x = map_size - 1
      dx = -1
    end
    if neighbours[:bottom].any?
      y = 0
      dy = 1
    else
      y = map_size - 1
      dy = -1
    end
    fill(x, y, dx, dy, "#{id_prefix}-0-0")
    break
  end
end

map_image = []
@map.each do |line|
  tiles_for_line = line.map { |tile| remove_border(tile_for(tile)) }
  0.upto(tiles_for_line.first.count - 1) do |i|
    map_image << tiles_for_line.map { |tile| tile[i] }.reduce(&:+)
  end
end

@sea_monster = <<-MONSTER.chomp.split("\n")
..................#.
#....##....##....###
.#..#..#..#..#..#...
MONSTER

def sea_monster_regexps(column)
  prefix = "." * column
  @sea_monster.map { |line| "^" + prefix + line }
end

@sea_monster.map do |line|
  line.gsub(" ",".")
end

sea_monster_height = @sea_monster.count
sea_monster_width = @sea_monster.first.length

0.upto(3) do |rotations|
  0.upto(1) do |flips|
    current_image = map_image.clone.map(&:join)
    map_image_height = current_image.count
    map_image_width = current_image.first.length

    monsters = []
    0.upto(map_image_height - sea_monster_height) do |y|
      0.upto(map_image_width - sea_monster_width) do |x|
        match = true
        regexps = sea_monster_regexps(x)
        0.upto(regexps.count - 1) do |i|
          unless current_image[y + i].match?(regexps[i])
            match = false
            break
          end
        end
        monsters << [y, x] if match
      end
    end
    unless monsters.empty?
      # This was the map, now let's "color" the dragons
      monsters.each do |y, x|
        0.upto(sea_monster_height - 1) do |i|
          0.upto(sea_monster_width - 1) do |j|
            if @sea_monster[i][j] == "#"
              current_image[y + i][x + j] = "O"
            end
          end
        end
      end
      puts current_image
      puts current_image.join.count("#")
    end
    map_image = flip(map_image)
  end
  map_image = rotate(map_image)
end

