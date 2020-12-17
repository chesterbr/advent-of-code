map = File.readlines(ARGV[0], chomp: true)
map_width = map.first.length
increments = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]
multiplied = 1
increments.each do |increment_right, increment_down|
  x = 0
  y = 0
  count = 0
  while true
    y += increment_down
    break if y > map.count - 1
    x += increment_right
    x = x % map_width
    line = map[y]

    # puts "#{y}, #{x}"
    if line[x] == "#"
      count += 1
    end
  end
  multiplied *= count
  puts count
end
puts multiplied
