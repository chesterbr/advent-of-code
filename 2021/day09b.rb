input = File.readlines("input", chomp:true)

@map = input.map { |line| line.split("").map(&:to_i) }
@max_x = @map[0].length - 1
@max_y = @map.length - 1

low_points = []
0.upto(@max_y) do |y|
  0.upto(@max_x) do |x|
    if (x == 0 || @map[y][x] < @map[y][x - 1]) && (x == @max_x || @map[y][x] < @map[y][x + 1]) &&
       (y == 0 || @map[y][x] < @map[y - 1][x]) && (y == @max_y || @map[y][x] < @map[y + 1][x])
      low_points << [x, y]
    end
  end
end

def fill_basin(x, y)
  return if @map[y][x] == 9
  @map[y][x] = 9
  @size += 1
  fill_basin(x + 1, y) if x < @max_x
  fill_basin(x - 1, y) if x > 0
  fill_basin(x, y + 1) if y < @max_y
  fill_basin(x, y - 1) if y > 0
end

sizes = []
low_points.each do |x, y|
  @size = 0
  fill_basin(x, y)
  sizes << @size
end

puts sizes.sort[-3..-1].reduce(:*)
