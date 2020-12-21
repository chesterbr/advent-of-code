require "set"
input = File.readlines("input", chomp:true)

def to_dec(border)
  border.gsub(".", "0").gsub("#","1").to_i(2)
end

def rotate_right(tile)
  tile.transpose.map(&:reverse)
end

def flip_h(tile)
  tile.map(&:reverse)
end

def flip_v(tile)
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

def connect_v?(top_tile_id, bottom_tile_id)
  borders_of(tiles[top_tile_id])[:bottom] == borders_of(tiles[bottom_tile_id])[:top]
end

def print(tile)
  puts tile.map(&:join)
end

DIRECTIONS = %i(top right bottom left)

# key is index-rotations-flips, value is tile as 2-d array
tiles = {}

# for each direction, a hash that maps borders
# to transformed tile ids that have that border
borders =  { top: {}, right: {}, bottom: {}, left: {} }

id = nil
tile = []
input.append("").each do |line|
  if line.start_with? "Tile"
    id = line.split(" ").last.to_i
    tile = []
  elsif line != ""
    tile << line.split("")
  else
    tiles[id] = tile
    # Account all four rotations and flips (just one direction,
    # as flipping the other is handled by rotating-then-flipping)
    0.upto(3) do |rotations|
      0.upto(1) do |flips|
        DIRECTIONS.each do |direction|
          border = borders_of(tile)[direction]
          borders[direction][border] ||= []
          borders[direction][border] << "#{id}-#{rotations}-#{flips}"
        end
        tile = flip_h(tile)
      end
      tile = rotate_right(tile)
    end
  end
end

mult = 1
tiles.each do |id, tile|
  counts = [
    borders[:right][borders_of(tile)[:left]].count,
    borders[:left][borders_of(tile)[:right]].count,
    borders[:top][borders_of(tile)[:bottom]].count,
    borders[:bottom][borders_of(tile)[:top]].count,
  ]
  if counts.count(1) >= 2
    mult *= id
  end
end
puts mult
return
