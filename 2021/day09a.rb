input = File.readlines("input", chomp:true)

map = input.map { |line| line.split("").map(&:to_i) }
max_x = map[0].length - 1
max_y = map.length - 1

risk = 0
0.upto(max_y) do |y|
  0.upto(max_x) do |x|
    if (x == 0 || map[y][x] < map[y][x - 1]) && (x == max_x || map[y][x] < map[y][x + 1]) &&
       (y == 0 || map[y][x] < map[y - 1][x]) && (y == max_y || map[y][x] < map[y + 1][x])
      risk += map[y][x] + 1
    end
  end
end

puts risk
